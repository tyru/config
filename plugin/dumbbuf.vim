" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: DumbBuf
" Version: 0.0.6
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-10-16.
"
" GetLatestVimScripts: 2783 1 :AutoInstall: dumbbuf.vim
"
" Description:
"   simple buffer manager like QuickBuf.vim
"
" Change Log: {{{
"   0.0.0:
"       Initial upload
"   0.0.1:
"       implement g:dumbbuf_cursor_pos, g:dumbbuf_shown_type, and 'tt'
"       mapping.
"       and fix bug of showing listed buffers even if current buffer is
"       unlisted.
"   0.0.2:
"       - fix bug of destroying " register...
"       - implement g:dumbbuf_close_when_exec, g:dumbbuf_downward.
"       - use plain j and k even if user mapped j to gj and/or k to gk.
"       - change default behavior.
"         if you want to close dumbbuf buffer on each mapping
"         as previous version, let g:dumbbuf_close_when_exec = 1.
"         (but '<CR>' mapping is exceptional case.
"         close dumbbuf buffer even if g:dumbbuf_close_when_exec is false)
"       - support of glvs.
"   0.0.3:
"       - fix bug of trapping all errors(including other plugin error).
"   0.0.4:
"       - implement single key mappings like QuickBuf.vim.
"         'let g:dumbbuf_single_key = 1' to use it.
"       - add g:dumbbuf_single_key, g:dumbbuf_updatetime.
"       - map plain gg and G mappings in local buffer.
"       - fix bug of making a waste buffer when called from
"         unlisted buffer.
"   0.0.5:
"       - fix bug: when using with another plugin that uses unlisted buffer,
"         pressing <CR> in dumbbuf buffer jumps into that unlisted buffer.
"         Thanks to Bernhard Walle for reporting the bug.
"       - add g:dumbbuf_open_with.
"   0.0.6:
"       - fix bug: when there is no buffers in list,
"         dumbbuf can't get selected buffer info.
"       - add option g:dumbbuf_wrap_cursor, and allow 'keep' in
"         g:dumbbuf_cursor_pos.
"       - implement 'select' of buffers. mapping is 'xx'.
"   0.0.7:
"       - add option g:dumbbuf_single_key_echo_stack
" }}}
"
"
" My .vimrc: {{{
" let dumbbuf_hotkey = '<Leader>b'
"
" " sometimes I put <Esc> to close dumbbuf buffer.
" " that mapping is QuickBuf's one :)
" let dumbbuf_mappings = {
"     'n': {
"         '<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
"     \}
" \}
"
" let dumbbuf_single_key = 1
" let g:dumbbuf_updatetime = 1    " mininum value of updatetime.
"
" let g:dumbbuf_cursor_pos = 'keep'
" }}}
"
" Mappings: {{{
"   please define g:dumbbuf_hotkey at first.
"   if that is not defined, this script is not loaded.
"
"   q
"       :close dumbbuf buffer.
"   g:dumbbuf_hotkey
"       toggle dumbbuf buffer.
"   <CR>
"       :edit the buffer.
"   uu
"       open one by one. this is same as QuickBuf's u.
"   ss
"       :split the buffer.
"   vv
"       :vspilt the buffer.
"   tt
"       :tabedit the buffer.
"   dd
"       :bdelete the buffer.
"   ww
"       :bwipeout the buffer.
"   ll
"       toggle listed buffers or unlisted buffers.
"   cc
"       :close the buffer.
"   xx
"       select the buffer.
"       if one or more selected buffers exist,
"       'ss', 'vv', 'tt', 'dd', 'ww', 'cc'
"       get to be able to execute for that buffers at a time.
"
"   and, if you turn on 'g:dumbbuf_single_key',
"   you can use single key mappings like QuickBuf.vim.
"   see 'g:dumbbuf_single_key' at 'Global Variables' for the details.
" }}}
"
" Global Variables: {{{
"   g:dumbbuf_hotkey (default: no default value)
"       a mapping which calls dumbbuf buffer.
"       if this variable is not defined, this plugin will be not loaded.
"
"   g:dumbbuf_open_with (default: 'botright')
"       open dumbbuf buffer with this command.
"
"   g:dumbbuf_vertical (default: 0)
"       if true, open dumbbuf buffer vertically.
"
"   g:dumbbuf_buffer_height (default: 10)
"       dumbbuf buffer's height.
"       this is used when only g:dumbbuf_vertical is false.
"
"   g:dumbbuf_buffer_width (default: 25)
"       dumbbuf buffer's width.
"       this is used when only g:dumbbuf_vertical is true.
"
"   g:dumbbuf_listed_buffer_name (default: '__buffers__')
"       dumbbuf buffer's filename.
"       set this filename when showing 'listed buffers'.
"       'listed buffers' are opposite of 'unlisted-buffers'.
"       see ':help unlisted-buffer'.
"
"       NOTE: DON'T assign string which includes whitespace, or any special
"       characters like "*", "?", ",".
"       see :help file-pattern
"
"   g:dumbbuf_unlisted_buffer_name (default: '__unlisted_buffers__')
"       dumbbuf buffer's filename.
"       set this filename when showing 'unlisted buffers'.
"
"       NOTE: DON'T assign string which includes whitespace, or any special
"       characters like "*", "?", ",".
"       see :help file-pattern
"
"   g:dumbbuf_cursor_pos (default: 'current')
"       jumps to this position when dumbbuf buffer opens.
"       this is useful for deleting some buffers continuaslly.
"
"       'current':
"           jump to the current buffer's line.
"       'keep':
"           keep the cursor pos.
"       'top':
"           always jump to the top line.
"       'bottom':
"           always jump to the bottom line
"
"   g:dumbbuf_shown_type (default: '')
"       show this type of buffers list.
"
"       '':
"           if current buffer is unlisted, show unlisted buffers list.
"           if current buffer is listed, show listed buffers list.
"       'unlisted':
"           show always unlisted buffers list.
"       'listed':
"           show always listed buffers list.
"
"   g:dumbbuf_close_when_exec (default: 0)
"       if true, close when execute local mapping from dumbbuf buffer.
"
"   g:dumbbuf_downward (default: 1)
"       if true, go downwardly when 'uu' mapping.
"       if false, go upwardly.
"
"   g:dumbbuf_single_key (default: 0)
"       if true, use single key mappings like QuickBuf.vim.
"       here is the single key mappings that are defined:
"           "u" as "uu".
"           "s" as "ss".
"           "v" as "vv".
"           "t" as "tt".
"           "d" as "dd".
"           "w" as "ww".
"           "l" as "ll".
"           "c" as "cc".
"       the reason why these mappings are defined as 'plain' mappings
"       in dumbbuf buffer is due to avoiding conflicts of Vim's default mappings.
"       however, making this global variable true, that mappings are
"       safely used without any conflicts.
"
"       this is implemented by doing getchar() and executing it on normal
"       mode. but you can enter to other modes while waiting a key.
"       so, like MRU, you can search string in dumbbuf buffer.
"
"   g:dumbbuf_single_key_echo_stack (default: 1)
"       if true, show the keys which was input.
"       this option is meaningless if g:dumbbuf_single_key is not true.
"
"   g:dumbbuf_updatetime (default: 100)
"       local value of &updatetime in dumbbuf buffer.
"       recommended value is 1(minimum value of &updatetime).
"       this default value is for only backward compatibility.
"
"   g:dumbbuf_wrap_cursor (default: 1)
"       wrap the cursor at the top or bottom of dumbbuf buffer.
"
"   g:dumbbuf_disp_expr (default: see below)
"       this variable is for the experienced users.
"
"       here is the default value:
"           'printf("%s %s[%s] %s <%d> %s", (val.is_selected ? "x" : " "), (val.is_current ? "*" : " "), bufname(val.nr), (val.is_modified ? "[+]" : "   "), val.nr, fnamemodify(bufname(val.nr), ":p:h"))'
"
"       'val' has buffer's info.
"       'v:val' also works for backward compatibility.
"
"   g:dumbbuf_options (default: see below)
"       this variable is for the experienced users.
"
"       here is the default value:
"           let g:dumbbuf_options = [
"               \'bufhidden=wipe',
"               \'buftype=nofile',
"               \'cursorline',
"               \'nobuflisted',
"               \'nomodifiable',
"               \'noswapfile',
"           \]
"
"   g:dumbbuf_mappings (default: see below)
"       this variable is for the experienced users.
"
"       these settings will be overridden at dumbbuf.vim.
"       for e.g., if your .vimrc setting is
"
"         let g:dumbbuf_mappings = {
"             \'n': {
"                 '<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
"             \}
"         \}
"
"       type <Esc> to close dumbbuf buffer.
"       no influences for other default mappings.
"
"       here is the default value:
"           let g:dumbbuf_mappings = {
"               \'n': {
"                   \'j': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>buflocal_move_lower()<CR>',
"                   \},
"                   \'k': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>buflocal_move_upper()<CR>',
"                   \},
"                   \'gg': {
"                       \'opt': '<silent>',
"                       \'mapto': 'gg',
"                   \},
"                   \'G': {
"                       \'opt': '<silent>',
"                       \'mapto': 'G',
"                   \},
"                   \g:dumbbuf_hotkey : {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>close<CR>',
"                   \},
"                   \'q': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>close<CR>',
"                   \},
"                   \'<CR>': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open", ' .
"                           \'{"type":"func", ' .
"                           \'"requires_args":0, ' .
"                           \'"pre":["close_dumbbuf", "jump_to_caller", ' .
"                                   \'"return_if_empty", "return_if_not_exist"], ' .
"                           \'"post":["clear_selected"]})<CR>',
"                   \},
"                   \'uu': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open_onebyone", ' .
"                           \'{"type":"func", ' .
"                           \'"requires_args":0, ' .
"                           \'"pre":["close_dumbbuf", "jump_to_caller", ' .
"                                   \'"return_if_empty", "return_if_not_exist"], ' .
"                           \'"post":["save_lnum", "clear_selected"]})<CR>',
"                   \},
"                   \'ss': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("split #%d", ' .
"                           \'{"type":"cmd", ' .
"                           \'"requires_args":1, ' .
"                           \'"process_selected":1, ' .
"                           \'"pre":["close_dumbbuf", "jump_to_caller", ' .
"                                   \'"return_if_noname", "return_if_empty", ' .
"                                   \'"return_if_not_exist"], ' .
"                           \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
"                   \},
"                   \'vv': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("vsplit #%d", ' .
"                           \'{"type":"cmd", ' .
"                           \'"requires_args":1, ' .
"                           \'"process_selected":1, ' .
"                           \'"pre":["close_dumbbuf", "jump_to_caller", ' .
"                                   \'"return_if_noname", "return_if_empty", ' .
"                                   \'"return_if_not_exist"], ' .
"                           \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
"                   \},
"                   \'tt': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("tabedit #%d", ' .
"                           \'{"type":"cmd", ' .
"                           \'"requires_args":[1, 0], ' .
"                           \'"process_selected":1, ' .
"                           \'"pre":["close_dumbbuf", "jump_to_caller", ' .
"                                   \'"return_if_noname", "return_if_empty", ' .
"                                   \'"return_if_not_exist"], ' .
"                           \'"post":["clear_selected", "save_lnum"]})<CR>',
"                   \},
"                   \'dd': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("bdelete %d", ' .
"                           \'{"type":"cmd", ' .
"                               \'"requires_args":1, ' .
"                               \'"process_selected":1, ' .
"                               \'"pre":["close_dumbbuf", "return_if_empty", ' .
"                                       \'"return_if_not_exist"], ' .
"                               \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
"                   \},
"                   \'ww': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("bwipeout %d", ' .
"                           \'{"type":"cmd", ' .
"                           \'"requires_args":1, ' .
"                           \'"process_selected":1, ' .
"                           \'"pre":["close_dumbbuf", "return_if_empty", ' .
"                                   \'"return_if_not_exist"], ' .
"                           \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
"                   \},
"                   \'ll': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_toggle_listed_type", ' .
"                           \'{"type":"func", ' .
"                           \'"requires_args":0})<CR>',
"                   \},
"                   \'cc': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_close", ' .
"                           \'{"type":"func", ' .
"                           \'"requires_args":0, ' .
"                           \'"process_selected":1, ' .
"                           \'"pre":["close_dumbbuf", "return_if_empty", ' .
"                                   \'"return_if_not_exist"], ' .
"                           \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
"                   \},
"                   \'xx': {
"                       \'opt': '<silent>',
"                       \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_select", ' .
"                           \'{"type":"func", ' .
"                           \'"requires_args":0, ' .
"                           \'"pre":["return_if_empty", "return_if_not_exist"], ' .
"                           \'"post":["save_lnum", "update"]})<CR>'
"                   \},
"               \}
"           \}
" }}}
"
"
" TODO: {{{
"   - manipulate buffers each project.
"   - user-defined mapping
"   - highlight current line.
"   (it's hard to make out in terminal, if only :setlocal cursorline)
" }}}
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_dumbbuf') && g:loaded_dumbbuf != 0
    finish
