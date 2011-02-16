" vim:set ts=8 sts=2 sw=2 tw=0:
"
" - 2ch viewer 'Chalice' /
"
" Written By:  Muraoka Taro <koron@tka.att.ne.jp>

scriptencoding cp932

" Chaliceの起動確認
if !ChaliceIsRunning()
  finish
endif

" 共通設定の読み込み
runtime! ftplugin/2ch.vim

setlocal comments=b:>,b:#
setlocal expandtab
setlocal formatoptions-=r
setlocal tabstop=4 shiftwidth=4 softtabstop=4
setlocal nowrap
setlocal buftype=

nnoremap <buffer> =			:ChaliceCheckThread write<CR>
" 書込みコマンド
nnoremap <silent> <buffer> <C-CR>	:ChaliceDoWrite<CR>
nnoremap <silent> <buffer> <C-W><CR>	:ChaliceDoWrite<CR>

nunmap <buffer> q
nunmap <buffer> Q

nunmap <buffer> <C-A>
nunmap <buffer> <BS>
nunmap <buffer> <C-H>
nunmap <buffer> <C-X>

nunmap <buffer> u
nunmap <buffer> m
nunmap <buffer> U
nunmap <buffer> M
nunmap <buffer> <Space>
nunmap <buffer> <S-Space>
nunmap <buffer> p

function! s:RevertLastMessage()
  if !exists('g:chalice_lastmessage') || g:chalice_lastmessage == ''
    return
  endif
  let save_reg = @"
  let @" = g:chalice_lastmessage
  normal! Gp
  let @" = save_reg
endfunction
nnoremap <buffer><silent> <C-S> :call <SID>RevertLastMessage()<CR>
