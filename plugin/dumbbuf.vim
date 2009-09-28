" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: DumbBuf
" Version: 0.0.6
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-09-29.
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
"   g:dumbbuf_updatetime (default: 100)
"       local value of &updatetime in dumbbuf buffer.
"       making this 0 speeds up key input
"       but that may be 'heavy' for Vim.
"
"   g:dumbbuf_wrap_cursor (default: 1)
"       wrap the cursor at the top or bottom of dumbbuf buffer.
"
"   g:dumbbuf_disp_expr (default: see below)
"       this variable is for the experienced users.
"
"       here is the default value:
"           'printf("%s[%s] %s <%d> %s", val.is_current ? "*" : " ", bufname(val.nr), val.is_modified ? "[+]" : "   ", val.nr, fnamemodify(bufname(val.nr), ":p:h"))'
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
" TODO: {{{
"   - manipulate buffers each project.
"   - reuse dumbbuf buffer.
"   - user-defined mapping
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
let s:bufs_info = []    " buffers info.
let s:selected_bufs = []    " selected buffers info.
let s:previous_lnum = -1    " lnum on which a mapping executed.

let s:shown_type = ''    " this must be one of '', 'listed', 'unlisted'.
let s:mappings = {'default': {}, 'user': {}}    " buffer local mappings.

