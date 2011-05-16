" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


function! s:run()
    let opt = tyru#util#undo_ftplugin_helper#new()

    let match_words = &matchpairs . ',\<if\>:\<en\%[dif]\>'
    let match_words += ',\<fu\%[nction]!\=\>:\<endf\%[unction]\>'
    let match_words += ',\<wh\%[ile]\>:\<endwh\%[ile]\>'
    let match_words += ',\<for\>:\<endfor\=\>'
    call opt.let('b:match_words', match_words)

    call opt.append('iskeyword', '#')
    call opt.set('comments', ':"\,:\')
    call opt.unset('modeline')

    let b:undo_ftplugin = opt.make_undo_ftplugin()
endfunction
call s:run()


let &cpo = s:save_cpo
