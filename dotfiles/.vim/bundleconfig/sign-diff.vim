
" let g:SD_debug = 1
let g:SD_disable = 0

if !g:SD_disable && maparg('<C-l>', 'n', 0) ==# ''
    Map -silent [n] <C-l> :SDUpdate<CR><C-l>
endif
