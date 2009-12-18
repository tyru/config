# vim:set fdm=marker:

bindkey -e

### fpath ### {{{
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
# }}}

### compinit ### {{{
autoload -U compinit
compinit -u
# }}}

### promptinit ### {{{
if [ $UID != 0 ]; then
    autoload promptinit
    promptinit
    prompt adam2
    # prompt elite2
fi
# }}}

### color ### {{{
# ${fg[...]} や $reset_color をロード
autoload -U colors; colors
# }}}

### completion ### {{{
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# ignore alphabet case when completion,
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# }}}

### search history ### {{{
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# bindkey "^I" menu-complete
# }}}

### setopt ### {{{

# http://journal.mycom.co.jp/column/zsh/index.html
# http://www.crimson-snow.net/tips/unix/zsh.html

setopt always_last_prompt
setopt auto_menu
setopt auto_name_dirs
setopt auto_param_keys
setopt auto_param_slash
setopt auto_pushd
setopt auto_remove_slash
setopt mark_dirs
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
setopt complete_in_word
setopt print_eight_bit
setopt prompt_subst
setopt pushd_ignore_dups
setopt rm_star_silent
setopt sh_word_split
setopt share_history
setopt no_beep
setopt no_listbeep
setopt notify
setopt rm_star_wait
setopt no_clobber
setopt no_hup
# setopt auto_cd
# setopt promptcr
# setopt print_exit_value
# }}}

### alias ### {{{
if [ -x "$(which vim)" ]; then
    alias vi=vim
fi

alias df='df -h'
alias du='du -h'
alias less='less -r'
alias l='ll'
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
# }}}

### misc ### {{{
# カレントディレクトリが変わると実行される {{{
# via http://d.hatena.ne.jp/hiboma/20061005/1160026514
chpwd () { ll }
# }}}

# via http://homepage1.nifty.com/blankspace/zsh/zsh.html {{{
typeset -A myabbrev
myabbrev=(
    "l@" "| less"
    "g@" "| grep"
    "p@" "| perl"
    "s@" "| sort -u"
    "n@" ">/dev/null 2>/dev/null"
    "e@" "2>&1"
    "h@" "--help 2>&1"
)
my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[@_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^@_a-zA-Z0-9]\([@_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev
# }}}

# gitのブランチ名を右プロンプトに表示 {{{
# via http://d.hatena.ne.jp/uasi/20091017/1255712789
rprompt-git-current-branch () {
    local name st color
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=`git branch 2> /dev/null | grep '^\*' | cut -b 3-`
    if [[ -z $name ]]; then
        return
    fi
    st=`git status`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
        color=${fg_bold[red]}
    else
        color=${fg[red]}
    fi

    # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
    # これをしないと右プロンプトの位置がずれる
    echo "[%{$color%}$name%{$reset_color%}]"
}
# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
RPROMPT='`rprompt-git-current-branch`'
# }}}

# via http://d.hatena.ne.jp/voidy21/20090902/1251918174 {{{
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $fg[yellow]'%d'$reset_color
zstyle ':completion:*:warnings' format $fg[red]'No matches for:'$fg[yellow]' %d'$reset_color
zstyle ':completion:*:descriptions' format $fg[yellow]'completing %B%d%b'$reset_color
zstyle ':completion:*:corrections' format $fg[yellow]'%B%d '$fg[red]'(errors: %e)%b'$reset_color
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true
# }}}

# 起動済みバックグランドプロセスの標準出力を見るワンライナー {{{
# via http://subtech.g.hatena.ne.jp/cho45/20091118/1258554176
function snatch () {
    gdb -p $1 -batch -n -x =( echo -e "p (int)open(\"/proc/$$/fd/1\", 1)\np (int)dup2(\$1, 1)\np (int)dup2(\$1, 2)" )
}

# }}}

# C-sによる画面の停止を無効{{{
# http://d.hatena.ne.jp/hogem/20090411/1239451878
stty stop undef
# }}}
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

### local ### {{{
if [ -e "$HOME/.alias.local" ]; then
    source "$HOME/.alias.local"
fi
# }}}
