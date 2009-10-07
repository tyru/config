
# source the system wide bashrc if it exists
if [ -f "/etc/bashrc" ] ; then
  source "/etc/bashrc"
fi

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

# for cygwin
OS=$(uname -o)
if [ "$OS" = "Cygwin" ]; then
    export LESS=MrXEd
    export TERM=cygwin
    export CFLAGS="-I/usr/local/include -I/usr/include"

    export LANG=ja_JP.SJIS
fi

export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS"
export PAGER=less
if [ -x "$(which vim)" ]; then
    export EDITOR="$(which vim)"
elif [ -x "$(which vi)" ]; then
    export EDITOR="$(which vi)"
fi
export PS1="{\@} \u@\H in [\W]\n \\$ "

# delete duplicated paths
export PATH="$HOME/bin:$HOME/local/bin:/usr/local/bin:$PATH"



### local ###

if [ -e "$HOME/.env.local" ]; then
    source "$HOME/.env.local"
fi
