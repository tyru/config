if exists("b:__WRAP_JAVA_XPT_VIM__")
  finish
endif

let b:__WRAP_JAVA_XPT_VIM__ = 1

call XPTemplate('try_', [
            \ 'try',
            \ '{',
            \ '    `wrapped^',
            \ '}`...^',
            \ 'catch (`except^ e)',
            \ '{',
            \ '    `handler^',
            \ '}`...^',
            \ '`catch...^catch (Exception e)',
            \ '{',
            \ '    \`\^',
            \ '}^^',
            \ '`finally...^finally',
            \ '{',
            \ '    \`cursor\^',
            \ '}^^',
            \ ''
            \])

