scriptencoding utf-8


set t_vb=

"--- フォント設定 ---

if has('win32')
  " Windows用
  set guifont=M+2VM+IPAG_circle:h13
  set printfont=M+2VM+IPAG_circle:h13
"   set guifont=Osaka－等幅:h13
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  set guifont=Osaka－等幅:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
"   set guifontset=a14,r14,k14
  set guifont=Monospace\ 12
endif

"--- ウインドウに関する設定 ---

" ウインドウの幅
set columns=90
" ウインドウの高さ
set lines=45
" コマンドラインの高さ(GUI使用時)
set cmdheight=1

" vim: fdm=marker : fen :
