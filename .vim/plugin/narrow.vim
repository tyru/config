" narrow - Emulate Emacs' narrowing feature
" Version: 0.2
" Copyright (C) 2007 kana <http://nicht.s8.xrea.com/>
" License: MIT license (see <http://www.opensource.org/licenses/mit-license>)
" $Id: /local/svn-repos/config/trunk/vim/dot.vim/plugin/narrow.vim 1271 2007-12-28T22:44:49.866924Z kana  $

if exists('g:loaded_narrow')
  finish
endif




command -bar -range Narrow  call narrow#Narrow(<line1>, <line2>)
command -bar Widen  call narrow#Widen()




let g:loaded_narrow = 1

" __END__
" vim: foldmethod=marker
