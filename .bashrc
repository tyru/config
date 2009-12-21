# vim:set fdm=marker:

# root should use /bin/bash {{{
if [ $UID != 0 -a -x "$(which zsh)" ]; then
    exec zsh
fi
# }}}

### shopt/set ### {{{
shopt -s nocaseglob
shopt -s cdspell

set bell-style visible
# }}}

### alias ### {{{
alias df='df -h'
alias du='du -h'
alias less='less -r'
alias l='ll'
alias ll='ls -lh'
alias la='ls -A'
alias l.='ls -d .*'
alias free='free -m -l -t'
alias sc='screen'
alias c='cd'
alias g='git'
alias v='vi'
alias gm='gvim'
alias diff='diff -u'
alias di='diff -u'
alias jobs='jobs -l'

OS="$(uname -o)"
if [ "$OS" = "Cygwin" ]; then
    alias less='less -r'
    alias ls='ls --color=tty --show-control-chars'
else
    alias ls='ls --color=tty'
fi

if [ -x "$(which vim)" ]; then
    alias vi=vim
fi
# }}}

### function ### {{{
cd () {
    command cd $1
    ll
}
# }}}

### cygwin ### {{{
if [ "$OS" = 'Cygwin' ]; then
    function wwhich() {
        if [ $# != 0 ]; then
            cygpath -w -a $(which $1)
        fi
    }
    function wpwd() {
        /usr/bin/cygpath -w -a .
    }
    function screen() {
        local conf="$HOME/.screenrc.cygwin"
        if [ -f "$conf" ]; then
            command screen -c "$conf" "$@"
        else
            command screen "$@"
        fi
    }
fi
# }}}

# misc. {{{
# C-sによる画面の停止を無効{{{
# http://d.hatena.ne.jp/hogem/20090411/1239451878
stty stop undef
# }}}
# }}}

### local ### {{{
if [ -e "$HOME/.alias.local" ]; then
    source "$HOME/.alias.local"
fi
# }}}
