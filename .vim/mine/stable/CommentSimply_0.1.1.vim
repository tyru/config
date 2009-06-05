scriptencoding utf-8

" DOCUMENT {{{1
"==================================================
" Name: CommentSimply.vim
" Version: 0.1.1
" Author:  tyru <kz.whizy@gmail.com>
" Last Change: 2009-01-02.
"
" Change Log: {{{2
"   0.0.0: Initial release.
"   0.0.1: Fixed s:Function.UnComment() uncomment nested commented line.
"   0.0.2: Stable release.
"   0.0.3: Rewrite code in OOP.
"   0.0.4: Fix bug that comment string won't change when call :CSOnelineComment(THIS IS NOT CHANGED YET. FIXED IN VER 0.1.0)
"   0.0.5: Fix bug that s:Function.Slurp() won't slurp. (just see 1 line.)
"   0.0.6: Stable release.
"   0.0.7: Support multi-line comment. but there were a few problems yet.
"   0.0.8: Fix some problems about multi-line. and insert at tail of current line when 'gca'.
"   0.0.9: Stable release.
"   0.1.0: Fix bug that :CSOnelineComment won't change comment string. add many global variables and |gcw|
"   0.1.1: Implement g:cs_multiline_priority and so on. and Fix some bugs. and Change the g:cs_mapping_table mostly. old mappings are what a crazy mapings!!
" }}}2
"
" Usage:
"   COMMANDS: {{{2
"     CSOnelineComment [comment string]
"         (this takes arguments 0 or 1)
"         change current oneline comment string.
"
"     CSRevertComment
"         (this takes no arguments)
"         revert comment string.
"
"   }}}2
"
"   MAPPING: {{{2
"     In normal or visual mode,
"
"     gcc   if g:cs_map_c is default. this is the same as 'gci'.
"     gcI   add oneline comment string to the beginning of line.
"     gci   add oneline comment string to the beginning of non-space string.
"     gca   add oneline comment string to the end of line.
"     gcw   add oneline comment string to wrap the line.
"     gcm   add multi-comment string.
"     gct   toggle comment/uncomment.
"     gcu   remove comment string.
"     TODO: gcv{string}   add various comment.
"
"   }}}2
"
"   ACTION: {{{2
"     If global variables are all default value...
"
"     |gcI|
"       before:
"           'testtesttest'
"       after:
"           '# testtesttest'
"
"     |gci|
"       before:
"           '   <- inserted here'
"       after:
"           '   # <- inserted here'
"
"     |gca|
"       before:
"           'aaaaaaa'
"       after:
"           'aaaaaaa    # '
"       and when normal mode, insert insert-mode at the end of line.
"
"     |gcw|
"       before:
"           'aaaaaaa'
"       after:
"           '/* aaaaaaa */'
"
"    }}}2
"
"   GLOBAL VARIABLES: {{{2
"
"     g:cs_prefix (default:gc)
"         the prefix of mapping.
"         example, if you did
"             let g:cs_prefix = ',c'
"         so you can add comment at the beginning of line
"         by typing ',cI' or ',ci'(if g:cs_map_c is default, same as ',cc').
"         
"         my favorite mapping is '<LocalLeader>c'.
"         my maplocalleader is ';'. so this is the same as ';c'.
"
"     g:cs_map_c (default:'i')
"         if this is default value, 'gcc' is same as 'gci'.
"
"     g:cs_ff_space (default:'')
"         this is added before comment when 'gcI', 'gci'.
"
"     g:cs_fb_space (default:' ')
"         this is added after comment when 'gcI', 'gci'.
"
"     g:cs_bf_space (default: expandtab:'    ', noexpandtab:"\t")
"         this is added before comment when 'gca'.
"
"     g:cs_bb_space (default:' ')
"         this is added after comment when 'gca'.
"
"     g:cs_wrap_forward (default:'/* ')
"         this is added before the line when 'gcw'.
"
"     g:cs_wrap_back (default:' */')
"         this is added after the line when 'gcw'.
"
"     g:cs_multiline_insert (default:1)
"         true : insert at %cursor% of g:cs_multiline_template.
"         false: won't insert.
"
"     g:cs_zero_insert_if_blank (default:1)
"         when 'gcI', if normal mode, and current line is blank line,
"         insert after comment string.
"
"     g:cs_tilda_insert_if_blank (default:1)
"         when 'gci', if normal mode, and current line is blank line,
"         insert after comment string.
"
"     g:cs_dollar_insert (default:1)
"         insert after comment string.
"
"     g:cs_tilda_read_indent (default:1)
"         at blank line, insert comment after indent space when 'gci'.
"
"     TODO: g:cs_align_forward (default:1)
"         if true, align 'gci' comment.
"
"     TODO: g:cs_align_back (default:1)
"         if true, align 'gca' comment.
"
"     g:cs_def_oneline_comment (default:"#")
"         if couldn't find oneline comment string of current filetype.
"         use this string as it.
"
"     g:cs_filetype_table (default:read below.)
"         NOTE: WRITE THIS LATER.
"
"     g:cs_multiline_template (default:read below.)
"         NOTE: WRITE THIS LATER.
"
"     g:cs_multiline_insert_pos (default:'a')
"         'i': insert multi-line comment at current line
"         'a': insert multi-line comment at next line
"
"     TODO: g:cs_oneline_priority (default:[1, 0])
"         define priorities of the order of oneline comment.
"         0 : vim's |comments| option definition.
"         1 : my comment string definition.
"
"     g:cs_multiline_priority (default:[1, 0])
"         define priorities of the order of multi-line comment.
"         0 : vim's |comments| option definition.
"         1 : my comment string definition.
"
"     g:cs_mapping_table (default:read below.)
"         NOTE: WRITE THIS LATER.
"
"     TODO: g:cs_synonym_table
"         make synonym if you don't like my mappings.
"         even you can delete original mappings.
"
"     g:cs_verbose (default:0)
"         display verbose message.
"
"   }}}2
"
"     
"
"   TODO:
"     * align comment when 'gci, 'gca'
"     * do TODO. fix FIXME. check XXX.
"     * support comments type of
"           multi-line : '#if 0' ~ '#endif'
"     * write document at 'doc/CommentSimply.txt'.
"       not but in this script.
"     * make b:*** of same name of global variables.
"     * insert if, while, for, or and so on.
"
"
"
"==================================================
" vim:set foldmethod=marker:fen:
" }}}1

