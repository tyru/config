" vim:set ts=8 sts=2 sw=2 tw=0:
"
" - 2ch viewer 'Chalice' /
"
" Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

scriptencoding cp932

" Chaliceの起動確認
if !ChaliceIsRunning()
  finish
endif

" 共通設定の読み込み
runtime! ftplugin/2ch.vim

"
" ローカル変数の設定
"
setlocal fileformat=unix
setlocal foldcolumn=1
setlocal tabstop=8
setlocal wrap
let b:title = ''
let b:title_raw = ''
let b:host = ''
let b:board = ''
let b:dat = ''

"
" キーマッピング
"
nnoremap <silent> <buffer> <S-Tab>	:ChaliceGoThreadList<CR>
nnoremap <silent> <buffer> <C-Tab>	:ChaliceGoBoardList<CR>

nnoremap <silent> <buffer> <CR>		:ChaliceHandleJump<CR>
nnoremap <silent> <buffer> <S-CR>	:ChaliceHandleJumpExt<CR>
nnoremap <silent> <buffer> -<CR>	:ChaliceHandleJumpExt<CR>
nnoremap <silent> <buffer> =		:ChaliceReformat thread<CR>
nnoremap <silent> <buffer> R		:ChaliceReloadThread<CR>
nnoremap <silent> <buffer> r		:ChaliceReloadThreadInc<CR>
nnoremap <silent> <buffer> ~		:ChaliceBookmarkAdd thread<CR>
nnoremap <silent> <buffer> <C-I>	:ChaliceJumplistNext<CR>
nnoremap <silent> <buffer> <C-O>	:ChaliceJumplistPrev<CR>
nnoremap <silent> <buffer> <		:ChaliceGoArticle prev<CR>
nnoremap <silent> <buffer> ,		:ChaliceGoArticle prev<CR>
nnoremap <silent> <buffer> >		:ChaliceGoArticle next<CR>
nnoremap <silent> <buffer> .		:ChaliceGoArticle next<CR>
nnoremap <silent> <buffer> #		:ChaliceGoArticle input<CR>
nnoremap <silent> <buffer> &		:Chalice2HTML<CR>

nnoremap <silent> <buffer> i		:ChaliceWrite<CR>
nnoremap <silent> <buffer> I		:ChaliceWrite sage<CR>
nnoremap <silent> <buffer> a		:ChaliceWrite anony<CR>
nnoremap <silent> <buffer> A		:ChaliceWrite anony,sage<CR>
nnoremap <silent> <buffer> o		:ChaliceWrite last<CR>
nnoremap <silent> <buffer> O		:ChaliceWrite last,sage<CR>
nnoremap <silent> <buffer> -i		:ChaliceWrite quote<CR>
nnoremap <silent> <buffer> -I		:ChaliceWrite sage,quote<CR>
nnoremap <silent> <buffer> -a		:ChaliceWrite anony,quote<CR>
nnoremap <silent> <buffer> -A		:ChaliceWrite anony,sage,quote<CR>
nnoremap <silent> <buffer> -o		:ChaliceWrite last,quote<CR>
nnoremap <silent> <buffer> -O		:ChaliceWrite last,sage,quote<CR>

nnoremap <silent> <buffer> p		<C-b>
nnoremap <silent> <buffer> K		<C-y>
nnoremap <silent> <buffer> J		<C-e>

nnoremap <silent> <buffer> <C-P><C-P>	:ChalicePreview<CR>
nnoremap <silent> <buffer> <C-P><C-C>	:ChalicePreviewClose<CR>
nnoremap <silent> <buffer> <C-P>c	:ChalicePreviewClose<CR>
nnoremap <silent> <buffer> <C-P><C-X>	:ChalicePreviewToggle<CR>

nnoremap <silent> <buffer> <2-LeftMouse>	:ChaliceHandleJump<CR>
nnoremap <silent> <buffer> <Space>	:ChaliceCruise thread<CR>
nnoremap <silent> <buffer> +		:ChaliceCruise thread,semiauto<CR>

" 番号付きの外部ブラウザを起動する
function! s:KickNumberedExternalBrowser(exnum)
  let save_exbrowser = g:chalice_exbrowser
  if exists('g:chalice_exbrowser_' . a:exnum)
    let g:chalice_exbrowser = g:chalice_exbrowser_{a:exnum}
  endif
  ChaliceHandleJumpExt
  let g:chalice_exbrowser = save_exbrowser
endfunction

" 番号付きの外部ブラウザを起動するキーマップを登録する
let i = 0
while i < 10
  if exists('g:chalice_exbrowser_' . i)
    execute "nnoremap <silent> <buffer> ".i."<S-CR> :call <SID>KickNumberedExternalBrowser(" . i . ")\<CR>"
    execute "nnoremap <silent> <buffer> ".i."-<CR> :call <SID>KickNumberedExternalBrowser(" . i . ")\<CR>"
  endif
  let i = i + 1
endwhile
