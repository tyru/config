
# bindkey
bindkey -v

bindkey "^R" history-incremental-search-backward
# no response when pressed in command line and vim
# bindkey "^S" history-incremental-search-forward

# compinit
autoload -U compinit
compinit -u

# promptinit
if [ $UID != 0 ]; then
    autoload promptinit
    promptinit
    prompt adam2
    # prompt elite2
fi

# colorize
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# ignore alphabet case when completion,
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# history-search-end
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# setopt
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


# alias
alias vi=vim
alias df='df -h'
alias du='du -h'
alias less='less -r'
alias l=ls
alias ll='ls -l'
alias ls='ls --color=tty --show-control-chars'
alias la='ls -A'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'


# function
# via http://www.q-eng.imat.eng.osaka-cu.ac.jp/~ippei/unix/zsh.html
function psg() {
    psa | head -n 1      # show label
    # do not show grep process
    psa | grep $* | grep -v "ps -auxww" | grep -v grep
}

function makevi() {
    make 2>&1 > .make.tmp
    vi .make.tmp
    rm .make.tmp
}

function noizy() {
    while :; do
        echo "\a"
        sleep 0.1
    done
}

function catjp() {
    local encoding
    if [ $(uname -o) = "Cygwin" ]; then
        encoding="windows"
    else
        encoding="unix"
    fi

    while getopts e: opt; do
        case $opt in
            "e" ) encoding="$OPTARG" ;;
            *   ) usage ; exit 0 ;;
        esac
    done

    cat $* | nkf --$encoding
}

function ccgl() {
    gcc "$@" -lglut32 -lglu32 -lopengl32
}

function cpan-inst() {
    for i in "$*"; do
        yes '' | cpan -i $i
    done
}

function title() {
    screen -X eval "title '$1'"
}

function ppath() {
    perl -MFile::Spec -e 'print join qq(\n), File::Spec->path'
}


# for cygwin
if [ $(uname -o) = 'Cygwin' ]; then
    alias gvim='/cygdrive/c/WINDOWS/system32/cmd.exe /c E:/usr/bin/gvim.bat'

    function explorer() {
        local path
        if [ $# = 0 ]; then
            path="."
        else
            path="$1"
        fi
        /cygdrive/c/WINDOWS/explorer.exe \
            "$(/usr/bin/cygpath.exe -w -a $path)"
    }
    function cmd() {
        if [ $# != 0 ]; then
            /cygdrive/c/WINDOWS/system32/cmd.exe /c \
                "$(/usr/bin/cygpath.exe -w -a $*)"
        fi
    }
    function wwhich() {
        if [ $# != 0 ]; then
            cygpath -w -a $(which $1)
        fi
    }
    function wpwd() {
        /usr/bin/cygpath -w -a .
    }
    function ccgl() {
        gcc "$@" -DWIN32 -lglut32 -lglu32 -lopengl32
    }
    function screen() {
        local conf="$HOME/.screenrc.cygwin"
        if [ $# = 0 -a -f $conf ]; then
            command screen -c $conf
        else
            command screen "$@"
        fi
    }
fi


if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
