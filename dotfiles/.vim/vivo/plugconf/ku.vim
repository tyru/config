let s:config = vivo#plugconf#new()

function! s:config.config()
  nnoremap s <SID>(anything)
  nnoremap <SID>(anything) <Nop>

  nmap <SID>(anything)f :<C-u>Ku file<CR>
  nmap <SID>(anything)h :<C-u>Ku file/mru<CR>
  nmap <SID>(anything)H :<C-u>Ku history<CR>
  nmap <SID>(anything): :<C-u>Ku cmd_mru/cmd<CR>
  nmap <SID>(anything)/ :<C-u>Ku cmd_mru/search<CR>

  MapAlterCommand ku Ku
endfunction
