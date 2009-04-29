
if [ -x $(which zsh) ]; then
    exec zsh
fi



shopt -s nocaseglob
shopt -s cdspell



# Default to human readable figures
alias df='df -h'
alias du='du -h'

alias less='less -r'                          # raw control characters
# alias whence='type -a'                      # where, of a sort

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty --show-control-chars'   # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #


