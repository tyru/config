scriptencoding utf-8

"-----------------------------------------------------------------
" DOCUMENT {{{1
"==================================================
" Name: CommentAnyWay.vim
" Version: 0.1.4
" Author: vimuma
" Last Change: 2009-01-06.
"
" Change Log: {{{2
"   0.0.0: Initial release.
"   0.0.1: Fixed s:UnComment() uncomment nested commented line.
"   0.0.2: Stable release.
"   0.0.3: Rewrite code in OOP.
"   0.0.4: Fix bug that comment won't change when call :CSOnelineComment(THIS IS NOT CHANGED YET. FIXED IN VER 0.1.0)
"   0.0.5: Fix bug that s:Slurp() won't slurp. (just see 1 line.)
"   0.0.6: Stable release.
"   0.0.7: Support multi-line comment. but there were a few problems yet.
"   0.0.8: Fix some problems about multi-line. and insert at tail of current line when 'gca'.
"   0.0.9: Stable release.
"   0.1.0: Fix bug that :CSOnelineComment won't change comment. add many global variables and |gcw|
"   0.1.1: Implement g:cs_multiline_priority and so on. and Fix some bugs. and Change the g:cs_mapping_table mostly. old mappings are what a crazy mapings!!
"   0.1.2: Fix some bugs and implement |gco| and |gcO| and so on.
"   0.1.3: Implement wrap-line definition. and fix some bugs.
"   0.1.3: Implement JumpComment and fix some bugs?
" }}}2
"
" Usage:
"   COMMANDS: {{{2
"     CSOnelineComment [comment]
"         (this takes arguments 0 or 1)
"         change current one-line comment.
"
"     CSRevertComment
"         (this takes no arguments)
"         revert comment.
"
"   }}}2
"
"   MAPPING: {{{2
"     In normal mode:
"       If you typed digits string([1-9]) before typing these mappings,
"       behave like in visual mode.
"       so you want to see when you gave digits string, see "In visual mode".
"
"       gcc
"           if g:cs_map_c is default. this is the same as |gct|.
"       gcI
"           add one-line comment to the beginning of line.
"       gci
"           add one-line comment to the beginning of non-space string(\S).
"       gca
"           add one-line comment to the end of line.
"       gcu
"           type is one of 'c I i a'.
"           remove one-line comment.
"       gcw
"           add one-line comment to wrap the line.
"       gcm
"           add multi-comment.
"       gct
"           toggle comment/uncomment.
"       TODO: gcv{wrap}{action}
"           add various comment.
"       gcj{jump}{action}
"           jump before add comment.
"
"
"     In visual mode:
"
"       gcc
"           if g:cs_map_c is default. this is the same as |gct|.
"       gcI
"           add one-line comment to the beginning of line.
"       gci
"           add one-line comment to the beginning of non-space string(\S).
"       gca
"           add one-line comment to the end of line.
"       gcu{type}
"           type is one of 'c I i a'.
"           remove one-line comment.
"       gcw
"           add one-line comment to wrap the line.
"       TODO: gcm
"           add multi-comment.
"       gct
"           toggle comment/uncomment.
"       TODO: gcv{string}
"           add various comments.
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
"   VARIOUS COMMENTS: {{{2
"     one-line comment: |gcI|, |gci|, |gca|
"     wrapping comment: |gcw|
"     jump and comment: |gco|, |gcO|
"     multi-line comment: |gcm|
"   }}}2
"
"   GLOBAL VARIABLES: {{{2
"       There are two type variables(b:*** and g:***)
"       except cs_filetype_table, cs_mapping_table, cs_verbose.
"
"
"     cs_prefix (default:gc)
"         the prefix of mapping.
"         example, if you did
"             let g:cs_prefix = ',c'
"         so you can add comment at the beginning of line
"         by typing ',cI' or ',ci'
"         
"         my favorite mapping is '<LocalLeader>c'.
"         my maplocalleader is ';'. so this is the same as ';c'.
"
"     cs_map_c (default:'i')
"         if this is default value, |gcc| is same as |gci|.
"         allowed 'I', 'i', 'a', 't', 'o', 'O'.
"
"     cs_oneline_comment (default:"#")
"         if couldn't find one-line comment of current filetype.
"         use this as its comment.
"
"     cs_toggle_comment (default:'i')
"         this is used when |gct| comment(or uncomment) the line.
"         if this is default, |gct| would behave like |gci| and |gcui| each line.
"
"     cs_jump_comment (default:'i')
"         this is used when |gco| or |gcO|.
"         allowed 'i', 'I'.
"
"     cs_ff_space (default:'')
"         this is added before comment when |gcI|, |gci|.
"
"     cs_fb_space (default:' ')
"         this is added after comment when |gcI|, |gci|.
"
"     cs_bf_space (default: expandtab:'    ', noexpandtab:"\t")
"         this is added before comment when |gca|.
"
"     cs_bb_space (default:' ')
"         this is added after comment when |gca|.
"
"     TODO: cs_wrap_read_indent (default:1)
"         insert comment after indent space when |gci|.
"
"     cs_wrap_forward (default:'/* ')
"         if couldn't find wrap-line comment of current filetype.
"         use this as its comment.
"         this is added before the line when |gcw|.
"
"     cs_wrap_back (default:' */')
"         if couldn't find wrap-line comment of current filetype.
"         use this as its comment.
"         this is added after the line when |gcw|.
"
"     cs_multiline_insert (default:1)
"         true : insert at %cursor% of cs_multiline_template.
"         false: won't insert.
"
"     cs_I_insert_if_blank (default:1)
"         when |gcI|, if normal mode, and current line is blank line,
"         insert after comment.
"
"     cs_i_insert_if_blank (default:1)
"         when |gci|, if normal mode, and current line is blank line,
"         insert after comment.
"
"     cs_a_insert (default:1)
"         insert after comment.
"
"     cs_i_read_indent (default:1)
"         at blank line, and normal mode,
"         insert comment after indent space when |gci|.
"
"     cs_insert_comment_if_blank (default:1)
"         insert comment at blank line when normal mode.
"
"     cs_align_forward (default:1)
"         if true, align |gci| comment.
"
"     TODO: cs_align_back (default:1)
"         if true, align |gca| comment.
"
"     g:cs_filetype_table (default:read below.)
"         ADD MORE DEFINITIONS LATER.
"         the default structure is:
"           {
"               \ 'oneline' : {
"                   \ 'actionscript' : '//',
"                   \ 'c'            : '//',
"                   \ 'cpp'          : '//',
"                   \ 'cs'           : '//',
"                   \ 'd'            : '//',
"                   \ 'java'         : '//',
"                   \ 'javascript'   : '//',
"                   \ 'objc'         : '//',
"                   \ 'asm'          : ';',
"                   \ 'lisp'         : ';',
"                   \ 'scheme'       : ';',
"                   \ 'vb'           : "'",
"                   \ 'perl'         : '#',
"                   \ 'python'       : '#',
"                   \ 'ruby'         : '#',
"                   \ 'vim'          : '"',
"                   \ 'vimperator'   : '"',
"                   \ 'dosbatch'     : 'rem',
"               \ },
"               \ 'wrapline' : {
"                   \ 'actionscript' : [ '/* '  , ' */' ],
"                   \ 'c'            : [ '/* '  , ' */' ],
"                   \ 'cpp'          : [ '/* '  , ' */' ],
"                   \ 'cs'           : [ '/* '  , ' */' ],
"                   \ 'd'            : [ '/* '  , ' */' ],
"                   \ 'java'         : [ '/* '  , ' */' ],
"                   \ 'javascript'   : [ '/* '  , ' */' ],
"                   \ 'objc'         : [ '/* '  , ' */' ],
"                   \ 'scheme'       : [ ';;; ' , ' ;;;' ],
"                   \ 'perl'         : [ '### ' , ' ###' ],
"                   \ 'ruby'         : [ '### ' , ' ###' ],
"               \ },
"               \ 'multiline' : {
"                   \ 'actionscript' : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'c'            : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'cpp'          : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'cs'           : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'd'            : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'java'         : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'javascript'   : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'objc'         : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
"                   \ 'scheme'       : { 's' : '#|',   'm' : ''  , 'e' : '|#' },
"                   \ 'perl'         : { 's' : '=pod', 'm' : ''  , 'e' : '=cut' },
"                   \ 'ruby'         : { 's' : '=pod', 'm' : ''  , 'e' : '=cut' },
"               \ },
"           \ }
"
"
"     cs_multiline_template (default:read below.)
"         the default structure is:
"           { 's': '%s%', 'm': '%m% %cursor%', 'e': '%e%' }
"         's' is the first comment. 'm' is the second. and 'e' is the third.
"         each value must include the quoted string whose key's name with '%'.
"         this name is inspired by flags of vim's option |comments|.
"
"     cs_multiline_insert_pos (default:'o')
"         'O': insert multi-line comment at current line
"         'o': insert multi-line comment at next line
"
"     cs_oneline_priority (default:[1, 0])
"         define priorities of the order of one-line comment.
"         0 : vim's |comments| option definition.
"         1 : my comment definition.
"
"     cs_multiline_priority (default:[1, 0])
"         define priorities of the order of multi-line comment.
"         0 : vim's |comments| option definition.
"         1 : my comment definition.
"
"     g:cs_mapping_table (default:read below.)
"         the default structure is:
"           {
"               \ 'c' : {
"                   \ 'func' : printf( 'Comment( "%s" )', g:cs_map_c ),
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv'
"               \ },
"               \ 'I' : {
"                   \ 'func' : 'Comment( "I" )',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv'
"               \ }, 
"               \ 'i' : {
"                   \ 'func' : 'Comment( "i" )',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv'
"               \ }, 
"               \ 'a' : {
"                   \ 'func' : 'Comment( "a" )',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv'
"               \ }, 
"               \ 'w' : {
"                   \ 'func' : 'Comment( "w" )',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv'
"               \ }, 
"               \ 't' : {
"                   \ 'func' : 'ToggleComment()',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv'
"               \ }, 
"               \ 'u' : {
"                   \ 'func' : 'UnComment()',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv'
"               \ }, 
"               \ 'm' : {
"                   \ 'func' : 'MultiComment()',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'n'
"               \ }, 
"               \ 'o' : {
"                   \ 'func' : 'JumpComment( "o" )',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'n'
"               \ }, 
"               \ 'O' : {
"                   \ 'func' : 'JumpComment( "O" )',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'n'
"               \ }
"           \ }
"
"   }}}2
"
"     
"   MEMO:
"     * Can I use 'compound filetype' more effectively...?
"
"   TODO:
"     * align comment when |gca|
"     * do TODO. fix FIXME. check XXX.
"     * support comments type of
"           multi-line : '#if 0' ~ '#endif'
"     * write document at 'doc/CommentAnyWay.txt'.
"       not but in this script.
"     * insert 'if', 'while', 'for', or and so on.
"     * support matchit.vim, surround.vim.
"     * use 'inoremap <silent><expr> <Plug>CheckIndent'
"       to avoid side-effect of ':normal'.
"       before I would implement this. I must implement the stack trace.
"     * implement comment history(stack trace).
"       use this when show history, uncomment(no need select region.
"       this enables to uncomment/comment quickly), and
"       pre-proc or post-proc like 'Hook::LexWrap' in Perl.
"
"   XXX:
"       * UnComment when pos ==# 'i' && cs_align_forward ?
"
"
"
"
"==================================================
" }}}1
"-----------------------------------------------------------------
" INCLUDE GUARD {{{1
if exists( 'g:loaded_comment_anyway' ) && g:loaded_comment_anyway != 0
    finish
endif
let g:loaded_comment_anyway = 1
" }}}1
" SAVE CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1
"-----------------------------------------------------------------
" SOME UTILITY FUNCTIONS {{{1

" s:Debug( ... ) {{{2
if g:cs_verbose
    func! s:Debug( ... )
        if a:0 ==# 0 | return | endif
        if a:1 ==? 'on'
            let g:cs_verbose = 1
        elseif a:1 ==? 'off'
            let g:cs_verbose = 0
        else
            echo eval( join( a:000, ' ' ) )
        endif
    endfunc
    command! -nargs=* CSDebug   call s:Debug( <f-args> )
endif
" }}}2

" s:Warn( msg, ... ) {{{2
func! s:Warn( msg, ... )
    echohl WarningMsg

    if a:0 ==# 0
        echo a:msg
    else
        let [errID, msg] = [a:msg, a:1]
        echo 'Sorry, internal error.'
        echo printf( "errID:%s\nmsg:%s", errID, msg )
    endif

    echohl None
endfunc
" }}}2

" s:EchoWith( msg, hi ) {{{2
func! s:EchoWith( msg, hi )
    execute 'echohl '. a:hi
    echo a:msg
    echohl None
endfunc
" }}}2

" s:Uniq( lis ) {{{2
func! s:Uniq( lis )
    if len( a:lis ) ==# 0 | return a:lis | endif
    let reduced = []

    for i in a:lis[1:]
        if [ a:lis[0] ] != [ i ]    " not same type exactly.
            let reduced += [ i ]
        endif
    endfor

    return [ a:lis[0] ] + s:Uniq( reduced )
endfunc
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
    if type( var ) ==# type( {} )
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

