let s:config = BundleConfigGet()

function! s:config.config()
    let g:netrw_nogx = 1
    Map -remap [nx] gx <Plug>(openbrowser-smart-search)
    Map -remap [nx] goo <Plug>(openbrowser-open)
    Map -remap [nx] gos <Plug>(openbrowser-search)
    MapAlterCommand o[pen] OpenBrowserSmartSearch
    " MapAlterCommand alc OpenBrowserSmartSearch -alc

    " let g:openbrowser_open_filepath_in_vim = 0
    if $VIMRC_USE_VIMPROC !=# 2
        let g:openbrowser_use_vimproc = $VIMRC_USE_VIMPROC
    endif
    " let g:openbrowser_force_foreground_after_open = 1

    command! OpenBrowserCurrent execute "OpenBrowser" "file:///" . expand('%:p:gs?\\?/?')
endfunction
