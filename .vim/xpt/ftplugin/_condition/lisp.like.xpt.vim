if exists("b:___CONDITION_C_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_C_LIKE_XPT_VIM__ = 1

call XPTemplatePriority('like')

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate( "if", [
    \ '(if [`condition^]',
    \ '    (`then^)',
    \ '    `else...^\(\`cursor\^\)^^)',   
    \ '' ])

call XPTemplate( 'when', [
    \ '(when (`cond^)',
    \ '   (`todo0^) `...^',
    \ '   (`todon^)`...^)',
    \ '' ])


call XPTemplate( 'unless', [
    \ '(unless (`cond^)',
    \ '   (`todo0^) `...^',
    \ '   (`todon^)`...^)',
    \ '' ])

