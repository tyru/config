"==================================================
" Name: CommentSimply.vim
" Version: 0.0.4
" Author:  tyru <kz.whizy@gmail.com>
" Last Change: 2008-12-30.
"
" Change Log:
"   0.0.0: Initial release.
"   0.0.1: Fixed UnComment() uncomment in even multi commented line.
"   0.0.2: Stable release.
"   0.0.3: Rewrite code in OOP.
"   0.0.4: Fix bug that comment string won't change when call :CSOnelineComment
"
" Usage:
"   COMMANDS:
"     CSOnelineComment
"         Change current oneline comment string.
"         (this takes arguments 0 or 1)
"
"   MAPPING:
"     In normal or visual mode,
"
"     \ca   add comment string to the beginning of line.
"     \c0   same as above.
"     \c^   add comment string to the beginning of non-space string.
"     \c$   add comment string to the end of line.
"     TODO: \cm   add multi-comment string.
"     \cc   toggle comment/uncomment.
"     \cu   remove comment string.
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
"     g:cs_ca_mapping (default:'^')
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
"     * OOP: Slurp -> Comment, UnComment, Toggle
"
"
"
"==================================================

scriptencoding euc-jp

" LOAD ONCE {{{1
if exists( 'g:loaded_comment_simply' ) && g:loaded_comment_simply != 0
    finish
endif
let g:loaded_comment_simply = 1
" }}}1

" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" GLOBAL VARIABLES {{{1
if exists( 'g:cs_ca_mapping' )
    if g:cs_ca_mapping !~ '^[0^$t]$'
        call s:Warn( 'g:cs_ca_mapping is allowed one of "0", "^", "$", "t".' )
        let g:cs_ca_mapping = '^'
    endif
else
    let g:cs_ca_mapping = '^'
endif

if !exists( 'g:cs_prefix' )
    if exists( 'mapleader' )
        let g:cs_prefix = mapleader . 'c'
    else
        let g:cs_prefix = '\c'
    endif
endif

if !exists( 'g:cs_ff_space' )   | let g:cs_ff_space = ''     | endif
if !exists( 'g:cs_fb_space' )   | let g:cs_fb_space = ' '    | endif
if !exists( 'g:cs_bf_space' )   | let g:cs_bf_space = '    ' | endif
if !exists( 'g:cs_bb_space' )   | let g:cs_bb_space = ' '    | endif
if !exists( 'g:cs_align_back' ) | let g:cs_align_back = 1    | endif
" }}}1

" SCOPED VARIABLES {{{1
let s:CSObject = { 'Function': {}, 'Option': {}, 'SearchString': { 'Comment': {}, 'UnComment': {} } }
let s:prev_filetype = ''
" }}}1


" FUNCTION DEFINITIONS {{{1

" s:CSObject.Function.Slurp( first, end, funcname, ... ) {{{2
func! s:CSObject.Function.Slurp( first, end, funcname, ... )
    if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenFileType() | endif
    let i = a:first
    let argstr = join( a:000, ',' )

    while i <= a:first
        execute 'call setline( i, '. a:funcname .'( i, argstr ) )'
        let i = i + 1
    endwhile

    nohlsearch
endfunc
" }}}2

" s:CSObject.Function.Comment( lnum, ... ) {{{2
func! s:CSObject.Function.Comment( lnum, ... )
    let pos =   a:0 == 0 ? g:cs_ca_mapping : a:1
    let comment = s:CSObject.SearchString.Comment
    return substitute( getline( a:lnum ), comment[pos][0], comment[pos][1], '' )
endfunc
" }}}2

" s:CSObject.Function.UnComment( lnum, ... ) {{{2
func! s:CSObject.Function.UnComment( lnum, ... )
    let line = getline( a:lnum )
    let uncomment = s:CSObject.SearchString.UnComment

    for i in ['0', '^', '$']
        if matchstr( line, s:CSObject.SearchString.UnComment[i][0] ) != ''
            let line = substitute( line, uncomment[i][0], uncomment[i][1], '' )
        endif
    endfor
    return line
endfunc
" }}}2

" s:CSObject.Function.ToggleComment( lnum, ... ) {{{2
func! s:CSObject.Function.ToggleComment( lnum, ... )
    if s:CSObject.Function.IsCommentedLine( a:lnum )
        return s:CSObject.Function.UnComment( a:lnum )
    else
        return s:CSObject.Function.Comment( a:lnum )
    endif
endfunc
" }}}2

" s:CSObject.Function.IsCommentedLine( lnum ) {{{2
func! s:CSObject.Function.IsCommentedLine( lnum )
    let line = getline( a:lnum )
    for i in ['0', '^', '$']
        if matchstr( line, s:CSObject.SearchString.UnComment[i][0] ) != ''
            return 1
        endif
    endfor
    return 0
endfunc
" }}}2

" s:CSObject.Function.MultiComment( lnum, ... ) {{{2
func! s:CSObject.Function.MultiComment( lnum, ... )
endfunc
" }}}2

" s:CSObject.Function.ChangeOnelineComment( ... ) {{{2
func! s:CSObject.Function.ChangeOnelineComment( ... )
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

    call s:LoadWhenFileType()   " rebuild comment string.

    if b:cs_oneline_comment == '"'
        echo "changed to '". b:cs_oneline_comment ."'."
    else
        echo 'changed to "'. b:cs_oneline_comment .'".'
    endif
endfunc
" }}}2

" TODO: Align comment in case '$'
" <SID>Comment( ... ) range {{{2
func! <SID>Comment( ... ) range
    let pos =   a:0 == 0 ? g:cs_ca_mapping : a:1
    call s:CSObject.Function.Slurp( a:firstline, a:lastline, 's:CSObject.Function.Comment', pos )
endfunc
" }}}2

" <SID>UnComment() range {{{2
func! <SID>UnComment() range
    call s:CSObject.Function.Slurp( a:firstline, a:lastline, 's:CSObject.Function.UnComment' )
endfunc
" }}}2

" <SID>ToggleComment() range {{{2
func! <SID>ToggleComment() range
    call s:CSObject.Function.Slurp( a:firstline, a:lastline, 's:CSObject.Function.ToggleComment' )
endfunc
" }}}2

func! <SID>MultiComment() range
    call s:Warn( 'not implemented yet.' )
endfunc

" s:Warn( msg ) {{{2
func! s:Warn( msg )
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}2

" }}}1

" AUTOCOMMAND {{{1
augroup CSFileType
    autocmd!
    autocmd FileType *   call s:LoadWhenFileType()
augroup END

func! s:LoadWhenFileType()
    if &ft == s:prev_filetype | return | endif

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
    let s:prev_filetype = &ft


    " build comment string
    let fcomment = escape( g:cs_ff_space . b:cs_oneline_comment . g:cs_fb_space, '/' )
    let bcomment = escape( g:cs_bf_space . b:cs_oneline_comment . g:cs_bb_space, '/' )

    let s:CSObject.SearchString.Comment['0'] = [ '^', fcomment ]
    let s:CSObject.SearchString.Comment['^'] = [ '^\(\s*\)', '\1'. fcomment ]
    let s:CSObject.SearchString.Comment['$'] = [ '$', bcomment ]
    let s:CSObject.SearchString.UnComment['0'] = [ '^'. fcomment, '' ]
    let s:CSObject.SearchString.UnComment['^'] = [ '^\(\s\{-}\)'. fcomment, '\1' ]
    " delete /[comment].*$/
    " In Perl: /^(?!\s*comment)(.*?)\s*comment.*
    let s:CSObject.SearchString.UnComment['$'] = [ bcomment .'[^'. b:cs_oneline_comment .']*$', '' ]
endfunc

" }}}1

" COMMANDS {{{1
command! -nargs=*  CSOnelineComment
            \ call s:CSObject.Function.ChangeOnelineComment( <f-args> )
command! -range    Comment
            \ <line1>,<line2>call <SID>Comment( <f-args> )
command! -range    UnComment
            \ <line1>,<line2>call <SID>UnComment()
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
            \   .'    :call <SID>ToggleComment()<CR>'
execute 'noremap <unique> <silent> '. g:cs_prefix .'m'
            \   .'    :call <SID>MultiComment()<CR>'

execute 'noremap <unique> <silent> '. g:cs_prefix .'u'
            \   .'    :call <SID>UnComment()<CR>'
" }}}1

" vim:set foldmethod=marker:fen:

