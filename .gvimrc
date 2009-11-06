scriptencoding utf-8

" フォント設定 {{{
if has('win32')    " Windows
    set guifont=M+2VM+IPAG_circle:h13
    set printfont=M+2VM+IPAG_circle:h13
elseif has('mac')    " Mac
    set guifont=Osaka－等幅:h14
    set printfont=Osaka－等幅:h14
else    " *nix系OS
    set guifont=Monospace\ 12
    set printfont=Monospace\ 12
endif
" }}}

" ウインドウに関する設定 {{{

" 幅
set columns=90
" 高さ
set lines=45
" コマンドラインの高さ(なぜかWindowsで2行分になる)
set cmdheight=1

" }}}

" vim: fdm=marker : fen :
