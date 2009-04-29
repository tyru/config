if exists("b:__PYTHON_PYTHON_XPT_VIM__")
  finish
endif
let b:__PYTHON_PYTHON_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate('if', [
            \ 'if `cond^:',
            \ '    `then^`...^',
            \ 'elif `cond2^:',
            \ '    `todo^`...^',
            \ '`else...^else:',
            \ '    \`cursor\^^^'
            \])

call XPTemplate('for', [
            \ 'for `vars^ in `range^0)^:',
            \ '    `cursor^'
            \])

call XPTemplate( 'def', [
            \ 'def `fun_name^( `params^^ ):',
            \ '    `cursor^'
            \ ])

call XPTemplate( 'lambda', ['(lambda `args^ : `expr^)'] )

call XPTemplate('try', [
            \ 'try:',
            \ '    `what^',
            \ 'except `except^:',
            \ '    `handler^`...^',
            \ 'except `exc^:',
            \ '    `handle^`...^',
            \ '`else...^else:',
            \ '    \`\^^^',
            \ '`finally...^finally:',
            \ '   \`\^^^'
            \])

call XPTemplate('class', [
            \ 'class `className^ `inherit^^:',
            \ '    def __init__( self `args^^):',
            \ '        `cursor^'
            \])

call XPTemplate('ifmain', [
      \ 'if __name__ == "__main__" :',
      \ '  `cursor^'
      \])

