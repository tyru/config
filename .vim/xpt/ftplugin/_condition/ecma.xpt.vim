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
XPTemplateDef
XPT ifu hint=if\ (undefined\ ===\ ...)\ {...}...
if (`$UNDEFINED^ === `var^) {
  `_^
}
`else...^else {
  \`cursor\^
}^^
..XPT

XPT ifnu hint=if\ (undefined\ !==\ ...)\ {...}...
if (`$UNDEFINED^ !== `var^) {
  `_^
}
`else...^else {
  \`cursor\^
}^^
..XPT

