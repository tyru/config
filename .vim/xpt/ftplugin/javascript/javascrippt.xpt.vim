if exists("b:__JAVASCRIPT_JAVASCRIPPT_XPT_VIM__")
  finish
endif
let b:__JAVASCRIPT_JAVASCRIPPT_XPT_VIM__ = 1



" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'$TRUE': 'true', '$FALSE' : 'false', '$NULL' : 'null', '$UNDEFINED' : 'undefined'})

" inclusion
XPTinclude
      \ _common/common
      \ _condition/ecma
      \ _comment/c.like
      \ _condition/c.like


" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate("bench", "
      \var t0 = new Date().getTime();\n
      \for (var i= 0; i < `times^; ++i){\n
      \  `do^\n
      \}\n
      \var t1 = new Date().getTime();\n
      \for (var i= 0; i < `times^; ++i){\n
      \  `do^\n
      \}\n
      \var t2 = new Date().getTime();\n
      \console.log(t1-t0, t2-t1);")

call XPTemplate("asoe", "
      \assertObjectEquals(`mess^,\n
      \`arr^, \n
      \`expr^);")

call XPTemplate("fun", "
      \function `name^ (`param^) {\n
      \  `cursor^\n
      \  return;\n
      \}")

call XPTemplate("for", "
      \for (var `i^= 0; `i^ < `ar^.length; ++`i^){\n
      \  var `e^ = `ar^[`i^];\n
      \  `cursor^\n
      \}")

call XPTemplate("forin", "
      \for (var `i^ in `ar^){\n
      \  var `e^ = `ar^[`i^];\n
      \  `cursor^\n
      \}")

call XPTemplate("if", "
      \if (`i^){\n
      \  `cursor^\n
      \}")

call XPTemplate("ife", "
      \if (`i^){\n
      \  `cursor^\n
      \} else {\n
      \}")

call XPTemplate("try", "
      \try {\n
      \  `do^\n
      \} catch (`err^) {\n
      \  `dealError^\n
      \} finally {\n
      \  `cursor^\n
      \}")

call XPTemplate("cmt", "
      \/**\n
      \* @author : `author^ | `email^\n
      \* @description\n
      \*     `cursor^\n
      \* @return {`Object^} `desc^\n
      \*/")

call XPTemplate("cpr", "
      \@param {`Object^} `name^ `desc^")

" file comment
" 4 back slash represent 1 after rendering.
call XPTemplate("fcmt", "
  \/**-------------------------/// `sum^ \\\\\\---------------------------\n
  \ *\n
  \ * <b>`function^</b>\n
  \ * @version : `1.0^\n
  \ * @since : `date^\n
  \ * \n
  \ * @description :\n
  \ *   `cursor^\n
  \ * @usage : \n
  \ * \n
  \ * @author : `$author^ | `$email^\n
  \ * @copyright : \n
  \ * @TODO : \n
  \ * \n
  \ *--------------------------\\\\\\ `sum^ ///---------------------------*/")





