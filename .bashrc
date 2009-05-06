
# root should use default /bin/bash.
if [ $UID != 0 -a -x "$(which zsh)" ]; then
    exec zsh
fi



shopt -s nocaseglob
shopt -s cdspell


alias df='df -h'
alias du='du -h'
alias ll='ls -l'
alias la='ls -A'
alias l=ls

if [ -x "$(which vim)" ]; then
    if [ -x "/usr/local/bin/vim" ]; then
        alias vi=/usr/local/bin/vim
    else
        alias vi=vim
    fi
fi


OS=$(uname -o)
if [ "$OS" = "Cygwin" ]; then
    alias ls='ls -hF --color=tty --show-control-chars'   # classify files in colour

    alias less='less -r'                          # raw control characters
    # alias whence='type -a'                      # where, of a sort
else
    alias ls='ls -hF --color=tty'
fi


