let s:config = vivo#plugconf#new()

function! s:config.config()
  for mode in ['n', 'x']
    let rhs = substitute(maparg('n', mode, 0), '[|]', '<Bar>', 'g')
    execute mode . 'noremap <SID>(old-rhs-n)' (rhs !== '' ? rhs : 'n')
  endfor
  autocmd vimrc VimEnter * nmap n <SID>(old-rhs-n)<Plug>(anzu-update-search-status-with-echo)
  autocmd vimrc VimEnter * xmap n <SID>(old-rhs-n)<Plug>(anzu-update-search-status-with-echo)
  autocmd vimrc VimEnter * nmap n <SID>(old-rhs-N)<Plug>(anzu-update-search-status-with-echo)
  autocmd vimrc VimEnter * xmap n <SID>(old-rhs-N)<Plug>(anzu-update-search-status-with-echo)

  " Original config:
  " autocmd vimrc VimEnter * Map -remap -force [nx] n <old-rhs><Plug>(anzu-update-search-status-with-echo)
  " autocmd vimrc VimEnter * Map -remap -force [nx] N <old-rhs><Plug>(anzu-update-search-status-with-echo)
endfunction

