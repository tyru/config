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
call XPTemplate("once", [
      \'if exists("b:`i^xptHeader()^")', 
      \'  finish', 
      \'endif',
      \'let b:`i^ = 1', 
      \'', 
      \])
call XPTemplate("xpt", [
      \'if exists("b:`i^xptHeader()^")', 
      \'  finish', 
      \'endif',
      \'let b:`i^ = 1', 
      \'', 
      \'" containers',
      \'let [s:f, s:v] = XPTcontainer()', 
      \'', 
      \'" constant definition',
      \"call extend(s:v, {'\\$TRUE': '1', '\\$FALSE' : '0', '\\$NULL' : 'NULL', '\\$UNDEFINED' : ''})", 
      \'', 
      \'" inclusion',
      \ 'XPTinclude ',
      \'', 
      \'" ========================= Function and Varaibles =============================', 
      \'', 
      \'', 
      \'" ================================= Snippets ===================================', 
      \'', 
      \])

call XPTemplate('container', [
      \'let [s:f, s:v] = XPTcontainer()', 
      \''
      \])

" repeatable part or defualt value must be escaped
call XPTemplate('tmpl', [
      \ "call XPTemplate('`name^', [", 
      \ "\\ `'^`text^`'^`...^,", 
      \ "\\ `'^`text^`'^`...^", 
      \ '\])'
      \])


call XPTemplate('tmpl_', [
      \ "call XPTemplate('`name^', [ '`wrapped^'])"
      \])

call XPTemplate('inc', [
      \ 'XPTinclude ',
      \ '      \ `^E("%:p:h:t")^/`name^`...^', 
      \ '      \ `^E("%:p:h:t")^/`name^`...^', 
      \])