" INCLUDE GUARD {{{1
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

func! s:Debug( ... )
    echo 'eval '. string( a:1 )
    echo eval( a:1 )
endfunc
command! -nargs=* Debug   call s:Debug( <f-args> )

" }}}2

" s:ExtendUserSetting( global_var, template ) {{{2
"   extend a:global_var if it doesn't have.
"
"   type( {} ):
"       if a:global_var has a key of template:
"           let a:global_var[key]
"               \ = s:ExtendUserSetting( g:global_var[key], a:template[key] )
"       else:
"           assign.
"   type( [] ): TODO?
"   type( 0 ) or type( "" ):
"       * return a:global_var, not consider if a:global_var equals a:template.
func! s:ExtendUserSetting( global_var, template )
    if type( a:global_var ) != type( a:template )
        call s:Warn( 'E001', 'type( a:global_var ) != type( a:template )' )
        throw 'type error'
    endif

    let var = a:global_var
    " TODO: List
    if type( var ) == type( {} )
        " consider nests
        for i in keys( a:template )
            if has_key( var, i )
                let var[i] = s:ExtendUserSetting( var[i], a:template[i] )
            else
                let var[i] = a:template[i]
            endif
        endfor
    endif

    return var
endfunc
" }}}2

" s:Uniq( lis ) {{{2
func! s:Uniq( lis )
    if len( a:lis ) == 0 | return a:lis | endif
    let reduced = []

    for i in a:lis[1:]
        if [ a:lis[0] ] != [ i ]    " not same type exactly.
            let reduced += [ i ]
        endif
    endfor

    return [ a:lis[0] ] + s:Uniq( reduced )
endfunc
" }}}2

" }}}1

