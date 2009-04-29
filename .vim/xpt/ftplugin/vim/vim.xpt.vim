if exists("b:__VIM_VIM_XPT_VIM__")
  finish
endif
let b:__VIM_VIM_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion
XPTinclude 
      \ _common/common

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
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
      \ 'fun! `Dict^.`name^(`_^^)',
      \ '  `cursor^', 
      \ 'endfunction'
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
      \ '`finally...^finally', 
      \ '  \`cursor\^^^', 
      \ 'endtry', 
      \ ''
      \])

call XPTemplate('if', [
      \ 'if `cond^', 
      \ '  `_^', 
      \ '`else...^else', 
      \ '  \`cursor\^^^', 
      \ 'endif " `cond^'
      \])


call XPTemplate('log', [ 'call Log(`_^)' ])
call XPTemplate('string', [ 'string(`_^)' ])
call XPTemplate('vimformat', [ 'vim:tw=78:ts=8:sw=2:sts=2:et:norl:fdm=marker:fmr={{{,}}}' ])


call XPTemplate('str_', [
      \ 'string(`wrapped^)'
      \])

