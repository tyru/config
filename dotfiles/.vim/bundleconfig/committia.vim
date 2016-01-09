let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    autocmd vimrc BufNew __committia_diff__ setl foldopen
endfunction
