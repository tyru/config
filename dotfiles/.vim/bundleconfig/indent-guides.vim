let s:config = BundleConfigGet()

function! s:config.config()
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0
    autocmd vimrc VimEnter,ColorScheme * hi IndentGuidesOdd guibg=Gray
    autocmd vimrc VimEnter,ColorScheme * hi IndentGuidesEven guibg=White
    let g:indent_guides_color_change_percent = 30
endfunction
