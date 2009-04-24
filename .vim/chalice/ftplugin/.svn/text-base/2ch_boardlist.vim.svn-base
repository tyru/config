" vim:set ts=8 sts=2 sw=2 tw=0:
"
" - 2ch viewer 'Chalice' /
"
" Last Change: 24-Apr-2002.
" Written By:  Muraoka Taro <koron@tka.att.ne.jp>

scriptencoding cp932

" Chaliceの起動確認
if !ChaliceIsRunning()
  finish
endif

" 共通設定の読み込み
runtime! ftplugin/2ch.vim

setlocal foldmethod=manual
setlocal tabstop=7
let b:title = ''

"
" キーマッピング
"
nnoremap <silent> <buffer> <S-Tab>	:ChaliceGoThread<CR>
nnoremap <silent> <buffer> <C-Tab>	:ChaliceGoThreadList<CR>

nnoremap <silent> <buffer> <CR>		:ChaliceOpenBoard<CR>
nnoremap <silent> <buffer> <S-CR>	:ChaliceOpenBoard external<CR>
nnoremap <silent> <buffer> -<CR>	:ChaliceOpenBoard external<CR>
nnoremap <silent> <buffer> R		:ChaliceReloadBoardList<CR>
nnoremap <silent> <buffer> ~		:ChaliceBookmarkAdd boardlist<CR>

nnoremap <silent> <buffer> l		zo
nnoremap <silent> <buffer> h		zc
nnoremap <silent> <buffer> <BS>		0

nnoremap <silent> <buffer> <2-LeftMouse>	:ChaliceOpenBoard<CR>

"
" folding設定
"

" スクリプトIDを取得
map <SID>xx <SID>xx
let s:sid = substitute(maparg('<SID>xx'), 'xx$', '', '')
unmap <SID>xx

function! s:FoldText()
  let entry = v:foldend - v:foldstart
  return substitute(getline(v:foldstart), '^' . Chalice_foldmark(0), Chalice_foldmark(1), ''). ' (' . entry . ') '
endfunction

execute 'setlocal foldtext=' . s:sid .'FoldText()'

" 番号付きの外部ブラウザを起動する
function! s:KickNumberedExternalBrowser(exnum)
  let save_exbrowser = g:chalice_exbrowser
  if exists('g:chalice_exbrowser_' . a:exnum)
    let g:chalice_exbrowser = g:chalice_exbrowser_{a:exnum}
  endif
  ChaliceOpenBoard external
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
