scriptencoding utf-8

" Options {{{
set browsedir=current
set clipboard=

" Window
set columns=90
set lines=45
set cmdheight=1
" }}}

" Font {{{
if has('win32')    " Windows
    set guifont=M+2VM+IPAG_circle:h13
    set printfont=M+2VM+IPAG_circle:h13
elseif has('mac')    " Mac
    set guifont=Osaka－等幅:h14
    set printfont=Osaka－等幅:h14
else    " *nix OS
    set guifont=Monospace\ 12
    set printfont=Monospace\ 12
    set linespace=4
endif
" }}}

" vim: fdm=marker : fen :