" s:LoadWhenBufEnter() {{{2
"   NOTE: don't return even when &ft is empty.
func! s:LoadWhenBufEnter()
    if &ft == ''
        let b:cs_oneline_comment = g:cs_oneline_comment
    elseif &ft =~ '\.'
        " compound filetype(http://d.hatena.ne.jp/ka-nacht/20080907/1220790705)
        let &ft = get( split( &ft, '\.' ), -1 )
    endif
    " return if filetype is same as previous one.
    if &ft ==# s:FileType.prev_filetype | return | endif

    " set one-line comment string
    if has_key( s:FileType.OneLineString, &ft )
        let b:cs_oneline_comment = s:FileType.OneLineString[&ft]
    endif
    let s:FileType.prev_filetype = &ft

    call s:LoadVimComments()    " load vim's 'comments' option.(for one or multi)
    call s:LoadOneLineComments()    " rebuild replace regexp.
endfunc
" }}}2

" s:GetVar( varname ) {{{2
func! s:GetVar( varname )
    for i in ['b', 'g']
        let varname = i .':'. a:varname
        if exists( varname )
            return eval( varname )
        endif
    endfor

    let v:errmsg = printf( "Can't get variable '%s'", a:varname )
    throw 'variable error'
endfunc
" }}}2

" s:HasElem( lis, elem ) {{{2
func! s:HasElem( lis, elem )
    let [lis, elem] = [a:lis, a:elem]
    " should return error?
    if type( lis ) !=# type( [] ) | throw 'arg error' | endif

    if empty( lis )
        return 0
    else
        return lis[0] ==# elem || s:HasElem( lis[1:], elem )
    endif
endfunc
" }}}2

" s:HasAllKeys( dict, lis ) {{{2
func! s:HasAllKeys( dict, lis )
    if type( a:lis ) !=# type( [] ) | throw 'arg error' | endif


    if len( a:lis ) ==# 0
        return 0
    elseif len( a:lis ) ==# 1
        return has_key( a:dict, a:lis[0] )
    else
        return has_key( a:dict, a:lis[0] )
            \ && s:HasAllKeys( a:dict, a:lis[1:] )
    endif
endfunc
" }}}2

" }}}1
"-----------------------------------------------------------------
" GLOBAL VARIABLES {{{1

" g:cs_map_c
if exists( 'g:cs_map_c' )
    if g:cs_map_c !~# '^[IiawmtuoO]$'
        call s:Warn( 'g:cs_map_c is allowed one of "I i a w m t u o O".' )
        let g:cs_map_c = 'i'
    endif
else
    let g:cs_map_c = 'i'
endif
" g:cs_toggle_comment
if exists( 'g:cs_toggle_comment' )
    if g:cs_toggle_comment !~# '^[Iiaw]$'
        let msg = 'g:cs_toggle_comment is allowed one of "I i a w".'
        call s:Warn( msg )
        let g:cs_toggle_comment = 'i'
    endif
else
    let g:cs_toggle_comment = 'i'
