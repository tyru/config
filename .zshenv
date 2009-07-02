
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


# local::lib
export PERL5LIB="$HOME/local/lib/perl5:$HOME/local/lib/perl5/site_perl:$PERL5LIB"
export PKG_DBDIR="$HOME/local/var/db/pkg"
export PORT_DBDIR="$HOME/local/var/db/pkg"
export INSTALL_AS_USER
export LD_LIBRARY_PATH="$HOME/local/lib"
mkdir -p ~/local/var/db/pkg

export GISTY_DIR="$HOME/work/gist"


# delete duplicated paths
export PATH="$HOME/bin:$HOME/local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
if [ -x "$(which rmdupenv)" ]; then
    rmdupenv PATH
    rmdupenv PERL5LIB
fi


if [ -f "$HOME/.env.local" ]; then
    source "$HOME/.env.local"
fi
