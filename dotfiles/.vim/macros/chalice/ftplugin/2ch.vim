" vim:set ts=8 sts=2 sw=2 tw=0:
"
" - 2ch viewer 'Chalice' /
"
" Written By:  Muraoka Taro <koron@tka.att.ne.jp>

setlocal buftype=nofile bufhidden=delete 
setlocal noexpandtab
setlocal nolist
setlocal nomodeline
setlocal nonumber
setlocal noswapfile
setlocal nowrap

nnoremap <silent> <buffer> q		:ChaliceQuit<CR>
nnoremap <silent> <buffer> Q		:ChaliceQuitAll<CR>

nnoremap <silent> <buffer> <C-A>	:ChaliceBookmarkToggle threadlist<CR>
nnoremap <silent> <buffer> <BS>		:ChaliceGoBoardList<CR>
nnoremap <silent> <buffer> <C-H>	:ChaliceGoBoardList<CR>
nnoremap <silent> <buffer> u		:ChaliceGoThreadList<CR>
nnoremap <silent> <buffer> m		:ChaliceGoThread<CR>
nnoremap <silent> <buffer> U		:ChaliceBookmarkToggle threadlist<CR>
nnoremap <silent> <buffer> M		:ChaliceBookmarkToggle thread<CR>
nnoremap <silent> <buffer> <C-X>	:ChaliceToggleNetlineStatus<CR>
nnoremap <silent> <buffer> <C-L>	:ChaliceAdjWinsize<CR><C-L>

nnoremap <silent> <buffer> <C-N>	:ChaliceHandleURL <C-R>+<CR>

nnoremap <silent> <buffer> <Space>	<C-f>0
nnoremap <silent> <buffer> <S-Space>	<C-b>0
nnoremap <silent> <buffer> p		<C-b>0
nnoremap <silent> <buffer> <C-I>	<Nop>
nnoremap <silent> <buffer> <C-O>	<Nop>
