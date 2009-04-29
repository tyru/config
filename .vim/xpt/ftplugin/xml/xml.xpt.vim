if exists("b:__XML_XPT_VIM__")
    finish
endif
let b:__XML_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate( 't', [
            \ '<`tag^`...^ `name^="`val^"`...^>',
            \ '    `cursor^',
            \ '</`tag^>',
            \ ])

call XPTemplate( 'ver', '<?xml version="`ver^1.0^" encoding="`enc^utf-8^" ?>' )
call XPTemplate( 'style', '<?xml-stylesheet type="`style^text/css^" href="`from^">' )

call XPTemplate('CDATA_', [
            \ '<![CDATA[',
            \ '`cursor^',
            \ ']]>'
            \])

