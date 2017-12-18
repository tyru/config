" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let b:match_words = &matchpairs . ',\<if\>:\<fi\>'
let b:match_words .= ',\<do\>:\<done\>'
let b:match_words .= ',\<case\>:\<esac\>'

let g:sh_noisk = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'unlet b:match_words'

let &cpo = s:save_cpo
