# vim:set fdm=marker fmr=<<<<,>>>>:

bindkey -e

### fpath ### <<<<
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
# >>>>
### compinit ### <<<<
autoload -U compinit
compinit -u
# >>>>
### promptinit ### <<<<
if [ $UID != 0 ]; then
    autoload promptinit
    promptinit
    prompt adam2
    # prompt elite2
fi
# >>>>
### color ### <<<<
# ${fg[...]} や $reset_color をロード
autoload -U colors; colors
# >>>>
### completion ### <<<<
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# ignore alphabet case when completion,
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# >>>>
### search history ### <<<<
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# bindkey "^I" menu-complete
# >>>>
### setopt ### <<<<

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
setopt hist_ignore_dups
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
# >>>>
### alias ### <<<<
alias df='df -h'
alias diff='diff -u'
alias du='du -h'
alias free='free -m -l -t'
alias j='jobs'
alias jobs='jobs -l'
alias l.='ls -d .*'
alias l='ll'
alias la='ls -A'
alias less='less -r'
alias ll='ls -lh'
alias whi='which'
alias whe='where'
alias go='gopen'
alias vprove='vim -c SimpleTapRun'
alias lingr='vim -c LingrLaunch'

if [ -x "$(which vim)" ]; then
    alias vi='vim'
fi

if [ -x "$(which tscreen)" ]; then
    alias screen='tscreen'
fi
alias sc=screen

if [ -x "$(which perldocjp)" ]; then
    alias perldoc='perldocjp'
fi