endif
" g:cs_jump_comment
if exists( 'g:cs_jump_comment' )
    if g:cs_jump_comment !=? 'i'
        let fmt = 'g:cs_jump_comment is allowed "%s".'
        call s:Warn( printf( fmt, join( s:AllowedMap.JumpComment, ' ' ) )
        let g:cs_jump_comment = 'i'
    endif
else
    let g:cs_jump_comment = 'i'
endif
" g:cs_ff_space
if ! exists( 'g:cs_ff_space' )
    let g:cs_ff_space = ''
endif
" g:cs_fb_space
if ! exists( 'g:cs_fb_space' )
    let g:cs_fb_space = ' '
endif
" g:cs_bf_space
if ! exists( 'g:cs_bf_space' )
    if &expandtab
        let g:cs_bf_space = '    '
    else
        let g:cs_bf_space = "\t"
    endif
endif
" g:cs_bb_space
if ! exists( 'g:cs_bb_space' )
    let g:cs_bb_space = ' '
endif
" g:cs_oneline_comment
if ! exists( 'g:cs_oneline_comment' )
    let g:cs_oneline_comment = "#"
endif
" g:cs_multiline_insert
if ! exists( 'g:cs_multiline_insert' )
    let g:cs_multiline_insert = 1
endif
" g:cs_I_insert_if_blank
if ! exists( 'g:cs_I_insert_if_blank' )
    let g:cs_I_insert_if_blank = 1
endif
" g:cs_i_insert_if_blank
if ! exists( 'g:cs_i_insert_if_blank' )
    let g:cs_i_insert_if_blank = 1
endif
" g:cs_insert_comment_if_blank
if ! exists( 'g:cs_insert_comment_if_blank' )
    let g:cs_insert_comment_if_blank = 1
endif
" g:cs_a_insert
if ! exists( 'g:cs_a_insert' )
    let g:cs_a_insert = 1
endif
" g:cs_align_forward
if ! exists( 'g:cs_align_forward' )
    let g:cs_align_forward = 1
endif
" g:cs_align_back
if ! exists( 'g:cs_align_back' )
    let g:cs_align_back = 1
endif
" g:cs_verbose
if ! exists( 'g:cs_verbose' )
    let g:cs_verbose = 0
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
" g:cs_i_read_indent
if ! exists( 'g:cs_i_read_indent' )
    let g:cs_i_read_indent = 1
endif

" cs_multiline_insert_pos {{{2
if exists( 'g:cs_multiline_insert_pos' )
    if g:cs_multiline_insert_pos !~ '^[oO]$'
        call s:Warn( 'g:cs_multiline_insert_pos is allowed one of "o O".' )
        let g:cs_multiline_insert_pos = 'o'
    endif
else
    let g:cs_multiline_insert_pos = 'o'
endif
" }}}2

" cs_oneline_priority {{{2
if exists( 'g:cs_oneline_priority' )
    if type( g:cs_oneline_priority ) != type( [] )
    \ || empty( g:cs_oneline_priority )
        call s:Warn( 'your g:cs_oneline_priority is not valid value. use default.' )
        let g:cs_oneline_priority = [1, 0]
    endif
else
    let g:cs_oneline_priority = [1, 0]
endif
" }}}2

" cs_multiline_priority {{{2
if exists( 'g:cs_multiline_priority' )
    if type( g:cs_multiline_priority ) != type( [] )
    \ || empty( g:cs_multiline_priority )
        call s:Warn( 'your g:cs_multiline_priority is not valid value. use default.' )
        let g:cs_multiline_priority = [1, 0]
    endif
else
    let g:cs_multiline_priority = [1, 0]
endif
" }}}2

" cs_filetype_table {{{2
let s:cs_filetype_table = {
    \ 'oneline' : {
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
        \ 'vb'           : "'",
        \ 'perl'         : '#',
        \ 'python'       : '#',
        \ 'ruby'         : '#',
        \ 'vim'          : '"',
        \ 'vimperator'   : '"',
        \ 'dosbatch'     : 'rem',
    \ },
    \ 'wrapline' : {
        \ 'actionscript' : [ '/* '  , ' */' ],
        \ 'c'            : [ '/* '  , ' */' ],
        \ 'cpp'          : [ '/* '  , ' */' ],
        \ 'cs'           : [ '/* '  , ' */' ],
        \ 'd'            : [ '/* '  , ' */' ],
        \ 'java'         : [ '/* '  , ' */' ],
        \ 'javascript'   : [ '/* '  , ' */' ],
        \ 'objc'         : [ '/* '  , ' */' ],
        \ 'scheme'       : [ ';;; ' , ' ;;;' ],
        \ 'perl'         : [ '### ' , ' ###' ],
        \ 'ruby'         : [ '### ' , ' ###' ],
        \ 'html'         : [ "<!-- ", " -->" ],
    \ },
    \ 'multiline' : {
        \ 'actionscript' : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'c'            : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'cpp'          : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'cs'           : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'd'            : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'java'         : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'javascript'   : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'objc'         : { 's' : '/*',   'm' : ' *', 'e' : ' */' },
        \ 'scheme'       : { 's' : '#|',   'm' : ''  , 'e' : '|#' },
        \ 'perl'         : { 's' : '=pod', 'm' : ''  , 'e' : '=cut' },
        \ 'ruby'         : { 's' : '=pod', 'm' : ''  , 'e' : '=cut' },
        \ 'html'         : { 's' : "<!--", 'm' : ''  , 'e' : '-->' },
    \ },
\ }
if exists( 'g:cs_filetype_table' )
    try
        let g:cs_filetype_table = s:ExtendUserSetting( g:cs_filetype_table, s:cs_filetype_table )
    catch /^type error$/
        call s:Warn( 'type error: g:cs_filetype_table is Dictionary. use default.' )
        let g:cs_filetype_table = s:cs_filetype_table
    endtry
else
    let g:cs_filetype_table = s:cs_filetype_table
endif
unlet s:cs_filetype_table
" }}}2

" cs_multiline_template {{{2
let s:cs_multiline_template = { 's': '%s%', 'm': '%m% %cursor%', 'e': '%e%' }
if exists( 'g:cs_multiline_template' )
    try
        let g:cs_multiline_template =
            \ s:ExtendUserSetting( g:cs_multiline_template, s:cs_multiline_template )
    catch /^type error$/
        let msg = 'type error: g:cs_multiline_template is Dictionary. use default.' 
        call s:Warn( msg )
        let g:cs_multiline_template = s:cs_multiline_template
    endtry
else
    let g:cs_multiline_template = s:cs_multiline_template
endif
" unlet s:cs_multiline_template
" }}}2

" cs_mapping_table {{{2
" this will be unlet in s:Init().
let s:cs_mapping_table = {
    \ 'c' : {
        \ 'func' : printf( 'Comment( "%s" )', g:cs_map_c ),
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ },
    \ 'I' : {
        \ 'func' : 'Comment( "I" )',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'i' : {
        \ 'func' : 'Comment( "i" )',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'a' : {
        \ 'func' : 'Comment( "a" )',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'w' : {
        \ 'func' : 'Comment( "w" )',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 't' : {
        \ 'func' : 'ToggleComment()',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'u' : {
        \ 'func' : 'UnComment()',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'm' : {
        \ 'func' : 'MultiComment()',
        \ 'silent' : 1,
        \ 'mode' : 'n'
    \ }, 
    \ 'o' : {
        \ 'func' : 'JumpComment( "o" )',
        \ 'silent' : 1,
        \ 'mode' : 'n'
    \ }, 
    \ 'O' : {
        \ 'func' : 'JumpComment( "O" )',
        \ 'silent' : 1,
        \ 'mode' : 'n'
    \ }
\}
if exists( 'g:cs_mapping_table' )
    try
        let g:cs_mapping_table =
            \ s:ExtendUserSetting( g:cs_mapping_table, s:cs_mapping_table )
    catch /^type error$/
        let msg = 'type error: g:cs_multiline_template is Dictionary. use default.' 
        call s:Warn( msg )
        let g:cs_mapping_table = s:cs_mapping_table
    endtry
else
    let g:cs_mapping_table = s:cs_mapping_table
endif
unlet s:cs_mapping_table
" }}}2
" }}}1
" SCOPED VARIABLES {{{1
" huge dictionary is camel case. small one is lower-letters.(ambiguous)
"
let s:SearchString = { 'Comment': {}, 'UnComment': {} }
let s:FileType = {
    \ 'prev_filetype'   : '',
    \ 'priorities_table' : ['option', 'setting'],
    \ 'OneLineString'   : { 'setting' : {}, 'option' : {} },
    \ 'WrapString'      : { 'setting' : {} },
    \ 'MultiLineString' : {
        \ 'setting'      : {},
        \ 'option'       : {},
        \ 'range_buffer' : '',
    \ }
\ }
let s:AllowedMap = {
    \ 'Comment'     : ['I', 'i', 'a', 't', 'w', 'o', 'O', 'u'],
    \ 'UnComment'   : ['I', 'i', 'a', 'w'],
    \ 'JumpComment' : ['I', 'i', 'w'],
\ }
let s:StackTrace = []
let s:Setting = {}
" e.g.:
"       [
"           {
"               'time' : '1231156600'
"               'trace' : [
"                   'ToggleComment',
"                   'ToggleOneLine',
"                   [ 'Comment', 'I' ]
"               ],
"               'range' : [ 1, 100 ],
"               'finished' : 0   " working job.
"           }
"              .
"              .
"              .
"       ]
" }}}1
"-----------------------------------------------------------------
" INITIALIZE {{{1
func! s:Init()
    " set comment string for some filetypes.
    let s:FileType.OneLineString.setting
                \ = deepcopy( g:cs_filetype_table.oneline )
    let s:FileType.WrapString.setting
                \ = deepcopy( g:cs_filetype_table.wrapline )
    " user's(and my) settings.
    let s:FileType.MultiLineString.setting
                \ = deepcopy( g:cs_filetype_table.multiline )
    unlet g:cs_filetype_table

    " mappings
    for mapkey in keys( g:cs_mapping_table )
        let map = g:cs_mapping_table[mapkey]
        if ! s:HasAllKeys( map, ['func', 'silent', 'mode'] )
            call s:Warn( 'missing a few keys in g:cs_mapping_table.'. map )
            continue
        endif

        for mode in split( g:cs_mapping_table[mapkey].mode, '\zs' )
            if map['silent']
                execute mode .'noremap <unique><silent> '. g:cs_prefix . mapkey
                    \ ."    :call <SID>". map['func'] .'<CR>'
            else
                execute mode .'noremap <unique>         '. g:cs_prefix . mapkey
                    \ ."    :call <SID>". map['func'] .'<CR>'
            endif
        endfor
    endfor
    unlet g:cs_mapping_table

    " map no mapped the map to <Plug>***.
    " (to check indent num of current line)
    inoremap <silent><expr>
        \ <Plug>cs_insert-comment-i     <SID>BuildOneLineComment( "i" )
    inoremap <silent><expr>
        \ <Plug>cs_restore-options      <SID>RestoreSetting()

    " add FileType autocmd.
    augroup CSBufEnter
        autocmd!
        autocmd BufEnter *   call s:LoadWhenBufEnter()
    augroup END
    " delete CSStartUp group.
    augroup CSStartUp
        autocmd!
    augroup END
    augroup! CSStartUp

    " set comment string.
    call s:LoadWhenBufEnter()
endfunc
" }}}1
"-----------------------------------------------------------------
" FUNCTION DEFINITIONS {{{1

" XXX
" s:EscapeRegexp( regexp ) {{{2
func! s:EscapeRegexp( regexp )
    let regexp = a:regexp
    " escape '-' between '[' and ']'.
    let regexp = substitute( regexp, '\[[^\]]*\(-\)[^\]]*\]', '', 'g' )

    " In Perl: escape( a:regexp, '\*+.?{}()[]^$|/' )
    if &magic
        return escape( a:regexp, '\*.{[]^$|/' )
    else
        return escape( a:regexp, '\*[]^$/' )
    endif
endfunc
" }}}2

" s:LoadOneLineComments() {{{2
func! s:LoadOneLineComments()
    try
        let ff_space        = s:GetVar( 'cs_ff_space' )
        let fb_space        = s:GetVar( 'cs_fb_space' )
        let bf_space        = s:GetVar( 'cs_bf_space' )
        let bb_space        = s:GetVar( 'cs_bb_space' )
        let oneline_comment = s:GetVar( 'cs_oneline_comment' )
        let wrap_forward    = s:GetVar( 'cs_wrap_forward' )
        let wrap_back       = s:GetVar( 'cs_wrap_back' )
        let priority        = s:GetVar( 'cs_oneline_priority' )
    catch /^variable error$/
        call s:Warn( 'E004', v:errmsg )
        return
    endtry

    if &ft != ''
        """ NOTE: if no comment definition, just use upper value.
        " set one-line comment string.(e.g.: '"' when filetype is 'vim')
        let table = s:FileType.priorities_table
        for order in priority
            let cmts_def = s:FileType.OneLineString[ table[order] ]
            if has_key( cmts_def, &ft )
                let oneline_comment = cmts_def[&ft]
                " IMPORTANT.
                break
            endif
        endfor
        " set wrap-line comment string.
        let cmts_def = s:FileType.WrapString.setting
        if has_key( cmts_def, &ft )
            let wrap_forward = cmts_def[&ft][0]
            let wrap_back    = cmts_def[&ft][1]
        endif
    endif

    if g:cs_verbose
        echo "user's(and my) setting:"
        echo '  oneline comment:['. oneline_comment .']'
    endif

    " build commented string for searching its commented line.
    let fcomment = ff_space . oneline_comment . fb_space
    let fescaped = s:EscapeRegexp( fcomment )
    let bcomment = bf_space . oneline_comment . bb_space
    let bescaped = s:EscapeRegexp( bcomment )

    let s:SearchString.Comment['I']
                \ = [ '^',
                \     fescaped ]
    let s:SearchString.UnComment['I']
                \ = [ '^'. fescaped,
                \     '' ]
    let s:SearchString.Comment['i']
                \ = [ '^\(\s*\)',
                \     '\1'. fescaped ]
    let s:SearchString.UnComment['i']
                \ = [ '^\(\s\{-}\)'. fescaped,
                \     '\1' ]
    let s:SearchString.Comment['a']
                \ = [ '$',
                \      bescaped ]
    let s:SearchString.UnComment['a']
                \ = [ bescaped .'[^'. oneline_comment .']*$',
                \     '' ]
    let fescaped = s:EscapeRegexp( wrap_forward )
    let bescaped = s:EscapeRegexp( wrap_back )
    let s:SearchString.Comment['w']
                \ = [ '^\(\s*\)\(.*\)$',
                \     '\1'. fescaped .'\2'. bescaped ]
    let s:SearchString.UnComment['w']
                \ = [ fescaped .'\(.*\)'. bescaped,
                \     '\1' ]
endfunc
" }}}2

" s:LoadVimComments() {{{2
func! s:LoadVimComments()
    if &comments == '' ||  &comments == 's1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-'
        return
    endif

    if &ft ==# '' | return | endif
    let head_space = '0'
    let cmts_def_m = s:FileType.MultiLineString.option
    let cmts_def_o = s:FileType.OneLineString.option
    if has_key( cmts_def_m, &ft )
        " cache
        return
    else
        " make a key
        let cmts_def_m[&ft] = {}
    endif

    for i in split( &comments, ',' )
        let keep_empty    = 1
        let [flags; vals] = split( i, ':', keep_empty )
        " &comments =~# '0' is 0...
        if index( split( &comments, '\zs' ), '0' ) != 0 | continue | endif

        " for dosbatch
        call filter( vals, "v:val != ''" )
        let val = vals[0]

        " for one-line comment.
        if flags == '' && ! has_key( cmts_def_o, &ft )
            let cmts_def_o[&ft] = val
        endif

        let matched = matchstr( flags, '[sme]' )
        if matched ==# '' | continue | endif


        if matched ==# 's' && flags =~# '0'
            unlet cmts_def_m[&ft]['s']
            continue
        elseif matched ==# 's' && flags =~# '[1-9]'
            let head_space = matchstr( flags, '[1-9]' )
        elseif matched ==# 'm' || matched ==# 'e'
            let val = repeat( ' ', head_space ) . val
        endif
        call extend( cmts_def_m[&ft], { matched : val } )
    endfor

    " echo debug message.
    if g:cs_verbose && has_key( cmts_def_o, &ft )
        echo "vim's option:"
        echo printf( "  oneline:[%s]", cmts_def_o[&ft] )
        let multi = []
        for i in ['s', 'm', 'e']
            if has_key( cmts_def_m[&ft], i )
                let multi += [ printf( '%s:[%s]', i, cmts_def_m[&ft][i] ) ]
            endif
        endfor
        echo printf( "  multiline: %s", join( multi, ', ' ) )
    endif
endfunc
" }}}2

" s:ChangeOnelineComment( ... ) {{{2
func! s:ChangeOnelineComment( ... )
    if a:0 ==# 1
        let b:cs_oneline_comment = a:1
    else
        let oneline_comment = input( 'oneline comment:' )
        if oneline_comment !=# ''
            let b:cs_oneline_comment = oneline_comment
        else
            call s:EchoWith( 'not changed.', 'MoreMsg' )
            return
        endif
    endif

    call s:LoadOneLineComments()    " rebuild comment string.

    if b:cs_oneline_comment ==# '"'
        call s:EchoWith( "changed to '". b:cs_oneline_comment ."'.", 'ModeMsg' )
    else
        call s:EchoWith( 'changed to "'. b:cs_oneline_comment .'".', 'ModeMsg' )
    endif
endfunc
" }}}2

" s:CommentOneLine( lnum, pos, space, is_normal ) {{{2
func! s:CommentOneLine( lnum, pos, space, is_normal )
    let comment = s:SearchString.Comment
    let line    = getline( a:lnum )
    if ! has_key( comment, a:pos )
        let errmsg = "s:Comment(): Unknown comment position '". a:pos ."'."
        call s:Warn( 'E002', errmsg )
        return line
    endif
    let insert_comment_if_blank = s:GetVar( 'cs_insert_comment_if_blank' )
    if ! insert_comment_if_blank && line =~# '^\s*$'
        return line
    endif

    let align_forward     = s:GetVar( 'cs_align_forward' )
    let i_read_indent = s:GetVar( 'cs_i_read_indent' )
    let is_i_align_cmt    = 
                \ a:pos ==# 'i' &&
                \ ( align_forward || ( a:is_normal && i_read_indent ) )
    " replace current line.
    if is_i_align_cmt
        let deleted_space = a:space
        " delete head space.
        let line = substitute( line, '^'. a:space, '', '')
        " replace with 'I' pattern.
        let line = substitute( line, comment['I'][0], comment['I'][1], '' )
        " append deleted space.
        let line = deleted_space . line
    else
        let line = substitute( line, comment[a:pos][0], comment[a:pos][1], '' )
    endif

    return line
endfunc
" }}}2

" s:UnCommentOneLine( lnum, pos ) {{{2
func! s:UnCommentOneLine( lnum, pos )
    let line      = getline( a:lnum )
    let uncomment = s:SearchString.UnComment
    if ! has_key( uncomment, a:pos )
        let msg = "s:UnComment(): Unknown uncomment position '". a:pos ."'."
        call s:Warn( 'E018', msg )
        return line
    endif

    if matchstr( line, uncomment[a:pos][0] ) !=# ''
        let line = substitute( line, uncomment[a:pos][0], uncomment[a:pos][1], '' )
    endif
    return line
endfunc
" }}}2

" s:ToggleOneLine( lnum, space, is_normal ) {{{2
func! s:ToggleOneLine( lnum, space, is_normal )
    let toggle_comment = s:GetVar( 'cs_toggle_comment' )
    if s:IsCommentedLine( a:lnum )
        return s:UnCommentOneLine( a:lnum, toggle_comment )
    else
        return s:CommentOneLine( a:lnum, toggle_comment, a:space, a:is_normal )
    endif
endfunc
" }}}2

" s:IsCommentedLine( lnum ) {{{2
func! s:IsCommentedLine( lnum )
    let line = getline( a:lnum )
    let uncomment = s:SearchString.UnComment

    for i in ['I', 'i', 'a', 'w']
        if ! has_key( uncomment, i ) | continue | endif
        if matchstr( line, uncomment[i][0] ) !=# ''
            return 1
        endif
    endfor
    return 0
endfunc
" }}}2

" TODO: range
" s:InsertMultiComment( first, last ) {{{2
func! s:InsertMultiComment( first, last )
    " NOTE: no need to call ***.LoadVimComments(),
    " because called it from s:LoadWhenBufEnter()

    if ! s:ExistsMultiLineComment()
        call s:Warn( "current filetype doesn't support multi-line comment string." )
        return
    endif

    " build multi-comment string.
    let cmts_lis = s:BuildMultiComments()
    if empty( cmts_lis ) | return | endif
    let cmt_str = join( cmts_lis, "\n" )

    let multiline_insert_pos = s:GetVar( 'cs_multiline_insert_pos' )
    let multiline_insert     = s:GetVar( 'cs_multiline_insert' )

    if a:first ==# a:last
        " has no range. (normal mode)
        call s:InsertString( cmt_str, multiline_insert_pos )
        " push this command (move to where %cursor% exists,
        " delete it, enter insert mode) to vim's stack.
        if search( '%cursor%', 'Wbc' )
            if multiline_insert
                call feedkeys( 'v7l"_c', 'n' )
            else
                call feedkeys( 'v7l"_d', 'n' )
            endif
        endif
    else
        " has a range. (visual mode)
        call s:InsertString( cmt_str, multiline_insert_pos )
        if search( '%cursor%', 'Wbc' )
            if multiline_insert
                call feedkeys( 'v7l"_c', 'n' )
            else
                call feedkeys( 'v7l"_d', 'n' )
            endif
        endif
        call s:InsertString( s:FileType.MultiLineString.range_buffer, 'here' )
    endif
endfunc
" }}}2

" s:ExistsMultiLineComment( ... ) {{{2
func! s:ExistsMultiLineComment( ... )
    if a:0 ==# 0
        let table = s:FileType.priorities_table
    elseif type( a:1 ) ==# type( [] )
        let table = a:1
    endif

    try
        let priority = s:GetVar( 'cs_multiline_priority' )
    catch /^variable error$/
        call s:Warn( 'E009', v:errmsg )
        return 0
    endtry

    for i in priority
        let option_or_setting = s:FileType.MultiLineString[ table[i] ]
        if has_key( option_or_setting, &ft )
          \ && s:HasAllKeys( option_or_setting[&ft], ['s', 'm', 'e'] )
            return 1
        endif
    endfor

    return 0
endfunc
" }}}2

" s:BuildMultiComments() {{{2
func! s:BuildMultiComments()
    let table       = s:FileType.priorities_table
    let result_lis  = []
    let debug       = {}

    try
        let template = s:GetVar( 'cs_multiline_template' )
        let priority = s:GetVar( 'cs_multiline_priority' )
    catch /^variable error$/
        call s:Warn( 'E010', v:errmsg )
        throw 'variable error'
    endtry

    for i in ['s', 'm', 'e']
        let replace_pat = printf( '%%\(%s\)%%', i )
        let lis = matchlist( template[i], replace_pat )
        if empty( lis )
            " FIXME: check in the global variable initialization.
            let template    = s:GetVar( 'cs_multiline_template' )
            let fmt = "'%%%s%%' is not found in g:cs_multiline_template['%s']: '%s'"
            call s:Warn( printf( fmt, i, i, template[i] ) )
            call s:Warn( 'use default value.' )
            let g:cs_multiline_template = s:cs_multiline_template
            return s:BuildMultiComments()
        endif

        " matched: %s%, %m%, %e%
        " key    : s, m, e
        let [matched, key; unko] = lis

        for order in priority
            let debug[i] = table[order]

            " cmts_def: e.g.: { 'cpp': { 's': '/*', 'm': '*', 'e': '*/' }, ... }
            let cmts_def = s:FileType.MultiLineString[ table[order] ]
            if has_key( cmts_def, &ft ) && has_key( cmts_def[&ft], key )
                let result_lis +=
                    \ [ substitute( template[i], matched, cmts_def[&ft][key], 'g' ) ]
                " IMPORTANT.
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
            " used vim's 'option' and 'setting'.
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

" s:InsertString( str, pos ) {{{2
func! s:InsertString( str, pos )
    let keep_empty = 1

    " build inserted string
    let lines     = split( a:str, "\n", keep_empty )
    let space     = s:GetMinIndentSpace( line( '.' ), line( '.' ) )
    let lines     = map( lines, 'space . v:val' )

    let reg_z      = getreg( 'z', 1 )
    let reg_z_type = getregtype( 'z' )
    let @z         = join( lines, "\n" )
    let opt_paste  = &paste
    setl paste

    " insert
    if exists( ':AutoComplPopLock' )   | AutoComplPopLock   | endif
    if a:pos ==# 'here'
        setl nopaste
        execute "normal a\<C-r>z"
    else
        if a:pos ==# 'o'
            put z
        else
            put! z
        endif
    endif
    if exists( ':AutoComplPopUnLock' ) | AutoComplPopUnlock | endif

    " reverse
    let &paste = opt_paste
    call setreg( 'z', reg_z, reg_z_type )
endfunc
" }}}2

" s:GetIndent( lnum_or_expr ) {{{2
func! s:GetIndent( lnum_or_expr )
    if type( a:lnum_or_expr ) ==# type( "" )    " string
        let lnum = line( a:lnum_or_expr )
    elseif type( a:lnum_or_expr ) ==# type( 0 )    " numeric
        let lnum = a:lnum_or_expr
    else
        throw 'type error'
    endif
    " :help fo-table
    "   o   Automatically insert the current comment leader after hitting 'o' or
    "       'O' in Normal mode.
    let save_fo  = &formatoptions
    let save_vb  = &t_vb
    let prev_pos = getpos( '.' )
    setl formatoptions+=o
    setl t_vb=


    " go to the line lnum.
    call cursor( lnum, 0 )

    " get indent num of lnum.
    let line = getline( '.' )
    if line =~# '^\s*$'
        " XXX: if 'word' is special word of current filetype,
        "      vim indent it automatically?
        " FIXME: insert same level indent when filetype is 'vim' and
        "        editing multi-line dictionary definition and
        "        type gco.( g:cs_jump_comment is 'i')
        execute "normal \<Plug>Oword"
        " call feedkeys( "\<Plug>Oword", 't' )
    else
        execute "normal \<Plug>O". substitute( line, '^\s*\(.*\)$', '\1', '' )
        " call feedkeys( "\<Plug>O". substitute( line, '^\s*\(.*\)$', '\1', '' ), 't' )
    endif
    let indent = indent( '.' )
    " call feedkeys( 'u', 'n' )    " undo
    silent undo

    call setpos( '.', prev_pos )
    let &formatoptions = save_fo
    let &t_vb          = save_vb

    return indent
endfunc
" }}}2

" s:GetMinIndentSpace( first, last ) {{{2
func! s:GetMinIndentSpace( first, last )

    " get minimal indent num
    for i in range( a:first, a:last )
        " if getline( i ) =~# '^\s*$' | continue | endif
        " let indent = indent( i )
        let indent = s:GetIndent( str2nr( i ) )
        if ! exists( 'indent_min' ) || indent < indent_min
            let indent_min = indent
        endif
    endfor

    if ! exists( 'indent_min' )
        return ''
    elseif &expandtab
        return repeat( ' ', indent_min )
    else
        return repeat( "\t", indent_min / &tabstop )
    endif
endfunc
" }}}2

" s:EnterInsertMode( pos, prev_line ) {{{2
func! s:EnterInsertMode( pos, prev_line )
    let [pos, prev_line] = [a:pos, a:prev_line]

    " insert at tail of current line when calling CommentOneLine()
    if pos ==# 'I'
        try
            if prev_line =~# '^\s*$' && s:GetVar( 'cs_I_insert_if_blank' )
                call feedkeys( 'A', 'n' )
            endif
        catch /^variable error$/
            call s:Warn( 'E012', v:errmsg )
        endtry
    elseif pos ==# 'i'
        try
            if prev_line =~# '^\s*$' && s:GetVar( 'cs_i_insert_if_blank' )
                call feedkeys( 'A', 'n' )
            endif
        catch /^variable error$/
            call s:Warn( 'E013', v:errmsg )
        endtry
    elseif pos ==# 'a'
        try
            if s:GetVar( 'cs_a_insert' )
                call feedkeys( 'A', 'n' )
            endif
        catch /^variable error$/
            call s:Warn( 'E014', v:errmsg )
        endtry
    endif
endfunc
" }}}2

" TODO: Align comment in case 'a'
" <SID>Comment( ... ) range {{{2
func! <SID>Comment( ... ) range
    " get comment pos.
    try
        let pos = a:0 ==# 0 ?       s:GetVar( 'cs_map_c' ) : a:1
    catch /^variable error$/
        call s:Warn( 'E011', v:errmsg )
        return
    endtry
    " check comment pos.
    if ! s:HasElem( s:AllowedMap.Comment, pos ) | return | endif

    let prev_line   = getline( a:firstline )
    let align_space = ''


    let range = a:firstline .','. a:lastline
    " toggle comment
    if pos ==# 't'
        execute range . 'call <SID>ToggleComment()'
        return
    " jump comment
    elseif pos ==? 'o'
        let fmt = '%scall <SID>JumpComment( "%s" )'
        execute printf( fmt, range, pos )
        return
    " uncomment
    elseif pos ==# 'u'
        execute range .'call <SID>UnComment()'
        return
    endif

    " get cs_align_forward
    try
        let align_forward = s:GetVar( 'cs_align_forward' )
        let i_read_indent = s:GetVar( 'cs_i_read_indent' )
    catch /^variable error$/
        call s:Warn( 'E003', v:errmsg )
        return
    endtry
    " align comment position when 'gci'.
    if pos ==# 'i' && ( align_forward || i_read_indent )
        let align_space = s:GetMinIndentSpace( a:firstline, a:lastline )
    else
        let align_space = ''
    endif


    " process each line
    try
        let i         = a:firstline
        let is_normal = a:firstline == a:lastline
        while i <= a:lastline
            let line     = getline( i )
            let replaced = s:CommentOneLine( i, pos, align_space, is_normal )
            if line != replaced | call setline( i, replaced ) | endif
            let i = i + 1
        endwhile

    catch /^variable error$/
        call s:Warn( 'E005', v:errmsg )
        return
    endtry


    " normal mode
    if is_normal
        call s:EnterInsertMode( pos, prev_line )
    endif

    nohlsearch
endfunc
" }}}2

" <SID>UnComment() range {{{2
func! <SID>UnComment() range
    let i    = a:firstline
    let line = getline( i )

    " get comment pos.
    try
        let pos = nr2char( getchar() )
        " NOTE: won't uncomment if cs_map_c is 't'.
    catch /^variable error$/
        call s:Warn( 'E017', v:errmsg )
    endtry
    " check comment pos.
    if pos ==# 'c' | let pos = s:GetVar( 'cs_map_c' ) | endif
    if ! s:HasElem( s:AllowedMap.UnComment, pos ) | return | endif

    try
        " process each line
        while i <= a:lastline
            let line     = getline( i )
            let replaced = s:UnCommentOneLine( i, pos )
            if line != replaced | call setline( i, replaced ) | endif
            let i = i + 1
        endwhile
    catch /^variable error$/
        call s:Warn( 'E007', v:errmsg )
    endtry

    nohlsearch
endfunc
" }}}2

" FIXME: sometimes strange in visual mode and selected multi-line...
" <SID>ToggleComment() range {{{2
func! <SID>ToggleComment() range
    let i         = a:firstline
    let prev_line = getline( i )
    let space     = s:GetMinIndentSpace( a:firstline, a:lastline )

    " process each line
    try
        let is_normal = a:firstline == a:lastline
        while i <= a:lastline
            let line           = getline( i )
            let replaced       = s:ToggleOneLine( i, space, is_normal )
            if line != replaced | call setline( i, replaced ) | endif
            let i = i + 1
        endwhile
    catch /^variable error$/
        call s:Warn( 'E008', v:errmsg )
    endtry

    " enter insert mode.
    try
        if is_normal
            call s:EnterInsertMode( s:GetVar( 'cs_toggle_comment' ), prev_line )
        endif
    catch /^variable error$/
        call s:Warn( 'E016', v:errmsg )
    endtry

    nohlsearch
endfunc
" }}}2

" TODO
" <SID>VariuosComment() range {{{2
func! <SID>VariuosComment() range
    call s:Warn( 'not implemented yet...' )
    return
endfunc
" }}}2

" <SID>JumpComment() {{{2
"   {range}{action}
func! <SID>JumpComment( vect )
    if a:vect != 'o' && a:vect != 'O' | return | endif

    try
        " get comment pos.
        let pos = s:GetVar( 'cs_jump_comment' )
        " check comment pos.
        if pos ==# 'c' | let pos = s:GetVar( 'cs_map_c' ) | endif
        if ! s:HasElem( s:AllowedMap.JumpComment, pos ) | return | endif

        " insert empty line.

        " feedkeysから呼び出さないと後ろのEnterInsertModeと同期とれなくなるかも
        " なのでcall feedkeys( "\<Plug>JumpComment", 'n' )として
        " formatoptions+=oして
        " cs_align_forward なら
        "   feedkeys( "\<Plug>o", 'n' )する
        " 違うなら
        "   feedkeys( "\<Plug>o\<Plug>esc\<Plug>0\<Plug>D\<Plug>i", 'n' )
        " そんでコメント文字列を(LoadOneLineCommentsでしたように)組み立てて
        " 書き込めばいいだけ(もちろんfeedkeysで)
        " 書き込むときset nopasteと<C-r>=使えば楽かも

        let s:Setting = { 'formatoptions' : &formatoptions }
        setl formatoptions+=o

        call feedkeys( a:vect, 'n' )    " jump.
        if !( pos ==# 'i' && s:GetVar( 'cs_align_forward' ) )
            call feedkeys( "\<Esc>0C", 'n' )
        endif

        " call <SID>BuildOneLineComment( 'i' )
        call feedkeys( "\<Plug>cs_insert-comment-i", 'm' )
        " call <SID>RestoreSetting()
        call feedkeys( "\<Plug>cs_restore-options", 'm' )

        " " replace current line.
        " call s:EnterInsertMode( pos, getline( lnum ) )

    catch /^variable error$/
        call s:Warn( 'E015', v:errmsg )
    endtry

    nohlsearch
endfunc
" }}}2

" <SID>BuildOneLineComment( pos ) {{{2
func! <SID>BuildOneLineComment( pos )
    try
        let ff_space        = s:GetVar( 'cs_ff_space' )
        let fb_space        = s:GetVar( 'cs_fb_space' )
        let bf_space        = s:GetVar( 'cs_bf_space' )
        let bb_space        = s:GetVar( 'cs_bb_space' )
        let oneline_comment = s:GetVar( 'cs_oneline_comment' )
        let wrap_forward    = s:GetVar( 'cs_wrap_forward' )
        let wrap_back       = s:GetVar( 'cs_wrap_back' )
        let priority        = s:GetVar( 'cs_oneline_priority' )
    catch /^variable error$/
        call s:Warn( 'E004', v:errmsg )
        return
    endtry

    if &ft != ''
        """ NOTE: if no comment definition, just use upper value.
        " set one-line comment string.(e.g.: '"' when filetype is 'vim')
        let table = s:FileType.priorities_table
        for order in priority
            let cmts_def = s:FileType.OneLineString[ table[order] ]
            if has_key( cmts_def, &ft )
                let oneline_comment = cmts_def[&ft]
                " IMPORTANT.
                break
            endif
        endfor
        " set wrap-line comment string.
        let cmts_def = s:FileType.WrapString.setting
        if has_key( cmts_def, &ft )
            let wrap_forward = cmts_def[&ft][0]
            let wrap_back    = cmts_def[&ft][1]
        endif
    endif

    let fcomment = ff_space . oneline_comment . fb_space
    let bcomment = bf_space . oneline_comment . bb_space

    if a:pos ==? 'i'
        return fcomment
    elseif a:pos ==# 'a'
        return bcomment
    else
        return ''
    endif
endfunc
" }}}2

" <SID>RestoreSetting() {{{2
func! <SID>RestoreSetting()
    if ! empty( s:Setting )
        for [key, val] in items( s:Setting )
            execute printf( 'setlocal %s=%s', key, val )
        endfor
    endif
    return ''
endfunc
" }}}2

" <SID>MultiComment() range {{{2
func! <SID>MultiComment() range
    " XXX: tekitou
    let save_z_str = getreg( 'z', 1 )
    let save_z_type = getregtype( 'z' )
    if a:firstline != a:lastline
        normal "zy
        let s:FileType.MultiLineString.range_buffer = @z
    endif
    call setreg( 'z', save_z_str, save_z_type )

    try
        call s:InsertMultiComment( a:firstline, a:lastline )
    catch /^variable error$/
        call s:Warn( 'E006', v:errmsg )
    endtry
endfunc
" }}}2

" }}}1
"-----------------------------------------------------------------
" AUTOCOMMAND {{{1
" this group will be deleted after Vim starts up.
augroup CSStartUp
    autocmd!
    autocmd VimEnter *      call s:Init()
augroup END
" }}}1
"-----------------------------------------------------------------
" COMMANDS {{{1
command! -nargs=?           CSOnelineComment
            \ call s:ChangeOnelineComment( <f-args> )
" }}}1
"-----------------------------------------------------------------
" MAPPINGS {{{1
""" see g:cs_mapping_table and s:Init()
" }}}1
"-----------------------------------------------------------------
" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1

" vim:set foldmethod=marker:fen:
