

function! vim_github_cli#system#system(cmds)
    """ Wraps `:call system(...)` . (Seam for testing)
    """
    return system(a:cmds)
endfunction


function! vim_github_cli#system#systemlist(cmds)
    """ Wraps `:call systemlist(...)` . (Seam for testing)
    """
    return systemlist(a:cmds)
endfunction


function! vim_github_cli#system#which(program)
    """ Wraps `:call system('which ${program}')`. (Seam for testing)
    vim_github_cli#system#system('which ' . a:program)
    return !v:shell_error
endfunction
