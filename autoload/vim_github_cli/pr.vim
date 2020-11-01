

function! vim_github_cli#pr#blame(...)
    """ Show PR that added line under cursor.
    " 
    " Abstracts github-cli's `gh pr view` - accepts any of it's commands
    "
    " Example:
    "   :GhPrBlame            " display PR desc in split
    "   :GhPrBlame -w         " display PR in webbrowser
    "   :GhPrBlame -R <repo>  " other args also supported (see man gh-pr)
    """
    let l:blame_output = system(['git', 'blame', '-L', line('.') . ',' . line('.'), '-l', expand('%:p')])
    let l:commit_hash = split(l:blame_output)[0]
    let l:pr_merge_msg = systemlist(['git', 'log', '--merges', '--ancestry-path', '--oneline', l:commit_hash . '..master', '--grep', 'pull request'])
    if (len(l:pr_merge_msg) == 0)
        echom "No PR found for line"
        return
    end
    let l:pr_num = matchstr(l:pr_merge_msg[-1], '\(#\)\@<=[0-9]\+')

    call call('vim_github_cli#pr#view', [l:pr_num] + a:000)
endfunc


function! vim_github_cli#pr#list(...)
    """ Open buffer listing all PRs that changed this file.
    "
    " Enter/Ctrl+o display PR under cursor.
    " Additional arguments are passed to `git log`
    "
    " Example:
    "   :GhPrList                     " display all PRs
    "   :GhPrList --since=2015/01/01  " displays PRs merged since 2015/01/01 (see man git-log)
    "
    " Hotkeys:
    "   <Enter>  " display PR text in vim
    "   <c-o>    " display PR in webbrowser
    """
    let l:args = deepcopy(a:000)
    let l:cmd = ['git', 'log', '--merges', '--oneline', '--grep', 'Merge pull request', '--pretty=[%cs] %h | %an | %s | %b'] 
                \ + filter(l:args, '!empty(v:val)')

    let l:pr_merges = systemlist(l:cmd)
    let l:pr_merges = filter(l:pr_merges, 'len(v:val) > 10')
    let l:pr_merges = map(l:pr_merges, "substitute(v:val, 'Merge pull request \\(#\\d\\+\\) from [^\\|]\\+', '\\1 ', '')")

    call s:show_pr_list_buffer(l:pr_merges)
endfunction


function! vim_github_cli#pr#view(pr_num, ...)
    """ Display a PR.
    "
    " See `man gh-pr` for all available arguments.
    "
    " Example:
    "   :call GhPrView('#100')        " show PR in vim
    "   :call GhPrView(100)           " also works
    "   :call GhPrView('#100', '-w')  " show PR in webbrowser
    "
    " Hotkeys:
    "   <c-o>    " display PR in webbrowser
    """
    " execute
    let l:args = deepcopy(a:000)
    let l:cmd = ['gh', 'pr', 'view', a:pr_num] + filter(l:args, '!empty(v:val)')
    let l:output = systemlist(l:cmd)

    " only '-w/--web' params do not display on cli
    if !empty(filter(l:args, 'index(["-w", "--web"], v:val) >= 0'))
        return
    end

    call <SID>show_pr_buffer(l:output)
endfunction


function! s:show_pr_buffer(contents)
    " create buffer
    if bufexists('gh_prbuf')
        bdel gh_prbuf
    end
    badd gh_prbuf
    exec g:vim_github_cli_opencmd_pr_view . ' gh_prbuf'
    setlocal modifiable
    call append(0, a:contents)
    exec ':0'
    setlocal nomodified
    setlocal nomodifiable

    " mappings
    exec 'nmap <buffer> ' . g:vim_github_cli_pr_view_web_map . ' :call <SID>pr_buffer_view_in_browser()<CR>'
endfunction


function! s:show_pr_list_buffer(contents)
    " create buffer
    if bufexists('gh_prlist')
        bdel gh_prlist
    end
    badd gh_prlist
    exec g:vim_github_cli_opencmd_pr_list . ' gh_prlist'
    setlocal modifiable
    call append(0, a:contents)
    exec ':0'
    setlocal nomodifiable
    setlocal nomodified

    " mappings
    exec 'nmap <buffer> ' . g:vim_github_cli_pr_view_map . ' :call <SID>pr_list_view_pr_under_cursor()<CR>'
    exec 'nmap <buffer> ' . g:vim_github_cli_pr_view_web_map . ' :call <SID>pr_list_view_pr_under_cursor("--web")<CR>'
endfunction


function! s:pr_list_view_pr_under_cursor(...)
    """ Open PR under cursor within 'gh_prlist' buffer.
    """
    let l:pr_num = substitute(getline('.'), '^.*\(#\d\+\).*$', '\1', '')
    call call('vim_github_cli#pr#view', [l:pr_num] + a:000)
endfunction


function! s:pr_buffer_view_in_browser()
    """ Open PR displayed in 'gh_prbuf' in webbrowser
    """
    let l:pr_num_line = filter(getline(1, 10), "!match(v:val, '^number:')")[0]
    let l:pr_num = trim(split(l:pr_num_line, ':')[1])
    call call('vim_github_cli#pr#view', [l:pr_num, '--web'])
endfunction
