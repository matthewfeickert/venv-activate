#!/usr/bin/env bash

_venv-activate()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="$(echo $($(which ls) -1 ${HOME}/venvs/ | sed 's/^//'))"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=($(compgen -W "${opts}" $cur))
        return 0
    fi
}

function venv-activate() {
    function display_venvs {
        $(which ls) -1 ${HOME}/venvs/ | sed 's/^/* /'
    }
    if [[ -z "$1" ]]; then
        printf "\nEnter a virtual environment:\n"
        display_venvs
    elif [[ -d "${HOME}/venvs/$1" ]]; then
        source "${HOME}/venvs/$1/bin/activate"
        return 0
    else
        printf "\n$1 is not a valid virtual environment."
        printf "\nSelect from one of:\n"
        display_venvs
    fi
    return 1
}

complete -F _venv-activate venv-activate