" GLOBAL VARIABLES {{{1

if ! exists( 'g:cs_ff_space' )
    let g:cs_ff_space = ''
endif
if ! exists( 'g:cs_fb_space' )
    let g:cs_fb_space = ' '
endif
if ! exists( 'g:cs_bf_space' )
    if &expandtab
        let g:cs_bf_space = '    '
    else
        let g:cs_bf_space = "\t"
    endif
endif
if ! exists( 'g:cs_bb_space' )
    let g:cs_bb_space = ' '
endif
if ! exists( 'g:cs_align_back' )
    let g:cs_align_back = 1
endif
if ! exists( 'g:cs_def_oneline_comment' )
    let g:cs_def_oneline_comment = "#"
endif
if ! exists( 'g:cs_multiline_insert' )
    let g:cs_multiline_insert = 1
endif
if ! exists( 'g:cs_zero_insert_if_blank' )
    let g:cs_zero_insert_if_blank = 1
endif
if ! exists( 'g:cs_tilda_insert_if_blank' )
    let g:cs_tilda_insert_if_blank = 1
endif
if ! exists( 'g:cs_dollar_insert' )
    let g:cs_dollar_insert = 1
endif
if ! exists( 'g:cs_verbose' )
    let g:cs_verbose = 0
endif


" g:cs_map_c
if exists( 'g:cs_map_c' )
    if g:cs_map_c !~ '^[0^$cu]$'
        call s:Warn( 'g:cs_map_c is allowed one of "a", "0", "^", "$", "m", "c", "u".' )
        let g:cs_map_c = '^'
    endif
else
    let g:cs_map_c = '^'
endif

" g:cs_multiline_insert_pos
if exists( 'g:cs_multiline_insert_pos' )
    if g:cs_multiline_insert_pos !~ '^[ia]$'
        call s:Warn( 'g:cs_multiline_insert_pos is allowed one of "i a".' )
        let g:cs_multiline_insert_pos = 'a'
    endif
else
    let g:cs_multiline_insert_pos = 'a'
endif

" g:cs_oneline_priority
if exists( 'g:cs_oneline_priority' )
    if type( g:cs_oneline_priority ) != type( [] ) || len( g:cs_oneline_priority ) != 2
        call s:Warn( 'your g:cs_oneline_priority is not valid value. use default.' )
        let g:cs_oneline_priority = [1, 0]
    endif
else
    let g:cs_oneline_priority = [1, 0]
endif

" g:cs_multiline_priority
if exists( 'g:cs_multiline_priority' )
    if type( g:cs_multiline_priority ) != type( [] ) || len( g:cs_multiline_priority ) != 2
        call s:Warn( 'your g:cs_multiline_priority is not valid value. use default.' )
        let g:cs_multiline_priority = [1, 0]
    endif
else
    let g:cs_multiline_priority = [1, 0]
endif


" g:cs_prefix
if ! exists( 'g:cs_prefix' )
    let g:cs_prefix = 'gc'
endif

" g:cs_wrap_forward
if ! exists( 'g:cs_wrap_forward' )
    let g:cs_wrap_forward = '/* '
endif

" g:cs_wrap_back
if ! exists( 'g:cs_wrap_back' )
    let g:cs_wrap_back = ' */'
endif

" g:cs_tilda_read_indent
if ! exists( 'g:cs_tilda_read_indent' )
    let g:cs_tilda_read_indent = 1
endif

" g:cs_filetype_table
let s:cs_filetype_table = {
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
        \ 'actionscript' : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'c'            : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'cpp'          : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'cs'           : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'd'            : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'java'         : { 's' : '/**',  'm' : ' *', 'e' : ' */' },
        \ 'javascript'   : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'objc'         : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'scheme'       : { 's' : '#|',   'm' : '',  'e' : '|#' },
        \ 'perl'         : { 's' : '=pod', 'm' : '',  'e' : '=cut' },
        \ 'ruby'         : { 's' : '=pod', 'm' : '',  'e' : '=cut' },
    \ },
