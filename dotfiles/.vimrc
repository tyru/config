scriptencoding utf-8

" bootstrap for ~/.vim/init.vim or ~/vimfiles/init.vim

let s:is_win = has('win16') || has('win32') || has('win64') || has('win95')
if s:is_win
    let $MYVIMDIR = expand('~/vimfiles')
else
    let $MYVIMDIR = expand('~/.vim')
endif

function! s:echomsg(msg, hl)
    execute 'echohl' a:hl
    try
        redraw
        echomsg a:msg
    finally
        echohl None
    endtry
endfunction
function! s:do_lazy_load(vimrc)
    " colorscheme is 'default' here.
    call s:echomsg('Loading ' . a:vimrc . ' ...', 'StatusLine')
    let g:vim_starting = 1
    let has_error = 0
    try
        call s:load_init_vim(a:vimrc)
    catch
        let has_error = 1
    finally
        unlet! g:vim_starting
    "     call s:echomsg('Loading ' . a:vimrc . ' ... done'
    "     \       . (has_error ? '(with errors)' : '') . '!',
    "     \   'SpellBad')
    endtry

    " for 'set fenc=...' in init.vim
    let &modified = 0

    " Load additional plugins (according to |load-plugins|),
    " it is not processed by Vim
    " because we are not in |startup| phase.
    " FIXME: Load only additional plugins (excluding already loaded scripts)
    runtime! plugin/**/*.vim

    " for 'autocmd VimEnter ...' in init.vim and/or plugins.
    doautocmd VimEnter

    if has_error
        echoerr v:exception '@' v:throwpoint
        " call StartDebugMode(a:vimrc)
    endif
endfunction
function! s:do_load(vimrc)
    let g:vim_starting = has('vim_starting')
    try
        call s:load_init_vim(a:vimrc)
    catch
        echoerr v:exception '@' v:throwpoint
        " call StartDebugMode(a:vimrc)
    finally
        unlet! g:vim_starting
    endtry
endfunction
function! s:load_init_vim(vimrc)
    " Use plain vim
    " when vim was invoked by 'sudo' command.
    if exists('$SUDO_USER')
        return
    endif
    " Do not start debug-mode
    " when vim was invoked by 'git' command.
    " if exists('$GIT_DIR')
    "     return
    " endif

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
        silent execute 'tabedit' a:vimrc

        " Go to error line.
        execute ':' . lnum
        " Open quickfix.
        copen
    endif
endfunction

let s:vimrc = $MYVIMDIR . '/init.vim'
if 0
    augroup vimrc-bootstrap
        autocmd VimEnter * autocmd! vimrc-bootstrap
        autocmd VimEnter * call s:do_lazy_load(s:vimrc)
    augroup END
else
    call s:do_load(s:vimrc)
endif
