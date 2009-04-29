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
call XPTemplate("while0", ""
      \."do {\n"
      \."  `cursor^\n"
      \."} while (`$FALSE^)")

call XPTemplate("do", ""
      \."do {\n"
      \."  `cursor^\n"
      \."} while (`$FALSE^)")

call XPTemplate("while1", [
      \'while (`$TRUE^) {', 
      \'  `cursor^',
      \'}'
      \])

call XPTemplate("for", ""
      \."for (`i^ = `0^; `i^ < `len^; ++`i^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("forr", ""
      \."for (`i^ = `n^; `i^ >`^=^ `end^; --`i^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate('forever', [
      \ 'for (;;) `_^/* void */;^'
      \])
