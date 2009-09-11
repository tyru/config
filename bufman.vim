" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: bufman
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-09-12.
"
" Description:
"   buffer manager like QuickBuf.vim
"
" Change Log: {{{
" }}}
" Usage: {{{
"   Commands: {{{
"   }}}
"   Mappings: {{{
"   }}}
"   Global Variables: {{{
"       g:bufman_buffer_height (default: 10)
"           bufman buffer's height.
"           this is used when only g:bufman_vertical is false.
"
"       g:bufman_vertical (default: 0)
"           open bufman buffer vertically.
"
"       g:bufman_buffer_width (default: 25)
"           bufman buffer's width.
"           this is used when only g:bufman_vertical is true.
"
"       g:bufman_listed_buffer_name (default: '__buffers__')
"           bufman buffer's filename.
"           set this filename when showing 'listed buffers'.
"           'listed buffers' are opposite of 'unlisted-buffers'.
"           see ':help unlisted-buffer'.
"
"       g:bufman_unlisted_buffer_name (default: '__unlisted_buffers__')
"           bufman buffer's filename.
"           set this filename when showing 'unlisted buffers'.
"
"       g:bufman_disp_expr (default: see below)
"           this variable is for the experienced users.
"
"           NOTE:
"           this document may be old!
"           see the real definition at 'Global Variables'
"
"           here is the default value:
"               'printf("%s[%s] %s <%d> %s", v:val.is_current ? "*" : " ", bufname(v:val.nr), v:val.is_modified ? "[+]" : "   ", v:val.nr, fnamemodify(bufname(v:val.nr), ":p:h"))'
"
"       g:bufman_options (default: see below)
"           this variable is for the experienced users.
"
"           NOTE:
"           this document may be old!
"           see the real definition at 'Global Variables'
"
"           here is the default value:
"               let g:bufman_options = [
"                   \'bufhidden=wipe',
"                   \'buftype=nofile',
"                   \'cursorline',
"                   \'nobuflisted',
"                   \'nomodifiable',
"                   \'noswapfile',
"               \]
"
"       g:bufman_mappings (default: see below)
"           this variable is for the experienced users.
"
"           NOTE:
"           this document may be old!
"           see the real definition at 'Global Variables'
"
"           here is the default value:
"               let g:bufman_mappings = {
"                   \'n': {
"                       \g:bufman_hotkey : {
"                           \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
"                       \},
"                       \'q': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
"                       \},
"                       \'<CR>': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_open()<CR>',
"                       \},
"                       \'uu': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_open_onebyone()<CR>',
"                       \},
"                       \'ss': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_split_open()<CR>',
"                       \},
"                       \'vv': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_vsplit_open()<CR>',
"                       \},
"                       \'dd': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_bdelete()<CR>',
"                       \},
"                       \'ww': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_bwipeout()<CR>',
"                       \},
"                       \'ll': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_toggle_listed_type()<CR>',
"                       \},
"                       \'cc': {
"                           \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_close()<CR>',
"                       \},
"                   \}
"               \}
"   }}}
" }}}
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_bufman') && g:loaded_bufman != 0
    finish
endif
let g:loaded_bufman = 1

" do not load anymore if g:bufman_hotkey is not defined.
if ! exists('g:bufman_hotkey')
    " g:bufman_hotkey is not defined!
    echoerr "g:bufman_hotkey is not defined!"
    finish
elseif exists('g:bufman_hotkey') && maparg(g:bufman_hotkey) != ''
    echoerr printf("'%s' is already defined!", g:bufman_hotkey)
    finish
endif
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}
" Scope Variables {{{
let s:bufman_bufnr = -1
let s:bufs_info = []
let s:shown_type = ''
let s:mappings = {'default': {}, 'user': {}}
" }}}
" Global Variables {{{
if ! exists('g:debug_errmsg')
    let g:debug_errmsg = 0
endif

"--- if g:bufman_hotkey is not defined,
" do not load this script.
" see 'Load Once'. ---

if ! exists('g:bufman_buffer_height')
    let g:bufman_buffer_height = 10
endif
if ! exists('g:bufman_vertical')
    let g:bufman_vertical = 0
endif
if ! exists('g:bufman_buffer_width')
    let g:bufman_buffer_width = 25
endif
if ! exists('g:bufman_listed_buffer_name')
    let g:bufman_listed_buffer_name = '__buffers__'
