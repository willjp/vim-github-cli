" official github-cli's config allows different configurations for each domain.
" (are enterprise installs even possible?)

function! vim_github_cli#git#remote_domain(...)
    """ extract domain from URI
    """
    let l:remote_url = call('vim_github_cli#git#remote_url', a:000)
    return vim_github_cli#git#domain_from_remote_url(l:remote_url)
endfunction

function! vim_github_cli#git#domain_from_remote_url(url)
    " strip proto:// (https://github.com/octocat/helloworld => github.com/octocat/helloworld )
    let l:domain = substitute(a:url, '\v^\w+://', '', '')

    " strip after-sshdomain or port ( github.com:octocat/helloworld => github.com )
    let l:domain = substitute(l:domain, '\v(\w+):.*', '\1', '')

    " if '/'s remain, split/retrieve first ( github.com/octocat/helloworld => github.com )
    let l:domain = split(l:domain, '/')[0]

    " strip user@ from ssh url (git@github.com:octocat/helloworld => github.com/octocat/helloworld )
    let l:domain = split(l:domain, '@')[-1]

    return l:domain
endfunction

function! vim_github_cli#git#remote_url(...)
    """ git remote get-url $*
    """
    let l:cmds = ['git', 'remote', 'get-url'] + a:000
    return vim_github_cli#system#system(l:cmds)
endfunction
