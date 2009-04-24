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

