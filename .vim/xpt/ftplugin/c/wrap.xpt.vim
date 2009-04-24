
call XPTemplate('if_', [
      \ 'if (`condition^) {', 
      \ '  `wrapped^', 
      \ '}'
      \])

call XPTemplate('invoke_', [
      \ '`name^(`wrapped^)'
      \])


