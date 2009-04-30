if exists("b:___LOOPS_C_LIKE_XPT_VIM__")
  finish
endif
let b:___LOOPS_C_LIKE_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion

call XPTemplatePriority('like')

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
XPTemplateDef
XPT while0 hint=do\ {\ ..\ }\ while\ (..)
do {\n
  `cursor^\n
} while (`$FALSE^)
..XPT

XPT do hint=do\ {\ ..\ }\ while\ (..)
do {\n
  `cursor^\n
} while (`$FALSE^)
..XPT

XPT while1 hint=while\ (..)\ {\ ..\ }
while (`$TRUE^) {
  `cursor^
}
..XPT

XPT for hint=for\ (..;..;++)
for (`i^ = `0^; `i^ < `len^; ++`i^){\n
  `cursor^\n
}
..XPT

XPT forr hint=for\ (..;..;--)
for (`i^ = `n^; `i^ >`^=^ `end^; --`i^){\n
  `cursor^\n
}
..XPT

XPT forever hint=for\ (;;)\ ..
for (;;) `_^/* void */;^
..XPT

