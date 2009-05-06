if exists("b:__PREPROCESSOR_C_LIKE_XPT_VIM__") 
    finish 
endif
let b:__PREPROCESSOR_C_LIKE_XPT_VIM__ = 1 

" containers
let [s:f, s:v] = XPTcontainer() 

" inclusion

XPTemplateDef

XPT inc		hint=include\ <>
include <`^.h>


XPT ind		hint=include\ ""
include "`_^fileRoot()^.h"


XPT once	hint=#ifndef\ ..\ #define\ ..
#ifndef `symbol^headerSymbol()^
#define `symbol^
`cursor^
#endif /* `symbol^ */


XPT ifndef	hint=#ifndef\ ..
ifndef `_^SV('.','\u&')^^ 
#    define `_^ 

`cursor^ 
#endif /* `_^ */


