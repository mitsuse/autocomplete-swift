function! omni_swift#complete(first, base)
    if a:first
        let s:context = {}
        let s:context.input_text = getline('.')[0:col('.') - 1]
        let s:context.complete_pos = s:decide_position(
        \   s:context.input_text,
        \   col('.') - 1,
        \)
        return s:context.complete_pos
    endif

    let s:context.complete_str = a:base

    return s:complete(s:context)
endfunction

function! s:decide_position(input_text, cursor_pos)
    let l:complete_pos = match(
    \   a:input_text,
    \   autocomplete_swift#generate_input_pattern() . '$',
    \)

    if l:complete_pos == -1
        let l:complete_pos = match(
        \   a:input_text,
        \   autocomplete_swift#generate_keyword_pattern() . '$',
        \)

        if l:complete_pos != -1
            return l:complete_pos
        endif
    endif

    return a:cursor_pos
endfunction

function! s:complete(context)
    if a:context.complete_pos == 0 && a:context.complete_str ==# ''
        return []
    end

    call autocomplete_swift#write_buffer(s:get_temp_path())

    let l:sourcekit_candidates = sourcekitten#complete(
    \   s:get_temp_path(),
    \   autocomplete_swift#get_offset(a:context.complete_pos),
    \)

    let l:candidates = []
    for l:s in l:sourcekit_candidates
        if s:match_prefix(l:s.sourcetext, a:context.complete_str) == 0
            continue
        end

        let l:c = {
        \   'kind': '[swift]',
        \   'word': autocomplete_swift#convert_placeholder(l:s.sourcetext),
        \   'abbr': l:s.name,
        \}
        call add(candidates, l:c)
    endfor

    return l:candidates
endfunction

function! s:match_prefix(string, prefix)
    if len(a:prefix) == 0
        return 1
    end
    return a:string[0:len(a:prefix) - 1] ==# a:prefix
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
