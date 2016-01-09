" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let b:match_words = &matchpairs . ',\<if\>:\<fi\>'
let b:match_words .= ',\<do\>:\<done\>'
let b:match_words .= ',\<case\>:\<esac\>'

let g:sh_noisk = 1

let &cpo = s:save_cpo
