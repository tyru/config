"==================================================
" Name: CommentSimply.vim
" Version: 0.0.6
" Author:  tyru <kz.whizy@gmail.com>
" Last Change: 2008-12-30.
"
" Change Log:
"   0.0.0: Initial release.
"   0.0.1: Fixed s:CSObject.Function.UnComment() uncomment nested commented line.
"   0.0.2: Stable release.
"   0.0.3: Rewrite code in OOP.
"   0.0.4: Fix bug that comment string won't change when call :CSOnelineComment
"   0.0.5: Fix bug that s:CSObject.Function.Slurp() won't slurp. (just see 1 line.)
"   0.0.6: Stable release.
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
"     TODO: g:cs_align_back (default:1)
"         Whether align behind comment.
"
"     g:cs_def_oneline_comment (default:"#")
"         If couldn't find oneline comment string of current filetype.
"         use this string as it.
"
"     TODO: g:cs_no_filetype_support (default:0)
"        If you don't think that you need to use my comment string definition,
"        turn this on.
"
"     g:cs_filetype_table (default:read below.)
"         NOTE: WRITE THIS LATER.
"
"     g:cs_multiline_template
"         NOTE: WRITE THIS LATER.
"
"   TODO:
"     * Multi-line comment.
"     * Align behind comment.
"     * enter insert mode when '\c$'
"     * call s:Init() when receiving VimEnter (for loading time while starting up.)
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
    if g:cs_ca_mapping !~ '^[0^$cu]$'
        call s:Warn( 'g:cs_ca_mapping is allowed one of "'. join( s:mapping_table, ' ' ) .'".' )
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

" XXX: this might override user's setting...
let g:cs_filetype_table = {
    \ 'oneline': [
        \ [ 'actionscript' , '//' ], 
        \ [ 'c'            , '//' ], 
        \ [ 'cpp'          , '//' ], 
        \ [ 'cs'           , '//' ], 
        \ [ 'd'            , '//' ], 
        \ [ 'java'         , '//' ], 
        \ [ 'javascript'   , '//' ], 
        \ [ 'objc'         , '//' ], 
        \ [ 'asm'          , ';' ], 
        \ [ 'lisp'         , ';' ], 
        \ [ 'scheme'       , ';' ], 
        \ [ 'vb'           , ';' ], 
        \ [ 'perl'         , '#' ], 
        \ [ 'python'       , '#' ], 
        \ [ 'ruby'         , '#' ], 
        \ [ 'vim'          , '"' ], 
        \ [ 'vimperator'   , '"' ], 
        \ [ 'dosbatch'     , 'rem' ], 
    \ ]
\ }

if !exists( 'g:cs_multiline_template' )
    let g:cs_multiline_template =
                \ "%s%\n"
                \ "%m% %cursor%\n"
                \ "%e%"
endif

if !exists( 'g:cs_ff_space' )   | let g:cs_ff_space = ''     | endif
if !exists( 'g:cs_fb_space' )   | let g:cs_fb_space = ' '    | endif
if !exists( 'g:cs_bf_space' )   | let g:cs_bf_space = '    ' | endif
if !exists( 'g:cs_bb_space' )   | let g:cs_bb_space = ' '    | endif
if !exists( 'g:cs_align_back' ) | let g:cs_align_back = 1    | endif
if !exists( 'g:cs_def_oneline_comment' ) | let g:cs_def_oneline_comment = "#" | endif
if !exists( 'g:cs_no_filetype_support' ) | let g:cs_no_filetype_support = 1   | endif
" }}}1
" SCOPED VARIABLES {{{1

" huge dictionary is camel case. small one is lower-letters.(ambiguous)
let s:CSObject = {
    \ 'Function': {},
    \ 'Option': {},
    \ 'SearchString': { 'Comment': {}, 'UnComment': {} },
    \ 'MultiCommentInfo': { 'replace_pat': '%[^%]\+%', 'option': {} },
    \ 'FileType': {
        \ 'prev_filetype': '', 'OneLineString': {}, 'MultiLineString': {}
    \ }
\ }
" this will be unlet in s:Init().
let s:mapping_table = {
    \ 'a': '<SID>Comment("'. g:cs_ca_mapping .'")',
    \ '0': '<SID>Comment( "0" )',
    \ '^': '<SID>Comment( "^" )',
    \ '$': '<SID>Comment( "$" )',
    \ 'm': '<SID>MultiComment()',
    \ 'c': '<SID>ToggleComment()',
    \ 'u': '<SID>UnComment()',
\}
" }}}1

