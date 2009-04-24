if exists("b:__CMT_XPT_VIM__")
  finish
endif
let b:__CMT_XPT_VIM__ = 1



call XPTemplateMark('`', '^')

" comment
call XPTemplate('cc', [ '/* `^ */' ])

call XPTemplate('cc_', [ '/* `wrapped^ */' ])

" line comment
call XPTemplate('cl', [ '// `cursor^' ])

" block comment
call XPTemplate('cb', [
      \'/*', 
      \' * `cursor^', 
      \' */' ])

" block doc comment
call XPTemplate('cd', [
      \'/**', 
      \' * `cursor^', 
      \' */' ])
