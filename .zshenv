
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVESIZE=1000
export LISTMAX=0
if [ -x "$(which vim)" ]; then
    export EDITOR="$(which vim)"
elif [ -x "$(which vi)" ]; then
    export EDITOR="$(which vi)"
fi
export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS --quit-if-one-screen"
export PATH=${HOME}/bin:${PATH}

# for cygwin
OS=$(uname -o)
if [ "$OS" = "Cygwin" ]; then
    export LESS="$LESS --dumb"
    export TERM=cygwin
    export CFLAGS="-I/usr/local/include -I/usr/include"

    export LANG=ja_JP.SJIS
fi


# local::lib
export PATH="$HOME/local/bin:$PATH"
export PERL5LIB="$HOME/local/lib/perl5:$HOME/local/lib/perl5/site_perl:$PERL5LIB"
export PKG_DBDIR="$HOME/local/var/db/pkg"
export PORT_DBDIR="$HOME/local/var/db/pkg"
export INSTALL_AS_USER
export LD_LIBRARY_PATH="$HOME/local/lib"
mkdir -p ~/local/var/db/pkg

export GISTY_DIR="$HOME/work/gist"

# scala
export PATH="$PATH:/usr/local/scala-2.7.4.final/bin"


# delete duplicated paths
if [ -x "$(which perl)" ]; then

    function rmdupenv() {
        if [ $# = 0 ]; then return; fi
        local env="$1"
        local sep="$2"

        eval "export $env=$(perl -e 'my ($e, $s) = (shift, shift || q(:)); #\
                                for(split $s, $ENV{$e}) { #\
                                    $h{$_} or $h{$_}=++$i #\
                                } #\
                                $,=$s; #\
                                %h=reverse %h; #\
                                print map { $h{$_} } #\
                                      sort { $a <=> $b } keys %h' \
                            $env $sep)"
    }

    export PATH="/bin:/usr/bin:$PATH"
    rmdupenv PATH
    rmdupenv PERL5LIB
fi


if [ -f "$HOME/.zshenv.local" ]; then
    source "$HOME/.zshenv.local"
fi
