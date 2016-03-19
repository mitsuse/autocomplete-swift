function! autocomplete_swift#complete(line, column)
    call s:write_buffer(s:get_temp_path())

    let l:sourcekit_candidates = sourcekitten#complete(
    \   s:get_temp_path(),
    \   s:get_offset(a:line, a:column),
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

function! autocomplete_swift#generate_keyword_pattern()
    return '\(\.\w*\|\h\w*\)'
endfunction

function! autocomplete_swift#generate_input_pattern()
    return '\(\.\|\(,\|:\|->\)\s*\)\w*'
endfunction

function! autocomplete_swift#convert_placeholder(text)
    let l:text = a:text
    let l:pattern = '<#\%(T##\)\?\%(.\{-}##\)\?\(.\{-}\)#>'
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

function! s:write_buffer(path)
    call writefile(getline(0, '.'), a:path)
endfunction

function! s:get_temp_path()
    if exists('s:path_buffer')
        if !filewritable(s:path_buffer)
            let s:path_buffer = tempname()
        endif
    else
        let s:path_buffer = tempname()
    endif
    return s:path_buffer
endfunction

function! s:get_offset(line, column)
    return line2byte(a:line) - 1 + a:column
endfunction