endif
let g:loaded_dumbbuf = 1

" do not load anymore if g:dumbbuf_hotkey is not defined.
if ! exists('g:dumbbuf_hotkey')
    " g:dumbbuf_hotkey is not defined!
    echomsg "g:dumbbuf_hotkey is not defined!"
    finish
elseif maparg(g:dumbbuf_hotkey, 'n') != ''
    echomsg printf("'%s' is already defined!", g:dumbbuf_hotkey)
    finish
endif
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}
" Scope Variables {{{
let s:debug_msg = []

let s:caller_bufnr = -1    " caller buffer's bufnr which calls dumbbuf buffer.
let s:dumbbuf_bufnr = -1    " dumbbuf buffer's bufnr.
let s:bufs_info = {}    " buffers info. (key: bufnr)
let s:selected_bufs = {}    " selected buffers info.
let s:previous_lnum = -1    " lnum where a previous mapping executed.

let s:current_shown_type = ''    " this must be one of '', 'listed', 'unlisted'.
let s:mappings = {'default': {}, 'user': {}}    " buffer local mappings.

" used for single key emulation.
let s:mapstack_count = -1
let s:mapstack = ''
let s:orig_updatetime = &updatetime
" }}}
" Global Variables {{{
if ! exists('g:dumbbuf_verbose')
    let g:dumbbuf_verbose = 0
