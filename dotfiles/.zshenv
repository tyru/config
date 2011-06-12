# vim:set fdm=marker:

if [ -f "$HOME/.env.common" ]; then
    source $HOME/.env.common
fi

export HISTFILE=~/.zsh_history
export HISTSIZE=300000
export SAVESIZE=300000
export LISTMAX=0
