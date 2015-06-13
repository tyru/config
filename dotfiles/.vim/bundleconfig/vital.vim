let s:config = BundleConfigGet()

function! s:config.config()
    if g:VIMRC.is_win
        let g:vitalizer#vital_dir = 'C:/config/dotfiles/dotfiles/.vim/bundle/vital.vim'
    endif
endfunction
