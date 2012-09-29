
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
function! StartDebugMode()
    echohl ErrorMsg
    let msg =
    \   "an error occurred... starting as debug mode.\n"
    \   . "\n"
    \   . 'v:exception = '.v:exception."\n"
    \   . 'v:throwpoint = '.v:throwpoint
    if has('gui_running')
        call confirm(msg)
    else
        for l in split(msg, '\n', 1)
            execute l !=# '' ? 'echomsg l' : 'echo "\n"'
        endfor
    endif
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
endfunction

try
    call s:load_init_vim()
catch
    call StartDebugMode()
endtry
