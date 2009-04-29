if exists("b:__C_C_XPT_VIM__")
  finish
endif
let b:__C_C_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})
" call XPTemplateIndent("/2*8")

" inclusion
XPTinclude
      \ _common/common 
      \ _comment/c.like 
      \ _condition/c.like
      \ _loops/c.like



" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

" " sample:
" XPT for indent=/2*8 priority=sub hint=this\ is\ for
" for (`i^ = 0; `i^ < `len^; ++`i^) {
"   `cursor^
" }
" ..XPT


XPT inc		hint=include\ <>
include <`^.h>
..XPT


XPT ind		hint=include\ ""
include "`_^fileRoot()^.h"
..XPT


XPT assert	hint=
assert(`isTrue^, "`text^");
..XPT


XPT once
#ifndef `symbol^headerSymbol()^
#define `symbol^
`cursor^
#endif /* `symbol^ */
..XPT


" Just Another Implementation
" XPT once
" #ifndef `symbol^__{S(S(E("%:t"),".","\\u&"),"\\.","_")}__^
" #define `symbol^
" `cursor^
" #endif /* `symbol^ */
" ..XPT


XPT main
  int
main(int argv, char **args)
{
  `cursor^
  return 0;
}
..XPT


XPT fun
  `int^
`name^(`_^)
{
  `cursor^
}
..XPT


XPT ifndef
ifndef `_^SV('.','\u&')^^ 
#    define `_^ 

`cursor^ 
#endif /* `_^ */
..XPT


XPT cmt
/**
 * @author : `$author^ | `$email^
 * @description
 *     `cursor^
 * @return {`int^} `desc^
 */
..XPT


XPT para syn=comment	hint=comment\ parameter
@param {`Object^} `name^ `desc^
..XPT


XPT filehead
/**-------------------------/// `sum^ \\\---------------------------
 *
 * <b>`function^</b>
 * @version : `1.0^
 * @since : `strftime("%Y %b %d")^
 * 
 * @description :
 *   `cursor^
 * @usage : 
 * 
 * @author : `$author^ | `$email^
 * @copyright `.com.cn^ 
 * @TODO : 
 * 
 *--------------------------\\\ `sum^ ///---------------------------*/

..XPT
