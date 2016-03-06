let s:Vital = vital#of('neocomplete_kitten')

let s:Process = s:Vital.import('Process')
let s:Json = s:Vital.import('Web.JSON')

let s:source = {
\   'name': 'kitten',
\   'kind': 'keyword',
\   'filetypes': {
\       'swift': 1,
\   },
\   'mark': '[kitten]',
\   'min_pattern_length': 4,
\   'max_candidates': 30,
\   'keyword_patterns': {
\       'swift': '\(\.\w*\|\h\w*\)',
\   },
\   'input_pattern': '\(\.\|\(,\|:\|->\)\s*\)\w*',
\ }

function! s:source.gather_candidates(context)
    let l:result = s:get_text_with_offset(a:context, line('.'))
    let l:sourcekit_candidates = s:sourcekitten_complete(
    \   l:result.text,
    \   l:result.offset,
    \)

    let l:candidates = []
    for l:s in l:sourcekit_candidates
        let l:c = {
        \   'word': s:convert_placeholder(l:s.sourcetext),
        \   'abbr': l:s.name,
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

function! s:get_text_with_offset(context, row)
    let l:text = join(getline(0, a:row - 1), "\n") . "\n"
    let l:result = {
    \   'text': l:text . join(getline(a:row, '$'), "\n"),
    \   'offset': len(l:text) + a:context.complete_pos,
    \}
    return l:result
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

function! s:convert_placeholder(text)
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
