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
    call completion_swift#write_buffer(s:get_temp_path())

    let l:sourcekit_candidates = sourcekitten#complete(
    \   s:get_temp_path(),
    \   completion_swift#get_offset(a:context.complete_pos),
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
