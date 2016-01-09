let s:skk = vivacious#bundleconfig#new()

function! s:skk.config()
    augroup vimrc-skk
        autocmd!
        autocmd VimEnter *
        \   let &statusline .= '%( | %{exists("g:skk_loaded") ? SkkGetModeStr() : ""}%)' |
        \   autocmd! vimrc-skk
    augroup END
endfunction

function! s:skk.recommends()
    return 'skkdict'
endfunction
