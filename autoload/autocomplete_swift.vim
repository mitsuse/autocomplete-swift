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
