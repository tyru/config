if exists("b:__C_WRAP_XPT_VIM__")
  finish
endif
let b:__C_WRAP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion
" XPTinclude 

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
XPTemplateDef
XPT ifproc_ hint=#if\ ..\ SEL\ #endif
#if `cond^0^
`wrapped^
`else...^#else
\`cursor\^^^
#endif
..XPT

XPT if_ hint=if\ (..)\ {\ SEL\ }
if (`condition^) {
  `wrapped^
}
..XPT

XPT invoke_ hint=..(\ SEL\ )
`name^(`wrapped^)
..XPT