CURRENT_ENV="$(perl -e 'print $^O')"
if [ "$CURRENT_ENV" = "cygwin" ]; then
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
# >>>>
### misc ### <<<<
# カレントディレクトリが変わると実行される <<<<
# via http://d.hatena.ne.jp/hiboma/20061005/1160026514
chpwd () { ll }
# >>>>
# abbrev <<<<
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
    "n@" ">/dev/null 2>/dev/null"
    "e@" "2>&1"
    "h@" "--help 2>&1 | less"
    "H@" "--help 2>&1"
)
my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[@_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^@_a-zA-Z0-9]\([@_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev
# >>>>
# gitのブランチ名を右プロンプトに表示 <<<<
# http://d.hatena.ne.jp/mollifier/20090814/p1
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"
# >>>>
# 補完時に色んな情報を出す <<<<
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
# >>>>
# 補完のセパレータを設定する <<<<
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
zstyle ':completion:*' list-separator '-->'
# >>>>
# manの補完をセクション番号別に表示させる <<<<
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
zstyle ':completion:*:manuals' separate-sections true
# >>>>
# 起動済みバックグランドプロセスの標準出力を見るワンライナー <<<<
# via http://subtech.g.hatena.ne.jp/cho45/20091118/1258554176
function snatch () {
    gdb -p $1 -batch -n -x =( echo -e "p (int)open(\"/proc/$$/fd/1\", 1)\np (int)dup2(\$1, 1)\np (int)dup2(\$1, 2)" )
}
# >>>>
# C-sによる画面の停止を無効 <<<<
# http://d.hatena.ne.jp/hogem/20090411/1239451878
stty stop undef
# >>>>
# surround.vimみたいにクォートで囲む <<<<
# http://d.hatena.ne.jp/mollifier/20091220/p1

autoload -U modify-current-argument

# シングルクォート用
_quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey '^[g' _quote-previous-word-in-single

# ダブルクォート用
_quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^[G' _quote-previous-word-in-double
# >>>>
# Gitのリポジトリのトップレベルにcdするコマンド <<<<
# http://d.hatena.ne.jp/hitode909/20100211/1265879271
function u()
{
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}
# >>>>
# mkcd <<<<
function mkcd() {
    [ $# = 1 ] && mkdir "$1" && cd "$1"
}
# >>>>
# viwi <<<<
function viwi() {
    local p
    [ $# != 0 ] && p=`which $1` && vi "$p"
}
# >>>>
# vimperator-like completion <<<<
# via http://gist.github.com/414589


unsetopt sh_word_split

# zsh automatic complete-word and list-choices

# Originally incr-0.2.zsh
# Incremental completion for zsh
# by y.fujii <y-fujii at mimosa-pudica.net>

# Thank you very much y.fujii!

# Adopted by Takeshi Banse <takebi@laafc.net>
# I want to use it with menu selection.

# To use this,
# establish `zle-line-init' containing `auto-fu-init' something like below
# % source auto-fu.zsh; zle-line-init () {auto-fu-init;}; zle -N zle-line-init

# XXX: use with the error correction or _match completer.
# If you got the correction errors during auto completing the word, then
# plese do _not_ do `magic-space` or `accept-line`. Insted please do the
# following, `undo` and then hit <tab> or throw away the buffer altogether.
# This applies _match completer with complex patterns, too.
# I'm very sorry for this annonying behaviour.
# (For example, 'ls --bbb' and 'ls --*~^*al*' etc.)

# TODO: handle RBUFFER.
# TODO: region_highlight, POSTDISPLAY and such should be zstyleable.
# TODO: signal handling during the recursive edit.
# TODO: add afu-viins/afu-vicmd keymaps.
# TODO: handle empty or space characters.

afu_zles=( \
  # Zles should be rebinded in the afu keymap. `auto-fu-maybe' to be called
  # after it's invocation, see `afu-initialize-zle-afu'.
  self-insert backward-delete-char backward-kill-word kill-line \
  kill-whole-line \
)

autoload +X keymap+widget

(( $+functions[keymap+widget-fu] )) || {
  local code=${functions[keymap+widget]/for w in *
    do
/for w in $afu_zles
  do
  }
  eval "function keymap+widget-fu () { $code }"
}

(( $+functions[afu-boot] )) ||
afu-boot () {
  {
    bindkey -M isearch "^M" afu+accept-line

    bindkey -N afu emacs
    keymap+widget-fu
    bindkey -M afu "^I" afu+complete-word
    bindkey -M afu "^M" afu+accept-line
    bindkey -M afu "^J" afu+accept-line
    bindkey -M afu "^O" afu+accept-line-and-down-history
    bindkey -M afu "^[a" afu+accept-and-hold
    bindkey -M afu "^X^[" afu+vi-cmd-mode

    bindkey -N afu-vicmd vicmd
    bindkey -M afu-vicmd  "i" afu+vi-ins-mode
  } always { "$@" }
}
(( $+functions[afu+vi-ins-mode] )) ||
(( $+functions[afu+vi-cmd-mode] )) || {
afu+vi-cmd-mode () { zle -K afu-vicmd; }; zle -N afu+vi-cmd-mode
afu+vi-ins-mode () { zle -K afu      ; }; zle -N afu+vi-ins-mode
}

{ #(( ${#${(@M)keymaps:#afu}} )) || afu-boot bindkey -e
  #afu-boot bindkey -e
  afu-boot
} >/dev/null 2>&1

local -a afu_accept_lines

afu-recursive-edit-and-accept () {
  local -a __accepted
  zle recursive-edit -K afu || { zle send-break; return }
  #if [[ ${__accepted[0]} != afu+accept* ]]
  if (( ${#${(M)afu_accept_lines:#${__accepted[0]}}} ))
  then zle "${__accepted[@]}"; return
  else return 0
  fi
}

afu-register-zle-accept-line () {
  local afufun="$1"
  local rawzle=".${afufun#*+}"
  local code=${"$(<=(cat <<"EOT"
  $afufun () {
    __accepted=($WIDGET ${=NUMERIC:+-n $NUMERIC} "$@")
    zle $rawzle && region_highlight=("0 ${#BUFFER} bold")
    return 0
  }
  zle -N $afufun
EOT
  ))"}
  eval "${${code//\$afufun/$afufun}//\$rawzle/$rawzle}"
  afu_accept_lines+=$afufun
}
afu-register-zle-accept-line afu+accept-line
afu-register-zle-accept-line afu+accept-line-and-down-history
afu-register-zle-accept-line afu+accept-and-hold
afu-register-zle-accept-line afu+run-help

# Entry point.
auto-fu-init () {
  {
    local -a region_highlight
    local afu_in_p=0
    POSTDISPLAY=$'\n-azfu-'
    afu-recursive-edit-and-accept
    zle -I
  } always {
    POSTDISPLAY=''
  }
}
zle -N afu

afu-clearing-maybe () {
  region_highlight=()
  if ((afu_in_p == 1)); then
    [[ "$BUFFER" != "$buffer_new" ]] || ((CURSOR != cursor_cur)) &&
    { afu_in_p=0 }
  fi
}

with-afu () {
  local zlefun="$1"
  afu-clearing-maybe
  ((afu_in_p == 1)) && { afu_in_p=0; BUFFER="$buffer_cur" }
  zle $zlefun && auto-fu-maybe
}

afu-register-zle-afu () {
  local afufun="$1"
  local rawzle=".${afufun#*+}"
  eval "function $afufun () { with-afu $rawzle; }; zle -N $afufun"
}

(( $+functions[afu-initialize-zle-afu] )) ||
afu-initialize-zle-afu () {
  local z
  for z in $afu_zles ;do
    afu-register-zle-afu afu+$z
  done
}
afu-initialize-zle-afu

afu+magic-space () {
  afu-clearing-maybe
  if [[ "$LASTWIDGET" == magic-space ]]; then
    LBUFFER+=' '
  else zle .magic-space && {
    # zle list-choices
  }
  fi
}
zle -N afu+magic-space

afu-able-p () {
  local c=$LBUFFER[-1]
  local ret=0
  case $c in
    (| |.|~|\^|\)) ret=1 ;;
  esac
  return $ret
}

auto-fu-maybe () {
  (($PENDING== 0)) && { afu-able-p } && [[ $LBUFFER != *$'\012'*  ]] &&
  { auto-fu }
}

auto-fu () {
  emulate -L zsh
  unsetopt rec_exact
  local LISTMAX=999999

  cursor_cur="$CURSOR"
  buffer_cur="$BUFFER"
  comppostfuncs=(afu-k)
  zle complete-word
  cursor_new="$CURSOR"
  buffer_new="$BUFFER"
  if [[ "$buffer_cur[1,cursor_cur]" == "$buffer_new[1,cursor_cur]" ]];
  then
    CURSOR="$cursor_cur"
    region_highlight=("$CURSOR $cursor_new fg=black,bold")

    if [[ "$buffer_cur" != "$buffer_new" ]] || ((cursor_cur != cursor_new))
    then afu_in_p=1; {
      local BUFFER="$buffer_cur"
      local CURSOR="$cursor_cur"
      zle list-choices
    }
    fi
  else
    BUFFER="$buffer_cur"
    CURSOR="$cursor_cur"
    zle list-choices
  fi
}
zle -N auto-fu

function afu-k () {
  ((compstate[list_lines] + BUFFERLINES + 2 > LINES)) && {
    compstate[list]=''
    zle -M "$compstate[list_lines]($compstate[nmatches]) to many matches..."
  }
}

afu+complete-word () {
  afu-clearing-maybe
  { afu-able-p } || { zle complete-word; return; }

  comppostfuncs=(afu-k)
  if ((afu_in_p == 1)); then
    afu_in_p=0; CURSOR="$cursor_new"
    case $LBUFFER[-1] in
      (=) # --prefix= ⇒ complete-word again for `magic-space'ing the suffix
        zle complete-word ;;
      (/) # path-ish  ⇒ propagate auto-fu
        zle complete-word; zle -U "$LBUFFER[-1]" ;;
      (,) # glob-ish  ⇒ activate the `complete-word''s suffix
        BUFFER="$buffer_cur"; zle complete-word ;;
      (*) ;;
    esac
  else
    [[ $LASTWIDGET == afu+* ]] && {
      afu_in_p=0; BUFFER="$buffer_cur"
    }
    zle complete-word
  fi
}
zle -N afu+complete-word

unset afu_zles


# enable.
zle-line-init () {
    auto-fu-init
}
zle -N zle-line-init
# >>>>
# >>>>
### cygwin ### <<<<
if [ "$MY_PERL_DOLLAR_O" = 'cygwin' ]; then

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
# >>>>

# start screen <<<<

# `-z "$WINDOW"` means if screen has already started.
# `! -z "$PS1"` means if zsh has started interactively.
if [ "$(which screen >/dev/null; echo $?)" = "0" -a "$CURRENT_ENV" != "MSWin32" -a -z "$WINDOW" -a ! -z "$PS1" ]; then
    screen
fi

# >>>>
