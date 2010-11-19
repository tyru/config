
if has('gui_running')
    set background=dark
    " runtime! colors/desert.vim
    runtime! colors/slate.vim
else
    set background=dark
    runtime! colors/koehler.vim
endif

hi CursorLine term=reverse
