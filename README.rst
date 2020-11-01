
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

    :GhPrBlame     " display PR for line within vim (<c-o> to open in webbrowser)
    :GhPrBlame -w  " display PR for line in web-browser (also wraps other `gh pr` params)

    :GhPrList                     " display all PRs that changed current file
    :GhPrList --since=2015/01/01  " also wraps other `git log` params
    " <Enter> displays PR in vim
    " <c-o> opens PR in webbrowser

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


