if exists("g:__XPTEMPLATE_CONF_VIM__")
  finish
endif
let g:__XPTEMPLATE_CONF_VIM__ = 1






fun! s:Def(k, v) "{{{
  if !exists(a:k)
    let cmd = "let ".a:k."="
    if type(a:v) == type("")
      let cmd = cmd . '"' .a:v. '"'
    elseif type(a:v) == type(1)
      let cmd = cmd . a:v
    else
      echoerr a:k." set with illegal value :".a:v
      return
    endif
    exe cmd
  endif
endfunction "}}}

call s:Def('g:xptemplate_strip_left', 1)
call s:Def('g:xptemplate_limit_curosr', 1)
call s:Def('g:xptemplate_show_stack', 1)
call s:Def('g:xptemplate_highlight', 1)
" call s:Def('g:xptemplate_indent', 1)

call s:Def('g:xptemplate_key', '<C-\\>')
call s:Def('g:xptemplate_to_right', "<C-l>")

call s:Def('g:xptemplate_fix', 1)



"for high light current editing item
hi CurrentItem ctermbg=green gui=none guifg=#d59619 guibg=#efdfc1
hi IgnoredMark cterm=none term=none ctermbg=black ctermfg=darkgrey gui=none guifg=#dddddd guibg=white


" TODO Be very careful with 'cpo' option!
"
let oldcpo = &cpo
set cpo-=<
exe "inoremap ".g:xptemplate_key." <C-r>=XPTemplateStart(0)<cr>"
exe "xnoremap ".g:xptemplate_key." \"0di<C-r>=XPTemplatePreWrap(@0)<cr>"
let &cpo = oldcpo


" checks critical setting:
"
" backspace	>2 or with start
" nocompatible
" selection 	inclusive
" selectmode 	"" without v

let bs=&bs

if bs != 2 && bs !~ "start" 
  if g:xptemplate_fix 
    set bs=2
  else
    echom "'backspace' option must be set with 'start'. set bs=2 or let g:xptemplate_fix=1 to fix it"
  endif
endif

if &compatible == 1 
  if g:xptemplate_fix 
    set nocompatible
  else
    echom "'compatible' option must be set. set compatible or let g:xptemplate_fix=1 to fix it"
  endif
endif
