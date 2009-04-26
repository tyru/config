if exists("b:__WRAP_CPP_XPT_VIM__")
  finish
endif

let b:__WRAP_CPP_XPT_VIM__ = 1

call XPTemplate('try_', [
            \ 'try',
            \ '{',
            \ '    `wrapped^',
            \ '}',
            \ '`...^catch ( `except^ e )',
            \ '{',
            \ '    `handler^',
            \ '}`...^',
            \ 'catch ( `what^...^^ )',
            \ '{',
            \ '    `cursor^',
            \ '}'
            \])

