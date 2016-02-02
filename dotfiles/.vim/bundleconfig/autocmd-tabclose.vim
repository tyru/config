let s:config = vivo#bundleconfig#new()

function! s:config.config()
    " :tabprevious on vimrc-tabclose
    function! s:tabclose_post()
        if tabpagenr() != 1
            " XXX: Doing :tabprevious here cause Vim behavior strange
            " Decho ':tabprevious'
        endif
    endfunction
    autocmd vimrc User tabclose-post call s:tabclose_post()
endfunction
