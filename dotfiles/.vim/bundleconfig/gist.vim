let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    let g:gist_detect_filetype = 1
    let g:gist_open_browser_after_post = 1
    let g:gist_browser_command = ":OpenBrowser %URL%"
    let g:gist_update_on_write = 2
endfunction
