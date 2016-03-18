let s:source = {
\   'name': 'swift',
\   'kind': 'keyword',
\   'filetypes': {
\       'swift': 1,
\   },
\   'mark': '[swift]',
\   'min_pattern_length': 4,
\   'max_candidates': 30,
\   'keyword_patterns': {
\       'swift': completion_swift#generate_keyword_pattern(),
\   },
\   'input_pattern': completion_swift#generate_input_pattern(),
\ }

function! s:source.gather_candidates(context)
    let l:sourcekit_candidates = sourcekitten#complete(
    \   s:write_buffer(),
    \   s:get_offset(a:context),
    \)

    let l:candidates = []
    for l:s in l:sourcekit_candidates
        let l:c = {
        \   'word': completion_swift#convert_placeholder(l:s.sourcetext),
        \   'abbr': l:s.name,
        \}
        call add(candidates, l:c)
    endfor

    return l:candidates
endfunction

function! neocomplete#sources#swift#define()
    return sourcekitten#is_installed() ? s:source : {}
endfunction

function! s:write_buffer()
    if exists('s:path_buffer')
        if !filewritable(s:path_buffer)
            let s:path_buffer = tempname()
        endif
    else
        let s:path_buffer = tempname()
    endif

    call writefile(getline(0, '.'), s:path_buffer)

    return s:path_buffer
endfunction

function! s:get_offset(context)
    return line2byte(line('.')) - 1 + a:context.complete_pos
endfunction
