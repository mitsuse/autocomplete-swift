let s:source = {
\   'name': 'kitten',
\   'kind': 'keyword',
\   'filetype': {
\       'swift': 1,
\   },
\   'mark': '[kitten]',
\   'min_pattern_length': 1,
\   'max_candidates': 10,
\ }

function! s:source.gather_candidates(context)
    " TODO: Implement.
    return []
endfunction

function! neocomplete#sources#kitten#define()
    return s:source
endfunction
