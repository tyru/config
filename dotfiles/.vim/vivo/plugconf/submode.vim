let s:config = vivo#plugconf#new()

function! s:config.config()
    " Move GUI window.
    call submode#enter_with('guiwinmove', 'n', '', 'mgw')
    call submode#leave_with('guiwinmove', 'n', '', '<Esc>')
    call submode#map       ('guiwinmove', 'n', 'r', 'j', '<Plug>(winmove-down)')
    call submode#map       ('guiwinmove', 'n', 'r', 'k', '<Plug>(winmove-up)')
    call submode#map       ('guiwinmove', 'n', 'r', 'h', '<Plug>(winmove-left)')
    call submode#map       ('guiwinmove', 'n', 'r', 'l', '<Plug>(winmove-right)')

    " Change GUI window size.
    call submode#enter_with('guiwinsize', 'n', '', 'mgs', '<Nop>')
    call submode#leave_with('guiwinsize', 'n', '', '<Esc>')
    call submode#map       ('guiwinsize', 'n', '', 'j', ':set lines+=1<CR>')
    call submode#map       ('guiwinsize', 'n', '', 'k', ':set lines-=1<CR>')
    call submode#map       ('guiwinsize', 'n', '', 'h', ':set columns-=5<CR>')
    call submode#map       ('guiwinsize', 'n', '', 'l', ':set columns+=5<CR>')

    " Change current window size.
    call submode#enter_with('winsize', 'n', '', 'mws', ':<C-u>call VimrcSubmodeResizeWindow()<CR>')
    call submode#leave_with('winsize', 'n', '', '<Esc>')

    " TODO or FIXME: submode#leave_with() can't do that.
    " call submode#leave_with('winsize', 'n', '', '<Esc>', ':<C-u>call VimrcSubmodeResizeWindowRestore()<CR>')

    function! VimrcSubmodeResizeWindow()
        let curwin = winnr()
        wincmd j | let target1 = winnr() | exe curwin "wincmd w"
        wincmd l | let target2 = winnr() | exe curwin "wincmd w"

        execute printf("call submode#map ('winsize', 'n', 'r', 'j', '<C-w>%s')", curwin == target1 ? "-" : "+")
        execute printf("call submode#map ('winsize', 'n', 'r', 'k', '<C-w>%s')", curwin == target1 ? "+" : "-")
        execute printf("call submode#map ('winsize', 'n', 'r', 'h', '<C-w>%s')", curwin == target2 ? ">" : "<")
        execute printf("call submode#map ('winsize', 'n', 'r', 'l', '<C-w>%s')", curwin == target2 ? "<" : ">")
    endfunction
    " function! VimrcSubmodeResizeWindowRestore()
    "     if exists('s:submode_save_lazyredraw')
    "         let &l:lazyredraw = s:submode_save_lazyredraw
    "         unlet s:submode_save_lazyredraw
    "     endif
    " endfunction

    " undo/redo
    call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
    call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
    call submode#leave_with('undo/redo', 'n', '', '<Esc>')
    call submode#map       ('undo/redo', 'n', '', '-', 'g-')
    call submode#map       ('undo/redo', 'n', '', '+', 'g+')

    " Tab walker.
    call submode#enter_with('tabwalker', 'n', '', 'mt', '<Nop>')
    call submode#leave_with('tabwalker', 'n', '', '<Esc>')
    call submode#map       ('tabwalker', 'n', '', 'h', 'gT')
    call submode#map       ('tabwalker', 'n', '', 'l', 'gt')
    call submode#map       ('tabwalker', 'n', '', 'H', ':execute "tabmove" tabpagenr() - 2<CR>')
    call submode#map       ('tabwalker', 'n', '', 'L', ':execute "tabmove" tabpagenr()<CR>')
endfunction
