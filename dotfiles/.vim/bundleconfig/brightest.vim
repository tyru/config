
let g:brightest_on_cursor_hold = 1
let g:brightest#highlight = {
\   "group"    : "VimrcBrightest",
\}
autocmd vimrc VimEnter highlight VimrcBrightest term=standout,underline ctermfg=1 guifg=salmon cterm=underline gui=underline

let g:brightest#pattern = '\k\+'

" https://github.com/osyo-manga/vim-brightest/pull/3
"
" runtime! plugin/brightest.vim
" BrightestDisable
" augroup vimrc-brightest
"     autocmd!
"     autocmd CursorHold * BrightestEnable | BrightestHighlight | BrightestDisable
" augroup END

let g:brightest#enable_filetypes = {
\   '_': 0,
\   'c': 1,
\   'cpp': 1,
\   'css': 1,
\   'go': 1,
\   'html': 1,
\   'javascript': 1,
\   'vim': 1,
\}
