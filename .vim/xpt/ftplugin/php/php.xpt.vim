if exists("b:__PHP_XPT_VIM__")
    finish
endif
let b:__PHP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _condition/c.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
" Based on snipmate's php templates
call XPTemplate('while', [
            \ 'while (`cond^)',
            \ '{',
            \ '    `body^',
            \ '}'
            \])

call XPTemplate( 'for', [
            \ 'for ($`var^i^ = `init^; $`var^ < `val^; $`var^++)',
            \ '{',
            \ '    `cursor^',
            \ '}',
            \ ''])


call XPTemplate( 'forr', [
            \ 'for ($`var^i^ = `init^; $`var^ >= `val^0^; $`var^--)',
            \ '{',
            \ '    `cursor^',
            \ '}',
            \ ''])

call XPTemplate('foreach', [
            \ 'foreach ($`var^ as `container^)',
            \ '{',
            \ '    `body^',
            \ '}'
            \])

call XPTemplate( 'fun', [
        \ 'function `funName^( `params^ )',
        \ '{',
        \ '   `cursor^',
        \ '}',
        \ '' ])

call XPTemplate('class', [
            \ 'class `className^',
            \ '{',
            \ '    function __construct( `args^ )',
            \ '    {',
            \ '        `cursor^',
            \ '    }',
            \ '}',
            \ ''
            \])

call XPTemplate('interface', [
            \ 'interface `interfaceName^',
            \ '{',
            \ '    `cursor^',
            \ '}'
            \])

