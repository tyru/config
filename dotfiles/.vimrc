
" bootstrap for ~/.vim/init.vim

let s:is_win = has('win16') || has('win32') || has('win64')
if s:is_win
    let $MYVIMDIR = expand('~/vimfiles')
else
    let $MYVIMDIR = expand('~/.vim')
endif
let $MYVIMRC = $MYVIMDIR . '/init.vim'

try
    source $MYVIMRC
catch
    echoerr 'Disabled loading .vimrc ...: ['.v:exception.'] at ['.v:throwpoint.']'
endtry
