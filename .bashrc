# vim:set fdm=marker:

MY_CURRENT_ENV="$(perl -e 'print $^O')"
source ~/.shrc.common

# exec zsh? {{{
# NOTE: "$PS1" to confirm user to login in interactively.
# XXX: scp, sftp will freeze when login. Temporarily disabled.
#if [ -x "$(which zsh)" && -z "$PS1" ]; then
#    exec zsh
#fi
# }}}

### shopt/set ### {{{
shopt -s nocaseglob
shopt -s cdspell

set bell-style visible
# }}}

### function ### {{{
cd () {
    command cd $1
    ll
}
# }}}

### cygwin ### {{{
if [ "$MY_PERL_DOLLAR_O" = 'cygwin' ]; then
    source ~/.shrc.cygwin
fi
# }}}

# misc. {{{
# C-sによる画面の停止を無効{{{
# http://d.hatena.ne.jp/hogem/20090411/1239451878
stty stop undef
# }}}
# local::lib {{{
function locallib () {
    local INSTALL_BASE
    INSTALL_BASE=$1
    if [ -d $INSTALL_BASE ]; then
        eval $(use-locallib $INSTALL_BASE)
    fi
}

# }}}
# }}}

# start screen {{{

# `-z "$WINDOW"` means if screen has already started.
# `! -z "$PS1"` means if zsh has started interactively.
if [ "$MY_CURRENT_ENV" != "MSWin32" -a -x "$(which screen)" -a -z "$WINDOW" -a ! -z "$PS1" ]; then
    screen
fi

# }}}
