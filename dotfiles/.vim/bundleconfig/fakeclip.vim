
" vim-fakeclip plugin is loaded only on the platform where
" 1. the X server exists
" 2. starting Vim of non-GUI version
set clipboard+=exclude:.*
let g:fakeclip_always_provide_clipboard_mappings = 1
