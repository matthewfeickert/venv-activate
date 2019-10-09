#!/usr/bin/env bash

if [[ -z "${VENV_ACTIVATE_PYTHON}" ]]; then
    printf "\n# venv-activate fails as VENV_ACTIVATE_PYTHON is not set.\n"
    return 1
fi

function venv-create() {
    if [[ ! -d "${HOME}/venvs" ]]; then
        mkdir -p "${HOME}/venvs"
    fi
    if [[ -z "$1" ]]; then
        printf "\nEnter a new virtual environment name\n\n"
    elif [[ -d "${HOME}/venvs/$1" ]]; then
        printf "\nERROR: %s already exists as a virtual environment: ${HOME}/venvs/%s\n" "${1}" "${1}"
        printf "\nEnter a new virtual environment name\n\n"
    else
        "${VENV_ACTIVATE_PYTHON}" -m venv "${HOME}/venvs/$1"
        . "${HOME}/venvs/$1/bin/activate"
        printf "\n(%s) $ pip install --upgrade pip setuptools wheel\n" "${1}"
        pip install --upgrade --quiet pip setuptools wheel
        deactivate
        printf "\n# Created virtual environment %s\n" "${1}"
        printf "\n# To activate it run:\n\nvenv-activate %s\n" "${1}"
        printf "\n# To exit the virtual environment run:\n\ndeactivate\n\n"
        return 0
    fi
    return 1
}

_venv-activate()
{
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="$($(which ls) -1 "${HOME}/venvs/" | sed 's/^//')"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=($(compgen -W "${opts}" "${cur}"))
        return 0
    fi
}

function venv-activate() {
    function display_venvs {
        $(which ls) -1 "${HOME}/venvs/" | sed 's/^/* /'
    }
    if [[ -z "$1" ]]; then
        printf "\nEnter a virtual environment:\n"
        display_venvs
    elif [[ -d "${HOME}/venvs/$1" ]]; then
        source "${HOME}/venvs/$1/bin/activate"
        return 0
    else
        printf "\n%s is not a valid virtual environment." "${1}"
        printf "\nSelect from one of:\n"
        display_venvs
    fi
    return 1
}

complete venv-create
complete -F _venv-activate venv-activate
