if exists("b:___LOOPS_C_LIKE_XPT_VIM__")
  finish
endif
let b:___LOOPS_C_LIKE_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion

call XPTemplatePriority('like')

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
XPTemplateDef

XPT while0 hint=do\ {\ ..\ }\ while\ ($FALSE)
do `$BRACKETSTYLE^{
  `cursor^
} while (`$FALSE^)


XPT do hint=do\ {\ ..\ }\ while\ (..)
do `$BRACKETSTYLE^{
  `cursor^
} while (`condition^)


XPT while1 hint=while\ ($TRUE)\ {\ ..\ }
while (`$TRUE^) `$BRACKETSTYLE^{
  `cursor^
}