endif

"--- if g:dumbbuf_hotkey is not defined,
" do not load this script.
" see 'Load Once'. ---

if ! exists('g:dumbbuf_buffer_height')
    let g:dumbbuf_buffer_height = 10
endif
if ! exists('g:dumbbuf_vertical')
    let g:dumbbuf_vertical = 0
endif
if ! exists('g:dumbbuf_open_with')
    let g:dumbbuf_open_with = 'botright'
endif
if ! exists('g:dumbbuf_buffer_width')
    let g:dumbbuf_buffer_width = 25
endif
if ! exists('g:dumbbuf_listed_buffer_name')
    let g:dumbbuf_listed_buffer_name = '__buffers__'
endif
if ! exists('g:dumbbuf_unlisted_buffer_name')
    let g:dumbbuf_unlisted_buffer_name = '__unlisted_buffers__'
endif
if ! exists('g:dumbbuf_cursor_pos')
    let g:dumbbuf_cursor_pos = 'current'
endif
if ! exists('g:dumbbuf_shown_type')
    let g:dumbbuf_shown_type = ''
endif
if ! exists('g:dumbbuf_close_when_exec')
    let g:dumbbuf_close_when_exec = 0
endif
if ! exists('g:dumbbuf_downward')
    let g:dumbbuf_downward = 1
endif
if ! exists('g:dumbbuf_single_key')
    let g:dumbbuf_single_key = 0
endif
if ! exists('g:dumbbuf_single_key_echo_stack')
    let g:dumbbuf_single_key_echo_stack = 1
endif
if ! exists('g:dumbbuf_updatetime')
    let g:dumbbuf_updatetime = 100
endif
if ! exists('g:dumbbuf_wrap_cursor')
    let g:dumbbuf_wrap_cursor = 1
endif


if ! exists('g:dumbbuf_disp_expr')
    " QuickBuf.vim like UI.
    let g:dumbbuf_disp_expr = 'printf("%s %s[%s] %s <%d> %s", (val.is_selected ? "x" : " "), (val.is_current ? "*" : " "), bufname(val.nr), (val.is_modified ? "[+]" : "   "), val.nr, fnamemodify(bufname(val.nr), ":p:h"))'
else
    " backward compatibility.
    let g:dumbbuf_disp_expr = substitute(g:dumbbuf_disp_expr, '\<v:val\>'.'\C', 'val', 'g')
endif
if ! exists('g:dumbbuf_options')
    let g:dumbbuf_options = [
        \'bufhidden=wipe',
        \'buftype=nofile',
        \'cursorline',
        \'nobuflisted',
        \'nomodifiable',
        \'noswapfile',
    \]
