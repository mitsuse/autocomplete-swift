let s:Vital = vital#of('autocomplete_swift')

let s:Process = s:Vital.import('Process')
let s:Json = s:Vital.import('Web.JSON')

let s:command_name = 'sourcekitten'

function! sourcekitten#complete(path, offset)
    if sourcekitten#is_installed() == 0
        return []
    endif

    let l:command = s:command_name . ' complete'

    let l:args = join(
    \   [
    \       '--file', a:path,
    \       '--offset', a:offset,
    \   ],
    \)

    let l:result = s:Process.system(
    \   l:command . ' ' . l:args,
    \)

    return s:Json.decode(l:result)
endfunction

function! sourcekitten#is_installed()
    return executable(s:command_name)
endfunction
