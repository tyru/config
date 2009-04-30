if exists("b:__XPT_XPT_XPT_VIM__")
  finish
endif
let b:__XPT_XPT_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : '', '\$UNDEFINED' : ''})
" call XPTemplatePriority('sub')

" inclusion

" ========================= Function and Varaibles =============================
fun! s:f.xptHeader() "{{{
  let symbol = expand("%:p")
  let symbol = matchstr(symbol, '/ftplugin/\zs.*')
  let symbol = substitute(symbol, '/', '_', 'g')
  let symbol = substitute(symbol, '\.', '_', 'g')
  let symbol = substitute(symbol, '.', '\u&', 'g')
  
  return '__'.symbol.'__'
endfunction "}}}

" ================================= Snippets ===================================
XPTemplateDef

" repeatable part or defualt value must be escaped
XPT tmpl hint=call\ XPTemplate(\ ...
call XPTemplate('`name^', [
\ `'^`text^`'^`...^,
\ `'^`text^`'^`...^
\])'
..XPT

XPT tmpl_ hint=call\ XPTemplate(\ ..,\ SEL\ ...
call XPTemplate('`name^', [ '`wrapped^'])
..XPT

XPT inc hint=XPTinclude\ ...
XPTinclude 
      \ `^E("%:p:h:t")^/`name^`...^
      \ `^E("%:p:h:t")^/`name^`...^
..XPT

XPT once hint=if\ exists\ finish\ let\ b...
if exists("b:`i^xptHeader()^")
    finish
endif
let b:`i^ = 1
..XPT

XPT container hint=let\ [s:f,\ s:v]\ =...
let [s:f, s:v] = XPTcontainer()
..XPT

call XPTemplate("xpt", [
XPT xpt hint=start\ template\ to\ write\ template
if exists("b:`i^xptHeader()^") 
  finish 
endif
let b:`i^ = 1 
 
" containers
let [s:f, s:v] = XPTcontainer() 
 
" constant definition
call extend(s:v, {'\\$TRUE': '1 '\\$FALSE' : '0', '\\$NULL' : 'NULL', '\\$UNDEFINED' : ''})", 
 
" inclusion
'XPTinclude 
 
" ========================= Function and Varaibles ============================= 
 
 
" ================================= Snippets =================================== 
 
..XPT
