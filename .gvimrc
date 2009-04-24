
scriptencoding euc-jp

" カラースキーマ等 {{{1

call RandomColorScheme()
set t_vb=

" }}}1

""" フォント設定 {{{1
"
if has('win32')
  " Windows用
  set guifont=M+2VM+IPAG_circle:h13
  set printfont=M+2VM+IPAG_circle:h13
"   set guifont=Osaka−等幅:h13
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  set guifont=Osaka−等幅:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
"   set guifontset=a14,r14,k14
  set guifont=Monospace\ 12
endif

""" }}}1

""" ウインドウに関する設定 {{{1
"
" ウインドウの幅
set columns=90
" ウインドウの高さ
set lines=45
" コマンドラインの高さ(GUI使用時)
set cmdheight=1

""" }}}1

""" 日本語入力に関する設定 {{{1
"
if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  highlight CursorIM guibg=Purple guifg=NONE
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIMの入力開始キーを設定:
    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
    "set imactivatekey=s-space
  endif
  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

""" }}}1

""" バイナリ編集(xxd)モード {{{1
"（vim -b での起動、もしくは *.bin ファイルを開くと発動）
"
"augroup BinaryXXD
"  autocmd!
"  autocmd BufReadPre  *.bin let &binary =1
"  autocmd BufReadPost * if &binary | silent %!xxd -g 1
"  autocmd BufReadPost * set ft=xxd | endif
"  autocmd BufWritePre * if &binary | %!xxd -r | endif
"  autocmd BufWritePost * if &binary | silent %!xxd -g 1
"  autocmd BufWritePost * set nomod | endif
"augroup END

""" }}}1

" vim: fdm=marker : fen :
