let s:eskk = vivacious#bundleconfig#new()

function! s:eskk.config()
    augroup vimrc-eskk-vimenter
        autocmd!
        autocmd VimEnter *
        \   let &statusline .= '%( | %{exists("g:loaded_autoload_eskk") ? eskk#statusline("IM:%s", "IM:off") : ""}%)' |
        \   autocmd! vimrc-eskk-vimenter
    augroup END

    " skkdict
    let skk_user_dict = '~/.skkdict/user-dict'
    let skk_user_dict_encoding = 'utf-8'
    let skk_system_dict = '~/.skkdict/system-dict'
    let skk_system_dict_encoding = 'euc-jp'

    if !exists('g:eskk#dictionary')
        let g:eskk#dictionary = {
        \   'path': skk_user_dict,
        \   'encoding': skk_user_dict_encoding,
        \}
    endif
    if !exists('g:eskk#large_dictionary')
        let g:eskk#large_dictionary = {
        \   'path': skk_system_dict,
        \   'encoding': skk_system_dict_encoding,
        \}
    endif

    " let g:eskk#server = {
    " \   'host': 'localhost',
    " \   'port': 55100,
    " \}

    let g:eskk#log_cmdline_level = 2
    let g:eskk#log_file_level = 4

    if 1    " for debugging default behavior.
        let g:eskk#egg_like_newline = 1
        let g:eskk#egg_like_newline_completion = 1
        let g:eskk#show_candidates_count = 2
        let g:eskk#show_annotation = 1
        let g:eskk#rom_input_style = 'msime'
        let g:eskk#keep_state = 0
        let g:eskk#keep_state_beyond_buffer = 0
        " let g:eskk#marker_henkan = '$'
        " let g:eskk#marker_okuri = '*'
        " let g:eskk#marker_henkan_select = '@'
        " let g:eskk#marker_jisyo_touroku = '?'
        let g:eskk#dictionary_save_count = 5
        let g:eskk#start_completion_length = 1

        if has('vim_starting')
            augroup vimrc-eskk
                autocmd!
                autocmd User eskk-initialize-pre call s:eskk_initial_pre()
            augroup END
            function! s:eskk_initial_pre() "{{{
                " User can be allowed to modify
                " eskk global variables (`g:eskk#...`)
                " until `User eskk-initialize-pre` event.
                " So user can do something heavy process here.
                " (I'm a paranoia, eskk#table#new() is not so heavy.
                " But it loads autoload/vice.vim recursively)

                let hira = eskk#table#new('rom_to_hira*', 'rom_to_hira')
                let kata = eskk#table#new('rom_to_kata*', 'rom_to_kata')

                for t in [hira, kata]
                    call t.add_map('~', '～')
                    call t.add_map('vc', '©')
                    call t.add_map('vr', '®')
                    call t.add_map('vh', '☜')
                    call t.add_map('vj', '☟')
                    call t.add_map('vk', '☝')
                    call t.add_map('vl', '☞')
                    call t.add_map('z ', '　')
                    " Input hankaku characters.
                    call t.add_map('(', '(')
                    call t.add_map(')', ')')
                    " It is better to register the word "Exposé" than to register this map :)
                    call t.add_map('qe', 'é')
                    if g:eskk#rom_input_style ==# 'skk'
                        call t.add_map('zw', 'w', 'z')
                    endif
                endfor

                call hira.add_map('jva', 'ゔぁ')
                call hira.add_map('jvi', 'ゔぃ')
                call hira.add_map('jvu', 'ゔ')
                call hira.add_map('jve', 'ゔぇ')
                call hira.add_map('jvo', 'ゔぉ')
                call hira.add_map('wyi', 'ゐ', '')
                call hira.add_map('wye', 'ゑ', '')
                call hira.add_map('&', '＆', '')
                call eskk#register_mode_table('hira', hira)

                " call kata.add_map('jva', 'ヴァ')
                " call kata.add_map('jvi', 'ヴィ')
                " call kata.add_map('jvu', 'ヴ')
                " call kata.add_map('jve', 'ヴェ')
                " call kata.add_map('jvo', 'ヴォ')
                call kata.add_map('wyi', 'ヰ', '')
                call kata.add_map('wye', 'ヱ', '')
                call kata.add_map('&', '＆', '')
                call eskk#register_mode_table('kata', kata)
            endfunction "}}}
        endif

        " Debug
        command! -bar          EskkDumpBuftable PP! eskk#get_buftable().dump()
        command! -bar -nargs=1 EskkDumpTable    PP! eskk#table#<args>#load()
        " EskkMap lhs rhs
        " EskkMap -silent lhs2 rhs
        " EskkMap lhs2 foo
        " EskkMap -expr lhs3 {'foo': 'hoge'}.foo
        " EskkMap -noremap lhs4 rhs

        " by @_atton
        " Map -remap [icl] <C-j> <Plug>(eskk:enable)

        " by @hinagishi
        " VimrcAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
        " function! s:eskk_initial_pre() "{{{
        "     let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
        "     call t.add_map(',', ', ')
        "     call t.add_map('.', '.')
        "     call eskk#register_mode_table('hira', t)
        "     let t = eskk#table#new('rom_to_kata*', 'rom_to_kata')
        "     call t.add_map(',', ', ')
        "     call t.add_map('.', '.')
        "     call eskk#register_mode_table('kata', t)
        " endfunction "}}}

        " VimrcAutocmd User eskk-initialize-post call s:eskk_initial_post()
        function! s:eskk_initial_post() "{{{
            " Disable "qkatakana", but ";katakanaq" works.
            " NOTE: This makes some eskk tests fail!
            " EskkMap -type=mode:hira:toggle-kata <Nop>

            map! <C-j> <Plug>(eskk:enable)
            EskkMap <C-j> <Nop>

            EskkMap U <Plug>(eskk:undo-kakutei)

            EskkMap jj <Esc>
            EskkMap -force jj hoge
        endfunction "}}}

    endif
endfunction

function! s:eskk.recommends()
    return 'skkdict'
endfunction
