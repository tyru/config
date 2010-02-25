# vim:set fdm=marker:

# exec zsh? {{{
# NOTE: "$PS1" to confirm user to login in interactively.
# (scp, sftp will freeze when login)
#if [ -x "$(which zsh)" && -z "$PS1" ]; then
#    exec zsh
#fi
# }}}

### shopt/set ### {{{
shopt -s nocaseglob
shopt -s cdspell

set bell-style visible
# }}}

### alias ### {{{
if [ -x "$(which vim)" ]; then
    alias vi=vim
fi

alias df='df -h'
alias di='diff'
alias diff='diff -u'
alias du='du -h'
alias free='free -m -l -t'
alias j=jobs
alias jobs='jobs -l'
alias l.='ls -d .*'
alias l='ll'
alias la='ls -A'
alias less='less -r'
alias ll='ls -lh'
alias sc='screen'
alias ev='evince'

if [ -x "$(which perldocjp)" ]; then
    alias perldoc='perldocjp'
fi

OS="$(uname -o)"
if [ "$OS" = "Cygwin" ]; then
    alias less='less -r'
    alias ls='ls --color=tty --show-control-chars'
else
    alias ls='ls --color=tty'
fi

if [ -x "/usr/local/share/vim/vim72/macros/less.sh" ]; then
    alias vless="/usr/local/share/vim/vim72/macros/less.sh"
elif [ -x "/usr/share/vim/vim72/macros/less.sh" ]; then
    alias vless="/usr/share/vim/vim72/macros/less.sh"
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
