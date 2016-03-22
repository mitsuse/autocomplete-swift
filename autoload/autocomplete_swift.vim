function! autocomplete_swift#complete(line, column)
    call s:write_buffer(s:get_temp_path())

    let l:offset = s:get_offset(a:line, a:column)
    if l:offset == -1
        return []
    endif

    let l:sourcekit_candidates = sourcekitten#complete(
    \   s:get_temp_path(),
    \   l:offset,
    \)

    let l:candidates = []
    for l:s in l:sourcekit_candidates
        let l:c = {
        \   'word': autocomplete_swift#convert_placeholder(l:s.sourcetext),
        \   'abbr': l:s.name,
        \}
        call add(candidates, l:c)
    endfor

    return l:candidates
endfunction

function! autocomplete_swift#decide_completion_position(text, column)
    let l:complete_position = match(
    \   a:text,
    \   autocomplete_swift#generate_keyword_pattern() . '$',
    \)

    if l:complete_position != -1
        return l:complete_position
    endif

    return a:column - 1
endfunction

function! autocomplete_swift#generate_keyword_pattern()
    return '\(\.\w*\|\h\w*\)'
endfunction

function! autocomplete_swift#generate_input_pattern()
    return '\(\.\|\(,\|:\|->\)\s\+\)\w*'
endfunction

function! autocomplete_swift#generate_placeholder_pattern()
    return '<#\%(T##\)\?\%([^#]\+##\)\?\([^#]\+\)#>'
endfunction

function! autocomplete_swift#convert_placeholder(text)
    if s:check_neosnippet_existence()
        return autocomplete_swift#convert_placeholder_for_neosnippet(a:text)
    endif

    return a:text
endfunction

function! autocomplete_swift#convert_placeholder_for_neosnippet(text)
    let l:text = a:text
    let l:pattern = autocomplete_swift#generate_placeholder_pattern()
    let l:count = 0

    while 1
        let l:count += 1
        if match(l:text, l:pattern) == -1
            break
        endif

        let l:text = substitute(l:text, l:pattern, '<`' . l:count . ':\1`>', '')
    endwhile

    return l:text
endfunction

function! autocomplete_swift#jump_to_placeholder()
    if &filetype !=# 'swift'
        return ''
    end

    if !autocomplete_swift#check_placeholder_existence()
        return ''
    endif

    return "\<ESC>:call autocomplete_swift#begin_replacing_placeholder()\<CR>"
endfunction

function! autocomplete_swift#check_placeholder_existence()
    return search(autocomplete_swift#generate_placeholder_pattern())
endfunction

function! autocomplete_swift#begin_replacing_placeholder()
    if mode() !=# 'n'
        return
    endif

    let l:pattern = autocomplete_swift#generate_placeholder_pattern()

    let [l:line, l:column] = searchpos(l:pattern)
    if l:line == 0 && l:column == 0
        return
    end

    execute printf(':%d s/%s//', l:line, l:pattern)

    call cursor(l:line, l:column)

    startinsert
endfunction

function! s:write_buffer(path)
    call writefile(getline(0, '.'), a:path)
endfunction

function! s:get_temp_path()
    if !exists('s:path_buffer') || !filewritable(s:path_buffer)
        let s:path_buffer = tempname()
    endif
    return s:path_buffer
endfunction

function! s:get_offset(line, column)
    if a:column < 1 && col('$') < a:column
        return -1
    endif

    " line2byte returns -1 when invalid `lnum` is passed.
    " In a new buffer, line2byte(1) also returns -1 until the internal state of Vim is updated
    " even if the first line exists, in other words, has some characters.
    " Therefore, s:get_offset must discriminate these context.

    if a:line < 1 && line('$') < a:line
        return -1
    endif

    let l:bytes = line2byte(a:line) - 1
    if l:bytes < 0
        let l:bytes = 0
    end

    " Subtract -1 from a:column because Vim's column starts with 1.
    return l:bytes + a:column - 1
endfunction

function! s:check_neosnippet_existence()
    return exists('g:loaded_neosnippet') && g:loaded_neosnippet
endfunction