\ }
if exists( 'g:cs_filetype_table' )
    try
        let g:cs_filetype_table = s:ExtendUserSetting( g:cs_filetype_table, s:cs_filetype_table )
    catch /type error/
        call s:Warn( 'type error: g:cs_filetype_table is Dictionary. use default.' )
        let g:cs_filetype_table = s:cs_filetype_table
    endtry
else
    let g:cs_filetype_table = s:cs_filetype_table
endif
unlet s:cs_filetype_table

" g:cs_multiline_template
let s:cs_multiline_template = { 's': '%s%', 'm': '%m% %cursor%', 'e': '%e%' }
if exists( 'g:cs_multiline_template' )
    try
        let g:cs_multiline_template =
            \ s:ExtendUserSetting( g:cs_multiline_template, s:cs_multiline_template )
    catch /type error/
        let msg = 'type error: g:cs_multiline_template is Dictionary. use default.' 
        call s:Warn( msg )
        let g:cs_multiline_template = s:cs_multiline_template
    endtry
else
    let g:cs_multiline_template = s:cs_multiline_template
endif
unlet s:cs_multiline_template

" this will be unlet in s:Init().
let s:cs_mapping_table = {
    \ 'c': 'Comment("'. g:cs_map_c .'")',
    \ 'I': 'Comment( "0" )',
    \ 'i': 'Comment( "^" )',
    \ 'a': 'Comment( "$" )',
    \ 'w': 'Comment( "w" )',
    \ 'm': 'MultiComment()',
    \ 't': 'ToggleComment()',
    \ 'u': 'UnComment()',
\}
if exists( 'g:cs_mapping_table' )
    try
        let g:cs_mapping_table =
            \ s:ExtendUserSetting( g:cs_mapping_table, s:cs_mapping_table )
    catch /type error/
        let msg = 'type error: g:cs_multiline_template is Dictionary. use default.' 
        call s:Warn( msg )
        let g:cs_mapping_table = s:cs_mapping_table
    endtry
else
    let g:cs_mapping_table = s:cs_mapping_table
endif
unlet s:cs_mapping_table
" }}}1

" SCOPED VARIABLES {{{1
" huge dictionary is camel case. small one is lower-letters.(ambiguous)
"
let s:Function = {}
let s:SearchString = { 'Comment': {}, 'UnComment': {} }
let s:FileType = { 'prev_filetype': '', 'OneLineString': {}, 'MultiLineString': { 'setting': {}, 'option': {}, 'range_buffer': '', 'priorities_table': ['option', 'setting']} }
" }}}1

" INITIALIZE {{{1
func! s:Init()
    " set comment string for some filetypes.
    let s:FileType.OneLineString
                \ = deepcopy( g:cs_filetype_table.oneline )
    " user's(and my) settings.
    let s:FileType.MultiLineString.setting
                \ = deepcopy( g:cs_filetype_table.multiline )
    unlet g:cs_filetype_table

    " mappings
    for i in keys( g:cs_mapping_table )
        execute 'noremap <unique> <silent> '. g:cs_prefix . i
                    \   ."    :call <SID>". g:cs_mapping_table[i] .'<CR>'
    endfor
    unlet g:cs_mapping_table

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

" s:Function.BuildOneLineComments() {{{2
func! s:Function.BuildOneLineComments()
    " build commented string for searching its commented line.
    let fcomment =
        \ escape( g:cs_ff_space . b:cs_oneline_comment . g:cs_fb_space, '/' )
    let bcomment =
        \ escape( g:cs_bf_space . b:cs_oneline_comment . g:cs_bb_space, '/' )

    let s:SearchString.Comment['0']
                \ = [ '^',
                \     fcomment ]
    let s:SearchString.Comment['^']
                \ = [ '^\(\s*\)',
                \     '\1'. fcomment ]
    let s:SearchString.Comment['$']
                \ = [ '$',
                \      bcomment ]
    let s:SearchString.Comment['w']
                \ = [ '^\(\s*\)\(.*\)$',
                \     '\1'. g:cs_wrap_forward .'\2'. g:cs_wrap_back ]
    let s:SearchString.UnComment['0']
                \ = [ '^'. fcomment,
                \     '' ]
    let s:SearchString.UnComment['^']
                \ = [ '^\(\s\{-}\)'. fcomment,
                \     '\1' ]
    " delete /[comment].*$/
    " In Perl: /^(?!\s*comment)(.*?)\s*comment.*
    let s:SearchString.UnComment['$']
                \ = [ bcomment .'[^'. b:cs_oneline_comment .']*$',
                \     '' ]
    let s:SearchString.UnComment['w']
                \ = [ g:cs_wrap_forward .'\(.*\)'. g:cs_wrap_back,
                \     '\1' ]
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

    call s:Function.BuildOneLineComments()    " rebuild comment string.

    if b:cs_oneline_comment ==# '"'
        echo "changed to '". b:cs_oneline_comment ."'."
    else
        echo 'changed to "'. b:cs_oneline_comment .'".'
    endif
