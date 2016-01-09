let s:eskk = vivacious#bundleconfig#new()

function! s:eskk.config()
    augroup vimrc-eskk
        autocmd!
        autocmd VimEnter *
        \   let &statusline .= '%( | %{exists("g:loaded_autoload_eskk") ? eskk#statusline("IM:%s", "IM:off") : ""}%)' |
        \   autocmd! vimrc-eskk
    augroup END
endfunction

function! s:eskk.recommends()
    return 'skkdict'
endfunction
