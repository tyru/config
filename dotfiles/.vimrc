
" bootstrap for ~/.vim/init.vim

let s:is_win = has('win16') || has('win32') || has('win64')
if s:is_win
    let $MYVIMDIR = expand('~/vimfiles')
else
    let $MYVIMDIR = expand('~/.vim')
endif
let s:vimrc = $MYVIMDIR . '/init.vim'

function! s:load_init_vim(vimrc)
    " Use plain vim
    " when vim was invoked by 'sudo' command.
    if exists('$SUDO_USER')
        return
    endif
    " Do not start debug-mode
    " when vim was invoked by 'git' command.
    if exists('$GIT_DIR')
        return
    endif
    " If on Windows && arguments were given
    if s:is_win && argc()
        let running_vim_list = filter(
        \   split(serverlist(), '\n'),
        \   'v:val !=? v:servername')
        " If one or more Vim instances are running
        if !empty(running_vim_list)
            " Open given files in running Vim and exit.
            silent execute '!start gvim'
            \   '--servername' running_vim_list[0]
            \   '--remote-tab-silent' join(argv(), ' ')
            qa!
        else
            " Can't find running Vim instances...
            " open it without loading .vimrc
            " (On Windows, it takes too much time to start Vim!)
            return
        endif
    endif

    source `=a:vimrc`
endfunction
function! StartDebugMode(vimrc)
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
        \   'filename': a:vimrc,
        \   'lnum': lnum,
        \   'text': v:exception,
        \}])

        " Open .vimrc
        let open = argc() is 0 ? 'edit' : 'tabedit'
        silent execute open a:vimrc

        " Go to error line.
        execute ':' . lnum
        " Open quickfix.
        copen
    endif
endfunction

try
    call s:load_init_vim(s:vimrc)

    " init.vim was loaded with no errors.
    let $MYVIMRC = s:vimrc
catch
    call StartDebugMode(s:vimrc)
endtry
