function! s:config()
  let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']

  " g:nf_loop_hook_fn only works when g:nf_loop_files is true.
  let g:nf_loop_files = 1
  " Call this function when wrap around.
  " let g:nf_loop_hook_fn = 'NFLoopPrompt'
  let g:nf_loop_hook_fn = 'NFLoopMsg'
  " To avoid |hit-enter| for NFLoopMsg().
  let g:nf_open_command = 'silent edit'
endfunction

function! NFLoopMsg(file_to_open)
  redraw
  echohl WarningMsg
  echomsg 'open a file from the start...'
  echohl None
  " Always open a next/previous file...
  return 1
endfunction

function! NFLoopPrompt(file_to_open)
  return input('open a file from the start? [y/n]:') =~? 'y\%[es]'
endfunction
