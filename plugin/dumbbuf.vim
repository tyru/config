" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: DumbBuf
" Version: 0.0.5
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-09-27.
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
" }}}
"
" Mappings: {{{
"   please define g:dumbbuf_hotkey at first.
"   if that is not defined, this script is not loaded.
"
"   gg
"       move the cursor to the top of line.
"   G
"       move the cursor to the bottom of line.
"   j
"       move the cursor to lower line.
"   k
"       move the cursor to upper line.
"   <CR>
"       :edit the buffer.
"   q
"       :close dumbbuf buffer.
"   g:dumbbuf_hotkey
"       :close dumbbuf_hotkey buffer.
"       this is useful for toggling dumbbuf buffer.
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
"           current buffer line
"       'top':
"           jump to always top buffer line
"       'bottom':
"           jump to always bottom buffer line
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
"   g:dumbbuf_disp_expr (default: see below)
"       this variable is for the experienced users.
"
"       NOTE:
"       this document may be old!
"       see the real definition at 'Global Variables'
"
"       here is the default value:
"           'printf("%s[%s] %s <%d> %s", v:val.is_current ? "*" : " ", bufname(v:val.nr), v:val.is_modified ? "[+]" : "   ", v:val.nr, fnamemodify(bufname(v:val.nr), ":p:h"))'
"
"   g:dumbbuf_options (default: see below)
"       this variable is for the experienced users.
"
"       NOTE:
"       this document may be old!
"       see the real definition at 'Global Variables'
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
"       NOTE:
"       this document may be old!
"       see the real definition at 'Global Variables'
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
"                       \'opt': '<silent>', 'mapto': 'j',
"                   \},
"                   \'k': {
"                       \'opt': '<silent>', 'mapto': 'k',
"                   \},
"                   \'gg': {
"                       \'opt': '<silent>', 'mapto': 'gg',
"                   \},
"                   \'G': {
"                       \'opt': '<silent>', 'mapto': 'G',
"                   \},
"                   \g:dumbbuf_hotkey : {
"                       \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
"                   \},
"                   \'q': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
"                   \},
"                   \'<CR>': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open_closing_dumbbuf", "func", 0)<CR>',
"                   \},
"                   \'uu': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open_onebyone", "func", 0)<CR>',
"                   \},
"                   \'ss': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("split #%d", "cmd", 1)<CR>',
"                   \},
"                   \'vv': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("vsplit #%d", "cmd", 1)<CR>',
"                   \},
"                   \'tt': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map(["tabedit #%d", "throw \"skip_post_process\""], "cmd", [1, 0])<CR>',
"                   \},
"                   \'dd': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("bdelete %d", "cmd", 1)<CR>',
"                   \},
"                   \'ww': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("bwipeout %d", "cmd", 1)<CR>',
"                   \},
"                   \'ll': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_toggle_listed_type", "func", 0)<CR>',
"                   \},
"                   \'cc': {
"                       \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_close", "func", 0)<CR>',
"                   \},
"               \}
"           \}
" }}}
"
" TODO: {{{
"   - manipulate buffers each project.
"   - reuse dumbbuf buffer.
"   - select some buffers and execute mapping each buffers.
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
    echoerr "g:dumbbuf_hotkey is not defined!"
    finish
