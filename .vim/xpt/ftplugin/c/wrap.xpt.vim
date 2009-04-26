if exists("b:__WRAP_XPT_VIM__")
  finish
endif
let b:__WRAP_XPT_VIM__ = 1

call XPTemplate('ifproc_', [
            \ '#if `cond^0^',
            \ '`wrapped^`...^',
            \ '#else',
            \ '`cursor^`...^',
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


