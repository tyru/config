
function! vimrc#cmd_synnames#call() abort
  for id in synstack(line("."), col("."))
    echo printf('%s (%s)', synIDattr(id, "name"), synIDattr(synIDtrans(id), "name"))
  endfor
endfunction
