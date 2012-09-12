
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
    echohl ErrorMsg
    echomsg 'an error occurred... starting as debug mode.'
    echo    "\n"
    echomsg 'v:exception = '.v:exception
    echomsg 'v:throwpoint = '.v:throwpoint
    echohl None

    let lnum = matchstr(v:throwpoint, '\C\%(line\|行\) \zs\d\+')
    if lnum != ''
        " Highlight error line with quickfix.
        call setqflist([{
        \   'filename': $MYVIMRC,
        \   'lnum': lnum,
        \   'text': v:exception,
        \}])

        " Open .vimrc
        let open = argc() is 0 ? 'edit' : 'tabedit'
        silent execute open $MYVIMRC

        " Go to error line.
        execute ':' . lnum
        " Open quickfix.
        copen
    endif
endtry