endfunc
" }}}2

" s:Function.Slurp( first, last, funcname, ... ) {{{2
func! s:Function.Slurp( first, last, funcname, ... )
    if ! exists( 'b:cs_oneline_comment' ) | call s:LoadWhenBufEnter() | endif
    let i = a:first
    let line = getline( i )

    if empty( a:000 )
        let argstr = ''
    else
        let lis = copy( a:000 )
        call map( lis, '"\"" . v:val . "\""')
        let argstr = join( lis, ',' )
    endif

    " slurp lines
    while i <= a:last
        execute 'call setline( i, s:Function.'. a:funcname .'( i, '. argstr .' ) )'
        let i = i + 1
    endwhile


    " normal mode
    if a:first == a:last
        " insert at tail of current line when calling Comment()
        if a:funcname == 'Comment'
            if a:1 == '0'
                if line =~ '^\s*$' && g:cs_zero_insert_if_blank
                    call feedkeys( 'A', 'n' )
                endif
            elseif a:1 == '^'
                if line =~ '^\s*$' && g:cs_tilda_insert_if_blank
                    call feedkeys( 'A', 'n' )
                endif
            elseif a:1 == '$'
                if g:cs_dollar_insert
                    call feedkeys( 'A', 'n' )
                endif
            endif
        endif
    endif

    nohlsearch
endfunc
" }}}2

" TODO: Align comment in case '$'
" s:Function.Comment( lnum, ... ) {{{2
func! s:Function.Comment( lnum, ... )
    let pos     = a:0 ==# 0 ?       g:cs_map_c : a:1
    let comment = s:SearchString.Comment
    let line    = getline( a:lnum )

    if pos == '^' && g:cs_tilda_read_indent
        if line =~ '^\s*$'  " blank line
            let indent = s:Function.GetIndent( str2nr( a:lnum ) )
            if &expandtab
                let space = repeat( ' ', indent )
            else
                let space = repeat( "\t", indent / &tabstop )
            endif
            return substitute( line, comment[pos][0], space . comment[pos][1], '' )
        endif
    endif

    return substitute( line, comment[pos][0], comment[pos][1], '' )
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

" s:Function.LoadVimCommentsOption() {{{2
func! s:Function.LoadVimCommentsOption()
    let keep_empty    = 1
    let head_space    = '0'
    let option = s:FileType.MultiLineString.option
    if &ft == ''              | return | endif
    if has_key( option, &ft )
        " cache
        return
    else
        " make a key
        let option[&ft] = {}
    endif


    for i in split( &comments, ',' )
        let [key; vals] = split( i, ':', keep_empty )
        let matched = matchstr( key, '[sme]' )
        if key =~ '0' || matchstr( key, '[sme]' ) == '' || matched == ''
            continue
        endif

        call filter( vals, "v:val != ''" )
        let val = vals[0]

        if matched ==# 's' && key =~ '[1-9]'
            let head_space = matchstr( key, '[1-9]' )
        elseif matched ==# 'm' || matched ==# 'e'
            let val = repeat( ' ', head_space ) . val
        endif
        call extend( option[&ft], { matched : val } )
    endfor
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

    let cmts_lis = s:Function.BuildMultiComments()
    if empty( cmts_lis ) | return | endif
    let cmt_str = join( cmts_lis, "\n" )

    if a:first ==# a:last
        " has no range. (normal mode)
        call s:Function.InsertString( cmt_str, g:cs_multiline_insert_pos )
        " push this command (move to where %cursor% exists,
        " delete it, enter insert mode) to vim's stack.
        if search( '%cursor%', 'Wbc' )
            if g:cs_multiline_insert
                call feedkeys( 'v7lc', 'n' )
            else
                call feedkeys( 'v7ld', 'n' )
            endif
        endif
    else
        " has a range. (visual mode)
        call s:Function.InsertString( cmt_str, g:cs_multiline_insert_pos )
        if search( '%cursor%', 'Wbc' )
            if g:cs_multiline_insert
                call feedkeys( 'v7lc', 'n' )
            else
                call feedkeys( 'v7ld', 'n' )
            endif
        endif
        call s:Function.InsertString( s:FileType.MultiLineString.range_buffer, 'here' )
    endif
