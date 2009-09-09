
bindkey -e


### compinit ###
autoload -U compinit
compinit -u

### promptinit ###
if [ $UID != 0 ]; then
    autoload promptinit
    promptinit
    prompt adam2
    # prompt elite2
fi

### colorize ###
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# ignore alphabet case when completion,
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

### search history ###
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^R" history-incremental-search-backward
# no response when pressed in command line and vim
# bindkey "^S" history-incremental-search-forward

### setopt ###
setopt always_last_prompt
setopt auto_menu
setopt auto_name_dirs
setopt auto_param_keys
setopt auto_pushd
setopt auto_remove_slash
setopt cdable_vars
setopt correct
setopt extended_glob
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt interactive_comments
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt print_eight_bit
setopt prompt_subst
setopt pushd_ignore_dups
setopt rm_star_silent
setopt sh_word_split
setopt share_history
unsetopt auto_cd
unsetopt beep
unsetopt listbeep
unsetopt print_exit_value
unsetopt promptcr



### alias ###
if [ -x "$(which vim)" ]; then
    alias vi=vim
fi

alias df='df -h'
alias du='du -h'
alias less='less -r'
alias l='ls'
alias ll='ls -lh'
alias la='ls -A'
alias l.='ls -d .*'
alias free='free -m -l -t'

OS="$(uname -o)"
if [ "$OS" = "Cygwin" ]; then
    alias less='less -r'
    alias ls='ls --color=tty --show-control-chars'
else
    alias ls='ls --color=tty'
fi


### misc ###

typeset -A myabbrev
myabbrev=(
    "@l" "| less"
    "@g" "| grep"
    "@p" "| perl"
    "@n" ">/dev/null 2>&1"
)

my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[@_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^@_a-zA-Z0-9]\([@_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev

bindkey     " "         my-expand-abbrev




# via http://blog.s21g.com/articles/602
_git-svn () {
    `git-svn --help \
    | grep "^ \w" \
    | sed "s/^ //" \
    | sed "s/ .*//" \
    | sed 's/^/ compadd /'`
}
compdef _git-svn git-svn 

# カレントディレクトリが変わると実行される
chpwd () { ls }




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
