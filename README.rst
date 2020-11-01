
vim-github-cli
==============

Exposes some github-cli_ functionality within vim.

.. _github-cli: https://github.com/cli/cli


.. contents::



Install
-------

1. Install github-cli for your OS (ex: ``sudo pacman -S github-cli``)
2. Associate github-cli to your account (ex: ``gh auth login``)
3. Install plugin (vundle, pathogen, rtp)



Usage
-----

More details in `:help vim-github-cli` .


Pull Requests
.............


.. code-block:: vim

    " Display PR that changed line under cursor
    " (within buffer, <c-o> opens in webbrowser)
    :GhPrBlame

    " Supports `gh pr` params
    :GhPrBlame -w
    :GhPrBlame -R <repo>


.. code-block:: vim

    " Display all PRs that touched file
    " (within buffer, <Enter> shows PR in vim, <c-o> opens in webbrowser)
    :GhPrList

    " Also supports `git log` params
    :GhPrList --since=2015/01/01
    :GhPrList -n 10


.. code-block:: vim

    :GhPrView 100     " display PR #100 in vim
    :GhPrView 100 -w  " display PR #100 in webbrowser


Configuration
-------------

.. code-block:: vim

    " buffers
    let g:vim_github_cli_opencmd_pr_list = 'vert sb'
    let g:vim_github_cli_opencmd_pr_view = 'vert sb'

    " hotkeys
    let g:vim_github_cli_pr_view_map = '<Enter>'
    let g:vim_github_cli_pr_view_web_map = '<c-o>'


