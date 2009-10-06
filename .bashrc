
# root should use /bin/bash
if [ $UID != 0 -a -x "$(which zsh)" ]; then
    exec zsh
fi



### shopt ###
shopt -s nocaseglob
shopt -s cdspell

set bell-style visible


### alias ###
alias df='df -h'
alias du='du -h'
alias less='less -r'
alias l='ls'
alias lh='ls -lh'
alias la='ls -A'
alias l.='ls -d .*'

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


### function ###
cd () {
    command cd $1
    ls -l
}


### cygwin ###
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



### local ###

if [ -e "$HOME/.alias.local" ]; then
    source "$HOME/.alias.local"
fi
