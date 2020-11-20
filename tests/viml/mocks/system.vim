" dirty mock implementation for "system(...)" and "systemlist(...)"
" make sure to ":source autoload/vim_github_cli/system.vim" following every test that uses it!!!


function! MockSystem(result)
    """ Mocks a :system(...).
    " Args:
    "   result (str):
    "       returned when invoked.
    """
    let g:mock_system_args = "null"
    let g:mock_system_result = a:result
    function! vim_github_cli#system#system(...)
        let g:mock_system_args = a:000
        return g:mock_system_result
    endfunction
endfunction


function! MockWhich(results) 
    """ Mocks which(program).
    "
    " Args:
    "   results (dict): ``(ex: {"foo": 1, "bar": 0} )``
    "       dictionary of results per program-name.
    "       (If not defined, returns false)
    """
    g:mock_which_results = a:results
    function! vim_github_cli#system#which(program)
        for [key, val] in items(g:mock_which_results)
            if has_key(g:mock_which_when, a:program)
                return g:mock_which_results[key]
            end
        endfor
        return 0
    endfunction
endfunction