endfunc
" }}}2

" s:Function.ExistsMultiLineComment( ... ) {{{2
func! s:Function.ExistsMultiLineComment( ... )
    if a:0 == 0
        let table = s:FileType.MultiLineString.priorities_table
    elseif type( a:1 ) == type( [] )
        let table = a:1
    endif

    for i in g:cs_multiline_priority
        let option_or_setting = s:FileType.MultiLineString[ table[i] ]
        " if s:Function.CanGetKeyList( option_or_setting, &ft, ['s', 'm', 'e'] )
        if has_key( option_or_setting, &ft )
          \ && has_key( option_or_setting[&ft] , 's' )
          \ && has_key( option_or_setting[&ft] , 'm' )
          \ && has_key( option_or_setting[&ft] , 'e' )
            return 1
        endif
    endfor

    return 0
endfunc
" }}}2

" s:Function.CanGetKeyList( dict, ... ) {{{2
"   return if a:dict has keys of a:000
func! s:Function.CanGetKeyList( dict, keys )
    if type( a:dict ) != type( {} ) | return 0 | endif
    if empty( a:keys )              | return 1 | endif    " reach the end.
    let [key; key_chain] = a:keys

    if has_key( a:dict, key ) && type( a:dict[key] ) == type( {} )
        return s:Function.CanGetKeyList( a:dict[key], key_chain )
    else
        " a:dict[key] doesn't have key because not a dictionary.
        return 0
    endif
endfunc
" }}}2

" s:Function.BuildMultiComments() {{{2
func! s:Function.BuildMultiComments()
    let table       = s:FileType.MultiLineString.priorities_table
    let template    = g:cs_multiline_template
    let result_lis  = []
    let debug       = {}


    for i in ['s', 'm', 'e']
        let replace_pat = '%\('. i .'\)%'
        let lis = matchlist( template[i], replace_pat )
        if empty( lis )
            " FIXME: check in the global variable initialization.
            let fmt = "'%%%s%%' is not found in g:cs_multiline_template['%s']: '%s'"
            call s:Warn( printf( fmt, i, i, g:cs_multiline_template[i] ) )
            call s:Warn( 'use default value.' )
            let g:cs_multiline_template = s:cs_multiline_template
            return s:Function.BuildMultiComments()
        endif

        " matched: %s%, %m%, %e%
        " key    : s, m, e
        let [matched, key; unko] = lis

        for order in g:cs_multiline_priority
            let debug[i] = table[order]

            " cmts_def: e.g.: { 'cpp': { 's': '/*', 'm': '*', 'e': '*/' }, ... }
            let cmts_def = s:FileType.MultiLineString[ table[order] ]
            " if s:Function.CanGetKeyList( cmts_def, [&ft, key] )
            if has_key( cmts_def, &ft ) && has_key( cmts_def[&ft], key )
                let result_lis +=
                    \ [ substitute( template[i], matched, cmts_def[&ft][key], 'g' ) ]
                break
            endif
        endfor
    endfor


    " some checks.
    if empty( result_lis )
        call s:Warn( 'not found comments definition...' )
        return result_lis
    endif
    let uniqed = s:Uniq( values( debug ) )
    if len( uniqed ) != 1
        if g:cs_verbose
            call s:Warn( "used 2 types comments definition." )
            " debug message
            let msg = []
            for i in ['s', 'm', 'e']
                let msg += [ i .':'. get( debug, i, '' ) ]
            endfor
            call s:Warn( join( msg, ', ' ) )
        endif
    endif

    return result_lis
