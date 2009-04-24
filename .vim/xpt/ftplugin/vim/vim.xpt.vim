runtime ftplugin/_common/common.xpt.vim




call XPTemplate("once", [
      \'if exists("`g^:`i^headerSymbol()^")', 
      \'  finish', 
      \'endif',
      \'let `g^:`i^ = 1', 
      \'`cursor^'
      \])

call XPTemplate("sfun", "
      \fun! s:`name^(`^) \"{{{\n
      \  `cursor^\n
      \endfunction \"}}}\n
      \")

call XPTemplate('method', [
      \ 'fun! `Dict^.`name^(`^) dict',
      \ '  `cursor^', 
      \ 'endfunction', 
      \ ''
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
      \ '  `^', 
      \ 'endtry', 
      \ ''
      \])

call XPTemplate('log', [
      \ 'call Log("`txt^")'
      \])
