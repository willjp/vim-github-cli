" Attempt to avoid accidental overlap with vim exceptions.
" (vim exceptions are un-typed strings in the format 'E1000')


" ==========
" Exceptions
" ==========

function vim_github_cli#error#no_http_providers(msg)
    """ Throw if no HTTP-request handlers were detected (ex: curl)
    """
    return vim_github_cli#error#generate("no_http_providers", a:msg)
endfunction


" =======
" Helpers
" =======

function vim_github_cli#error#match_exceptioncodes(codes)
    """ Return match from `codes` if last thrown exception matches any of them.
    """
    for code in a:codes
        if (match(v:exception, vim_github_cli#error#prefix_match(code)) != -1)
            return code
        end
    endfor
    return 0
endfunction

function vim_github_cli#error#match_exceptioncode(code)
    """ Return true if code matches last thrown exception, otherwise false.
    """
    if (match(v:exception, vim_github_cli#error#prefix_match(a:code)) != -1)
        return 1
    end
    return 0
endfunction

function vim_github_cli#error#prefix_match(code)
    """ Regex match for error-prefix.
    """
    return '\V\^[ERROR::VIM-GITHUB-CLI::'.a:code.'\V]'
endfunction

function vim_github_cli#error#prefix(code)
    """ Prefix for a vim-github-cli error.
    """
    return '[ERROR::VIM-GITHUB-CLI::'.a:code.']'
endfunction

function vim_github_cli#error#generate(code, msg)
    """ An vim-github-cli exception with `code` (able to match), 
    " and an arbitrary description.
    """
    return vim_github_cli#error#prefix(a:code) . " " . a:msg
endfunction
