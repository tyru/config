
function! vimrc#cmd_git_grep#call(args, local) abort
  setlocal grepprg=git\ grep\ -I\ --line-number
  try
    execute (a:local ? 'l' : '') . 'grep' a:args
  finally
    setlocal grepprg<
  endtry
endfunction