endif

if exists('g:dumbbuf_mappings')
    let s:mappings.user = g:dumbbuf_mappings
    unlet g:dumbbuf_mappings
endif
let s:mappings.default = {
    \'v': {
        \'x': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_select", ' .
                \'{"type":"func", ' .
                \'"requires_args":0, ' .
                \'"prev_mode":"v", ' .
                \'"pre":["return_if_empty"], ' .
                \'"post":["save_lnum", "update_marks"]})<CR>'
        \},
    \},
    \'n': {
        \'j': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>buflocal_move_lower()<CR>',
        \},
        \'k': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>buflocal_move_upper()<CR>',
        \},
        \'gg': {
            \'opt': '<silent>',
            \'mapto': 'gg',
        \},
        \'G': {
            \'opt': '<silent>',
            \'mapto': 'G',
        \},
        \g:dumbbuf_hotkey : {
            \'opt': '<silent>',
            \'mapto': ':<C-u>close<CR>',
        \},
        \'q': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>close<CR>',
        \},
        \'<CR>': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open", ' .
                \'{"type":"func", ' .
                \'"requires_args":0, ' .
                \'"pre":["close_return_if_empty", "close_dumbbuf", "jump_to_caller"]' .
                \'})<CR>',
        \},
        \'uu': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open_onebyone", ' .
                \'{"type":"func", ' .
                \'"requires_args":0, ' .
                \'"pre":["close_return_if_empty", "close_dumbbuf", "jump_to_caller"], ' .
                \'"post":["save_lnum"]})<CR>',
        \},
        \'ss': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("split #%d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":1, ' .
                \'"process_selected":1, ' .
                \'"pre":["close_return_if_empty", "close_dumbbuf", "jump_to_caller"], ' .
                \'"post":["save_lnum", "update_dumbbuf"]})<CR>',
        \},
        \'vv': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("vsplit #%d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":1, ' .
                \'"process_selected":1, ' .
                \'"pre":["close_return_if_empty", "close_dumbbuf", "jump_to_caller"], ' .
                \'"post":["save_lnum", "update_dumbbuf"]})<CR>',
        \},
        \'tt': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("tabedit #%d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":[1, 0], ' .
                \'"process_selected":1, ' .
                \'"pre":["close_return_if_empty", "close_dumbbuf", "jump_to_caller"], ' .
                \'"post":["save_lnum"]})<CR>',
        \},
        \'dd': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("bdelete %d", ' .
                \'{"type":"cmd", ' .
                    \'"requires_args":1, ' .
                    \'"process_selected":1, ' .
                    \'"pre":["close_return_if_empty", "close_dumbbuf"], ' .
                    \'"post":["save_lnum", "update_dumbbuf"]})<CR>',
        \},
        \'ww': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("bwipeout %d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":1, ' .
                \'"process_selected":1, ' .
                \'"pre":["close_return_if_empty", "close_dumbbuf"], ' .
                \'"post":["save_lnum", "update_dumbbuf"]})<CR>',
        \},
        \'ll': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_toggle_listed_type", ' .
                \'{"type":"func", ' .
                \'"requires_args":0})<CR>',
        \},
        \'cc': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_close", ' .
                \'{"type":"func", ' .
                \'"requires_args":0, ' .
                \'"process_selected":1, ' .
                \'"pre":["close_return_if_empty", "close_dumbbuf"], ' .
                \'"post":["save_lnum", "update_dumbbuf"]})<CR>',
        \},
        \'xx': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_select", ' .
                \'{"type":"func", ' .
                \'"requires_args":0, ' .
                \'"pre":["return_if_empty"], ' .
                \'"post":["save_lnum", "update_marks"]})<CR>'
        \},
    \}
\}
let s:mappings.single_key = {
    \'u': 'uu',
    \'s': 'ss',
    \'v': 'vv',
    \'t': 'tt',
    \'d': 'dd',
    \'w': 'ww',
    \'l': 'll',
    \'c': 'cc',
    \'x': 'xx',
\}

" }}}

" Functions {{{

" util {{{

" Debug {{{
if g:dumbbuf_verbose
    command -nargs=+ DumbBufDebug call s:debug_command(<f-args>)

    func! s:debug_command(cmd, ...)
        if a:cmd ==# 'list'
            for i in s:debug_msg | call s:warn(i) | endfor
        elseif a:cmd ==# 'eval'
            echo string(eval(join(a:000, ' ')))
        endif
    endfunc
endif

" s:debug {{{
fun! s:debug(msg)
    if g:dumbbuf_verbose
        call s:warn(a:msg)
        call add(s:debug_msg, a:msg)
        if len(s:debug_msg) > 30
            let s:debug_msg = s:debug_msg[-30:-1]
        endif
    endif
endfunc
" }}}

" }}}

" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunc
" }}}

" }}}

" misc. {{{

" s:get_buffer_info {{{
"   this returns the caller buffer's info
func! s:get_buffer_info(bufnr)
    return has_key(s:bufs_info, a:bufnr) ? s:bufs_info[a:bufnr] : []
endfunc
" }}}

" s:eval_disp_expr {{{
func! s:eval_disp_expr(buf)
    let val = a:buf
    return eval(g:dumbbuf_disp_expr)
endfunc
" }}}

" s:write_buffers_list {{{
"   this determines s:bufs_info[i].lnum
func! s:write_buffers_list(bufs)
    call s:jump_to_buffer(s:dumbbuf_bufnr)

    let disp_line = []
    try
        let lnum = 1
        for nr in sort(keys(a:bufs))
            let a:bufs[nr].lnum = lnum
            let lnum += 1
            call add(disp_line, s:eval_disp_expr(a:bufs[nr]))
        endfor
    catch
        call s:warn("error occured while evaluating g:dumbbuf_disp_expr.")
        call s:debug(v:exception)
        return
    endtry

    silent put =disp_line
    normal! gg"_dd
