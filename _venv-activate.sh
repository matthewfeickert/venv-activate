#!/usr/bin/env bash

if [[ -z "${_VENV_ACTIVATE_HOME}" ]]; then
    printf "\n# ERROR: venv-activate fails as _VENV_ACTIVATE_HOME is not set.\n"
    _check_flag=1
fi
if [[ -z "${_VENV_ACTIVATE_PYTHON}" ]]; then
    printf "\n# ERROR: venv-activate fails as _VENV_ACTIVATE_PYTHON is not set.\n"
    _check_flag=1
fi
if [[ "${_check_flag}" -eq 1 ]]; then
    unset _check_flag
    return 1
fi
if [[ ! -d "${_VENV_ACTIVATE_HOME}" ]]; then
    printf "\n# ERROR: venv-venv-activate fails as _VENV_ACTIVATE_HOME path %s does not exist.\n\n" "${_VENV_ACTIVATE_HOME}"
    return 1
fi

function venv-create() {
    if [[ ! -d "${_VENV_ACTIVATE_HOME}" ]]; then
        printf "\n# ERROR: venv-create fails as _VENV_ACTIVATE_HOME does not exist.\n\n"
        return 1
    fi
    if [[ -z "$1" ]]; then
        printf "\nEnter a new virtual environment name\n\n"
    elif [[ -d "${_VENV_ACTIVATE_HOME}/$1" ]]; then
        printf "\nERROR: %s already exists as a virtual environment: ${_VENV_ACTIVATE_HOME}/%s\n" "${1}" "${1}"
        printf "\nEnter a new virtual environment name\n\n"
    else
        "${_VENV_ACTIVATE_PYTHON}" -m venv "${_VENV_ACTIVATE_HOME}/${1}"
        # shellcheck disable=SC1090
        . "${_VENV_ACTIVATE_HOME}/$1/bin/activate"
        printf "\n(%s) $ python -m pip install --upgrade pip setuptools wheel\n" "${1}"
        python -m pip install --upgrade --quiet pip setuptools wheel
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
    opts="$(command ls -1 "${_VENV_ACTIVATE_HOME}/" | sed 's/^//')"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=($(compgen -W "${opts}" "${cur}"))
        return 0
    fi
}

function venv-activate() {
    function display_venvs {
        command ls -1 "${_VENV_ACTIVATE_HOME}/" | sed 's/^/* /'
    }
    if [[ -z "$1" ]]; then
        printf "\nEnter a virtual environment:\n"
        display_venvs
    elif [[ -d "${_VENV_ACTIVATE_HOME}/$1" ]]; then
        # shellcheck disable=SC1090
        source "${_VENV_ACTIVATE_HOME}/$1/bin/activate"
        return 0
    else
        printf "\n%s is not a valid virtual environment." "${1}"
        printf "\nSelect from one of:\n"
        display_venvs
    fi
    return 1
}

function venv-remove() {
    function display_venvs {
        command ls -1 "${_VENV_ACTIVATE_HOME}/" | sed 's/^/* /'
    }
    if [[ ! -d "${_VENV_ACTIVATE_HOME}" ]]; then
        printf "\n# ERROR: venv-remove fails as _VENV_ACTIVATE_HOME does not exist.\n\n"
        return 1
    fi
    if [[ -z "$1" ]]; then
        printf "\nEnter a virtual environment name to remove\n\n"
        display_venvs
    elif [[ ! -d "${_VENV_ACTIVATE_HOME}/$1" ]]; then
        printf "\nERROR: %s does not exist as a virtual environment under ${_VENV_ACTIVATE_HOME}/\n" "${1}"
        printf "\nEnter an existing virtual environment name to remove:\n"
        display_venvs
    else
        rm -rf "${_VENV_ACTIVATE_HOME:?}/${1}"
        printf "\n# Deleted virtual environment %s\n" "${1}"
        return 0
    fi
    return 1
}

function venv-info() {
    function display_venvs {
        command ls -1 "${_VENV_ACTIVATE_HOME}/" | sed 's/^/* /'
    }
    if [[ ! -d "${_VENV_ACTIVATE_HOME}" ]]; then
        printf "\n# ERROR: venv-info fails as _VENV_ACTIVATE_HOME does not exist.\n\n"
        return 1
    fi
    if [[ -z "$1" ]]; then
        printf "\nEnter a virtual environment name to show information:\n\n"
        display_venvs
    elif [[ ! -d "${_VENV_ACTIVATE_HOME}/$1" ]]; then
        printf "\nERROR: %s does not exist as a virtual environment under ${_VENV_ACTIVATE_HOME}/\n" "${1}"
        printf "\nEnter an existing virtual environment name to show information:\n"
        display_venvs
    else
        local venv_bin="${_VENV_ACTIVATE_HOME:?}/${1}/bin"
        printf "\n# Python   : v%s\n" "$(${venv_bin}/python --version | awk '{print $NF}')"
        printf "# pip      : v%s\n" "$(${venv_bin}/python -m pip --version | awk '{print $2}')"
        printf "# installed: %s\n" "$(${venv_bin}/python -m pip freeze | wc -l) packages"
        return 0
    fi
    return 1
}

complete venv-create
complete -F _venv-activate venv-activate
complete -F _venv-activate venv-remove
complete -F _venv-activate venv-info
