
" bootstrap for ~/.vim/init.vim

let s:is_win = has('win16') || has('win32') || has('win64')
if s:is_win
    let $MYVIMDIR = expand('~/vimfiles')
else
    let $MYVIMDIR = expand('~/.vim')
endif
let $MYVIMRC = $MYVIMDIR . '/init.vim'

function! s:load_init_vim()
    " Use plain vim when vim was invoked by 'sudo'
    if exists('$SUDO_USER')
        return
    endif

    source $MYVIMRC
endfunction

try
    call s:load_init_vim()
catch
    echoerr 'Disabled loading .vimrc ...: ['.v:exception.'] at ['.v:throwpoint.']'
endtry