elseif exists('g:dumbbuf_hotkey') && maparg(g:dumbbuf_hotkey) != ''
    echoerr printf("'%s' is already defined!", g:dumbbuf_hotkey)
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
    let g:dumbbuf_disp_expr = 'printf("%s[%s] %s <%d> %s", v:val.is_current ? "*" : " ", bufname(v:val.nr), v:val.is_modified ? "[+]" : "   ", v:val.nr, fnamemodify(bufname(v:val.nr), ":p:h"))'
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
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_move_lower()<CR>',
        \},
        \'k': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_move_upper()<CR>',
        \},
        \'gg': {
            \'opt': '<silent>', 'mapto': 'gg',
        \},
        \'G': {
            \'opt': '<silent>', 'mapto': 'G',
        \},
        \g:dumbbuf_hotkey : {
            \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
        \},
        \'q': {
            \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
        \},
        \'<CR>': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open_closing_dumbbuf", {"type":"func", "requires_args":0, "pre":["jump_to_caller"], "post":["clear_selected", "close"]})<CR>',
        \},
        \'uu': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_open_onebyone", {"type":"func", "requires_args":0, "pre":["jump_to_caller"], "post":["clear_selected"]})<CR>',
        \},
        \'ss': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("split #%d", {"type":"cmd", "requires_args":1, "pre":["jump_to_caller"], "post":["clear_selected", "update"]})<CR>',
        \},
        \'vv': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("vsplit #%d", {"type":"cmd", "requires_args":1, "pre":["jump_to_caller"], "post":["clear_selected", "update"]})<CR>',
        \},
        \'tt': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("tabedit #%d", {"type":"cmd", "requires_args":[1, 0], "pre":["close", "jump_to_caller"], "post":["clear_selected"]})<CR>',
        \},
        \'dd': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("bdelete %d", {"type":"cmd", "requires_args":1, "post":["clear_selected", "update"]})<CR>',
        \},
        \'ww': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("bwipeout %d", {"type":"cmd", "requires_args":1, "post":["clear_selected", "update"]})<CR>',
        \},
        \'ll': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_toggle_listed_type", {"type":"func", "requires_args":0})<CR>',
        \},
        \'cc': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>run_from_local_map("<SID>buflocal_close", {"type":"func", "requires_args":0, "post":["clear_selected", "update"]})<CR>',
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
\}

" }}}

" Functions {{{

" Utility Functions {{{

" Debug {{{
if g:dumbbuf_verbose
    command DumbBufDebug call s:list_debug()

    func! s:list_debug()
        for i in s:debug_msg | call s:warn(i) | endfor
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

" s:apply {{{
func! s:apply(funcname, args)
    let args_str = ''
    let i = 0
    let arg_len = len(a:args)
    while i < arg_len
        if i ==# 0
            let args_str = printf('a:args[%d]', i)
        else
            let args_str .= ', '.printf('a:args[%d]', i)
        endif
        let i += 1
    endwhile

    return eval(printf('%s(%s)', a:funcname, args_str))
endfunc
" }}}

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

" s:get_caller_buffer_info {{{
"   this returns [<caller buffer info>, <lnum of current buffer>]
func! s:get_caller_buffer_info()
    let i = 0
    let bufs_len = len(s:bufs_info)

    while i < bufs_len
        if s:bufs_info[i].nr ==# s:caller_bufnr
            return [s:bufs_info[i], i]
        endif
        let i += 1
    endwhile

    return []
endfunc
" }}}

" s:write_buffers_list {{{
func! s:write_buffers_list()

    try
        let disp_line = map(deepcopy(s:bufs_info), g:dumbbuf_disp_expr)
    catch
        call s:warn("error occured while evaluating g:dumbbuf_disp_expr.")
        return
    endtry


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
        \})
    endfor

    return result_list
endfunc
" }}}

" s:jump_to_buffer {{{
func! s:jump_to_buffer(bufnr)
    let winnr = bufwinnr(a:bufnr)
    if winnr != -1
        call s:debug(printf("jump to ... [%s]", bufname(a:bufnr)))
        execute winnr.'wincmd w'
    endif
    return winnr
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
func! s:get_shown_type()
    if s:shown_type =~# '^\(unlisted\|listed\)$'.'\C'    " don't ignorecase
        return s:shown_type
    elseif s:shown_type == ''
        if g:dumbbuf_shown_type =~# '^\(unlisted\|listed\)$'.'\C'
            return g:dumbbuf_shown_type
        elseif g:dumbbuf_shown_type == ''
            let info = s:get_caller_buffer_info()
            if empty(info)
                throw "internal error: can't get caller buffer's info..."
            endif
            return info[0].is_unlisted ? 'unlisted' : 'listed'
        else
            throw printf("internal error: strange g:dumbbuf_shown_type value...[%s]",
                        \g:dumbbuf_shown_type)
        endif
    else
        " error
        throw printf("internal error: strange s:shown_type value...[%s]", s:shown_type)
    endif
endfunc
" }}}

" s:filter_bufs_info {{{
func! s:filter_bufs_info(curbufinfo)
    " if current buffer is unlisted, filter unlisted buffers.
    " if current buffers is listed, filter listed buffers.
    let s:shown_type = s:get_shown_type()
    call filter(s:bufs_info,
                \'s:shown_type ==# "unlisted" ?' .
                    \'v:val.is_unlisted : ! v:val.is_unlisted')
endfunc
" }}}

