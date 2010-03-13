

let b:match_words = &matchpairs . ',\<if\>:\<en\%[dif]\>'
let b:match_words += ',\<fu\%[nction]!\=\>:\<endf\%[unction]\>'
let b:match_words += ',\<wh\%[ile]\>:\<endwh\%[ile]\>'
let b:match_words += ',\<for\>:\<endfor\=\>'


setlocal iskeyword+=#


" vim: foldmethod=marker : fen :
