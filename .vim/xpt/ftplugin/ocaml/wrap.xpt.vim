if exists("b:__WRAP_OCAML_XPT_VIM__")
  finish
endif

let b:__WRAP_OCAML_XPT_VIM__ = 1

call XPTemplate('try_', [
            \ 'try',
            \ '    `wrapped^',
            \ 'with `exc^ -> `rez^`...^',
            \ '   | `exc2^ -> `rez2^`...^'
            \])

call XPTemplate( 'p_', ['(`wrapped^)' ] )

