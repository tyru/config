
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVESIZE=1000
export LISTMAX=0
export EDITOR="$(which vim)"

if [ -d "${HOME}/bin" ] ; then
    export PATH=${HOME}/bin:${PATH}
fi
# if [ -d "${HOME}/perl5lib" ]; then
#     export PERL5LIB="${HOME}/perl5lib"
# fi

if [ -f "$HOME/.zshenv.local" ]; then
    # overwrite settings
    source "$HOME/.zshenv.local"
fi
