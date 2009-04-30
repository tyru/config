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
XPTemplateDef

XPT bench hint=
var t0 = new Date().getTime();
for (var i= 0; i < `times^; ++i){
  `do^
}
var t1 = new Date().getTime();
for (var i= 0; i < `times^; ++i){
  `do^
}
var t2 = new Date().getTime();
console.log(t1-t0, t2-t1);
..XPT

XPT asoe hint=assertObjectEquals
assertObjectEquals(`mess^
                  , `arr^
                  , `expr^);
..XPT

XPT fun hint=function\ ..(\ ..\ )\ {..}
function `name^ (`param^) {
  `cursor^
  return;
}
..XPT

XPT for hint=for\ (var..;..;++)
for (var `i^= 0; `i^ < `ar^.length; ++`i^){
  var `e^ = `ar^[`i^];
  `cursor^
}
..XPT

XPT forin hint=for\ (var\ ..\ in\ ..)\ {..}
for (var `i^ in `ar^){
  var `e^ = `ar^[`i^];
  `cursor^
}
..XPT

XPT if hint=if\ (..)\ {..}
if (`i^){
  `cursor^
}`else...^
else {
    `cursor^
}^^
..XPT

XPT try hint=try\ {..}\ catch\ {..}\ finally
try {
  `do^
}
catch (`err^) {
  `dealError^
}`...^
catch (`err^) {
  `dealError^
  }`...^`finally...^
finally {
  \`cursor\^
}^^
..XPT

XPT cmt hint=/**\ @auth...\ */
/**
* @author : `author^ | `email^
* @description
*     `cursor^
* @return {`Object^} `desc^
*/
..XPT

XPT cpr hint=@param
@param {`Object^} `name^ `desc^
..XPT

" file comment
" 4 back slash represent 1 after rendering.
XPT fcmt hint=full\ doxygen\ comment
/**-------------------------/// `sum^ \\\\\\---------------------------
 *
 * <b>`function^</b>
 * @version : `1.0^
 * @since : `date^
 * 
 * @description :
 *   `cursor^
 * @usage : 
 * 
 * @author : `$author^ | `$email^
 * @copyright : 
 * @TODO : 
 * 
 *--------------------------\\\\\ `sum^ ///---------------------------*/
..XPT

