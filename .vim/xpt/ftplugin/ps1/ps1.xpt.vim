if exists("b:__PS1_XPT_VIM__")
    finish
endif
let b:__PS1_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _conditon/perl.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate('cmdlet', [
            \ 'Cmdlet `verb^-`noun^',
            \ '{',
            \ '    `Param...^Param\(',
            \ '       \`\^',
            \ '    \)^^',
            \ '    `Begin...^Begin',
            \ '    {',
            \ '    }^^',
            \ '    Process',
            \ '    {',
            \ '    }',
            \ '    `End...^End',
            \ '    {',
            \ '    }^^',
            \ '}',
            \ ''
            \])

call XPTemplate( 'fun', [
        \ 'function `funName^( `params^ )',
        \ '{',
        \ '   `cursor^',
        \ '}',
        \ '' ])

call XPTemplate( 'function', [
        \ 'function `funName^( `params^ )',
        \ '{',
        \ '    `Begin...^Begin',
        \ '    {',
        \ '        \`\^',
        \ '    }^^',
        \ '    `Process...^Process',
        \ '    {',
        \ '        \`\^',
        \ '    }^^',
        \ '    `End...^End',
        \ '    {',
        \ '        \`\^',
        \ '    }^^',
        \ '}',
        \ '' ])

call XPTemplate('foreach', [
            \ 'foreach ($`var^ in `other^)',
            \ '{ `cursor^ }',
            \ ''
            \])

call XPTemplate('switch', [
            \ 'switch `option^^ (`what^)',
            \ '{',
            \ ' `pattern^ { `action^ }`...^',
            \ ' `pattern^ { `action^ }`...^',
            \ ' `Default...^Default { \`action\^ }^^',
            \ '}',
            \ ''])

call XPTemplate('trap', [
            \ 'trap [`exception^Exception^]',
            \ '{',
            \ '    `body^',
            \ '}'
            \])

call XPTemplate( 'forr', [
            \ 'for ($`var^i^ = `init^; $`var^ -ge `val^; $`var^--)',
            \ '{',
            \ '    `cursor^',
            \ '}',
            \ ''])

