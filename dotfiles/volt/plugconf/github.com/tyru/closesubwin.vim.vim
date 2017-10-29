
function! s:config()
    nmap <Plug>(vimrc:prefix:excmd)ch <Plug>(closesubwin-close-help)
    nmap <Plug>(vimrc:prefix:excmd)cq <Plug>(closesubwin-close-quickfix)
    nmap <Plug>(vimrc:prefix:excmd)cu <Plug>(closesubwin-close-unlisted)
    " Close first matching window in above windows.
    nmap <Plug>(vimrc:prefix:excmd)cc <Plug>(closesubwin-close-sub)
endfunction