" s:open_dumbbuf_buffer {{{
func! s:open_dumbbuf_buffer()

    " remember current bufnr.
    let s:caller_bufnr = bufnr('%')
    if s:caller_bufnr ==# -1
        call s:warn("internal error: can't get current bufnr.")
        return
    endif
    if bufwinnr(s:caller_bufnr) == -1
        call s:warn("internal error: caller buffer does not appear.")
        call s:warn('caller buffer is '.bufname(s:caller_bufnr))
        return
    endif
    if bufwinnr(s:dumbbuf_bufnr) != -1
        call s:debug("I'm now going to open dumbbuf buffer but dumbbuf exists! close it.")
        call s:close_dumbbuf_buffer()
    endif
    call s:debug('caller buffer name is '.bufname(s:caller_bufnr))

    " save current buffers info.
    let s:bufs_info = s:parse_buffers_info()

    " open and switch to dumbbuf's buffer.
    let s:dumbbuf_bufnr = s:create_dumbbuf_buffer()
    if s:dumbbuf_bufnr ==# -1
        call s:warn("internal error: can't open buffer.")
        return
    endif

    " get current buffer's info and lnum on dumbbuf buffer.
    let info = s:get_caller_buffer_info()
    if empty(info)
        call s:warn("internal error: can't get current buffer's info")
        return
    endif
    let [curbufinfo, lnum] = info

    " if current buffer is listed, display just listed buffers.
    " if current buffers is unlisted, display just unlisted buffers.
    try
        call s:filter_bufs_info(curbufinfo)
    catch /internal error:/
        call s:warn(printf("'%s' is not valid value. please choose in '', 'unlisted', 'listed'.", g:dumbbuf_shown_type))
        call s:warn("use '' as g:dumbbuf_shown_type value...")

        let g:dumbbuf_shown_type = ''
        sleep 1

        try
            call s:filter_bufs_info(curbufinfo)
        catch /internal error:/
            call s:warn(v:exception)
            return
        endtry
    endtry
    call s:debug(printf("filtered only '%s' buffers.", s:shown_type))

    " name dumbbuf's buffer.
    if s:shown_type ==# 'unlisted'
        silent execute 'file `=g:dumbbuf_unlisted_buffer_name`'
    else
        silent execute 'file `=g:dumbbuf_listed_buffer_name`'
    endif

    " write buffers list.
    call s:write_buffers_list()

    " move cursor to specified position.
    if g:dumbbuf_cursor_pos ==# 'current'
        if lnum !=# 0
            execute 'normal! '.lnum.'gg'
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
    " NOTE: updatetime is global. so I must restore it later.
    let s:orig_updatetime = &updatetime
    let &l:updatetime = g:dumbbuf_updatetime
endfunc
" }}}

" s:update_buffers_list {{{
func! s:update_buffers_list()
    call s:close_dumbbuf_buffer()
    call s:open_dumbbuf_buffer()
endfunc
" }}}

" s:dispatch_code {{{
func! s:dispatch_code(code, no, opt)
    let cursor_buf = a:opt.cursor_buf
    let lnum       = a:opt.lnum
    let requires_args = type(a:opt.requires_args) == type([]) ?
                \a:opt.requires_args[a:no] : a:opt.requires_args

    if a:opt.type ==# 'cmd'
        if requires_args
            execute printf(a:code, cursor_buf.nr)
        else
            execute a:code
        endif
    elseif a:opt.type ==# 'func'
        if requires_args
            " NOTE: not used.
            call s:apply(a:code, a:opt.args)
        else
            call s:apply(a:code, [cursor_buf, lnum])
        endif
    else
        throw "internal error: unknown type: ".a:opt.type
    endif
endfunc
"}}}



" s:run_from_map {{{
func! s:run_from_map()
    call s:debug(printf('from map: winnr:%d, bufnr:%d, s:dumbbuf_bufnr:%d', winnr('$'), bufnr('%'), s:dumbbuf_bufnr))
    " if dumbbuf buffer exists, close it.
    " (because old dumbbuf buffers list may be wrong)
    let winnr = bufwinnr(s:dumbbuf_bufnr)
    if winnr != -1
        call s:close_dumbbuf_buffer()
    endif

    " open dumbbuf buffer from listed buffer.
    call s:open_dumbbuf_buffer()
endfunc
" }}}

