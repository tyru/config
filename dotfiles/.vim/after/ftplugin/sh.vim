" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let s:opt = tyru#util#undo_ftplugin_helper#new()

let s:match_words = &matchpairs . ',\<if\>:\<fi\>'
let s:match_words += ',\<do\>:\<done\>'
let s:match_words += ',\<case\>:\<esac\>'
call s:opt.let('b:match_words', s:match_words)

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