endif
if ! exists('g:bufman_unlisted_buffer_name')
    let g:bufman_unlisted_buffer_name = '__unlisted_buffers__'
endif
if ! exists('g:bufman_disp_expr')
    " QuickBuf.vim like UI.
    let g:bufman_disp_expr = 'printf("%s[%s] %s <%d> %s", v:val.is_current ? "*" : " ", bufname(v:val.nr), v:val.is_modified ? "[+]" : "   ", v:val.nr, fnamemodify(bufname(v:val.nr), ":p:h"))'
endif
if ! exists('g:bufman_options')
    let g:bufman_options = [
        \'bufhidden=wipe',
        \'buftype=nofile',
        \'cursorline',
        \'nobuflisted',
        \'nomodifiable',
        \'noswapfile',
    \]
endif

if exists('g:bufman_mappings')
    let s:mappings.user = g:bufman_mappings
    unlet g:bufman_mappings
endif
let s:mappings.default = {
    \'n': {
        \g:bufman_hotkey : {
            \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
        \},
        \'q': {
            \'opt': '<silent>', 'mapto': ':<C-u>close<CR>',
        \},
        \'<CR>': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_open()<CR>',
        \},
        \'uu': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_open_onebyone()<CR>',
        \},
        \'ss': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_split_open()<CR>',
        \},
        \'vv': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_vsplit_open()<CR>',
        \},
        \'dd': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_bdelete()<CR>',
        \},
        \'ww': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_bwipeout()<CR>',
        \},
        \'ll': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_toggle_listed_type()<CR>',
        \},
        \'cc': {
            \'opt': '<silent>', 'mapto': ':<C-u>call <SID>buflocal_close()<CR>',
        \},
    \}
\}

" }}}

" Functions {{{

" Utility Functions {{{

" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}

" }}}



" s:open_bufman_buffer {{{
func! s:open_bufman_buffer()
    if g:bufman_vertical
        execute g:bufman_buffer_width.'vnew'
        return bufnr('%')
    else
        execute g:bufman_buffer_height.'new'
        return bufnr('%')
    endif
endfunc
" }}}

" s:get_current_buffer_info {{{
func! s:get_current_buffer_info(caller_bufnr)
    let current = get(filter(deepcopy(s:bufs_info), 'v:val.nr ==# a:caller_bufnr'), 0, -1)
    if type(current) == type(-1) && current ==# -1
        call s:warn("internal error: can't get current buffer's info")
        return -1
    endif
    return current
endfunc
" }}}

" s:write_buffers_list {{{
func! s:write_buffers_list()

    try
        let disp_line = map(deepcopy(s:bufs_info), g:bufman_disp_expr)
    catch
        call s:warn("error occured while evaluating g:bufman_disp_expr.")
        return
    endtry


    " write buffers list.
    let reg_z = getreg('z', 1)
    let reg_z_type = getregtype('z')

    let @z = join(disp_line, "\n")
    silent! put z

    call setreg('z', reg_z, reg_z_type)

    " delete the top of one waste blank line!
    normal! ggdd
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

        " skip bufman's buffer.
        if bufnr == s:bufman_bufnr | continue | endif

        " echoerr string(m)
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