endfunc
" }}}

" s:parse_buffers_info {{{
func! s:parse_buffers_info()
    " redirect output of :ls! to ls_out.
    redir => ls_out
    silent ls!
    redir END
    let buf_list = split(ls_out, "\n")

    " see ':help :ls' about regexp.
    let regex =
        \'^'.'\s*'.
        \'\(\d\+\)'.
        \'\([u ]\)'.
        \'\([%# ]\)'.
        \'\([ah ]\)'.
        \'\([-= ]\)'.
        \'\([\+x ]\)'

    let result = {}

    for line in buf_list
        let m = matchlist(line, regex)
        if empty(m) | continue | endif

        " bufnr:
        "   buffer number.
        "   this must NOT be -1.
        " unlisted:
        "   'u' or empty string.
        "   'u' means buffer is NOT listed.
        "   empty string means buffer is listed.
        " percent_numsign:
        "   '%' or '#' or empty string.
        "   '%' means current buffer.
        "   '#' means sub buffer.
        " a_h:
        "   'a' or 'h' or empty string.
        "   'a' means buffer is loaded and active(displayed).
        "   'h' means buffer is loaded but not active(hidden).
        " minus_equal:
        "   '-' or '=' or empty string.
        "   '-' means buffer is not modifiable.
        "   '=' means buffer is readonly.
        " plus_x:
        "   '+' or 'x' or empty string.
        "   '+' means buffer is modified.
        "   'x' means error occured while loading buffer.
        let [bufnr, unlisted, percent_numsign, a_h, minus_equal, plus_x; rest] = m[1:]

        " skip dumbbuf's buffer.
        if bufnr == s:dumbbuf_bufnr | continue | endif

        call s:debug(string(m))
        let result[bufnr] = {
            \'nr': bufnr + 0,
            \'is_unlisted': unlisted ==# 'u',
            \'is_current': percent_numsign ==# '%',
            \'is_sub': percent_numsign ==# '#',
            \'is_active': a_h ==# 'a',
            \'is_hidden': a_h ==# 'h',
            \'is_modifiable': minus_equal !=# '-',
            \'is_readonly': minus_equal ==# '=',
            \'is_modified': plus_x ==# '+',
            \'is_err': plus_x ==# 'x',
            \'lnum': -1,
            \'is_selected': 0,
        \}
    endfor

    return result
endfunc
" }}}

" s:get_cursor_buffer {{{
func! s:get_cursor_buffer()
    for buf in values(s:bufs_info)
        if buf.lnum ==# line('.')
            return buf
        endif
    endfor
    return {}
endfunc
" }}}

" s:get_shown_type {{{
"   this returns 'listed' or 'unlisted'.
"   if s:current_shown_type or g:dumbbuf_shown_type value is invalid,
"   this may throw exception.
func! s:get_shown_type(caller_bufnr)
    if g:dumbbuf_shown_type =~# '^\(unlisted\|listed\)$'.'\C'
        return g:dumbbuf_shown_type
    elseif g:dumbbuf_shown_type == ''
        let info = s:get_buffer_info(a:caller_bufnr)
        if empty(info)
            throw "internal error: can't get caller buffer's info..."
        endif
        return info.is_unlisted ? 'unlisted' : 'listed'
    else
        call s:warn(printf("'%s' is not valid value. please choose in '', 'unlisted', 'listed'.", g:dumbbuf_shown_type))
        call s:warn("use '' as g:dumbbuf_shown_type value...")

        let g:dumbbuf_shown_type = ''
        sleep 1

        return s:get_shown_type(a:caller_bufnr)
    endif
endfunc
" }}}

" s:filter_bufs_info {{{
"   filter s:bufs_info.
"   NOTE: that this modifies s:bufs_info.
func! s:filter_bufs_info(curbufinfo, shown_type)
    " if current buffer is unlisted, filter unlisted buffers.
    " if current buffers is listed, filter listed buffers.
    call filter(s:bufs_info,
                \'a:shown_type ==# "unlisted" ?' .
                    \'v:val.is_unlisted : ! v:val.is_unlisted')
endfunc
" }}}

" s:set_cursor_pos {{{
"   move cursor to the pos which is specified by g:dumbbuf_cursor_pos.
func! s:set_cursor_pos(curbufinfo)
    if g:dumbbuf_cursor_pos ==# 'current'
        if a:curbufinfo.lnum !=# -1
            execute 'normal! ' . a:curbufinfo.lnum . 'gg'
        endif
    elseif g:dumbbuf_cursor_pos ==# 'keep'
        call s:debug(printf("s:previous_lnum [%d]", s:previous_lnum))
        if s:previous_lnum == -1
            " same as above.
            if a:curbufinfo.lnum !=# -1
                execute 'normal! ' . a:curbufinfo.lnum . 'gg'
            endif
        else
            " keep.
            execute s:previous_lnum
        endif
    elseif g:dumbbuf_cursor_pos ==# 'top'
        normal! gg
    elseif g:dumbbuf_cursor_pos ==# 'bottom'
        normal! G
    else
        call s:warn(printf("'%s' is not valid value. please choose in 'current', 'top', 'bottom'.", g:dumbbuf_cursor_pos))
        call s:warn("use 'current' as g:dumbbuf_cursor_pos value...")

        let g:dumbbuf_cursor_pos = 'current'

        sleep 1
    endif
endfunc
" }}}



