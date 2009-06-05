"==================================================
" Name: CommentSimply.vim
" Version: 0.0.8
" Author:  tyru <kz.whizy@gmail.com>
" Last Change: 2008-12-31.
"
" Change Log:
"   0.0.0: Initial release.
"   0.0.1: Fixed s:Function.UnComment() uncomment nested commented line.
"   0.0.2: Stable release.
"   0.0.3: Rewrite code in OOP.
"   0.0.4: Fix bug that comment string won't change when call :CSOnelineComment
"   0.0.5: Fix bug that s:Function.Slurp() won't slurp. (just see 1 line.)
"   0.0.6: Stable release.
"   0.0.7: Support multi-line comment. but there were a few problems yet.
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
"     \cm   add multi-comment string.
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
"     g:cs_multiline_insert_pos (default:'i')
"         'i': insert multi-line comment at current line
"         'a': insert multi-line comment at next line
"
"     TODO: g:cs_priority (default:[0, 1])
"         NOTE: WRITE THIS LATER.
"     
"
"   TODO:
"     * align behind comment.
"     * enter insert mode when '\c$'
"     * call s:Init() when receiving VimEnter (for loading time while starting up.)
"     * get top-level object lower.
"     * process %cursor% in g:cs_multiline_template
"     * support some flags of vim's 'comments' option.
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

" SOME UTILITY FUNCTIONS {{{1
" s:Warn( msg, ... ) {{{2
func! s:Warn( msg, ... )
    echohl WarningMsg

    if a:0 ==# 0
        echo a:msg
    else
        let [errID, msg] = [a:msg, a:1]
        echo 'Sorry, internal error.'
        echo printf( 'errID:%s msg:%s', errID, msg )
    endif

    echohl None
endfunc
" }}}2
" }}}1

" GLOBAL VARIABLES {{{1
if exists( 'g:cs_ca_mapping' )
    if g:cs_ca_mapping !~ '^[0^$cu]$'
        call s:Warn( 'g:cs_ca_mapping is allowed one of "a", "0", "^", "$", "m", "c", "u".' )
        let g:cs_ca_mapping = '^'
    endif
else
    let g:cs_ca_mapping = '^'
endif

if exists( 'g:cs_multiline_insert_pos' )
    if g:cs_multiline_insert_pos !~ '^[ia]$'
        call s:Warn( 'g:cs_multiline_insert_pos is allowed one of "i a".' )
        let g:cs_multiline_insert_pos = 'i'
    endif
else
    let g:cs_multiline_insert_pos = 'i'
endif

if exists( 'g:cs_priority' )
    if type( g:cs_priority ) != type( [] ) || len( g:cs_priority ) != 2
        call s:Warn( 'your g:cs_priority is not valid value. use default.' )
        let g:cs_priority = [ 0, 1 ]
    endif
else
    let g:cs_priority = [ 0, 1 ]
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
    \ 'oneline': {
        \ 'actionscript' : '//', 
        \ 'c'            : '//', 
        \ 'cpp'          : '//', 
        \ 'cs'           : '//', 
        \ 'd'            : '//', 
        \ 'java'         : '//', 
        \ 'javascript'   : '//', 
        \ 'objc'         : '//', 
        \ 'asm'          : ';', 
        \ 'lisp'         : ';', 
        \ 'scheme'       : ';', 
        \ 'vb'           : ';', 
        \ 'perl'         : '#', 
        \ 'python'       : '#', 
        \ 'ruby'         : '#', 
        \ 'vim'          : '"', 
        \ 'vimperator'   : '"', 
        \ 'dosbatch'     : 'rem', 
    \ },
    \ 'multiline': {
        \ 'actionscript': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'c': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'cpp': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'cs': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'd': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'java': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'javascript': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'objc': { 's': '/*', 'm': '*', 'e': '*/' },
        \ 'scheme': { 's': '#|', 'm': '', 'e': '|#' },
        \ 'perl': { 's': '=pod', 'm': '', 'e': '=cut' },
        \ 'ruby': { 's': '=pod', 'm': '', 'e': '=cut' },
    \ },
\ }

if !exists( 'g:cs_multiline_template' )
    let g:cs_multiline_template =
                \ "%s%\n".
                \ "%m% %cursor%\n".
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
"
" replace_pat is In Perl: %([^%]+?)%
let s:Function = {}
let s:SearchString = { 'Comment': {}, 'UnComment': {} }
let s:MultiCommentInfo = { 'replace_pat': '%\([sme]\)%', 'option': {} }
let s:FileType = { 'prev_filetype': '', 'OneLineString': {}, 'MultiLineString': {} }

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
    let s:FileType.OneLineString   = deepcopy( g:cs_filetype_table.oneline )
    let s:FileType.MultiLineString = deepcopy( g:cs_filetype_table.multiline )
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

