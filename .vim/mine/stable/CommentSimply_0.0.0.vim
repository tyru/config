"==================================================
" Name: CommentSimply.vim
" Version: 0.0.0
" Author:  tyru <kz.whizy@gmail.com>
" Last Change: 2008-12-02.
"
" Usage:
"   COMMANDS:
"     No command.
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
"     g:comment_simply_prefix (default:<Leader>c)
"         Change the prefix of mapping.
"         example, if you did
"             let g:comment_simply_prefix = ',c'
"         so you can add comment at the beginning of line
"         by typing ',ca' or ',c0'.
"     g:comment_simply_front_space (default:'')
"         This is added before space when '\ca', '\c0', '\c^'.
"     g:comment_simply_back_space (default:'    ')
"         This is added before space when '\c$'.
"     g:comment_simply_disable_autocmd (default:0)
"         You can disable to register autocmd.
"         (if you concern Vim's loading file speed)
"     g:comment_simply_align_behind (default:1)
"         NOTE: NOT IMPLEMENTED YET
"         Whether align behind comment.
"
"   TODO:
"     Multi-line comment.
"     Align behind comment.
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
let s:Debug = 1
" }}}1

" GLOBAL VARIABLES {{{1
if exists('g:loaded_comment_simply') && g:loaded_comment_simply != 0
  finish
endif
let g:loaded_comment_simply = 1


if !exists('g:comment_simply_front_space')
  let g:comment_simply_front_space = ''
endif

if !exists('g:comment_simply_back_space')
  let g:comment_simply_back_space = '    '    " default is 4 spaces
endif

if !exists('g:comment_simply_disable_autocmd')
  let g:comment_simply_disable_autocmd = 0
endif

if !exists('g:comment_simply_prefix')
  if exists('mapleader')
    let g:comment_simply_prefix = mapleader . 'c'
  else
    let g:comment_simply_prefix = '\c'
  endif
endif

if !exists('g:comment_simply_align_behind')
  let g:comment_simply_disable_autocmd = 1
endif
" }}}1

" FUNCTION DEFINITIONS {{{1

" func! <SID>NormalComment() {{{2
func! <SID>NormalComment( pos ) range
  if !exists( 'b:cs_oneline_comment' ) | return | endif

  if s:Debug
    let silent = ''
  else
    let silent = 'silent! '
  endif

  if a:pos == '0'
    execute silent .'s/^/'. b:cs_oneline_comment .'/'
  elseif a:pos == '^'
    execute silent .'s/^\(\s*\)/\1'. b:cs_oneline_comment .'/'
  elseif a:pos == '$'
    execute silent .'s/$/'. g:comment_simply_back_space . b:cs_oneline_comment .'/'
  endif

  nohlsearch
endfunc
" }}}2

" func! <SID>NormalUnComment() {{{2
func! <SID>NormalUnComment()
  if !exists( 'b:cs_oneline_comment' ) | return | endif

  if s:Debug
    let silent = ''
  else
    let silent = 'silent! '
  endif

  " '0'
  execute silent .'s/^'. b:cs_oneline_comment .'//'

  " '^'
  execute silent .'s/^\(\s*\)'. b:cs_oneline_comment .'/\1/'

  " '$'
  "   NOTE: delete /[comment].*$/
  "   Perl: /^(?!\s*comment)(.*?)\s*comment.*
  execute silent .'s/^\%(\s*'. b:cs_oneline_comment
            \.'\)\@!\(.\{-}\)\s*'. b:cs_oneline_comment .'.*'
        \   .'/\1/'

  nohlsearch
endfunc
" }}}2

" TODO: Align comment in case '$'
" <SID>RangeComment( pos ) range {{{2
func! <SID>RangeComment( pos ) range
  if !exists( 'b:cs_oneline_comment' ) | return | endif

  if s:Debug
    let silent = ''
  else
    let silent = 'silent! '
  endif

  if a:pos == '0'
    execute silent . a:firstline .",". a:lastline
          \   .'s/^/'. b:cs_oneline_comment .'/'
  elseif a:pos == '^'
    execute silent . a:firstline .",". a:lastline
          \   .'s/^\(\s*\)/\1'. b:cs_oneline_comment .'/'
  elseif a:pos == '$'
    execute silent . a:firstline .",". a:lastline
          \   .'s/$/'. g:comment_simply_back_space . b:cs_oneline_comment .'/'
  endif

  nohlsearch
