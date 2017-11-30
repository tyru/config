
function! s:config()
  " let g:openbrowser_github_always_used_branch = 'master'
  let g:openbrowser_github_always_use_commit_hash = 1
endfunction

function! s:depends()
  return ['github.com/tyru/open-browser.vim']
endfunction
