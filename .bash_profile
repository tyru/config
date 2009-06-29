
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

export PS1="{\@} \u@\H being in [\W]\n \\$ "
export PERL5LIB="$HOME/local/lib/perl5:$HOME/local/lib/perl5/site_perl"
export GISTY_DIR="$HOME/work/gist"

if [ -x "$(which vim)" ]; then
    export EDITOR="$(which vim)"
elif [ -x "$(which vi)" ]; then
    export EDITOR="$(which vi)"
fi

export PKG_DBDIR="$HOME/local/var/db/pkg"
export PORT_DBDIR="$HOME/local/var/db/pkg"
export INSTALL_AS_USER
export LD_LIBRARY_PATH="$HOME/local/lib"
mkdir -p ~/local/var/db/pkg


# delete duplicated paths
export PATH="$HOME/bin:$HOME/local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
if [ -x "$(which rmdupenv)" ]; then
    rmdupenv PATH
    rmdupenv PERL5LIB
fi


if [ -f "$HOME/.env.local" ]; then
    source "$HOME/.env.local"
fi
