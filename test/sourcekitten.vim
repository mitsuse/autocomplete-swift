let s:suite = themis#suite('sourcekitten')
let s:assert = themis#helper('assert')

function! s:suite.is_installed()
    call s:assert.not_equals(sourcekitten#is_installed(), 0)
endfunction

function! s:suite.completes()
    let path = tempname()
    let offset = 1

    let text = '0.'
    call writefile([text], path)

    call s:assert.not_empty(sourcekitten#complete(path, offset))
endfunction
