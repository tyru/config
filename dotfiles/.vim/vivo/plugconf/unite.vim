let s:config = vivo#plugconf#new()

function! s:config.config()
    nmap s <SID>(unite)
    nmap ,t <SID>(prompt)
    xmap ,t <SID>(prompt)
    omap ,t <SID>(prompt)

    MapAlterCommand        u[nite]     Unite -prompt='-')/\  -no-split -create <args>
    command! -bar -nargs=* CustomUnite Unite -prompt='-')/\  -no-split -create <args>
    nnoremap <SID>(unite)f        :<C-u>CustomUnite -buffer-name=files file buffer<CR>
    nnoremap <SID>(unite)F        :<C-u>CustomUnite -buffer-name=files file_rec<CR>
    nnoremap <SID>(unite)p        :<C-u>CustomUnite -buffer-name=files buffer_tab<CR>
    nnoremap <SID>(unite)h        :<C-u>CustomUnite -buffer-name=files file_mru<CR>
    nnoremap <SID>(unite)t        :<C-u>CustomUnite -immediately tab:no-current<CR>
    nnoremap <SID>(unite)w        :<C-u>CustomUnite -immediately window:no-current<CR>
    " nnoremap <SID>(unite)T        :<C-u>CustomUnite tag<CR>
    " nnoremap <SID>(unite)H        :<C-u>CustomUnite help<CR>
    nnoremap <SID>(unite)b        :<C-u>CustomUnite buffer<CR>
    " nnoremap <SID>(unite)o        :<C-u>CustomUnite outline<CR>
    nnoremap <SID>(unite)r        :<C-u>CustomUnite -input=ref/ source<CR>
    nnoremap <SID>(unite)s        :<C-u>CustomUnite source<CR>
    nnoremap <SID>(unite)g        :<C-u>CustomUnite grep<CR>
    nnoremap <SID>(unite)/        :<C-u>CustomUnite line<CR>
    " nnoremap <SID>(unite):        :<C-u>CustomUnite history/command<CR>
    nnoremap <SID>(unite)j        :<C-u>CustomUnite jump<CR>


    " abbrev
    function! s:register_anything_abbrev() "{{{
        let abbrev = {
        \   '^r@': [$VIMRUNTIME . '/'],
        \   '^p@': map(split(&runtimepath, ','), 'v:val . "/plugin/"'),
        \   '^h@': ['~/'],
        \   '^v@': [$MYVIMDIR . '/'],
        \   '^g@': ['~/git/'],
        \   '^d@': ['~/git/dotfiles/'],
        \   '^m@': ['~/Dropbox/memo/'],
        \   '^s@': ['~/scratch/'],
        \}

        if has('win16') || has('win32') || has('win64') || has('win95')
            call extend(abbrev, {
            \   '^m@' : ['~/Dropbox/memo/'],
            \   '^de@' : ['C:' . substitute($HOMEPATH, '\', '/', 'g') . '/デスクトップ/'],
            \   '^cy@' : [exists('$CYGHOME') ? $CYGHOME . '/' : 'C:/cygwin/home/'. $USERNAME .'/'],
            \   '^ms@' : [exists('$MSYSHOME') ? $MSYSHOME . '/' : 'C:/msys/home/'. $USERNAME .'/'],
            \})
        endif

        for [pat, subst_list] in items(abbrev)
            call unite#custom#substitute('files', pat, subst_list)
        endfor
    endfunction "}}}

    autocmd vimrc VimEnter * call s:register_anything_abbrev()


    let g:unite_enable_start_insert = 1
    let g:unite_enable_ignore_case = 1
    let g:unite_enable_smart_case = 1

    " matcher {{{
    " if has('migemo') || executable('cmigemo')
    "     call unite#custom#source('file,buffer,file_mru', 'matchers', 'matcher_migemo')
    " endif
    " }}}


    " unite-source-menu {{{

    let g:unite_source_menu_menus = {}

    function! UniteSourceMenuMenusMap(key, value)
        return {
        \   'word' : a:key,
        \   'kind' : 'command',
        \   'action__command' : a:value,
        \}
    endfunction


    " edit ++enc=... {{{
    let g:unite_source_menu_menus.enc = {
    \   'description' : 'edit ++enc=...',
    \   'candidates'  : {},
    \   'map': function('UniteSourceMenuMenusMap'),
    \}
    for s:tmp in [
    \           'latin1',
    \           'cp932',
    \           'shift-jis',
    \           'iso-2022-jp',
    \           'euc-jp',
    \           'utf-8',
    \           'ucs-bom'
    \       ]
        call extend(g:unite_source_menu_menus.enc.candidates,
        \           {s:tmp : 'edit ++enc='.s:tmp},
        \           'error')
    endfor
    unlet s:tmp

    nnoremap <silent> <SID>(prompt)a  :<C-u>Unite menu:enc<CR>
    " }}}
    " set fenc=... {{{
    let g:unite_source_menu_menus.fenc = {
    \   'description' : 'set fenc=...',
    \   'candidates'  : {},
    \   'map': function('UniteSourceMenuMenusMap'),
    \}
    for s:tmp in [
    \           'latin1',
    \           'cp932',
    \           'shift-jis',
    \           'iso-2022-jp',
    \           'euc-jp',
    \           'utf-8',
    \           'ucs-bom'
    \       ]
        call extend(g:unite_source_menu_menus.fenc.candidates,
        \           {s:tmp : 'set fenc='.s:tmp},
        \           'error')
    endfor
    unlet s:tmp

    nnoremap <silent> <SID>(prompt)s  :<C-u>Unite menu:fenc<CR>
    " }}}
    " set ff=... {{{
    let g:unite_source_menu_menus.ff = {
    \   'description' : 'set ff=...',
    \   'candidates'  : {},
    \   'map': function('UniteSourceMenuMenusMap'),
    \}
    for s:tmp in ['dos', 'unix', 'mac']
        call extend(g:unite_source_menu_menus.ff.candidates,
        \           {s:tmp : 'set ff='.s:tmp},
        \           'error')
    endfor
    unlet s:tmp

    nnoremap <silent> <SID>(prompt)d  :<C-u>Unite menu:ff<CR>
    " }}}

    " }}}



    autocmd vimrc FileType unite call s:unite_settings()

    let g:unite_winheight = 5    " default winheight.
    let g:unite_winwidth  = 10    " default winwidth.
    function! s:unite_settings() "{{{
        nmap <buffer> <Space><Space> <Plug>(unite_toggle_mark_current_candidate)

        imap <buffer> <C-n> <SID>(expand_unite_window)<Plug>(unite_select_next_line)
        imap <buffer> <C-p> <SID>(expand_unite_window)<Plug>(unite_select_previous_line)
    endfunction "}}}

    " Expand current unite window width/height 2/3
    imap <SID>(expand_unite_window) <Plug>(unite_insert_leave)<SID>(expand_unite_window_fn)<Plug>(unite_insert_enter)

    nnoremap <silent> <SID>(expand_unite_window_fn) :<C-u>call <SID>unite_resize_window(&columns / 3 * 2, &lines / 3 * 2)<CR>
    function! s:unite_resize_window(width, height)
        if winnr('$') is 1
            return
        elseif g:unite_enable_split_vertically
            execute 'vertical resize' a:width
        else
            execute 'resize' a:height
        endif

        imap <buffer> <C-n> <Plug>(unite_select_next_line)
        imap <buffer> <C-p> <Plug>(unite_select_previous_line)
    endfunction
endfunction
