let s:config = vivo#plugconf#new()

function! s:config.disable_if()
  return !has('signs') || !has('diff')
  \   || (!exists('*mkdir') && !executable('mkdir'))
  \   || !executable('diff')
endfunction

function! s:config.config()
  " let g:SD_debug = 1
  " let g:SD_disable = 1

  if !g:SD_disable && maparg('<C-l>', 'n', 0) ==# ''
    nnoremap <silent> <C-l> :<C-u>SDUpdate<CR><C-l>
  endif
endfunction