" s:Function.Slurp( first, last, funcname, ... ) {{{2
func! s:Function.Slurp( first, last, funcname, ... )
    if !exists( 'b:cs_oneline_comment' ) | call s:LoadWhenBufEnter() | endif
    let i = a:first
    let argstr = join( a:000, ',' )

    while i <= a:last
        execute 'call setline( i, s:Function.'. a:funcname .'( i, argstr ) )'
        let i = i + 1
    endwhile

    " insert at tail of current line
    " when calling Comment(), with '$', and not in visual mode.
    if a:funcname == 'Comment' && a:1 == '$' && a:first == a:last
        call feedkeys( 'A', 'n' )
    endif

    nohlsearch
endfunc
" }}}2

" s:Function.Comment( lnum, ... ) {{{2
func! s:Function.Comment( lnum, ... )
    let pos =   a:0 ==# 0 ? g:cs_ca_mapping : a:1
    let comment = s:SearchString.Comment
    return substitute( getline( a:lnum ), comment[pos][0], comment[pos][1], '' )
endfunc
" }}}2

" s:Function.UnComment( lnum, ... ) {{{2
func! s:Function.UnComment( lnum, ... )
    let line = getline( a:lnum )
    let uncomment = s:SearchString.UnComment

    for i in ['0', '^', '$']
        if matchstr( line, s:SearchString.UnComment[i][0] ) !=# ''
            let line = substitute( line, uncomment[i][0], uncomment[i][1], '' )
        endif
    endfor
    return line
endfunc
" }}}2

" s:Function.ToggleComment( lnum, ... ) {{{2
func! s:Function.ToggleComment( lnum, ... )
    if s:Function.IsCommentedLine( a:lnum )
        return s:Function.UnComment( a:lnum )
    else
        return s:Function.Comment( a:lnum )
    endif
endfunc
" }}}2

" s:Function.IsCommentedLine( lnum ) {{{2
func! s:Function.IsCommentedLine( lnum )
    let line = getline( a:lnum )
    for i in ['0', '^', '$']
        if matchstr( line, s:SearchString.UnComment[i][0] ) !=# ''
            return 1
        endif
    endfor
    return 0
endfunc
" }}}2

" TODO
" s:Function.MultiComment( first, last ) {{{2
func! s:Function.MultiComment( first, last )
    " NOTE: no need to call ***.LoadVimCommentsOption(),
    " because called it from s:LoadWhenBufEnter()

    if ! s:Function.ExistsMultiLineComment()
        call s:Warn( "current filetype doesn't have multi-line comment string." )
        return
    endif

    if a:first ==# a:last
        " has no range. (normal mode)
        let cmt_str = s:Function.BuildMultiComment()
        if cmt_str !=# ''
            call s:Function.InsertString( cmt_str, g:cs_multiline_insert_pos )
        endif
    else
        " has a range. (visual mode)
        call s:Warn( "haven't supported multi-line comment in visual mode." )
    endif
endfunc
" }}}2

" s:Function.ExistsMultiLineComment() {{{2
func! s:Function.ExistsMultiLineComment()
    let option = s:MultiCommentInfo.option
    return has_key( option, 's' ) && has_key( option, 'm' ) && has_key( option, 'e' )
endfunc
" }}}2

" s:Function.InsertString( str, pos ) {{{2
func! s:Function.InsertString( str, pos )
    let keep_empty = 1

    " build inserted string
    let indent   = s:Function.GetIndent( '.' )
    let lines    = split( a:str, "\n", keep_empty )
    if &expandtab
        let space = repeat( ' ', indent )
    else
        let space = repeat( "\t", indent / &tabstop )
    endif
    let lines = map( lines, 'space . v:val' )

    let reg_z     = @z
    let @z        = join( lines, "\n" )
    let opt_paste = &paste
    setl paste

    " insert
    if exists( ':AutoComplPopLock' )   | AutoComplPopLock   | endif
    if a:pos ==# 'i'
        normal O
    else
        normal o
    endif
    execute "normal i\<C-r>z"
    if exists( ':AutoComplPopUnLock' ) | AutoComplPopUnlock | endif

    " reverse paste
    let &paste = opt_paste
    let @z     = reg_z

    " push this command (move to where %cursor% exists,
    " delete it, enter insert mode) to vim's stack.
    call feedkeys( "?%cursor%\<CR>v7lc", 'n' )

    return 1
endfunc
" }}}2

" s:Function.GetIndent( lnum ) {{{2
func! s:Function.GetIndent( lnum )
    let cur_line = line('.')
    let lnum = line( a:lnum )

    execute 'normal '. lnum .'gg'
    " get indent num of that line.
    execute "normal O".'unko'
    let indent = indent('.')
    silent undo

    execute 'normal '. cur_line .'gg'

    return indent
endfunc
" }}}2

