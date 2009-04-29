if exists("b:__WRAP_ERLANG_XPT_VIM__")
    finish
endif
let b:__WRAP_ERLANG_XPT_VIM__ = 1

call XPTemplate( "try_", [
      \ 'try',
      \ '    `wrapped^',
      \ 'catch',
      \ '    `excep^ -> `toRet^ `...0^;',
      \ '    `except^ -> `toRet^`...0^',
      \ '`after...^after',
      \ '    \`afterBody\^^^',
      \ 'end',
      \ '' ] )

