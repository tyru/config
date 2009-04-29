if exists("b:__C_WRAP_XPT_VIM__")
  finish
endif
let b:__C_WRAP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion
" XPTinclude 

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
call XPTemplate('ifproc_', [
            \ '#if `cond^0^',
            \ '`wrapped^',
            \ '`else...^#else',
            \ '\`cursor\^^^',
            \ '#endif'
            \])

call XPTemplate('if_', [
      \ 'if (`condition^) {', 
      \ '  `wrapped^', 
      \ '}'
      \])

call XPTemplate('invoke_', [
      \ '`name^(`wrapped^)'
      \])


