# venv-activate

Bash tab completion of activation of Python virtual environments (that are installed under `$HOME/venvs`)

## Installation

If `_venv-activate.sh` is installed at `/opt/_venv-activate/_venv-activate.sh` then if the following is added to a user's `~/.bashrc`

```
# Enable tab completion of Python virtual environments
if [ -f /opt/_venv-activate/_venv-activate.sh ]; then
    . /opt/_venv-activate/_venv-activate.sh
fi
```

then a user can tab complete for possible Python virtual environments to activate with `venv-activate` if the virtual environments are installed under `$HOME/venvs/`

## Example

```
$ mkdir -p $HOME/venvs
$ cd $HOME/venvs
$ python3 -m venv data-science
$ cd
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
