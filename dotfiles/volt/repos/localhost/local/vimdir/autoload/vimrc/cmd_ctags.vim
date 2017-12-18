
function! vimrc#cmd_ctags#call(q_args)
  if !executable('ctags')
    echohl ErrorMsg
    echomsg "Ctags: No 'ctags' command in PATH"
    echohl None
    return
  endif
  if a:q_args !=# ''
    execute '!ctags' a:q_args
  else
    execute '!ctags' (filereadable('.ctags') ? '' : '-R')
  endif
endfunction