" s:open_dumbbuf_buffer {{{
"   open and set up dumbbuf buffer.
func! s:open_dumbbuf_buffer(shown_type)
    " open and switch to dumbbuf's buffer.
    let s:dumbbuf_bufnr = s:create_dumbbuf_buffer()
    if s:dumbbuf_bufnr ==# -1
        call s:warn("internal error: can't open buffer.")
        return
    endif


    " ======== begin - get buffers list and set up ========

    let curbufinfo = s:get_buffer_info(s:caller_bufnr)
    if empty(curbufinfo)
        call s:warn("internal error: can't get current buffer's info")
        return
    endif

    call s:filter_bufs_info(curbufinfo, a:shown_type)
    call s:debug(printf("filtered only '%s' buffers.", a:shown_type))

    for buf in values(s:bufs_info)
        let buf.is_selected = has_key(s:selected_bufs, buf.nr)
    endfor

    " ======== begin - get buffers list and set up ========



    " name dumbbuf's buffer.
    if a:shown_type ==# 'unlisted'
        silent execute 'file `=g:dumbbuf_unlisted_buffer_name`'
    else
        silent execute 'file `=g:dumbbuf_listed_buffer_name`'
    endif

    " write buffers list.
    call s:write_buffers_list(s:bufs_info)

    " move cursor to specified position.
    call s:set_cursor_pos(curbufinfo)


    "-------- buffer settings --------

    " options
    for i in g:dumbbuf_options
        execute printf('setlocal %s', i)
    endfor

    " mappings
    for [mode, maps] in items(s:mappings.default) + items(s:mappings.user)
        for [from, map] in items(maps)
            " if 'map' has 'mapto', map it.
            if has_key(map, 'mapto')
                execute printf('%snoremap <buffer>%s %s %s',
                                \mode, (has_key(map, 'opt') ? map.opt : ''), from, map.mapto)
            " if 'map' is empty and 'from' is mapped, delete it.
            elseif empty(map) && maparg(from, mode) != ''
                execute mode.'unmap <buffer> '.from
            endif
        endfor
    endfor

    " updatetime
    " NOTE: updatetime is global option. so I must restore it later.
    let s:orig_updatetime = &updatetime
    let &updatetime = g:dumbbuf_updatetime
endfunc
" }}}

" s:close_dumbbuf_buffer {{{
func! s:close_dumbbuf_buffer()
    let prevwinnr = winnr()

    if s:jump_to_buffer(s:dumbbuf_bufnr) != -1
        close
    endif

    " jump to previous window.
    if winnr() != prevwinnr
        execute prevwinnr.'wincmd w'
    endif
endfunc
" }}}

" s:update_only_marks {{{
func! s:update_only_marks()
    if s:jump_to_buffer(s:dumbbuf_bufnr) == -1
        return
    endif


    let save_modifiable = &l:modifiable

    setlocal modifiable

    try
        for buf in values(s:bufs_info)
            " update 'is_selected'.
            let buf.is_selected = has_key(s:selected_bufs, buf.nr)
            " rewrite buffers list.
            let r = s:eval_disp_expr(buf)
            call s:debug(printf("replace line %d with '%s'", buf.lnum, string(r)))
            call setline(buf.lnum, r)
        endfor
    finally
        let &l:modifiable = save_modifiable
    endtry
endfunc
" }}}

" s:update_buffers_list {{{
func! s:update_buffers_list(...)
    " close if exists.
    call s:close_dumbbuf_buffer()

    " remember current bufnr.
    let s:caller_bufnr = bufnr('%')
    call s:debug('caller buffer name is '.bufname(s:caller_bufnr))
    " save current buffers to s:bufs_info.
    let s:bufs_info = s:parse_buffers_info()
    " decide which type dumbbuf shows.
    if a:0 > 0
        let s:current_shown_type = a:1
    else
        let s:current_shown_type = s:get_shown_type(s:caller_bufnr)
    endif

    " open.
    call s:open_dumbbuf_buffer(s:current_shown_type)
endfunc
" }}}

" s:jump_to_buffer {{{
func! s:jump_to_buffer(bufnr)
    if a:bufnr ==# bufnr('%') | return a:bufnr | endif
    let winnr = bufwinnr(a:bufnr)
    if winnr != -1 && winnr != winnr()
        call s:debug(printf("jump to ... [%s]", bufname(a:bufnr)))
        execute winnr.'wincmd w'
    endif
    return winnr
endfunc
" }}}

" s:create_dumbbuf_buffer {{{
func! s:create_dumbbuf_buffer()
    execute printf("%s %s %dnew",
                \g:dumbbuf_vertical ? 'vertical' : '',
                \g:dumbbuf_open_with,
                \g:dumbbuf_vertical ? g:dumbbuf_buffer_width : g:dumbbuf_buffer_height)
    return bufnr('%')
endfunc
" }}}


" s:get_prev_count {{{
func! s:get_prev_count()
    return [line("'<"), line("'>")]
endfunc
" }}}

" }}}


