"==================================================
" Name: CommentSimply.vim
" Version: 0.0.1
" Author:  tyru <kz.whizy@gmail.com>
" Last Change: 2008-12-29.
"
" Change Log:
"   0.0.0: Initial Release
"   0.0.1: Fixed UnComment() uncomment in even multi commented line.
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
"     \cu   remove comment string.
"     TODO: \cm   add multi-comment string.
"     TODO: \cc   toggle comment/uncomment.
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

" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" GLOBAL VARIABLES {{{1
if exists( 'g:loaded_comment_simply' ) && g:loaded_comment_simply != 0
    finish
endif
let g:loaded_comment_simply = 1


if exists( 'g:cs_ca_mapping' )
    if g:cs_ca_mapping !~ '^[0^$t]$'
        call s:Warn( 'g:cs_ca_mapping is allowed one of "0", "^", "$", "t".' )
        let g:cs_ca_mapping = '^'
    endif
else
    let g:cs_ca_mapping = '^'
endif

if !exists( 'g:cs_ff_space' )   | let g:cs_ff_space = ''     | endif
if !exists( 'g:cs_fb_space' )   | let g:cs_fb_space = ' '    | endif
if !exists( 'g:cs_bf_space' )   | let g:cs_bf_space = '    ' | endif
if !exists( 'g:cs_bb_space' )   | let g:cs_bb_space = ' '    | endif

if !exists( 'g:cs_prefix' )
    if exists( 'mapleader' )
        let g:cs_prefix = mapleader . 'c'
    else
        let g:cs_prefix = '\c'
    endif
endif

if !exists( 'g:cs_align_back' ) | let g:cs_align_back = 1 | endif
" }}}1

" SCOPED VARIABLES {{{1
let s:fcomment  = ''
let s:bcomment  = ''
let s:comment   = {}
let s:uncomment = {}
" }}}1


" FUNCTION DEFINITIONS {{{1

" TODO: Align comment in case '$'
" <SID>Comment( ... ) range {{{2
func! <SID>Comment( ... ) range
    let pos =   a:0 == 0 ? g:cs_ca_mapping : a:1
    if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenFileType() | endif
    let i = a:firstline

    while i <= a:lastline
        if pos == '0'
            let replaced =
                        \ substitute( getline( i ), s:comment['0'][0], s:comment['0'][1], '' )
        elseif pos == '^'
            let replaced =
                        \ substitute( getline( i ), s:comment['^'][0], s:comment['^'][1], '' )
        elseif pos == '$'
            let replaced =
                        \ substitute( getline( i ), s:comment['$'][0], s:comment['$'][1], '' )
        endif

        call setline( i, replaced )
        let i = i + 1
    endwhile

    nohlsearch
endfunc
" }}}2

" <SID>UnComment() range {{{2
func! <SID>UnComment() range
    if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenFileType() | endif
    let i =  a:firstline

    while i <= a:lastline
        let line = getline( i )

        if matchstr( line, s:uncomment['0'][0] ) != ''
            " '0'
            let replaced = substitute(
                        \ line, s:uncomment['0'][0], s:uncomment['0'][1], '' )

        elseif matchstr( line, s:uncomment['^'][0] ) != ''
            " '^'
            let replaced = substitute(
                        \ line, s:uncomment['^'][0], s:uncomment['^'][1], '' )

        elseif matchstr( line, s:uncomment['$'][0] ) != ''
            " '$'
            "   NOTE: delete /[comment].*$/
            "   Perl: /^(?!\s*comment)(.*?)\s*comment.*
            let replaced = substitute(
                        \ line, s:uncomment['$'][0], s:uncomment['$'][1], '' )
        else
            let replaced = line
        endif

        call setline( i, replaced )
        let i = i + 1
    endwhile

    nohlsearch
endfunc
" }}}2

" <SID>ToggleComment() range {{{2
func! <SID>ToggleComment() range
    if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenFileType() | endif
    let i =  a:firstline

    while i <= a:lastline
        if s:IsCommentedLine( i )
            execute i .'UnComment'
        else
            execute i .'Comment'
        endif

        let i = i + 1
    endwhile

endfunc
" }}}2

func! s:IsCommentedLine( lnum )
    let line = getline( a:lnum )

    if matchstr( line, s:uncomment['0'][0] ) != ''
        return 1

    elseif matchstr( line, s:uncomment['^'][0] ) != ''
        return 1

    elseif matchstr( line, s:uncomment['$'][0] ) != ''
        " '$'
        "   NOTE: delete /[comment].*$/
        "   Perl: /^(?!\s*comment)(.*?)\s*comment.*
        return 1
    endif

    return 0
endfunc

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
augroup CSFileType
    autocmd!
    autocmd FileType *   call s:LoadWhenFileType()
augroup END

func! s:LoadWhenFileType()

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

    " build comment string
    let s:fcomment =
                \ escape( g:cs_ff_space . b:cs_oneline_comment . g:cs_fb_space, '/' )
    let s:bcomment =
                \ escape( g:cs_bf_space . b:cs_oneline_comment . g:cs_bb_space, '/' )

    let s:comment['0'] = [ '^', s:fcomment ]
    let s:comment['^'] = [ '^\(\s*\)', '\1'. s:fcomment ]
    let s:comment['$'] = [ '$', s:bcomment ]
    let s:uncomment['0'] = [ '^'. s:fcomment, '' ]
    let s:uncomment['^'] = [ '^\(\s\{-}\)'. s:fcomment, '\1' ]
    let s:uncomment['$'] = [ s:bcomment .'[^'. b:cs_oneline_comment .']*$', '' ]

endfunc

" }}}1

" COMMANDS {{{1
command! -nargs=*  CSOnelineComment
            \ call s:ChangeOnelineComment( <f-args> )
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
" execute 'noremap <unique> <silent> '. g:cs_prefix .'m'
"             \   .'    :call <SID>MultiComment()<CR>'

execute 'noremap <unique> <silent> '. g:cs_prefix .'u'
            \   .'    :call <SID>UnComment()<CR>'
" }}}1

" vim:set foldmethod=marker:fen:

