" Use the toolchain specified with `com.apple.dt.toolchain.{name}`.
function! autocomplete_swift#use_toolchain(name)
    call autocomplete_swift#use_custom_toolchain(s:get_xcode_toolchain(a:name))
endfunction

" Use the custom toolchain specified with the given identifier.
function! autocomplete_swift#use_custom_toolchain(identifier)
    let g:autocomplete_swift#toolchain = a:identifier
endfunction

func s:get_xcode_toolchain(name)
    return 'com.apple.dt.toolchain.' . a:name
endfunction

function! autocomplete_swift#jump_to_placeholder()
    if &filetype !=# 'swift'
        return ''
    end

    if !autocomplete_swift#check_placeholder_existence()
        return ''
    endif

    return "\<ESC>:call autocomplete_swift#begin_replacing_placeholder()\<CR>"
endfunction

function! autocomplete_swift#check_placeholder_existence()
    return search(autocomplete_swift#generate_placeholder_pattern())
endfunction

function! autocomplete_swift#begin_replacing_placeholder()
    if mode() !=# 'n'
        return
    endif

    let l:pattern = autocomplete_swift#generate_placeholder_pattern()

    let [l:line, l:column] = searchpos(l:pattern)
    if l:line == 0 && l:column == 0
        return
    end

    execute printf(':%d s/%s//', l:line, l:pattern)

    call cursor(l:line, l:column)

    startinsert
endfunction

function! autocomplete_swift#generate_placeholder_pattern()
    return '<#\%(T##\)\?\%([^#]\+##\)\?\([^#]\+\)#>'
endfunction
