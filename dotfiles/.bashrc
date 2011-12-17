# vim:set fdm=marker:

# $MY_CURRENT_ENV is necessary for .shrc.common
MY_CURRENT_ENV="$(perl -e 'print $^O')"
source ~/.shrc.common

# exec zsh? {{{
# This is considered as harmful.
# See http://d.hatena.ne.jp/tyru/20100922/exec_bin_zsh_considered_harmful
#
# NOTE: "$PS1" to confirm user to login in interactively.
#if [ -x "$(which zsh)" && -z "$PS1" ]; then
#    exec zsh
#fi
# }}}

# shopt/set {{{
shopt -s nocaseglob
shopt -s cdspell

set bell-style visible

# Do not overwrite existing file by redirect `>`.
# Use `>|` to override this setting.
# http://answer.pythonpath.jp/questions/312/bashrc
set -o noclobber

# }}}

# List directory when changing directory {{{
cd () {
    command cd $1
    ll
}
# }}}

# cygwin {{{
if [ "$MY_PERL_DOLLAR_O" = 'cygwin' ]; then
    source ~/.shrc.cygwin
fi
# }}}

# Share history between multiple terminals {{{
# http://answer.pythonpath.jp/questions/312/bashrc
# http://iandeth.dyndns.org/mt/ian/archives/000651.html

function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend
# }}}

source ~/.shrc.start-screen
