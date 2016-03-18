let s:suite = themis#suite('completion_swift')
let s:assert = themis#helper('assert')

function! s:suite.replaces_the_first_argument()
    let text = '.advancedBy(<#T##n: Distance##Distance#>)'
    let expectation = '.advancedBy(<`' . '1:Distance' . '`>)'
    let result = completion_swift#convert_placeholder(text)
    call s:assert.equals(result, expectation)
endfunction

function! s:suite.replaces_arguments_after_the_first()
    let text = '.advancedBy(<#T##n: Self.Distance##Self.Distance#>, limit: <#T##Self#>)'
    let expectation = '.advancedBy(<`' . '1:Self.Distance' . '`>, limit: <`' . '2:Self' .'`>)'
    let result = completion_swift#convert_placeholder(text)
    call s:assert.equals(result, expectation)
endfunction

function! s:suite.decides_completion_position_for_dot()
    let pattern = completion_swift#generate_keyword_pattern() . '$'
    let text = '[0, 1].count.adv'
    let expectation = 12
    let result = match(text, pattern)
    call s:assert.equals(result, expectation)
endfunction

function! s:suite.decides_completion_position_for_keyword()
    let pattern = completion_swift#generate_keyword_pattern() . '$'
    let text = 'private proto'
    let result = match(text, pattern)
    let expectation = 8
    call s:assert.equals(result, expectation)
endfunction

function! s:suite.decides_completion_position_for_dot_by_force()
    let pattern = completion_swift#generate_input_pattern() . '$'
    let text = '[0, 1].count.'
    let result = match(text, pattern)
    let expectation = 12
    call s:assert.equals(result, expectation)
endfunction

function! s:suite.decides_completion_position_for_argument_by_force()
    let pattern = completion_swift#generate_input_pattern() . '$'
    let text = 'Point(x: 0, y: 2, z'
    let result = match(text, pattern)
    let expectation = 16
    call s:assert.equals(result, expectation)
endfunction

function! s:suite.decides_completion_position_for_parent_by_force()
    let pattern = completion_swift#generate_input_pattern() . '$'
    let text = 'protocol Name: Eq'
    let result = match(text, pattern)
    let expectation = 13
    call s:assert.equals(result, expectation)
endfunction

function! s:suite.decides_completion_position_for_return_by_force()
    let pattern = completion_swift#generate_input_pattern() . '$'
    let text = 'func test() -> Na'
    let result = match(text, pattern)
    let expectation = 12
    call s:assert.equals(result, expectation)
endfunction