" s:run_from_local_map {{{
func! s:run_from_local_map(code, opt)
    let opt = extend(
                \deepcopy(a:opt),
                \{"process_selected":0, "prev_mode":"n", "pre":[], "post":[]},
                \"keep")

    " at now, current window should be dumbbuf buffer
    " because this func is called only from dumbbuf buffer local mappings.

    " get selected buffer info.
    let cursor_buf = s:get_cursor_buffer()
    if empty(cursor_buf)
        call s:warn("can't get buffer on cursor...")
    endif
    " this must be done in dumbbuf buffer.
    let lnum = line('.')

    " current window should be dumbbuf buffer, though.
    " if winnr('$') == 1
    "     execute printf("%s %s new",
    "                 \g:dumbbuf_vertical ? 'vertical' : '',
    "                 \g:dumbbuf_open_with)
    " endif

    let opt.v_selected_bufs = []
    if opt.prev_mode ==# 'v'
        let save_pos = getpos('.')
        for lnum in call('range', s:get_prev_count())
            call cursor(lnum, 0)
            call add(opt.v_selected_bufs, s:get_cursor_buffer())
        endfor
        call setpos('.', save_pos)
    endif


    try
        " pre
        call s:do_tasks(opt.pre, cursor_buf, lnum)

        " if a:code supports 'process_selected' and selected buffers exist,
        " process selected buffers instead of current cursor buffer.
        let bufs = s:get_buffers_being_processed(opt, cursor_buf)

        " dispatch a:code.
        " NOTE: current buffer may not be caller buffer.
        if type(a:code) == type([])
            for buf in bufs
                let i = 0
                let len = len(a:code)
                while i < len
                    call s:dispatch_code(a:code[i], i, extend(copy(opt), {'lnum': lnum, 'cursor_buf': buf}))
                    let i += 1
                endwhile
            endfor
        else
            for buf in bufs
                let i = 0
                call s:dispatch_code(a:code, i, extend(copy(opt), {'lnum': lnum, 'cursor_buf': buf}))
            endfor
        endif

        " post
        call s:do_tasks(opt.post, cursor_buf, lnum)

    catch /internal error:/
        call s:warn(v:exception)

    catch /^nop$/
        " nop.

    " catch    " NOTE: this traps also unknown other plugin's error...
    "     echoerr printf("internal error: '%s' in '%s'", v:exception, v:throwpoint)

    endtry
endfunc
" }}}

" s:do_tasks {{{
func! s:do_tasks(tasks, cursor_buf, lnum)
    for p in a:tasks
        if p ==# 'close_dumbbuf'
            call s:close_dumbbuf_buffer()

        elseif p ==# 'jump_to_caller'    " jump to caller buffer.
            call s:jump_to_buffer(s:caller_bufnr)

        elseif p ==# 'close_return_if_empty'
            " if buffer is not available, close dumbbuf and do nothing.
            try
                call s:do_tasks(['return_if_empty'], a:cursor_buf, a:lnum)
            catch /^nop$/
                call s:close_dumbbuf_buffer()
                throw 'nop'
            endtry

        elseif p ==# 'return_if_empty'
            " check buffer's availability.
            if bufname(a:cursor_buf.nr + 0) == ''
                call s:warn("buffer name is empty.")
                throw 'nop'
            endif
            if ! bufexists(a:cursor_buf.nr + 0)
                call s:warn("buffer doesn't exist.")
                throw 'nop'
            endif

        elseif p ==# 'save_lnum'    " NOTE: do this before 'update'.
            call s:debug("save_lnum:".a:lnum)
            let s:previous_lnum = a:lnum

        elseif p ==# 'update_dumbbuf'
            " close or update dumbbuf buffer.
            if g:dumbbuf_close_when_exec
                call s:debug("just close")
                call s:close_dumbbuf_buffer()
            else
                call s:debug("close and re-open")
                call s:update_buffers_list()
            endif

        elseif p ==# 'update_marks'
            call s:update_only_marks()

        else
            call s:warn("internal warning: unknown task name: ".p)
        endif
    endfor
endfunc
" }}}

" s:dispatch_code {{{
func! s:dispatch_code(code, no, opt)
    " NOTE: a:opt.cursor_buf may be empty.
    call s:debug(string(a:opt))
    let requires_args = type(a:opt.requires_args) == type([]) ?
                \a:opt.requires_args[a:no] : a:opt.requires_args

    if a:opt.type ==# 'cmd'
        if requires_args
            if ! empty(a:opt.cursor_buf)
                silent execute printf(a:code, a:opt.cursor_buf.nr)
            else
                call s:warn("internal error: a:opt.cursor_buf is empty...")
            endif
        else
            silent execute a:code
        endif
    elseif a:opt.type ==# 'func'
        if requires_args
            " NOTE: not used.
            silent call call(a:code, [a:opt.args])
        else
            silent call call(a:code, [a:opt])
        endif
    else
        throw "internal error: unknown type: ".a:opt.type
    endif
endfunc
"}}}

" s:get_buffers_being_processed {{{
func! s:get_buffers_being_processed(opt, cursor_buf)
    if a:opt.process_selected && !empty(s:selected_bufs)
        let tmp = s:selected_bufs
        let s:selected_bufs = {}    " clear
        return map(keys(tmp), 's:bufs_info[v:val]')
    else
        return [a:cursor_buf]
    endif
endfunc
" }}}


" these functions are called from dumbbuf's buffer {{{

" s:buflocal_move_lower {{{
func! s:buflocal_move_lower()
    for i in range(1, v:count1)
        if line('.') == line('$')
            if g:dumbbuf_wrap_cursor
                " go to the top of buffer.
                execute '1'
            endif
        else
            normal! j
        endif
    endfor
endfunc
" }}}

" s:buflocal_move_upper {{{
func! s:buflocal_move_upper()
    for i in range(1, v:count1)
        if line('.') == 1
            if g:dumbbuf_wrap_cursor
                " go to the bottom of buffer.
                execute line('$')
            endif
        else
            normal! k
        endif
    endfor
endfunc
" }}}

" s:buflocal_open {{{
"   this must be going to close dumbbuf buffer.
func! s:buflocal_open(opt)
    if ! empty(a:opt.cursor_buf)
        let winnr = bufwinnr(a:opt.cursor_buf.nr)
        if winnr == -1
            execute a:opt.cursor_buf.nr.'buffer'
        else
            execute winnr.'wincmd w'
        endif
    endif