endfunc
" }}}2

" s:Function.InsertString( str, pos ) {{{2
func! s:Function.InsertString( str, pos )
    if a:str == '' | return | endif
    let keep_empty = 1

    " build inserted string
    let indent    = s:Function.GetIndent( '.' )
    let lines     = split( a:str, "\n", keep_empty )
    if &expandtab
        let space = repeat( ' ', indent )
    else
        let space = repeat( "\t", indent / &tabstop )
    endif
    let lines     = map( lines, 'space . v:val' )

    let reg_z     = @z
    let @z        = join( lines, "\n" )
    let opt_paste = &paste
    setl paste

    " insert
    if exists( ':AutoComplPopLock' )   | AutoComplPopLock   | endif
    if a:pos ==# 'here'
        setl nopaste
        execute "normal a\<C-r>z"
    else
        if a:pos ==# 'i' && line( '.' ) != 1
            normal k
        endif
        put z
    endif
    if exists( ':AutoComplPopUnLock' ) | AutoComplPopUnlock | endif

    " reverse paste
    let &paste = opt_paste
    let @z     = reg_z
endfunc
" }}}2

" s:Function.GetIndent( lnum_or_expr ) {{{2
func! s:Function.GetIndent( lnum_or_expr )
    let cur_line = line( '.' )
    if type( a:lnum_or_expr ) == type( "" )
        let lnum = line( a:lnum_or_expr )
    else
        let lnum = a:lnum_or_expr
    endif
    " via :help fo-table
    "   o   Automatically insert the current comment leader after hitting 'o' or
    "       'O' in Normal mode.
    let save_fo = &formatoptions
    setl formatoptions+=o


    execute 'normal '. lnum .'gg'
    " get indent num of that line.
    execute 'normal O'.'unko'
    let indent = indent('.')
    silent undo

    execute 'normal '. cur_line .'gg'
    let &formatoptions = save_fo

    return indent
endfunc
" }}}2

" <SID>Comment( ... ) range {{{2
func! <SID>Comment( ... ) range
    let pos =   a:0 ==# 0 ?     g:cs_map_c : a:1
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

" <SID>MultiComment() range {{{2
func! <SID>MultiComment() range
    let save_z = @z
    if a:firstline != a:lastline
        normal "zd
        let s:FileType.MultiLineString.range_buffer = @z
    endif
    let @z = save_z

    call s:Function.MultiComment( a:firstline, a:lastline )
endfunc
" }}}2

" }}}1

" AUTOCOMMAND {{{1
augroup CSBufEnter
    autocmd!
    autocmd BufEnter *   call s:LoadWhenBufEnter()
augroup END

" this group will be deleted after Vim starts up.
augroup CSStartUp
    autocmd!
    autocmd VimEnter *      call s:Init()
augroup END

func! s:LoadWhenBufEnter()
    " return if filetype is same as previous one.
    if s:FileType.prev_filetype !=# '' && &ft ==# s:FileType.prev_filetype
        return
    endif

    " set oneline comment string
    if has_key( s:FileType.OneLineString, &ft )
        let b:cs_oneline_comment = s:FileType.OneLineString[&ft]
    else
        let b:cs_oneline_comment = g:cs_def_oneline_comment
    endif
    let s:FileType.prev_filetype = &ft

    call s:Function.LoadVimCommentsOption()    " for multi-line comment.
    call s:Function.BuildOneLineComments()
endfunc
" }}}1

" COMMANDS {{{1
command! -nargs=?           CSOnelineComment
            \ call s:Function.ChangeOnelineComment( <f-args> )
" }}}1

" MAPPINGS {{{1
""" see g:cs_mapping_table and s:Init()
" }}}1

" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1

