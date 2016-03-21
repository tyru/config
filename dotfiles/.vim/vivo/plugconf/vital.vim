let s:config = vivo#plugconf#new()

function! s:config.config()
    if has('win16') || has('win32') || has('win64') || has('win95')
        let g:vitalizer#vital_dir = 'C:/config/dotfiles/dotfiles/.vim/bundle/vital.vim'
    endif
endfunction
