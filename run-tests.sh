#!/usr/bin/env bash
fg_comment=$(tput setaf 8)
fg_preview=$(tput setaf 3)
fg_normal=$(tput sgr0)
fg_header=$(tput setaf 4)
interactive=0
args=$@

while [ $# -gt 0 ] ; do
    case $1 in
        -h|--help)
            echo "${fg_preview}run-tests.sh [-i] [TESTFILE [TESTFILE...]]${fg_normal}"
            echo
            echo "${fg_header}DESCRIPTION:${fg_normal}"
            echo "    runs unittests (all by default)"
            echo
            echo "${fg_header}ARGUMENTS:${fg_normal}"
            echo "    -i --interactive"
            echo "        runs vader interactively (defaults to non-interactive)"
            echo
            echo "${fg_header}EXAMPLES:${fg_normal}"
            echo "    ${fg_comment}# run all tests, non-interactively${fg_normal}"
            echo "    ./run-tests.sh"
            echo
            echo "    ${fg_comment}# run all tests, interactively${fg_normal}"
            echo "    ./run-tests.sh -i"
            echo
            echo "    ${fg_comment}# run single testfile, non-interactively${fg_normal}"
            echo "    ./run-tests.sh tests/viml/test_error.vader"
            echo
            echo "    ${fg_comment}# run multiple testfiles, non-interactively${fg_normal}"
            echo "    ./run-tests.sh \\"
            echo "        tests/viml/test_error.vader \\"
            echo "        tests/viml/test_graphql.vader"
            echo
            exit 0
            ;;
        -i|--interactive)
            interactive=1
            args=( "${args[@]/$1}" )
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if test -z "${args}" ; then
    default_tests='tests/viml/*.vader'
else
    default_tests=""
fi

test -d .test_deps || mkdir -p .test_deps
test -e .test_deps/vader.vim/.git || git clone https://github.com/junegunn/vader.vim .test_deps/vader.vim
test -e .test_deps/jellybeans.vim/.git || git clone https://github.com/nanotech/jellybeans.vim  .test_deps/jellybeans.vim

vimrc=$(cat <<-END
filetype off
set rtp+=.test_deps/vader.vim
set rtp+=.test_deps/jellybeans.vim
set rtp+=.
filetype plugin indent on
syntax enable
colorscheme jellybeans
map <leader>q :q<CR>
END
)

if [[ "$interactive" == "1" ]] ; then
    vadercmd='+Vader '
    vadercmd+=" $default_tests"
    vim -Nu <(echo "$vimrc") "$vadercmd ${args[@]}"
else
    vadercmd='Vader! '
    vadercmd+=" $default_tests"
    vim -Nu <(echo "$vimrc") -c "$vadercmd ${args[@]}" > /dev/null
fi
