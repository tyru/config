if exists("b:__WRAP_CS_XPT_VIM__")
  finish
endif

let b:__WRAP_CS_XPT_VIM__ = 1

call XPTemplate('try_', [
            \ 'try',
            \ '{',
            \ '    `wrapped^',
            \ '}`...^',
            \ 'catch (`except^ e)',
            \ '{',
            \ '    `handler^',
            \ '}`...^',
            \ 'catch',
            \ '{',
            \ '    `cursor^',
            \ '}',
            \])

call XPTemplate('tryf_', [
            \ 'try',
            \ '{',
            \ '    `wrapped^',
            \ '}',
            \ '`...^catch (`except^ e)',
            \ '{',
            \ '    `handler^',
            \ '}`...^',
            \ 'catch',
            \ '{',
            \ '    `cursor^',
            \ '}',
            \ 'finally',
            \ '{',
            \ '    `cleanup^^',
            \ '}'
            \])

