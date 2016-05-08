let s:Vital = vital#of('autocomplete_swift')

let s:Http = s:Vital.import('Web.HTTP')
let s:Json = s:Vital.import('Web.JSON')

let s:command_name = 'sourcekittendaemon'
let s:host = 'localhost'
let s:port = -1

function! sourcekitten_daemon#complete(path, offset)
    if sourcekitten_daemon#is_enabled() != 1
        return []
    endif

    let l:response = s:Http.get(
    \   s:address . '/complete',
    \   {},
    \   {
    \       'X-Offset': a:offset,
    \       'X-Path': a:path,
    \   }
    \)

    if l:response.success != 1
        return []
    endif

    return s:Json.decode(l:response.content)
endfunction

function! sourcekitten_daemon#enable(port)
    let s:port = a:port
    let s:address = 'http://' . s:host . ':' . s:port
endfunction

function! sourcekitten_daemon#disable()
    let s:port = -1
endfunction

function! sourcekitten_daemon#is_executable()
    return executable(s:command_name)
endfunction

function! sourcekitten_daemon#is_enabled()
    return s:port != -1
endfunction
