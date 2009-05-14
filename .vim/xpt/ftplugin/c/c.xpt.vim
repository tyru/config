if exists("b:__C_C_XPT_VIM__")
  finish
endif
let b:__C_C_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$INDENT_HELPER' : '/* void */;'})

" inclusion
XPTinclude
      \ _common/common 
      \ _comment/c.like 
      \ _condition/c.like
      \ _loops/c.like
      \ _structures/c.like
      \ _preprocessor/c.like

" ========================= Function and Varaibles =============================

function! s:f.showLst()
   call complete( col('.'), [ "xx-small", "x-small", "small", "medium", "large", "x-large", "xx-large", "larger", "smaller" ] )
endfunction

fun! s:f.expandIfNotEmpty(sep, item)
  let v = self.V()
  
  let t = v == '' ? '' : v . '`' . a:sep . '`' . a:item . '^'

  return t
endfunction
" ================================= Snippets ===================================
XPTemplateDef


" XPT fs
" font-size: `size^showLst()^

" " sample:
" XPT for indent=/2*8 hint=this\ is\ for
" for (`i^ = 0; `i^ < `len^; ++`i^) {
"   `cursor^
" }


" JUST A TEST
"
" Super Repetition. saves 1 key pressing. without needing expanding repetition
" For small repetition usage. Such as parameter list
" 
"   type first, then <tab>
" NOT <tab> then type
"
" NOTE that "exp" followed by only 2 dot. distinction from expandable
"
XPT superrepetition
XSET exp..|post=expandIfNotEmpty(', ', 'exp..')
`exp..^




XPT assert	hint=assert\ (..,\ msg)
assert(`isTrue^, "`text^");

XPT main hint=main\ (argc,\ argv)
  int
main(int argc, char **argv)
{
  `cursor^
  return 0;
}


XPT fun=..\ ..\ (..)
  `int^
`name^(`_^)
{
  `cursor^
}

XPT cmt
/**
 * @author : `$author^ | `$email^
 * @description
 *     `cursor^
 * @return {`int^} `desc^
 */


XPT para syn=comment	hint=comment\ parameter
@param {`Object^} `name^ `desc^


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