endfunc
" }}}

" s:buflocal_open_onebyone {{{
"   this does NOT do update or close buffers list.
func! s:buflocal_open_onebyone(opt)
    call s:debug("current lnum:" . a:opt.lnum)

    " open buffer on the cursor and close dumbbuf buffer.
    call s:buflocal_open(a:opt)
    " open dumbbuf's buffer again.
    call s:update_buffers_list()
    " go to previous lnum.
    execute a:opt.lnum

    if g:dumbbuf_downward
        call s:buflocal_move_lower()
    else
        call s:buflocal_move_upper()
    endif
endfunc
" }}}

" s:buflocal_toggle_listed_type {{{
func! s:buflocal_toggle_listed_type(opt)
    " NOTE: s:current_shown_type SHOULD NOT be '', and MUST NOT be.

    if s:current_shown_type ==# 'unlisted'
        call s:update_buffers_list('listed')

    elseif s:current_shown_type ==# 'listed'
        call s:update_buffers_list('unlisted')

    else
        call s:warn("internal warning: strange s:current_shown_type value...: ".s:current_shown_type)
    endif
endfunc
 " }}}

" s:buflocal_close {{{
func! s:buflocal_close(opt)
    if empty(a:opt.cursor_buf) | return | endif
    if s:jump_to_buffer(a:opt.cursor_buf.nr) != -1
        close
    endif
endfunc
" }}}

" s:buflocal_select {{{
func! s:buflocal_select(opt)
    if a:opt.prev_mode ==# 'v'
        let tmp = deepcopy(a:opt)
        let tmp.prev_mode = 'n'
        for i in a:opt.v_selected_bufs
            let tmp.cursor_buf = i
            call s:buflocal_select(tmp)
        endfor
    else
        if has_key(s:selected_bufs, a:opt.cursor_buf.nr)
            " remove from selected.
            unlet s:selected_bufs[a:opt.cursor_buf.nr]
        else
            " add to selected.
            let s:selected_bufs[a:opt.cursor_buf.nr] = 1
        endif
    endif
endfunc
" }}}

" }}}


" single key emulation {{{

" s:emulate_single_key {{{
"   emulate QuickBuf.vim's single key mappings.
func! s:emulate_single_key()
    if s:dumbbuf_bufnr != bufnr('%') | return | endif
    if mode() !=# 'n'                | return | endif

    call s:debug(printf('s:mapstack [%s], s:mapstack_count [%d]', s:mapstack, s:mapstack_count))

    let count1 = (s:mapstack_count == -1 ? '' : s:mapstack_count)
    if g:dumbbuf_single_key_echo_stack
        echon count1 . s:mapstack
        redraw
    endif

    let c = nr2char(getchar())
    call s:debug(printf('getchar:[%s]', c))
    let key = s:mapstack . c

    let reset = 'let s:mapstack = "" | let s:mapstack_count = -1'

    if s:mapstack == '' && c =~ '[1-9]'    " range
        if s:mapstack_count == -1
            let s:mapstack_count = str2nr(c)
        else
            let s:mapstack_count = str2nr(s:mapstack_count . c)
        endif
    elseif has_key(s:mappings.single_key, key)    " single key mappings
        " NOTE: don't have to check if candidate mappings exist,
        " because s:mappings.single_key has only keys of one character.
        "
        " do it.
        call s:debug("run single key")
        call feedkeys(count1 . s:mappings.single_key[key], 'm')
        execute reset
    elseif mapcheck(key, 'n') != ''
        if maparg(key, 'n') != ''    " exact mapping exists
            " do it.
            call s:debug("run real mapping")
            call feedkeys(count1 . key, 'm')
            execute reset
        else    " candidate mapping exists
            let s:mapstack = s:mapstack . c
        endif
    else    " no mappings
        " do it.
        call s:debug("run no mappings")
        call feedkeys(count1 . key, "m")
        execute reset
    endif

    redraw
endfunc
" }}}

" s:try_to_emulate_single_key {{{
func! s:try_to_emulate_single_key()
    try
        call s:emulate_single_key()
    catch
        " ignore all!
        if v:exception != ''
            call s:debug(printf("ignore following error: '%s' in '%s'", v:exception, v:throwpoint))
        endif
        " clear
        let s:mapstack = ''
        let s:mapstack_count = -1
    endtry
endfunc
" }}}

" }}}


" autocmd's handlers {{{

" s:bufleave_handler {{{
func! s:bufleave_handler()
    call s:debug("s:bufleave_handler()...")

    let &updatetime = s:orig_updatetime
    let s:mapstack  = ''
endfunc
" }}}

" }}}

" }}}

" Mappings {{{
execute 'nnoremap <silent><unique> '.g:dumbbuf_hotkey.' :call <SID>update_buffers_list()<CR>'

" single key emulation
"
" nop.
noremap <silent><unique> <Plug>dumbbuf_try_to_emulate_single_key <Nop>
noremap! <silent><unique> <Plug>dumbbuf_try_to_emulate_single_key <Nop>
" redefine only mapmode-n.
nnoremap <silent> <Plug>dumbbuf_try_to_emulate_single_key :<C-u>call <SID>try_to_emulate_single_key()<CR>

" }}}

" Autocmd {{{
if g:dumbbuf_single_key
    augroup DumbBuf
        autocmd!

        for i in [g:dumbbuf_listed_buffer_name, g:dumbbuf_unlisted_buffer_name]
            " single key emulation.
            execute 'autocmd CursorHold '.i.' call feedkeys("\<Plug>dumbbuf_try_to_emulate_single_key", "m")'
            " restore &updatetime.
            execute 'autocmd BufLeave    '.i.' call s:bufleave_handler()'
        endfor
    augroup END
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
