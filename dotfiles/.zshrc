# vim:set fdm=marker fmr=<<<,>>>:

# $MY_CURRENT_ENV is necessary for .shrc.common
MY_CURRENT_ENV="$(perl -e 'print $^O')"
source ~/.shrc.common

bindkey -e


if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

### fpath ### <<<
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
# >>>
### compinit ### <<<
autoload -U compinit
compinit -u
# >>>
### promptinit ### <<<
if [ $UID != 0 ]; then
    autoload promptinit
    promptinit
    prompt adam2
    # prompt elite2
fi
# >>>
### color ### <<<
# ${fg[...]} や $reset_color をロード
autoload -U colors; colors
# >>>
### completion ### <<<
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# ignore alphabet case when completion,
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# >>>
### search history ### <<<
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# bindkey "^I" menu-complete
# >>>
### setopt ### <<<

# http://journal.mycom.co.jp/column/zsh/index.html
# http://www.crimson-snow.net/tips/unix/zsh.html

setopt always_last_prompt
setopt append_history
setopt auto_cd
setopt auto_menu
setopt auto_name_dirs
setopt auto_param_keys
setopt auto_param_slash
setopt auto_pushd
setopt auto_remove_slash
setopt cdable_vars
setopt complete_in_word
setopt correct
setopt extended_glob
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt interactive_comments
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt mark_dirs
setopt no_beep
setopt no_clobber
setopt no_hup
setopt no_listbeep
setopt no_promptcr
setopt notify
setopt print_eight_bit
setopt prompt_subst
setopt pushd_ignore_dups
setopt rm_star_silent
setopt rm_star_wait
setopt sh_word_split
setopt share_history
# setopt print_exit_value
# >>>
### abbrev ### <<<
# via http://homepage1.nifty.com/blankspace/zsh/zsh.html
typeset -A myabbrev
myabbrev=(
    "l@" "| less"
    "g@" "| grep"
    "p@" "| perl"
    "s@" "| sort"
    "u@" "| sort -u"
    "c@" "| xsel --input --clipboard"
    "x@" "| xargs"
    "v@" "| vim -"
    "n@" ">/dev/null 2>&1"
    "e@" "2>&1"
    "h@" "--help 2>&1 | less"
    "r@" "3>&2 2>&1 1>&3"
    "t@" "&>/dev/null </dev/null &"
)
my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[@_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^@_a-zA-Z0-9]\([@_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev
# >>>
### misc ### <<<
# カレントディレクトリが変わると実行される <<<
# via http://d.hatena.ne.jp/hiboma/20061005/1160026514
chpwd () { ll }
# >>>
# <<<
RPROMPT="$RPROMPT%T "
# >>>
# gitのブランチ名を右プロンプトに表示 <<<
# http://d.hatena.ne.jp/mollifier/20090814/p1
# http://www.pshared.net/diary/20100708.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable svn hg git bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr)*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="$RPROMPT%1(v|%F{green}%1v%f|)"
# >>>
# 補完時に色んな情報を出す <<<
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
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
# >>>
# 補完のセパレータを設定する <<<
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
zstyle ':completion:*' list-separator '-->'
# >>>
# manの補完をセクション番号別に表示させる <<<
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
zstyle ':completion:*:manuals' separate-sections true
# >>>
# 起動済みバックグランドプロセスの標準出力を見るワンライナー <<<
# via http://subtech.g.hatena.ne.jp/cho45/20091118/1258554176
function snatch () {
    gdb -p $1 -batch -n -x =( echo -e "p (int)open(\"/proc/$$/fd/1\", 1)\np (int)dup2(\$1, 1)\np (int)dup2(\$1, 2)" )
}
# >>>
# C-sによる画面の停止を無効 <<<
# http://d.hatena.ne.jp/hogem/20090411/1239451878
stty stop undef
# >>>
# surround.vimみたいにクォートで囲む <<<
# http://d.hatena.ne.jp/mollifier/20091220/p1

autoload -U modify-current-argument

# シングルクォート用
_quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey '^[q' _quote-previous-word-in-single

# ダブルクォート用
_quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^[Q' _quote-previous-word-in-double
# >>>
# vimperator-like completion <<<
# via http://gist.github.com/414589
if [ -f "$HOME/.zsh/auto-fu.zsh/auto-fu.zsh" -a "$MY_CURRENT_ENV" != "cygwin" ]; then
    unsetopt sh_word_split
    zstyle ':completion:*' completer _oldlist _complete _expand _match _prefix _approximate _list _history

    AUTO_FU_NOCP=1 source $HOME/.zsh/auto-fu.zsh/auto-fu.zsh

    # enable.
    zle-line-init () {
        auto-fu-init
    }
    zle -N zle-line-init


    # http://d.hatena.ne.jp/tarao/20100823/1282543408
    #
    # delete unambiguous prefix when accepting line
    function afu+delete-unambiguous-prefix () {
        afu-clearing-maybe
        local buf; buf="$BUFFER"
        local bufc; bufc="$buffer_cur"
        [[ -z "$cursor_new" ]] && cursor_new=-1
        [[ "$buf[$cursor_new]" == ' ' ]] && return
        [[ "$buf[$cursor_new]" == '/' ]] && return
        ((afu_in_p == 1)) && [[ "$buf" != "$bufc" ]] && {
            # there are more than one completion candidates
            zle afu+complete-word
            [[ "$buf" == "$BUFFER" ]] && {
                # the completion suffix was an unambiguous prefix
                afu_in_p=0; buf="$bufc"
            }
            BUFFER="$buf"
            buffer_cur="$bufc"
        }
    }
    zle -N afu+delete-unambiguous-prefix
    function afu-ad-delete-unambiguous-prefix () {
        local afufun="$1"
        local code; code=$functions[$afufun]
        eval "function $afufun () { zle afu+delete-unambiguous-prefix; $code }"
    }
    afu-ad-delete-unambiguous-prefix afu+accept-line
    afu-ad-delete-unambiguous-prefix afu+accept-line-and-down-history
    afu-ad-delete-unambiguous-prefix afu+accept-and-hold


    # `Perl -M` の時に候補を探しにいくのを抑制する {{{
    # http://d.hatena.ne.jp/hchbaw/20110309/1299680906
    #
    # ':auto-fu:var' autoable-function/preds に登録されたそれぞれの関数には順に、
    # - $1にカーソルの直前の引数
    # - $2にカーソル付近のコマンド(のようなもの)
    # - $3にカーソル付近のコマンド(のようなもの)からカーソルまでの文字列
    # - $4にカーソル付近のコマンド(のようなもの)全体の文字列
    # が渡されます。(上の方に書いたパターンをもとに自動補完の抑制を行なっている
    # のもここに登録された関数で実装されています。)
    # この場合、コマンドがperlで、引数-Mxxxを処理している際に非0を返して自動補完
    # を抑制するようにしています。
    # 仮にここで-1をかえすと_ただちに自動補完をする_ということになります。
    afu-autoable-pm-p () { [[ ! ("$2" == 'perl' && "$1" == -(#i)m*) ]] }

    # デフォルト値を'preds'へと取得します
    local -a preds; afu-autoable-default-functions preds
    preds+=afu-autoable-pm-p
    # }}}


    zstyle ':auto-fu:var' autoable-function/preds $preds
fi
# >>>
# コマンドラインの単語区切りを設定する <<<
# http://d.hatena.ne.jp/sugyan/20100712/1278869962
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified
# >>>
# zshのgitファイル補完の高速化 <<<
# http://u7fa9.org/memo/HEAD/archives/2011-02/2011-02-01.rst
__git_files() { _files }
# >>>
# 右プロンプトに終了ステータスを含める <<<
RPROMPT="$RPROMPT%(?.. %F{red}[%B%?%b%F{red}])"
# >>>
# ^R, ^S: history-incremental-pattern-search-(forward|backward) <<<
autoload -Uz is-at-least
if is-at-least 4.3.10; then
    # http://subtech.g.hatena.ne.jp/secondlife/20110222/1298354852
    # http://subtech.g.hatena.ne.jp/mayuki/20110310/1299761759
    # zsh 4.3.10 でないと動かない
    bindkey '^R' history-incremental-pattern-search-backward
    bindkey '^S' history-incremental-pattern-search-forward
fi
# >>>
# Ctrl+wで､直前の/までを削除する <<<
# http://edvakf.tumblr.com/post/24017596/setopt-hist-ignore-dups
WORDCHARS='*?_-.[]~=&;!#$%^(){}'
# >>>
# >>>
### cygwin ### <<<
if [ "$MY_PERL_DOLLAR_O" = 'cygwin' ]; then
    source ~/.shrc.cygwin
fi
# >>>

source ~/.shrc.start-screen
