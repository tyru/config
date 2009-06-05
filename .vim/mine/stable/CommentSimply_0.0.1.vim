"==================================================
" Name: CommentSimply.vim
" Version: 0.0.1
" Author:  tyru <kz.whizy@gmail.com>
" Last Change: 2008-12-13.
"
" Change Log:
"   0.0.0: Initial Release
"   0.0.1: Fixed UnComment() uncomment in even multi commented line.
"
" Usage:
"   COMMANDS:
"     CSOnelineComment
"         Change current oneline comment chars.
"         (this takes arguments 0 or 1)
"
"   MAPPING:
"     In normal or visual mode,
"
"     \ca   add comment chars to the beginning of line.
"     \c0   same as above.
"     \c^   add comment chars to the beginning of non-space chars.
"     \c$   add comment chars to the end of line.
"
"   GLOBAL VARIABLES:
"     g:cs_prefix (default:<Leader>c)
"         Change the prefix of mapping.
"         example, if you did
"             let g:cs_prefix = ',c'
"         so you can add comment at the beginning of line
"         by typing ',ca' or ',c0'.
"         if you don't think mappings should be the same 
"
"     g:cs_ca_mapping (default:0)
"         if this is default value, '\ca' is same as '\c^'.
"
"     g:cs_ff_space (default:'')
"         This is added before comment when '\ca', '\c0', '\c^'.
"
"     g:cs_fb_space (default:' ')
"         This is added after comment when '\ca', '\c0', '\c^'.
"
"     g:cs_bf_space (default:'    ')
"         This is added before comment when '\c$'.
"
"     g:cs_bb_space (default:' ')
"         This is added after comment when '\c$'.
"
"     g:cs_align_back (default:1)
"         NOTE: NOT IMPLEMENTED YET
"         Whether align behind comment.
"
"   TODO:
"     * Multi-line comment.
"     * Align behind comment.
"     * enter insert mode when '\c$'
"
"
"
"==================================================

scriptencoding euc-jp

" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" DEBUG {{{1
let s:debug = 0
if s:debug
  set verbose=7
endif
" }}}1

" GLOBAL VARIABLES {{{1
if exists('g:loaded_comment_simply') && g:loaded_comment_simply != 0
  finish
endif
let g:loaded_comment_simply = 1


if exists('g:cs_ca_mapping')
  if g:cs_ca_mapping != '0' && g:cs_ca_mapping != '^' && g:cs_ca_mapping != '$'
    call s:Warn( 'g:cs_ca_mapping is allowed "0" or "^" or "$".' )
    let g:cs_ca_mapping = '^'
  endif
else
  let g:cs_ca_mapping = '^'
endif

if !exists('g:cs_ff_space')   | let g:cs_ff_space = ''     | endif
if !exists('g:cs_fb_space')   | let g:cs_fb_space = ' '    | endif
if !exists('g:cs_bf_space')   | let g:cs_bf_space = '    ' | endif
if !exists('g:cs_bb_space')   | let g:cs_bb_space = ' '    | endif

if !exists('g:cs_prefix')
  if exists('mapleader')
    let g:cs_prefix = mapleader . 'c'
  else
    let g:cs_prefix = '\c'
  endif
endif

if !exists('g:cs_align_back') | let g:cs_align_back = 1 | endif
" }}}1


" FUNCTION DEFINITIONS {{{1

" TODO: Align comment in case '$'
" <SID>Comment( ... ) range {{{2
func! <SID>Comment( pos ) range
  if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenFileType() | endif
  let range = a:firstline .','. a:lastline

  """ Debug
  if s:debug
    let silent = ''
    call s:DebugMsg( 'a:firstline ', a:firstline )
    call s:DebugMsg( 'a:lastline ', a:lastline )
    call s:DebugMsg( 'range ', range )
  else
    let silent = 'silent! '
  endif

  " build comment string
  let fcomment = g:cs_ff_space . b:cs_oneline_comment . g:cs_fb_space
  let bcomment = g:cs_bf_space . b:cs_oneline_comment . g:cs_bb_space

  " add comment
  if a:pos == '0'
    execute silent . range .'s/^/'. escape( fcomment, '/' ) .'/'
  elseif a:pos == '^'
    execute silent . range .'s/^\(\s*\)/\1'. escape( fcomment, '/' ) .'/'
  elseif a:pos == '$'
    execute silent . range .'s/$/'. escape( bcomment, '/' ) .'/'
  endif

  nohlsearch
endfunc
" }}}2

" <SID>UnComment() range {{{2
func! <SID>UnComment() range
  if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenFileType() | endif

  """ debug
  if s:debug
    let silent = ''
    call s:DebugMsg( 'a:firstline ', a:firstline )
    call s:DebugMsg( 'a:lastline ', a:lastline )
  else
    let silent = 'silent! '
  endif


  """ build comment string
  let fcomment = g:cs_ff_space . b:cs_oneline_comment . g:cs_fb_space
  let bcomment = g:cs_bf_space . b:cs_oneline_comment . g:cs_bb_space

  """ comment
  let i =  a:firstline
  while i <= a:lastline
    let line = getline( i )

    if matchstr( line, '^'. escape( fcomment, '/' ) ) != ''
      " '0'
      execute silent . i .'s/^'. escape( fcomment, '/' ) .'//'
    elseif matchstr( line, '^\(\s\{-}\)'. escape( fcomment, '/' ) ) != ''
      " '^'
      execute silent . i .'s/^\(\s\{-}\)'. escape( fcomment, '/' ) .'/\1/'
    elseif matchstr( line, escape( bcomment, '/' ) . '[^'. b:cs_oneline_comment .']*$' ) != ''
      " '$'
      "   NOTE: delete /[comment].*$/
      "   Perl: /^(?!\s*comment)(.*?)\s*comment.*
      execute silent . i . 's/'. escape( bcomment, '/' ) .'[^'. b:cs_oneline_comment .']*$//'
    endif

    let i = i + 1
  endwhile

  nohlsearch
endfunc
" }}}2

" s:ReMapCA( ca_map ) {{{2
func s:ReMapCA( ca_map )
  execute 'noremap <silent> '. g:cs_prefix . a:ca_map
        \   .'    :call <SID>Comment( "^" )<CR>'
endfunc
" }}}2

" s:DebugMsg( str, content ) {{{2
func! s:DebugMsg( str, content )
  echohl WarningMsg
  echo a:str .'###|'. a:content .'|###'
  echohl None
endfunc
" }}}2

" s:Warn( msg ) {{{2
func! s:Warn( msg )
  echohl WarningMsg
  echo a:msg
  echohl None
endfunc
" }}}2

func! s:ChangeOnelineComment( ... )
  if a:0 == 1
    let b:cs_oneline_comment = a:1
  else
    let oneline_comment = input( 'oneline comment:' )
    if oneline_comment != ''
      let b:cs_oneline_comment = oneline_comment
    else
      echo 'not changed.'
      return
    endif
  endif
  echo 'changed to "'. b:cs_oneline_comment .'".'
endfunc

" }}}1

" AUTOCOMMAND {{{1
autocmd FileType *   call s:LoadWhenFileType()

func! s:LoadWhenFileType()

  if s:debug
    call s:DebugMsg( '', 'calling s:LoadWhenFileType()...' )
  endif

  if &ft == 'actionscript' || &ft == 'c' || &ft == 'cpp'
        \ || &ft == 'cs' || &ft == 'd' || &ft == '//'
        \ || &ft == 'java' || &ft == 'javascript' || &ft == 'objc'
    let b:cs_oneline_comment = '//'

  elseif &ft == 'asm' || &ft == 'lisp' || &ft == 'scheme' || &ft == 'vb'
    let b:cs_oneline_comment = ';'

  elseif &ft == 'perl' || &ft == 'python' || &ft == 'ruby'
    let b:cs_oneline_comment = '#'

  elseif &ft == 'vim' || &ft == 'vimperator'
    let b:cs_oneline_comment = '"'

  elseif &ft == 'dosbatch'
    let b:cs_oneline_comment = 'rem'

  else
    let b:cs_oneline_comment = '#'
  endif

  if s:debug
    call s:DebugMsg( '', 'set "'. b:cs_oneline_comment .'" as comment chars.' )
  endif

endfunc

" }}}1

" COMMANDS {{{1
command! -nargs=*  CSOnelineComment   call s:ChangeOnelineComment( <f-args> )
" }}}1

" MAPPINGS {{{1
execute 'noremap <unique> <silent> '. g:cs_prefix . 'a'
      \   .'    :call <SID>Comment( "'. g:cs_ca_mapping .'" )<CR>'
execute 'noremap <unique> <silent> '. g:cs_prefix .'0'
      \   .'    :call <SID>Comment( "0" )<CR>'
execute 'noremap <unique> <silent> '. g:cs_prefix .'^'
      \   .'    :call <SID>Comment( "^" )<CR>'
execute 'noremap <unique> <silent> '. g:cs_prefix .'$'
      \   .'    :call <SID>Comment( "$" )<CR>'

execute 'noremap <unique> <silent> '. g:cs_prefix .'c'
      \   .'    :call <SID>UnComment()<CR>'
" }}}1

" vim: foldmethod=marker : fen :

