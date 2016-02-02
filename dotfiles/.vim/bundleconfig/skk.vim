let s:skk = vivo#bundleconfig#new()

function! s:skk.config()
    augroup vimrc-skk
        autocmd!
        autocmd VimEnter *
        \   let &statusline .= '%( | %{exists("g:skk_loaded") ? SkkGetModeStr() : ""}%)' |
        \   autocmd! vimrc-skk
    augroup END

    " skkdict
    let skk_user_dict = '~/.skkdict/user-dict'
    let skk_user_dict_encoding = 'utf-8'
    let skk_system_dict = '~/.skkdict/system-dict'
    let skk_system_dict_encoding = 'euc-jp'

    let skk_jisyo = skk_user_dict
    let skk_jisyo_encoding = skk_user_dict_encoding
    let skk_large_jisyo = skk_system_dict
    let skk_large_jisyo_encoding = skk_system_dict_encoding

    " let skk_control_j_key = ''
    " Map -remap [lic] <C-j> <Plug>(skk-enable-im)

    let skk_manual_save_jisyo_keys = ''

    let skk_egg_like_newline = 1
    let skk_auto_save_jisyo = 1
    let skk_imdisable_state = -1
    let skk_keep_state = 0
    let skk_show_candidates_count = 2
    let skk_show_annotation = 0
    let skk_sticky_key = ';'
    let skk_use_color_cursor = 1
    let skk_remap_lang_mode = 0


    if 0
        " g:skk_enable_hook test {{{
        " Do not map `<Plug>(skk-toggle-im)`.
        let skk_control_j_key = ''

        " `<C-j><C-e>` to enable, `<C-j><C-d>` to disable.
        Map -remap [ic] <C-j><C-e> <Plug>(skk-enable-im)
        Map -remap [ic] <C-j><C-d> <Nop>
        function! MySkkMap()
            lunmap <buffer> <C-j>
            lmap <buffer> <C-j><C-d> <Plug>(skk-disable-im)
        endfunction
        function! HelloWorld()
            echomsg 'Hello.'
        endfunction
        function! Hogera()
            echomsg 'hogera'
        endfunction
        let skk_enable_hook = 'MySkkMap,HelloWorld,Hogera'
        " }}}
    endif
endfunction

function! s:skk.recommends()
    return 'skkdict'
endfunction
