
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVESIZE=10000
export LISTMAX=0
if [ -x "$(which vim)" ]; then
    export EDITOR="$(which vim)"
elif [ -x "$(which vi)" ]; then
    export EDITOR="$(which vi)"
fi
export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS --quit-if-one-screen"
export PAGER=less

# for cygwin
OS=$(uname -o)
if [ "$OS" = "Cygwin" ]; then
    export LESS="$LESS --dumb"
    export TERM=cygwin
    export CFLAGS="-I/usr/local/include -I/usr/include"

    export LANG=ja_JP.SJIS
fi

export PATH="$HOME/bin:$HOME/local/bin:/usr/local/bin:$PATH"
