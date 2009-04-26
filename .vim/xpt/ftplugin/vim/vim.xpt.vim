if exists("b:__VIM_XPT_VIM__")
  finish
endif
let b:__VIM_XPT_VIM__ = 1


runtime ftplugin/_common/common.xpt.vim


call XPTemplate("once", [
      \'if exists("`g^:`i^headerSymbol()^")', 
      \'  finish', 
      \'endif',
      \'let `g^:`i^ = 1', 
      \'`cursor^'
      \])

call XPTemplate("fun", "
      \fun! `name^(`_^^) \"{{{\n
      \  `cursor^\n
      \endfunction \"}}}\n
      \")

call XPTemplate('method', [
      \ 'fun! `Dict^.`name^(`^) dict',
      \ '  `cursor^', 
      \ 'endfunction', 
      \ ''
      \])

call XPTemplate('while', [
      \ 'while `cond^',
      \ '  `cursor^',
      \ 'endwhile'
      \])

call XPTemplate('while1', [
      \ 'while 1',
      \ '  `cursor^',
      \ 'endwhile'
      \])

call XPTemplate('fordic', [
      \ 'for [`k^, `v^] in items(`dic^)',
      \ '  `cursor^',
      \ 'endfor'
      \])
call XPTemplate("forin", [
    \"for `v^ in `list^", 
    \"  `cursor^", 
    \"endfor"
    \])

call XPTemplate('try', [
      \ 'try', 
      \ '  `^', 
      \ 'catch /`^/', 
      \ '  `^', 
      \ 'finally', 
      \ '  `cursor^', 
      \ 'endtry', 
      \ ''
      \])

call XPTemplate('log', [ 'call Log(`txt^)' ])

call XPTemplate('string', [ 'string(`_^)' ])


call XPTemplate('str_', [
      \ 'string(`wrapped^)'
      \])
