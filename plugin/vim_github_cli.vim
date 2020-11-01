
" =============
" Configuration
" =============

function! s:set_config_with_fallback(variable, default)
    if !exists(a:variable)
        exec "let ". a:variable ." = '". a:default ."'"
    end
endfunction


" buffers
call s:set_config_with_fallback('g:vim_github_cli_opencmd_pr_list', 'sb')
call s:set_config_with_fallback('g:vim_github_cli_opencmd_pr_view', 'sb')

" hotkeys
call s:set_config_with_fallback('g:vim_github_cli_pr_view_map',     '<Enter>')
call s:set_config_with_fallback('g:vim_github_cli_pr_view_web_map', '<c-o>')


" ========
" Commands
" ========

" Show last PR to change current line.
" Wraps `gh pr view` params.
"
" Example
"   :GhPrBlame
"   :GhPrBlame -w
command -nargs=* GhPrBlame :call vim_github_cli#pr#blame(<f-args>)


" List PRs that modified current file.
" Wraps `git log` params.
"
" Example
"   :GhPrList
"   :GhPrList -n 10
"   :GhPrList --since=2015/01/01
"
command -nargs=* GhPrList :call vim_github_cli#pr#list(<f-args>)


" Wraps `gh pr view` and it's params
"
" Example
"   :GhPrView 100
"   :GhPrView #100 -w
"
command -nargs=* GhPrView :call vim_github_cli#pr#view(<f-args>)