" INITIALIZE {{{1
func! s:Init()
    " set comment string for some filetypes
    for [ftype, cmt_str] in g:cs_filetype_table.oneline
        let s:CSObject.FileType.OneLineString[ftype] = cmt_str
    endfor
    " TODO: multi-line (g:cs_filetype_table.multiline)
    unlet g:cs_filetype_table

    " mappings
    for i in keys( s:mapping_table )
        execute 'noremap <unique> <silent> '. g:cs_prefix . i
                    \   .'    :call '. s:mapping_table[i] .'<CR>'
    endfor
    unlet s:mapping_table

    " set comment string.
    call s:LoadWhenBufEnter()

    " delete CSStartUp group.
    augroup CSStartUp
        autocmd!
    augroup END
    augroup! CSStartUp

endfunc
" }}}1

" FUNCTION DEFINITIONS {{{1

" s:CSObject.Function.Slurp( first, last, funcname, ... ) {{{2
func! s:CSObject.Function.Slurp( first, last, funcname, ... )
    if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenBufEnter() | endif
    let i = a:first
    let argstr = join( a:000, ',' )

    while i <= a:last
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

" TODO
" s:CSObject.Function.MultiComment( has_range, ... ) {{{2
func! s:CSObject.Function.MultiComment( first, last, ... )
    " NOTE: no need to call ***.LoadVimCommentsOption(),
    " because called it from s:LoadWhenBufEnter()

    if a:first == a:last
        " has no range. (normal mode)
        let cmt_str = s:CSObject.Function.BuildMultiComment()
        echo cmt_str
    else
        " has a range. (visual mode)
        call s:Warn( 'not implemented yet.' )
    endif
endfunc
" }}}2

" s:CSObject.Function.BuildMultiComment() {{{2
func! s:CSObject.Function.BuildMultiComment()
    let replace_pat = s:CSObject.MultiCommentInfo.replace_pat
    while !empty( matchlist( g:cs_multiline_template, replace_pat ) )
    endwhile
endfunc
" }}}2

" TODO
" s:CSObject.Function.LoadVimCommentsOption() {{{2
func! s:CSObject.Function.LoadVimCommentsOption()
    let keep_empty = 1

    for i in split( &comments, ',' )
        let [key, val] = split( i, ':', keep_empty )
        for ch in split( key, '\zs' )
            if ch =~ '^[sme]$'   " if j is 's' or 'm' or 'e'.
                let s:CSObject.MultiCommentInfo.option[ch] = val
            endif
        endfor
    endfor
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

    call s:LoadWhenBufEnter()   " rebuild comment string.

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

" TODO
" <SID>MultiComment() range {{{2
func! <SID>MultiComment() range
    call s:Warn( 'not implemented yet.' )
endfunc
" }}}2

" s:Warn( msg ) {{{2
func! s:Warn( msg )
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}2

" }}}1

" AUTOCOMMAND {{{1
augroup CSBufEnter
    autocmd!
    autocmd BufEnter *   call s:LoadWhenBufEnter()
augroup END

augroup CSStartUp
    autocmd!
    autocmd VimEnter *      call s:Init()
augroup END

func! s:LoadWhenBufEnter()
    " return if filetype is same as previous one.
    if s:CSObject.FileType.prev_filetype != '' && &ft == s:CSObject.FileType.prev_filetype | return | endif

    " set oneline comment string
    if exists( 's:CSObject.FileType.OneLineString.'. &ft )
        let b:cs_oneline_comment = s:CSObject.FileType.OneLineString[&ft]
    else
        let b:cs_oneline_comment = g:cs_def_oneline_comment
    endif
    let s:CSObject.FileType.prev_filetype = &ft

    " load vim's 'comments' option for multi-line comment.
    call s:CSObject.Function.LoadVimCommentsOption()

    " build commented string for searching its commented line.
    let fcomment = escape( g:cs_ff_space . b:cs_oneline_comment . g:cs_fb_space, '/' )
    let bcomment = escape( g:cs_bf_space . b:cs_oneline_comment . g:cs_bb_space, '/' )

    let s:CSObject.SearchString.Comment['0']   = [ '^', fcomment ]
    let s:CSObject.SearchString.Comment['^']   = [ '^\(\s*\)', '\1'. fcomment ]
    let s:CSObject.SearchString.Comment['$']   = [ '$', bcomment ]
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
""" see s:mapping_table and s:Init()
" }}}1

" vim:set foldmethod=marker:fen:

