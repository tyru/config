if exists("b:__VIM_VIM_XPT_VIM__")
  finish
endif
let b:__VIM_VIM_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion
XPTinclude 
      \ _common/common

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
call XPTemplate('vimformat', [ 'vim:tw=78:ts=8:sw=2:sts=2:et:norl:fdm=marker:fmr={{{,}}}' ])

XPTemplateDef

call XPTemplate("once", [
XPT once hint=if\ exists..\ finish\ ..\ let
if exists("`g^:`i^headerSymbol()^")
  finish
endif
let `g^:`i^ = 1
`cursor^
..XPT

XPT log hint=call\ log\ on\ selection
call Log(`_^)
..XPT

XPT fun hint=fun!\ ..(..)\ ..\ endfunction
fun! `name^(`_^^) \"{{{
  `cursor^
endfunction \"}}}
..XPT

XPT method hint=fun!\ Dict.name\ ...\ endfunction
fun! `Dict^.`name^(`_^^)
  `cursor^
endfunction
..XPT

XPT while hint=while\ ..\ ..\ endwhile
while `cond^
  `cursor^
endwhile
..XPT

XPT while1 hint=while\ 1\ ..\ endwhile
while 1
  `cursor^
endwhile
..XPT

XPT fordic hint=for\ [..,..]\ in\ ..\ ..\ endfor
for [`k^, `v^] in items(`dic^)
  `cursor^
endfor
..XPT

XPT forin hint=for\ ..\ in\ ..\ ..\ endfor
for `v^ in `list^
  `cursor^
endfor
..XPT

XPT try hint=try\ ..\ catch\ ..\ finally...
try
  `^
catch /`^/
  `^
`finally...^finally
  \`cursor\^^^
endtry

..XPT

XPT if hint=if\ ..\ else\ ..
if `cond^
  `_^
`else...^else
  \`cursor\^^^
endif 
..XPT

XPT str_ hint=transform\ SEL\ to\ string
string(`wrapped^)
..XPT

