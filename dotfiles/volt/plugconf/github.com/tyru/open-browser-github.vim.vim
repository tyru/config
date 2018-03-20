
function! s:config()
endfunction

function! s:loaded_on()
  return 'excmd=OpenGithubFile,OpenGithubIssue,OpenGithubPullReq,OpenGithubProject'
endfunction

function! s:depends()
  return ['github.com/tyru/open-browser.vim']
endfunction
