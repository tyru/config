" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let b:match_words = &matchpairs . ',\<if\>:\<en\%[dif]\>'
let b:match_words += ',\<fu\%[nction]!\=\>:\<endf\%[unction]\>'
let b:match_words += ',\<wh\%[ile]\>:\<endwh\%[ile]\>'
let b:match_words += ',\<for\>:\<endfor\=\>'

setlocal iskeyword+=#
setlocal comments=:\",:\


let &cpo = s:save_cpo
