
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVESIZE=1000
export LISTMAX=0
export EDITOR="$(which vim)"

if [ -d "${HOME}/bin" ] ; then
    export PATH=${HOME}/bin:${PATH}
fi


export PKG_DBDIR="$HOME/local/var/db/pkg"
export PORT_DBDIR="$HOME/local/var/db/pkg"
export INSTALL_AS_USER
export LD_LIBRARY_PATH="$HOME/local/lib"
mkdir -p ~/local/var/db/pkg


if [ -f "$HOME/.zshenv.local" ]; then
    # overwrite settings
    source "$HOME/.zshenv.local"
fi
