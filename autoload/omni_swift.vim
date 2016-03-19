let s:Vital = vital#of('autocomplete_swift')

let s:String = s:Vital.import('Data.String')

function! omni_swift#complete(first, base)
    if a:first
        let s:context = {}
        let s:context.input_text = getline('.')[0:col('.') - 1]
        let s:context.complete_pos = autocomplete_swift#decide_completion_position(
        \   s:context.input_text,
        \   col('.') - 1,
        \)
        return s:context.complete_pos
    else
        let s:context.complete_str = a:base
        return s:complete(s:context)
    endif
endfunction

function! s:complete(context)
    let l:candidates = []

    for l:c in autocomplete_swift#complete(line('.'), a:context.complete_pos)
        if s:String.starts_with(l:c.word, a:context.complete_str) == 0
            continue
        end
        call add(l:candidates, l:c)
    endfor

    return l:candidates
endfunction
