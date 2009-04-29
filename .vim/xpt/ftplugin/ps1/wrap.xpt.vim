if exists("b:__PS1_WRAPPED_XPT_VIM__")
    finish
endif
let b:__PS1_WRAPPED_XPT_VIM__ = 1

runtime ftplugin/common/common.xpt.vim

call XPTemplate( 'if_', [
            \ 'if ( `cond^ )',
            \ '{',
            \ '    `wrapped^',
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
