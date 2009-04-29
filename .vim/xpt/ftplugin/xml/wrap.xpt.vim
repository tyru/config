if exists("b:__XML_WRAP_XPT_VIM__")
    finish
endif
let b:__XML_WRAP_XPT_VIM__= 1


call XPTemplate( '_', [
        \ '<`tag^`...^ `name^="`val^"`...^>',
        \ '    `wrapped^',
        \ '</`tag^>'
        \ ])

call XPTemplate('CDATA_', [
            \ '<![CDATA[',
            \ '`wrapped^',
            \ ']]>'
            \])