" s:close_bufman_buffer {{{
func! s:close_bufman_buffer()
    let winnr = bufwinnr(s:bufman_bufnr)
    if winnr !=# -1
        " current window num is only bufman's buffer!!
        if winnr('$') == 1 && (expand('%') ==# g:bufman_listed_buffer_name || expand('%') ==# g:bufman_unlisted_buffer_name)
            " if previous opened file does exist, open that file.
            if expand('#') != ''
                edit #
            endif
        else
            " jump to bufman's buffer.
            execute winnr.'wincmd w'
            " close it.
            close
        endif
    endif
endfunc
" }}}

" s:is_selected {{{
func! s:is_selected()
    " selected buffer is available.
    " (not out-of-range)
    return line('.') <= len(s:bufs_info)
endfunc
" }}}

" s:get_selected_buffer {{{
func! s:get_selected_buffer()
    if ! s:is_selected() | return {} | endif

    let cur = s:bufs_info[line('.') - 1]
    call s:close_bufman_buffer()
    return cur
endfunc
" }}}

" s:run {{{
func! s:run()
    " if bufman's buffer is displayed, jump to that buffer.
    let winnr = bufwinnr(s:bufman_bufnr)
    if winnr !=# -1
        execute winnr.'wincmd w'
        return
    else
        call s:show_buffers()
    endif
endfunc
" }}}

" s:show_buffers {{{
func! s:show_buffers()

    " remember current bufnr.
    let caller_bufnr = bufnr('%')
    if caller_bufnr ==# -1
        call s:warn("internal error: can't get current bufnr.")
        return
    endif

    " save current buffers info.
    let s:bufs_info = s:parse_buffers_info()

    " open and switch to bufman's buffer.
    let s:bufman_bufnr = s:open_bufman_buffer()
    if s:bufman_bufnr ==# -1
        call s:warn("internal error: can't open buffer.")
        return
    endif

    " if current buffer is listed, display just listed buffers.
    " if current buffers is unlisted, display just unlisted buffers.
    if s:shown_type ==# 'unlisted'
        call filter(s:bufs_info, 'v:val.is_unlisted')
    elseif s:shown_type ==# 'listed'
        call filter(s:bufs_info, '! v:val.is_unlisted')
    else
        let current = s:get_current_buffer_info(caller_bufnr)
        call filter(s:bufs_info, 'current.is_unlisted ? v:val.is_unlisted : ! v:val.is_unlisted')
        " save shown type.
        let s:shown_type = current.is_unlisted ? 'unlisted' : 'listed'
    endif

    " name bufman's buffer.
    if s:shown_type ==# 'unlisted'
        silent execute 'file '.g:bufman_unlisted_buffer_name
    else
        silent execute 'file '.g:bufman_listed_buffer_name
    endif

    " write buffers list.
    call s:write_buffers_list()


    "-------- buffer settings --------
    " options
    for i in g:bufman_options
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

endfunc
" }}}



" these functions are called from bufman's buffer {{{

" s:buflocal_open {{{
func! s:buflocal_open()
    if ! s:is_selected() | return | endif
    let buf = s:get_selected_buffer()

    let winnr = bufwinnr(buf.nr)
    if winnr == -1
        execute buf.nr . 'buffer'
    else
        execute winnr . 'wincmd w'
    endif
endfunc
" }}}

" s:buflocal_open_onebyone {{{
func! s:buflocal_open_onebyone()
    if ! s:is_selected() | return | endif
    let lnum = line('.')

    " close bufman's buffer, and open selected item.
    call s:buflocal_open()
    " open bufman's buffer again.
    call s:show_buffers()

    if lnum == line('$')
        let lnum = 0
    else
        let lnum += 1
    endif

    " goto lnum.
    execute 'normal! '.lnum.'gg'
endfunc
" }}}

" s:buflocal_split_open {{{
func! s:buflocal_split_open()
    if ! s:is_selected() | return | endif
    let buf = s:get_selected_buffer()

    execute 'split ' . bufname(buf.nr)
endfunc
" }}}

" s:buflocal_vsplit_open {{{
func! s:buflocal_vsplit_open()
    if ! s:is_selected() | return | endif
    let buf = s:get_selected_buffer()

    execute 'vsplit ' . bufname(buf.nr)
endfunc
" }}}

" s:buflocal_bdelete {{{
func! s:buflocal_bdelete()
    if ! s:is_selected() | return | endif
    let buf = s:get_selected_buffer()

    execute 'bdelete ' . buf.nr
endfunc
" }}}

" s:buflocal_bwipeout {{{
func! s:buflocal_bwipeout()
    if ! s:is_selected() | return | endif
    let buf = s:get_selected_buffer()

    execute 'bwipeout ' . buf.nr
endfunc
" }}}

" s:buflocal_toggle_listed_type {{{
func! s:buflocal_toggle_listed_type()
    call s:close_bufman_buffer()

    if s:shown_type ==# 'unlisted'
        let s:shown_type = 'listed'
    elseif s:shown_type ==# 'listed'
        let s:shown_type = 'unlisted'
    endif
    call s:show_buffers()
endfunc
 " }}}

" s:buflocal_close {{{
func! s:buflocal_close()
    if ! s:is_selected() | return | endif
    let buf = s:get_selected_buffer()

    let winnr = bufwinnr(buf.nr)
    if winnr !=# -1
        execute winnr . 'wincmd w'
        close
    endif
endfunc
" }}}

" }}}

" }}}

" Mappings {{{
execute 'nnoremap <silent><unique> '.g:bufman_hotkey.' :call <SID>run()<CR>'
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
