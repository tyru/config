if exists("b:___CONDITION_ECMA_XPT_VIM__")
  finish
endif
let b:___CONDITION_ECMA_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'$TRUE': 'true', '$FALSE' : 'false', '$NULL' : 'null', '$UNDEFINED' : 'undefined'})

" inclusion
XPTinclude
      \ _condition/c.like

call XPTemplatePriority('spec')

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
call XPTemplate('ifu', [
      \ 'if (`$UNDEFINED^ === `var^) {',
      \ '  `_^',
      \ '}', 
      \ '`else...^else {', 
      \ '  \`cursor\^', 
      \ '}^^'
      \])

call XPTemplate('ifnu', [
      \ 'if (`$UNDEFINED^ !== `var^) {',
      \ '  `_^',
      \ '}', 
      \ '`else...^else {', 
      \ '  \`cursor\^', 
      \ '}^^'
      \])



