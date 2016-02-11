let s:Vital = vital#of('neocomplete_kitten')

let s:Process = s:Vital.import('Process')
let s:Json = s:Vital.import('Web.JSON')

let s:source = {
\   'name': 'kitten',
\   'kind': 'keyword',
\   'filetype': {
\       'swift': 1,
\   },
\   'mark': '[kitten]',
\   'min_pattern_length': 1,
\   'max_candidates': 30,
\   'keyword_patterns': {
\       'swift': '\(\(:\|,\|->\)\s\|\.\)',
\   }
\ }

function! s:source.gather_candidates(context)
    let l:file = join(getline(0, line('.') - 1), ' ')
    let l:offset = len(l:file) + col('.') + len(a:context.complete_str)

    let l:file = join([l:file] + getline(line('.'), '$'), ' ')

    let l:result = s:sourcekitten_complete(l:file, l:offset)

    let l:candidates = []

    for l:r in l:result
        let l:c = {
        \   'word': a:context.complete_str . substitute(l:r.sourcetext, '<#T##.*#>', '', 'g'),
        \   'abbr': l:r.name,
        \}
        call add(candidates, l:c)
    endfor

    return l:candidates
endfunction

function! neocomplete#sources#kitten#define()
    return executable('sourcekitten') ? s:source : {}
endfunction

function! s:quote(string)
    return '"' . escape(a:string, '"') . '"'
endfunction

function! s:sourcekitten_complete(text, offset)
    let l:command = 'sourcekitten complete'

    let l:args = join(
    \   [
    \       '--text', s:quote(a:text),
    \       '--offset', a:offset,
    \   ],
    \)

    let l:result = s:Process.system(
    \   l:command . ' ' . l:args,
    \)

    return s:Json.decode(l:result)
endfunction