" used for single key emulation.
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
                \'"pre":["close_dumbbuf", "jump_to_caller", ' .
                        \'"return_if_empty", "return_if_not_exist"], ' .
                \'"post":["clear_selected"]})<CR>',
        \},
        \'uu': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open_onebyone", ' .
                \'{"type":"func", ' .
                \'"requires_args":0, ' .
                \'"pre":["close_dumbbuf", "jump_to_caller", ' .
                        \'"return_if_empty", "return_if_not_exist"], ' .
                \'"post":["save_lnum", "clear_selected"]})<CR>',
        \},
        \'ss': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("split #%d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":1, ' .
                \'"process_selected":1, ' .
                \'"pre":["close_dumbbuf", "jump_to_caller", ' .
                        \'"return_if_noname", "return_if_empty", ' .
                        \'"return_if_not_exist"], ' .
                \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
        \},
        \'vv': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("vsplit #%d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":1, ' .
                \'"process_selected":1, ' .
                \'"pre":["close_dumbbuf", "jump_to_caller", ' .
                        \'"return_if_noname", "return_if_empty", ' .
                        \'"return_if_not_exist"], ' .
                \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
        \},
        \'tt': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("tabedit #%d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":[1, 0], ' .
                \'"process_selected":1, ' .
                \'"pre":["close_dumbbuf", "jump_to_caller", ' .
                        \'"return_if_noname", "return_if_empty", ' .
                        \'"return_if_not_exist"], ' .
                \'"post":["clear_selected", "save_lnum"]})<CR>',
        \},
        \'dd': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("bdelete %d", ' .
                \'{"type":"cmd", ' .
                    \'"requires_args":1, ' .
                    \'"process_selected":1, ' .
                    \'"pre":["close_dumbbuf", "return_if_empty", ' .
                            \'"return_if_not_exist"], ' .
                    \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
        \},
        \'ww': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("bwipeout %d", ' .
                \'{"type":"cmd", ' .
                \'"requires_args":1, ' .
                \'"process_selected":1, ' .
                \'"pre":["close_dumbbuf", "return_if_empty", ' .
                        \'"return_if_not_exist"], ' .
                \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
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
                \'"pre":["close_dumbbuf", "return_if_empty", ' .
                        \'"return_if_not_exist"], ' .
                \'"post":["clear_selected", "save_lnum", "update"]})<CR>',
        \},
        \'xx': {
            \'opt': '<silent>',
            \'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_select", ' .
                \'{"type":"func", ' .
                \'"requires_args":0, ' .
                \'"pre":["return_if_empty", "return_if_not_exist"], ' .
                \'"post":["save_lnum", "update"]})<CR>'
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
    echo a:msg
    echohl None
endfunc
" }}}

" }}}

" misc. {{{

" s:get_buffer_info {{{
"   this returns the caller buffer's info
func! s:get_buffer_info(bufnr)
    for buf in s:bufs_info
        if buf.nr ==# a:bufnr
            return buf
        endif
    endfor

    return []
endfunc
" }}}

" s:write_buffers_list {{{
"   this defines s:bufs_info[i].lnum
func! s:write_buffers_list()
    call s:jump_to_buffer(s:dumbbuf_bufnr)

    let disp_line = []
    try
        let i = 0
        let len = len(s:bufs_info)
        while i < len
            let val = s:bufs_info[i]
            let val.lnum = i + 1
            call add(disp_line, eval(g:dumbbuf_disp_expr))

            let i += 1
        endwhile
        " let disp_line = map(deepcopy(s:bufs_info), g:dumbbuf_disp_expr)
    catch
        call s:warn("error occured while evaluating g:dumbbuf_disp_expr.")
        return
    endtry

    " TODO use 'put ="..."'

    " write buffers list.
    let reg_z = getreg('z', 1)
    let reg_z_type = getregtype('z')

    let @z = join(disp_line, "\n")
    silent! put z

    call setreg('z', reg_z, reg_z_type)

    " delete the top of one waste blank line!
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

    let result_list = []

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
        call add(result_list, {
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
        \})
    endfor

    return result_list
endfunc
" }}}


" s:has_cursor_buffer {{{
"   this returns if the buffer on the cursor is available.
"   (not out-of-range)
func! s:has_cursor_buffer()
    return line('.') <= len(s:bufs_info)
endfunc
" }}}

" s:get_cursor_buffer {{{
func! s:get_cursor_buffer()
    if ! s:has_cursor_buffer() | return {} | endif
    let cur = s:bufs_info[line('.') - 1]
    return cur
endfunc
" }}}


" s:get_shown_type {{{
"   this returns 'listed' or 'unlisted'.
"   if s:shown_type or g:dumbbuf_shown_type value is invalid,
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
func! s:filter_bufs_info(curbufinfo, shown_type)
    " if current buffer is unlisted, filter unlisted buffers.
    " if current buffers is listed, filter listed buffers.
    call filter(s:bufs_info,
                \'a:shown_type ==# "unlisted" ?' .
                    \'v:val.is_unlisted : ! v:val.is_unlisted')
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

    let curbufinfo = s:get_buffer_info(s:caller_bufnr)
    if empty(curbufinfo)
        call s:warn("internal error: can't get current buffer's info")
        return
    endif

    " if current buffer is listed, display just listed buffers.
    " if current buffers is unlisted, display just unlisted buffers.
    call s:filter_bufs_info(curbufinfo, a:shown_type)
    call s:debug(printf("filtered only '%s' buffers.", a:shown_type))

    " check flag if selected.
    for buf in s:bufs_info
        " TODO store s:bufs_info and s:selected_bufs as dict.
        if !empty(filter(deepcopy(s:selected_bufs), 'v:val.nr == buf.nr'))
            " if current buffer is selected
            let buf.is_selected = 1
        endif
    endfor

    " name dumbbuf's buffer.
    if a:shown_type ==# 'unlisted'
        silent execute 'file `=g:dumbbuf_unlisted_buffer_name`'
    else
        silent execute 'file `=g:dumbbuf_listed_buffer_name`'
    endif

    " write buffers list.
    call s:write_buffers_list()

    " move cursor to specified position.
    if g:dumbbuf_cursor_pos ==# 'current'
        if curbufinfo.lnum !=# -1
            execute 'normal! '.curbufinfo.lnum.'gg'
        endif
    elseif g:dumbbuf_cursor_pos ==# 'keep'
        call s:debug(printf("s:previous_lnum [%d]", s:previous_lnum))
        if s:previous_lnum == -1
            " same as above.
            if curbufinfo.lnum !=# -1
                execute 'normal! '.curbufinfo.lnum.'gg'
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
        let s:shown_type = a:1
    else
        let s:shown_type = s:get_shown_type(s:caller_bufnr)
    endif

    " open.
    call s:open_dumbbuf_buffer(s:shown_type)
endfunc
" }}}

" s:jump_to_buffer {{{
func! s:jump_to_buffer(bufnr)
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

" }}}


" s:run_from_local_map {{{
func! s:run_from_local_map(code, opt)
    let opt = extend(copy(a:opt), {"process_selected":0, "pre":[], "post":[]}, "keep")

    " at now, current window should be dumbbuf buffer
    " because this func is called only from dumbbuf buffer local mappings.

    " get selected buffer info.
    let cursor_buf = s:get_cursor_buffer()
    " this must be done in dumbbuf buffer.
    let lnum = line('.')
    " save current value.
    let save_close_when_exec = g:dumbbuf_close_when_exec

    " current window should be dumbbuf buffer, though.
    " if winnr('$') == 1 && bufnr('%') == s:dumbbuf_bufnr
    "     execute printf("%s %s new",
    "                 \g:dumbbuf_vertical ? 'vertical' : '',
    "                 \g:dumbbuf_open_with)
    " endif


    try
        " pre process.
        call s:map_process_pre(opt.pre, cursor_buf)

        let bufs = opt.process_selected && !empty(s:selected_bufs) ?
                    \ s:selected_bufs
                    \ : [cursor_buf]

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

        " post process.
        call s:map_process_post(opt.post, lnum)

    catch /internal error:/
        call s:warn(v:exception)

    catch /^return_from_pre_process$/

    " catch    " NOTE: this traps also unknown other plugin's error...
    "     echoerr printf("internal error: '%s' in '%s'", v:exception, v:throwpoint)

    finally
        " restore previous value.
        let g:dumbbuf_close_when_exec = save_close_when_exec
    endtry
endfunc
" }}}

" s:map_process_pre {{{
func! s:map_process_pre(tasks, cursor_buf)
    for p in a:tasks
        if p ==# 'close_dumbbuf'
            call s:close_dumbbuf_buffer()
        elseif p ==# 'jump_to_caller'    " jump to caller buffer.
            call s:jump_to_buffer(s:caller_bufnr)
        elseif p ==# 'return_if_noname'
            if bufname('%') == ''
                throw 'return_from_pre_process'
            endif
        elseif p ==# 'return_if_empty'
            if empty(a:cursor_buf)
                call s:warn("empty list!")
                throw 'return_from_pre_process'
            endif
        elseif p ==# 'return_if_not_exist'
            if has_key(a:cursor_buf, 'nr') && ! bufexists(a:cursor_buf.nr)
                call s:warn("selected buffer does not exist!")
                throw 'return_from_pre_process'
            endif
        else
            call s:warn("internal warning: unknown pre process name: ".p)
        endif
    endfor
endfunc
" }}}

" s:map_process_post {{{
func! s:map_process_post(tasks, lnum)
    for p in a:tasks
        if p ==# 'clear_selected'
            " clear selected buffers.
            let s:selected_bufs = []
        elseif p ==# 'close_dumbbuf'
            call s:debug("just close")
            call s:close_dumbbuf_buffer()
        elseif p ==# 'update'
            " close or update dumbbuf buffer.
            if g:dumbbuf_close_when_exec
                call s:debug("just close")
                call s:close_dumbbuf_buffer()
            else
                call s:debug("close and re-open")
                call s:update_buffers_list()
            endif
        elseif p ==# 'save_lnum'    " NOTE: do this before 'update'.
            call s:debug("save_lnum:".a:lnum)
            let s:previous_lnum = a:lnum
        else
            call s:warn("internal warning: unknown post process name: ".p)
        endif
    endfor
endfunc
" }}}

" s:dispatch_code {{{
func! s:dispatch_code(code, no, opt)
    call s:debug(printf("a:code [%s], buffer [%s]",
                        \a:code, bufname(a:opt.cursor_buf.nr)))

    let requires_args = type(a:opt.requires_args) == type([]) ?
                \a:opt.requires_args[a:no] : a:opt.requires_args

    if a:opt.type ==# 'cmd'
        if requires_args
            execute printf(a:code, a:opt.cursor_buf.nr)
        else
            execute a:code
        endif
    elseif a:opt.type ==# 'func'
        if requires_args
            " NOTE: not used.
            return function(a:code)(a:opt.args)
        else
            return function(a:code)(a:opt.cursor_buf, a:opt.lnum)
        endif
    else
        throw "internal error: unknown type: ".a:opt.type
    endif
endfunc
"}}}

" these functions are called from dumbbuf's buffer {{{

" s:buflocal_move_lower {{{
func! s:buflocal_move_lower()
    if line('.') == line('$')
        if g:dumbbuf_wrap_cursor
            " go to the top of buffer.
            execute '1'
        endif
    else
        normal! j
    endif
endfunc
" }}}

" s:buflocal_move_upper {{{
func! s:buflocal_move_upper()
    if line('.') == 1
        if g:dumbbuf_wrap_cursor
            " go to the bottom of buffer.
            execute line('$')
        endif
    else
        normal! k
    endif
endfunc
" }}}

" s:buflocal_open {{{
"   this must be going to close dumbbuf buffer.
func! s:buflocal_open(curbuf, db_lnum)
    if ! empty(a:curbuf)
        let winnr = bufwinnr(a:curbuf.nr)
        if winnr == -1
            execute a:curbuf.nr.'buffer'
        else
            execute winnr.'wincmd w'
        endif
    endif
endfunc
" }}}

" s:buflocal_open_onebyone {{{
"   this does NOT do update or close buffers list.
func! s:buflocal_open_onebyone(curbuf, db_lnum)
    call s:debug("current lnum:".a:db_lnum)
    let save_close_when_exec = g:dumbbuf_close_when_exec

    " open buffer on the cursor and close dumbbuf buffer.
    call s:buflocal_open(a:curbuf, a:db_lnum)
    " open dumbbuf's buffer again.
    call s:update_buffers_list()
    " go to previous lnum.
    execute a:db_lnum

    if g:dumbbuf_downward
        call s:buflocal_move_lower()
    else
        call s:buflocal_move_upper()
    endif
endfunc
" }}}

" s:buflocal_toggle_listed_type {{{
func! s:buflocal_toggle_listed_type(curbuf, db_lnum)
    " NOTE: s:shown_type SHOULD NOT be '', and MUST NOT be.

    if s:shown_type ==# 'unlisted'
        call s:update_buffers_list('listed')

    elseif s:shown_type ==# 'listed'
        call s:update_buffers_list('unlisted')

    else
        call s:warn("internal warning: strange s:shown_type value...: ".s:shown_type)
    endif
endfunc
 " }}}

" s:buflocal_close {{{
func! s:buflocal_close(curbuf, db_lnum)
    if empty(a:curbuf) | return | endif
    if s:jump_to_buffer(a:curbuf.nr) != -1
        close
    endif
endfunc
" }}}

" s:buflocal_select {{{
func! s:buflocal_select(curbuf, db_lnum)
    if !empty(filter(deepcopy(s:selected_bufs), 'v:val.nr == a:curbuf.nr'))
        " remove from selected.
        call filter(s:selected_bufs, 'v:val.nr != a:curbuf.nr')
    else
        " add to selected.
        call add(s:selected_bufs, a:curbuf)
    endif
endfunc
" }}}

" }}}


" singkey key emulation {{{

" s:emulate_single_key {{{
"   emulate QuickBuf.vim's single key mappings.
func! s:emulate_single_key()
    if s:dumbbuf_bufnr != bufnr('%') | return | endif
    if mode() !=# 'n'                | return | endif

    let c = nr2char(getchar())
    call s:debug(printf('getchar:[%s]', c))
    let key = s:mapstack . c

    if has_key(s:mappings.single_key, key) || mapcheck(key, 'n') != ''
        " (candidate) mappings exist.
        if has_key(s:mappings.single_key, key)    " single key mapping.
            call feedkeys(s:mappings.single_key[key], 'm')
            let s:mapstack = ''
        elseif maparg(key, 'n') != ''    " user mapping or local buffer mapping.
            call feedkeys(key, 'm')
            let s:mapstack = ''
        else
            " push char key.
            let s:mapstack = s:mapstack . c
        endif
    else
        " no mappings. just do it.
        call feedkeys(key, "m")
        let s:mapstack = ''
    endif
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
noremap <silent> <Plug>try_to_emulate_single_key <Nop>
noremap! <silent> <Plug>try_to_emulate_single_key <Nop>
" redefine only mapmode-n.
nnoremap <silent> <Plug>try_to_emulate_single_key :<C-u>call <SID>try_to_emulate_single_key()<CR>

" }}}

" Autocmd {{{
if g:dumbbuf_single_key
    augroup DumbBuf
        autocmd!

        for i in [g:dumbbuf_listed_buffer_name, g:dumbbuf_unlisted_buffer_name]
            " single key emulation.
            execute 'autocmd CursorHold '.i.' call feedkeys("\<Plug>try_to_emulate_single_key", "m")'
            " restore &updatetime.
            execute 'autocmd BufLeave    '.i.' call s:bufleave_handler()'
        endfor
    augroup END
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
