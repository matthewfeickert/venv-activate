# venv-activate

Bash tab completion of creation and activation of Python virtual environments (installed under `$HOME/.venvs` by default)

## Installation

If `_venv-activate.sh` is installed at `/opt/_venv-activate/_venv-activate.sh` then if the following is added to a user's `~/.bashrc`

```
# Enable tab completion of Python virtual environments
if [ -f /opt/_venv-activate/_venv-activate.sh ]; then
    VENV_ACTIVATE_HOME="${HOME}/.venvs"
    VENV_ACTIVATE_PYTHON=$(which python3)
    . /opt/_venv-activate/_venv-activate.sh
fi
```

then a user can tab complete for possible Python virtual environments to activate with `venv-activate` (assuming that the path of `VENV_ACTIVATE_HOME` actually exists).

## Example

```
$ venv-create data-science
```

results in

```

(data-science) $ python -m pip install --upgrade pip setuptools wheel

# Created virtual environment data-science

# To activate it run:

venv-activate data-science

# To exit the virtual environment run:

deactivate


```

and then

```
$ venv-activate #tab
```

results in

```
$ venv-activate
data-science
```

and tab completing `data-science` and hitting `enter` then activates the virtual environment

```
(data-science) $
```

## Authors

Primary Author: [Matthew Feickert](http://www.matthewfeickert.com/)
