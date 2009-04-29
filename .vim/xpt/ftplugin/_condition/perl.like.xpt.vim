if exists("b:___CONDITION_PERL_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_PERL_LIKE_XPT_VIM__ = 1

call XPTemplate( 'if', [
            \ 'if ( `cond^ )',
            \ '{',
            \ '    `code^',
            \ '}`...^',
            \ 'elseif ( `cond2^ )',
            \ '{',
            \ '    `body^',
            \ '}`...^`else...^',
            \ 'else',
            \ '{',
            \ '    \`body\^',
            \ '}^^',
            \ '' ])