endfunc
" }}}2

" <SID>RangeUnComment() range {{{2
func! <SID>RangeUnComment() range
  if !exists( 'b:cs_oneline_comment' ) | return | endif

  if s:Debug
    let silent = ''
  else
    let silent = 'silent! '
  endif

  " '0'
  execute silent . a:firstline .",". a:lastline
        \   .'s/^'. b:cs_oneline_comment .'//'

  " '^'
  execute silent . a:firstline .",". a:lastline
        \   .'s/^\(\s*\)'. b:cs_oneline_comment .'/\1/'

  " '$'
  "   NOTE: delete /[comment].*$/
  "   Perl: /^(?!\s*comment)(.*?)\s*comment.*
  execute silent . a:firstline .",". a:lastline
        \   .'s/^\%(\s*'. b:cs_oneline_comment
            \.'\)\@!\(.\{-}\)\s*'. b:cs_oneline_comment .'.*'
        \   .'/\1/'

  nohlsearch
endfunc
" }}}2

" }}}1

" MAPPINGS {{{1
""" normal
execute 'nnoremap <silent> '. g:comment_simply_prefix .'a'
      \   .'    :call <SID>NormalComment( "0" )<CR>'
execute 'nnoremap <silent> '. g:comment_simply_prefix .'0'
      \   .'    :call <SID>NormalComment( "0" )<CR>'
execute 'nnoremap <silent> '. g:comment_simply_prefix .'^'
      \   .'    :call <SID>NormalComment( "^" )<CR>'
execute 'nnoremap <silent> '. g:comment_simply_prefix .'$'
      \   .'    :call <SID>NormalComment( "$" )<CR>'
execute 'nnoremap <silent> '. g:comment_simply_prefix .'c'
      \   .'    :call <SID>NormalUnComment()<CR>'
""" visual
execute 'vnoremap <silent> '. g:comment_simply_prefix .'a'
      \   .'    :call <SID>RangeComment( "0" )<CR>'
execute 'vnoremap <silent> '. g:comment_simply_prefix .'0'
      \   .'    :call <SID>RangeComment( "0" )<CR>'
execute 'vnoremap <silent> '. g:comment_simply_prefix .'^'
      \   .'    :call <SID>RangeComment( "^" )<CR>'
execute 'vnoremap <silent> '. g:comment_simply_prefix .'$'
      \   .'    :call <SID>RangeComment( "$" )<CR>'
execute 'vnoremap <silent> '. g:comment_simply_prefix .'c'
      \   .'    :call <SID>RangeUnComment()<CR>'
" }}}1

" AUTOCOMMAND {{{1

if g:comment_simply_disable_autocmd == 0

  autocmd FileType *   call s:LoadWhenFileType()
  func! s:LoadWhenFileType()

    if &filetype == 'actionscript'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'c' || &filetype == 'cpp'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'cs'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'css'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'd'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'java'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'javascript'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'asm' || &filetype == 'lisp' || &filetype == 'scheme'
      let b:cs_oneline_comment = '; '

    elseif &filetype == 'vb'
      let b:cs_oneline_comment = '; '

    elseif &filetype == 'objc'
      let b:cs_oneline_comment = '// '

    elseif &filetype == 'perl'
      let b:cs_oneline_comment = '# '

    elseif &filetype == 'python'
      let b:cs_oneline_comment = '# '

    elseif &filetype == 'ruby'
      let b:cs_oneline_comment = '# '

    elseif &filetype == 'vim' || &filetype == 'vimperator'
      let b:cs_oneline_comment = '" '

    else
      let b:cs_oneline_comment = '# '
    endif

  endfunc

endif
" }}}1

" vim: foldmethod=marker : fen :

