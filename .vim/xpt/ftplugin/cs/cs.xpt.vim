if exists('b:__CS_XPT_VIM__')
  finish
endif
let b:__CS_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude 
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loop/java.like
      \ c/wrap

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================

call XPTemplate( 'foreach', [
       \'foreach ( `var^var^ `e^ in `what^ )',
       \'{',
       \'    `cursor^',
       \'}'
       \])

call XPTemplate( 'class', [
    \ 'class `className^',
    \ '{',
    \ '    public `className^( `ctorParam^^ )',
    \ '    {',
    \ '        `cursor^',
    \ '    }',
    \ '}'
    \ ])

call XPTemplate( 'main', [
    \ 'public static void Main( string[] args )',
    \ '{',
    \ '    `cursor^',
    \ '}'
    \ ])

call XPTemplate( 'prop', [
    \ 'public `type^ `Name^',
    \ '{',
    \ '    `get...^get { return \`what\^; }^^',
    \ '    `set...^set { \`what\^ = value; }^^',
    \ '}'
    \ ])

call XPTemplate( 'namespace', [
               \ 'namespace `name^',
               \ '{',
               \ '    `cursor^',
               \ '}',
               \ '' ])

call XPTemplate('try', [
            \ 'try',
            \ '{',
            \ '    `what^',
            \ '}`...^',
            \ 'catch (`except^ e)',
            \ '{',
            \ '    `handler^',
            \ '}`...^',
            \ '`catch...^catch',
            \ '{',
            \ '    \`\^',
            \ '}^^',
            \ '`finally...^finally',
            \ '{',
            \ '    \`cursor\^',
            \ '}^^',
            \ ''
            \])