" s:Function.BuildMultiComment() {{{2
func! s:Function.BuildMultiComment()
    let template    = g:cs_multiline_template
    let replace_pat = s:MultiCommentInfo.replace_pat
    let option      = s:MultiCommentInfo.option
    let errored     = 0

    while 1
        let lis = matchlist( template, replace_pat )
        if empty( lis ) | break | endif
        let [matched, key; unko] = lis

        if get( option, lis[1], -1 ) ==# -1
            call s:Warn( 'key '. lis[1] ." doesn't exists" )
            let errored = 1
            break
        endif

        let template = substitute( template, lis[0], option[lis[1]], '' )
    endwhile

    return errored ? '' : template
endfunc
" }}}2

" TODO
" s:Function.LoadVimCommentsOption() {{{2
func! s:Function.LoadVimCommentsOption()
    let keep_empty    = 1
    let no_key_values = []
    let head_space    = 0

    let s:MultiCommentInfo.option = {}

    for i in split( &comments, ',' )
        let [key; vals] = split( i, ':', keep_empty )
        let matched = matchstr( key, '[sme]' )

        if key =~ '0'
            continue
        elseif matched == ''
            continue
        elseif key == ''
            let no_key_values += filter( vals, "v:val != ''" )
            continue
        endif

        " XXX: tekitou
        call filter( vals, "v:val != ''" )
        let val = vals[0]

        " FIXME: FileType 'vim' has strange multi-line string.
        if matched ==# 's' && key =~ '[0-9]'
            let head_space = matchstr( key, '[0-9]' )
        elseif matched ==# 'm' || matched ==# 'e'
            let val = repeat( ' ', head_space ) . val
        endif
        let s:MultiCommentInfo.option[matched] = val
    endfor
endfunc
" }}}2

" s:Function.ChangeOnelineComment( ... ) {{{2
func! s:Function.ChangeOnelineComment( ... )
    if a:0 ==# 1
        let b:cs_oneline_comment = a:1
    else
        let oneline_comment = input( 'oneline comment:' )
        if oneline_comment !=# ''
            let b:cs_oneline_comment = oneline_comment
        else
            echo 'not changed.'
            return
        endif
    endif

    call s:LoadWhenBufEnter()   " rebuild comment string.

    if b:cs_oneline_comment ==# '"'
        echo "changed to '". b:cs_oneline_comment ."'."
    else
        echo 'changed to "'. b:cs_oneline_comment .'".'
    endif
endfunc
" }}}2

" TODO: Align comment in case '$'
" <SID>Comment( ... ) range {{{2
func! <SID>Comment( ... ) range
    let pos =   a:0 ==# 0 ? g:cs_ca_mapping : a:1
    call s:Function.Slurp( a:firstline, a:lastline, 'Comment', pos )
endfunc
" }}}2

" <SID>UnComment() range {{{2
func! <SID>UnComment() range
    call s:Function.Slurp( a:firstline, a:lastline, 'UnComment' )
endfunc
" }}}2

" <SID>ToggleComment() range {{{2
func! <SID>ToggleComment() range
    call s:Function.Slurp( a:firstline, a:lastline, 'ToggleComment' )
endfunc
" }}}2

" TODO
" <SID>MultiComment() range {{{2
func! <SID>MultiComment() range
    call s:Function.MultiComment( a:firstline, a:lastline )
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
    if s:FileType.prev_filetype !=# '' && &ft ==# s:FileType.prev_filetype | return | endif

    " set oneline comment string
    if has_key( s:FileType.OneLineString, &ft )
        let b:cs_oneline_comment = s:FileType.OneLineString[&ft]
    else
        let b:cs_oneline_comment = g:cs_def_oneline_comment
    endif
    let s:FileType.prev_filetype = &ft

    " load vim's 'comments' option for multi-line comment.
    call s:Function.LoadVimCommentsOption()

    " build commented string for searching its commented line.
    let fcomment = escape( g:cs_ff_space . b:cs_oneline_comment . g:cs_fb_space, '/' )
    let bcomment = escape( g:cs_bf_space . b:cs_oneline_comment . g:cs_bb_space, '/' )

    let s:SearchString.Comment['0']   = [ '^', fcomment ]
    let s:SearchString.Comment['^']   = [ '^\(\s*\)', '\1'. fcomment ]
    let s:SearchString.Comment['$']   = [ '$', bcomment ]
    let s:SearchString.UnComment['0'] = [ '^'. fcomment, '' ]
    let s:SearchString.UnComment['^'] = [ '^\(\s\{-}\)'. fcomment, '\1' ]
    " delete /[comment].*$/
    " In Perl: /^(?!\s*comment)(.*?)\s*comment.*
    let s:SearchString.UnComment['$'] = [ bcomment .'[^'. b:cs_oneline_comment .']*$', '' ]
endfunc
" }}}1

" COMMANDS {{{1
command! -nargs=*  CSOnelineComment
            \ call s:Function.ChangeOnelineComment( <f-args> )
command! -range    Comment
            \ <line1>,<line2>call <SID>Comment( <f-args> )
command! -range    UnComment
            \ <line1>,<line2>call <SID>UnComment()
" }}}1

" MAPPINGS {{{1
""" see s:mapping_table and s:Init()
" }}}1

" vim:set foldmethod=marker:fen:

