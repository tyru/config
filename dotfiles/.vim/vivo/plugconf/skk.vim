let s:skk = vivo#plugconf#new()

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

    let g:skk_jisyo = g:skk_user_dict
    let g:skk_jisyo_encoding = g:skk_user_dict_encoding
    let g:skk_large_jisyo = g:skk_system_dict
    let g:skk_large_jisyo_encoding = g:skk_system_dict_encoding
endfunction

function! s:skk.recommends()
    return 'skkdict'
endfunction
