if exists("b:__XPT_XPT_VIM__")
  finish
endif
let b:__XPT_XPT_VIM__ = 1


call XPTemplate('container', [
      \'let s:f = g:XPTfuncs()', 
      \'let s:v = g:XPTvars()', 
      \'`cursor^'
      \])

" repeatable part or defualt value must be escaped
call XPTemplate('tmpl', [
      \ "call XPTemplate('`name^', [", 
      \ "\\ `'^`text^`'^`...^,", 
      \ '\\'." `'^`text^`'^`...^", 
      \ '\])'
      \])


call XPTemplate('tmpl_', [
      \ "call XPTemplate('`name^', [ '`wrapped^'])"
      \])

call XPTemplate('inc', [
      \ 'runtime ftplugin/`_common^/`name^.xpt.vim', 
      \])

