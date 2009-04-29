if exists('b:__SCHEME_XPT_VIM__')
  finish
endif
let b:__SCHEME_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _condition/lisp.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate( 'begin', [
    \ '(begin',
    \ '   (`todo0^) `...^',
    \ '   (`todon^)`...^)',
    \ '' ])

call XPTemplate( 'case', [
    \ '(case (`of^)',
    \ '      ({`match^} `expr1^) `...^',
    \ '      ({`matchn^} `exprn^)`...^',
    \ '      `else...^\(else \`cursor\^\)^^)',
    \ '' ])


call XPTemplate( 'cond', [
    \ '(cond ([`condition^] `expr1^) `...^',
    \ '      ([`condition^] `exprn^)`...^',
    \ '      `else...^\(else \`cursor\^\)^^)',
    \ '' ])

call XPTemplate( 'let', [
    \ '(let [(`newVar^ `value^ `...^)',
    \ '      (`newVarn^ `valuen^`...^)]',
    \ '     (`cursor^))',
    \ ''])

call XPTemplate( 'letrec', [
    \ '(letrec [(`newVar^ `value^ `...^)',
    \ '         (`newVarn^ `valuen^`...^)]',
    \ '     (`cursor^))',
    \ ''])

call XPTemplate( 'lambda', [
    \ '(lambda [`params^]',
    \ '        (`cursor^))'
    \ ])

call XPTemplate( 'defun', [
    \ '(define `funName^',
    \ '    (lambda [`params^]',
    \ '        (`cursor^))',
    \ ' )',
    \ '' ])

call XPTemplate( 'def', ['(define `varName^ `cursor^)'] )

call XPTemplate( 'do', [
    \ '(do {(`var1^ `init1^ `step1^) `...0^',
    \ '     (`varn^ `initn^ `stepn^)`...0^}',
    \ '   ([`test^] `exprs^ `...1^ `exprs^`...1^^)',
    \ '   (`command0^) `...2^^',
    \ '   (`command1^)`...2^)',
    \ '' ])