" s:run_from_local_map {{{
func! s:run_from_local_map(code, opt)
    call s:debug(printf('from local map: winnr:%d, bufnr:%d, s:dumbbuf_bufnr:%d', winnr('$'), bufnr('%'), s:dumbbuf_bufnr))

    let opt = extend(copy(a:opt), {"pre":[], "post":[]}, "keep")

    " at now, current window should be dumbbuf buffer
    " because this func is called only from dumbbuf buffer local mappings.

    " get selected buffer info.
    let cursor_buf = s:get_cursor_buffer()
    if ! empty(cursor_buf) && ! bufexists(cursor_buf.nr)
        call s:warn("selected buffer does not exist!")
        return
    endif
    " this must be done in dumbbuf buffer.
    let lnum = line('.')
    " save current value.
    let save_close_when_exec = g:dumbbuf_close_when_exec

    " --- pre process ---

    for p in opt.pre
        if p ==# 'close'
            call s:close_dumbbuf_buffer()
        elseif p ==# 'jump_to_caller'    " jump to caller buffer.
            call s:jump_to_buffer(s:caller_bufnr)
        else
            call s:warn("internal warning: unknown pre process name: ".p)
        endif
    endfor

    call s:debug(printf("exec %s from local map: %s", string(opt.type), string(a:code)))
    call s:debug("selected buffers len:".len(s:selected_bufs))
    " dispatch a:code.
    " NOTE: current buffer may not be caller buffer.
    try
        if type(a:code) == type([])
            for buf in empty(s:selected_bufs) ? [cursor_buf] : s:selected_bufs
                let i = 0
                let len = len(a:code)
                while i < len
                    call s:dispatch_code(a:code[i], i, extend(copy(opt), {'lnum': lnum, 'cursor_buf': buf}))
                    let i += 1
                endwhile
            endfor
        else
            for buf in empty(s:selected_bufs) ? [cursor_buf] : s:selected_bufs
                let i = 0
                call s:dispatch_code(a:code, i, extend(copy(opt), {'lnum': lnum, 'cursor_buf': buf}))
            endfor
        endif

        " --- post process ---

        for p in opt.post
            if p ==# 'clear_selected'
                " clear selected buffers.
                let s:selected_bufs = []
            elseif p ==# 'close'
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
            else
                call s:warn("internal warning: unknown post process name: ".p)
            endif
        endfor

    catch /internal error:/
        call s:warn(v:exception)

    " catch    " NOTE: this traps also unknown other plugin's error. wtf?
    "     echoerr printf("internal error: '%s' in '%s'", v:exception, v:throwpoint)

    finally
        " restore previous value.
        let g:dumbbuf_close_when_exec = save_close_when_exec
    endtry
endfunc
" }}}



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

" s:buflocal_open_closing_dumbbuf {{{
"   this must be going to close dumbbuf buffer.
func! s:buflocal_open_closing_dumbbuf(curbuf, db_lnum)
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

    try
        " open buffer on the cursor and close dumbbuf buffer.
        call s:buflocal_open_closing_dumbbuf(a:curbuf, a:db_lnum)
        " open dumbbuf's buffer again.
        call s:open_dumbbuf_buffer()

        if g:dumbbuf_downward
            call s:buflocal_move_lower()
        else
            call s:buflocal_move_upper()
        endif
    finally
        let g:dumbbuf_close_when_exec = save_close_when_exec
    endtry
endfunc
" }}}

" s:buflocal_toggle_listed_type {{{
"   this does NOT do update or close buffers list.
func! s:buflocal_toggle_listed_type(curbuf, db_lnum)
    if s:shown_type ==# 'unlisted'
        let s:shown_type = 'listed'
        call s:update_buffers_list()

    elseif s:shown_type ==# 'listed'
        let s:shown_type = 'unlisted'
        call s:update_buffers_list()

    elseif s:shown_type == ''
        if a:curbuf.is_unlisted
            let s:shown_type = 'listed'
        else
            let s:shown_type = 'unlisted'
        endif
        call s:update_buffers_list()
        " restore.
        let s:shown_type = ''

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

" }}}



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

" Mappings {{{
execute 'nnoremap <silent><unique> '.g:dumbbuf_hotkey.' :call <SID>run_from_map()<CR>'

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
            " get each key and execute it.
            execute 'autocmd CursorHold '.i.' call feedkeys("\<Plug>try_to_emulate_single_key", "m")'
            " restore &updatetime because &updatetime is global setting.
            execute 'autocmd BufLeave   '.i.' let &updatetime = s:orig_updatetime'
        endfor
    augroup END
endif
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
