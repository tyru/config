scriptencoding utf-8

"-----------------------------------------------------------------
" DOCUMENT {{{1
"==================================================
" Name: CommentAnyWay.vim
" Version: 0.1.6
" Author: vimuma
" Last Change: 2009-01-08.
"
" Change Log: {{{2
"   0.0.0: Initial release.
"   0.0.1: Fixed s:UnComment() uncomment nested commented line.
"   0.0.2: Stable release.
"   0.0.3: Rewrite code in Object-Oriented.
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
"   0.1.4: Implement JumpComment
"   0.1.5: Rewrite code in Object-Oriented.(at the time of 0.0.3, not OOP code!)
"   0.1.6: Implement VariousComment().
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
"       gcv{wrap}{action}
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
"       gcv{string}
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
"   TYPES OF COMMENTS: {{{2
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
"         if this is the default, |gcc| is same as |gci|.
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
"     cs_I_comment_if_blank (default:1)
"         when |gcI| on the blank line,
"           true: comment.
"           false: don't comment.
"
"     cs_i_comment_if_blank (default:1)
"         when |gci| on the blank line,
"           true: comment.
"           false: don't comment.
"
"     cs_a_comment_if_blank (default:1)
"         when |gca| on the blank line,
"           true: comment.
"           false: don't comment.
"
"     cs_wrap_forward (default:'>>> ')
"         if couldn't find wrap-line comment of current filetype.
"         use this as its comment.
"         this is added before the line when |gcw|.
"
"     cs_wrap_back (default:' <<<')
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
"     TODO: cs_toggle_enter_i (default:0)
"         when normal mode, enter insert mode when toggle.
"         this affects cs_I_insert_if_blank, cs_i_insert_if_blank,
"         cs_a_insert.
"           0: no effect.
"           1: force to enter insert mode.
"           2: force to NOT enter insert mode.
"
"     cs_i_read_indent (default:1)
"         at blank line, and normal mode,
"         insert comment after indent space when |gci|.
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
"     * implement comment history(stack trace).
"       use this when show history, uncomment(no need select region.
"       this enables to uncomment/comment quickly), and
"       pre-proc or post-proc like 'Hook::LexWrap' in Perl.
"     * remove 'variables error' and its handler.
"     * get indent num without enter insert-mode.
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

" s:GetVar( varname ) {{{2
func! s:GetVar( varname )
    for i in ['b', 'g']
        let varname = i .':'. a:varname
        if exists( varname )
            return deepcopy( eval( varname ) )
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

    if empty( a:lis )
        return 0
    elseif len( a:lis ) ==# 1
        return has_key( a:dict, a:lis[0] )
    else
        return has_key( a:dict, a:lis[0] )
            \ && s:HasAllKeys( a:dict, a:lis[1:] )
    endif
endfunc
" }}}2

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

" s:LoadWhenBufEnter() {{{2
"   NOTE: don't return even when &ft is empty.
func! s:LoadWhenBufEnter()
    if &ft == ''
        let b:cs_oneline_comment = g:cs_oneline_comment
    elseif &ft =~ '\.'
        " compound filetype(http://d.hatena.ne.jp/ka-nacht/20080907/1220790705)
        let &ft = get( split( &ft, '\.' ), -1 )
    elseif &ft ==# s:FileType.prev_filetype
        " cache
        return
    endif

    " set one-line comment string
    if has_key( s:FileType.OneLineString, &ft )
        let b:cs_oneline_comment = s:FileType.OneLineString[&ft]
    endif
    let s:FileType.prev_filetype = &ft

    call s:LoadVimComments()    " load vim's 'comments' option.(for one or multi)
    for type in ['OneLine', 'MultiLine']
        call s:CommentAnyWay[type].LoadDefinitions()    " rebuild replace regexp.
    endfor
endfunc
" }}}2

" <SID>RunWithPos( pos ) range {{{2
func! <SID>RunWithPos( pos ) range
    let pos = a:pos ==# 'c' ?   s:GetVar( 'cs_map_c' ) : a:pos
    let mapping = s:CommentAnyWay.Base.FindMapping( pos )
    if mapping !=# ''
        call s:CommentAnyWay[mapping].Init()
        let s:CommentAnyWay[mapping].pos   = pos
        let s:CommentAnyWay[mapping].range = [a:firstline, a:lastline]
        call s:CommentAnyWay[mapping].Run()
    else
        if g:cs_verbose
            call s:Warn( printf( 'no key for %s.', pos ) )
            call s:Warn( printf( 'mapping:%s', mapping ) )
        endif
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
        call s:Warn( 'g:cs_jump_comment is allowed "o O".' )
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
        \ 'pass' : 'c',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ },
    \ 'I' : {
        \ 'pass' : 'I',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'i' : {
        \ 'pass' : 'i',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'a' : {
        \ 'pass' : 'a',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'w' : {
        \ 'pass' : 'w',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 't' : {
        \ 'pass' : 't',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'u' : {
        \ 'pass' : 'u',
        \ 'silent' : 1,
        \ 'mode' : 'nv'
    \ }, 
    \ 'm' : {
        \ 'pass' : 'm',
        \ 'silent' : 1,
        \ 'mode' : 'n'
    \ }, 
    \ 'o' : {
        \ 'pass' : 'o',
        \ 'silent' : 1,
        \ 'mode' : 'n'
    \ }, 
    \ 'O' : {
        \ 'pass' : 'O',
        \ 'silent' : 1,
        \ 'mode' : 'n'
    \ },
    \ 'v' : {
        \ 'pass' : 'v',
        \ 'mode' : 'nv'
    \ },
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
" NOTE: if include these variables in s:CommentAnyWay,
" structures get so huge.(Base, OneLine, MultiLine)
let s:SearchString = { 'Comment': {}, 'UnComment': {} }
let s:FileType = {
    \ 'prev_filetype'   : '',
    \ 'priorities_table' : ['option', 'setting'],
    \ 'OneLineString'   : { 'setting' : {}, 'option' : {} },
    \ 'WrapString'      : { 'setting' : {} },
    \ 'MultiLineString' : {
        \ 'setting'      : {},
        \ 'option'       : {},
    \ }
\ }
let s:Settings = []
" let s:StackTrace = []
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
        if ! s:HasAllKeys( map, ['pass', 'mode'] )
            call s:Warn( 'missing a few keys in g:cs_mapping_table["'. mapkey .'"]' )
            continue
        endif

        for mode in split( g:cs_mapping_table[mapkey].mode, '\zs' )
            if has_key( map, 'silent' ) && map.silent
                let silent = '<silent>'
            else
                let silent = ''
            endif
            execute printf( '%snoremap <unique>%s %s :call <SID>RunWithPos( "%s" )<CR>', mode, silent, g:cs_prefix . mapkey, map.pass )
        endfor
    endfor
    unlet g:cs_mapping_table

    " map no mapped the map to <Plug>***.
    " (to check indent num of current line)
    inoremap <silent><expr>
        \ <Plug>insert-comment-i    <SID>InsertCommentFromMap( "i" )
    inoremap <silent><expr>
        \ <Plug>restore-options     <SID>RestoreSetting()

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

" BASE {{{2
" NOTE: DO NOT INITIALIZE mappings FROM Init().
let s:CommentAnyWay = {
    \ 'Base' : {
        \ 'pos'            : '',
        \ 'lnum'           : 0,
        \ 'range'          : [],
        \ 'head_space'     : '',
        \ 'MAX_SRCH_LINES' : 100,
    \ },
    \ 'OneLine'   : {},
    \ 'MultiLine' : {},
\ }

" s:CommentAnyWay.Base.FindMapping( mapkey ) {{{3
func! s:CommentAnyWay.Base.FindMapping( mapkey )
    for type in ['OneLine', 'MultiLine']
        if has_key( s:CommentAnyWay[type], 'mappings' )
        \ && has_key( s:CommentAnyWay[type].mappings, a:mapkey )
            return type
        endif
    endfor

    return ''
endfunc
" }}}3

" s:CommentAnyWay.Base.IsValidPos() dict {{{3
func! s:CommentAnyWay.Base.IsValidPos() dict
    return s:HasAllKeys( self, ['pos', 'mappings'] )
        \ && has_key( self.mappings, self.pos )
endfunc
" }}}3

" s:CommentAnyWay.Base.HasRange() dict {{{3
func! s:CommentAnyWay.Base.HasRange() dict
    return ! empty( self.range ) && self.range[0] != self.range[1]
endfunc
" }}}3

" TODO: look up indent num without using feedkeys.
" s:CommentAnyWay.Base.GetIndent( lnum_or_expr ) dict {{{3
func! s:CommentAnyWay.Base.GetIndent( lnum_or_expr ) dict
    " get lnum
    if type( a:lnum_or_expr ) ==# type( "" )    " string
        let lnum = line( a:lnum_or_expr )
    elseif type( a:lnum_or_expr ) ==# type( 0 )    " numeric
        let lnum = a:lnum_or_expr
    else
        throw 'type error'
    endif

    if getline( lnum ) !~# '^\s*$'
        return indent( lnum )
    else
        let prev_pos = getpos( '.' )

        " search upward until found non-blank line.
        " if up ==# 1 |  | endif
        let i = prev_pos[1]
        while prev_pos[1] - i < self.MAX_SRCH_LINES
            if getline( i ) !~# '^\s*$'
                call setpos( '.', prev_pos )
                return indent( i )
            endif
            let i = i - 1
        endwhile

        call setpos( '.', prev_pos )
        return 0
    endif
endfunc
" }}}3

" s:CommentAnyWay.Base.GetMinIndentSpace( first, last ) dict {{{3
func! s:CommentAnyWay.Base.GetMinIndentSpace( first, last ) dict
    " get minimal indent num
    for i in range( a:first, a:last )
        let indent = self.GetIndent( str2nr( i ) )
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
" }}}3

" s:CommentAnyWay.Base.EnterInsertMode( prev_line ) dict {{{3
func! s:CommentAnyWay.Base.EnterInsertMode( prev_line ) dict
    let [pos, prev_line] = [self.pos, a:prev_line]

    " insert at tail of current line when calling CommentOneLine()
    if pos ==# 'I'
        if prev_line =~ '^\s*$' && s:GetVar( 'cs_I_insert_if_blank' )
            call feedkeys( 'A', 'n' )
        endif
    elseif pos ==# 'i'
        if prev_line =~ '^\s*$' && s:GetVar( 'cs_i_insert_if_blank' )
            call feedkeys( 'A', 'n' )
        endif
    elseif pos ==# 'a'
        if s:GetVar( 'cs_a_insert' )
            call feedkeys( 'A', 'n' )
        endif
    endif
endfunc
" }}}3

" TODO: use 'feedkeys' instead of 'normal'.
" s:CommentAnyWay.Base.InsertString( str, pos ) dict {{{3
func! s:CommentAnyWay.Base.InsertString( str, pos ) dict
    let keep_empty = 1

    " build inserted string
    let lines     = split( a:str, "\n", keep_empty )
    let space     = self.GetMinIndentSpace( line( '.' ), line( '.' ) )
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
" }}}3
" }}}2

" ONELINE COMMENT {{{2
let s:CommentAnyWay.OneLine = deepcopy( s:CommentAnyWay.Base )
let s:CommentAnyWay.OneLine['mappings'] = {
    \ 'I' : { 'funcname' : 'Comment'        , 'slurp' : 1 } , 
    \ 'i' : { 'funcname' : 'Comment'        , 'slurp' : 1 } , 
    \ 'a' : { 'funcname' : 'Comment'        , 'slurp' : 1 } , 
    \ 'w' : { 'funcname' : 'Comment'        , 'slurp' : 1 } , 
    \ 't' : { 'funcname' : 'ToggleComment'  , 'slurp' : 1 } , 
    \ 'u' : { 'funcname' : 'UnComment'      , 'slurp' : 1 } , 
    \ 'v' : { 'funcname' : 'VariousComment' } , 
    \ 'o' : { 'funcname' : 'JumpComment' }, 
    \ 'O' : { 'funcname' : 'JumpComment' }, 
\ }

" s:CommentAnyWay.OneLine.Init() dict {{{3
func! s:CommentAnyWay.OneLine.Init() dict
    let self.pos            = ''
    let self.lnum           = 0
    let self.range          = []
    let self.head_space     = ''
    let self.MAX_SRCH_LINES = 100
    let self.uncomment_pos  = ''
endfunc
" }}}3

" s:CommentAnyWay.OneLine.Run() dict {{{3
func! s:CommentAnyWay.OneLine.Run() dict
    " save current line status.
    let prev_line = getline( self.range[0] )
    " get cs_align_forward
    " align comment position when 'gci'.
    if self.pos ==# 'i' && ( s:GetVar( 'cs_align_forward' ) || s:GetVar( 'cs_i_read_indent' ) )
        let self.head_space = self.GetMinIndentSpace( self.range[0], self.range[1] )
    else
        let self.head_space = ''
    endif

    " check uncomment pos.
    if self.pos ==# 'u'
        let self.uncomment_pos = nr2char( getchar() )    " get pos.
        if ! has_key( s:SearchString.UnComment, self.uncomment_pos )
            let msg = "s:UnComment(): Unknown uncomment position '". self.uncomment_pos ."'."
            call s:Warn( 'E018', msg )
            return
        endif
    " check comment pos.
    elseif ! has_key( self.mappings, self.pos )
        let errmsg = "s:Comment(): Unknown comment position '". self.pos ."'."
        call s:Warn( 'E002', errmsg )
        return
    endif

    let map = self.mappings[self.pos]
    if has_key( map, 'slurp' ) && map.slurp
        call self.Slurp()
    else
        " for JumpComment().
        let funcname = self.mappings[self.pos].funcname
        call self[funcname]()
    endif

    if ! self.HasRange()
        call self.EnterInsertMode( prev_line )
    endif

    nohlsearch
endfunc
" }}}3

" s:CommentAnyWay.OneLine.Slurp() dict {{{3
func! s:CommentAnyWay.OneLine.Slurp() dict
    let funcname = self.mappings[self.pos].funcname

    for self.lnum in range( self.range[0], self.range[1] )
        let line     = getline( self.lnum )
        let replaced = self[funcname]()
        if line != replaced | call setline( self.lnum, replaced ) | endif
    endfor
endfunc
" }}}3

"   FIXME: undo works when |gci|...(so use feedkeys( 'foo', 't' ))
" TODO: Align comment in case 'a'
" s:CommentAnyWay.OneLine.Comment() dict {{{3
func! s:CommentAnyWay.OneLine.Comment() dict
    let comment = s:SearchString.Comment
    let line    = getline( self.lnum )
    let is_blankline = line =~# '^\s*$'

    if self.pos ==# 'w' && is_blankline | return line | endif

    let is_i_align_cmt = self.pos ==# 'i' && ( s:GetVar( 'cs_align_forward' ) || ( ! self.HasRange() && s:GetVar( 'cs_i_read_indent' ) ) )
    " replace current line.
    if is_i_align_cmt
        " delete head space.
        let line = substitute( line, '^'. self.head_space, '', '')
        " replace with 'I' pattern.
        let line = substitute( line, comment['I'][0], comment['I'][1], '' )
        " append deleted space.
        let line = self.head_space . line
    else
        let line = substitute( line, comment[self.pos][0], comment[self.pos][1], '' )
    endif

    return line
endfunc
" }}}3

" s:CommentAnyWay.OneLine.UnComment() dict {{{3
func! s:CommentAnyWay.OneLine.UnComment() dict
    let uncomment = s:SearchString.UnComment[self.uncomment_pos]
    return substitute( getline( self.lnum ), uncomment[0], uncomment[1], '' )
endfunc
" }}}3

" FIXME: sometimes strange in visual mode and selected multi-line...
" s:CommentAnyWay.OneLine.ToggleComment() dict {{{3
func! s:CommentAnyWay.OneLine.ToggleComment() dict
    let self.pos           = s:GetVar( 'cs_toggle_comment' )
    let self.uncomment_pos = s:GetVar( 'cs_toggle_comment' )

    if self.IsCommentedLine()
        return self.UnComment()
    else
        return self.Comment()
    endif
endfunc
" }}}3

" s:CommentAnyWay.OneLine.IsCommentedLine() dict {{{3
func! s:CommentAnyWay.OneLine.IsCommentedLine() dict
    let line = getline( self.lnum )
    let uncomment = s:SearchString.UnComment

    for i in ['I', 'i', 'a', 'w']
        if ! has_key( uncomment, i ) | continue | endif
        if matchstr( line, uncomment[i][0] ) !=# ''
            return 1
        endif
    endfor
    return 0
endfunc
" }}}3

" s:CommentAnyWay.OneLine.JumpComment() dict {{{3
func! s:CommentAnyWay.OneLine.JumpComment() dict
    let vect = self.pos

    " get comment pos.
    let pos = s:GetVar( 'cs_jump_comment' )
    " check comment pos.
    if pos ==# 'c' | let pos = s:GetVar( 'cs_map_c' ) | endif


    let s:Settings = [ ['formatoptions', &formatoptions] ]
    setl formatoptions+=o

    call feedkeys( vect, 'n' )    " jump.
    if !( pos ==# 'i' && s:GetVar( 'cs_align_forward' ) )
        call feedkeys( "\<Esc>0C", 'n' )
    endif

    " call <SID>InsertCommentFromMap( 'i' )
    call feedkeys( "\<Plug>insert-comment-i", 'm' )
    " call <SID>RestoreSetting()
    call feedkeys( "\<Plug>restore-options", 'm' )
endfunc
" }}}3

" s:CommentAnyWay.OneLine.VariousComment() dict {{{3
func! s:CommentAnyWay.OneLine.VariousComment() dict
    " save values.
    call inputsave()
    let def = s:GetVar( 'cs_oneline_comment' )
    let s:Settings = [ ['eventignore', &eventignore], ['ft', &ft] ]
    setl eventignore=all
    setl ft=

    let input_str = input( 'set definition:' )
    if input_str ==# '' | return | endif
    let b:cs_oneline_comment = input_str
    call self.LoadDefinitions()

    echon 'comment type:'
    let key = nr2char( getchar() )
    if key ==# "\<CR>" || key ==# "\<Esc>"
        return
    endif
    if self.FindMapping( key ) !=# 'OneLine' | return | endif
    let self.pos = key
    call self.Run()

    " restore
    let b:cs_oneline_comment = def
    call <SID>RestoreSetting()
    call self.LoadDefinitions()
    call inputrestore()
endfunc
" }}}3

" ----- for inoremap <expr> ------ {{{3
" <SID>InsertCommentFromMap( pos ) {{{4
func! <SID>InsertCommentFromMap( pos )
    let ff_space        = s:GetVar( 'cs_ff_space' )
    let fb_space        = s:GetVar( 'cs_fb_space' )
    let bf_space        = s:GetVar( 'cs_bf_space' )
    let bb_space        = s:GetVar( 'cs_bb_space' )
    let oneline_comment = s:GetVar( 'cs_oneline_comment' )
    let wrap_forward    = s:GetVar( 'cs_wrap_forward' )
    let wrap_back       = s:GetVar( 'cs_wrap_back' )
    let priority        = s:GetVar( 'cs_oneline_priority' )

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
" }}}4

" <SID>RestoreSetting() {{{4
func! <SID>RestoreSetting()
    if ! empty( s:Settings )
        for [key, val] in s:Settings
            execute printf( 'setlocal %s=%s', key, val )
        endfor
        let s:Settings = []
    endif
    " no inserted string.
    return ''
endfunc
" }}}4
" }}}3

" s:CommentAnyWay.OneLine.LoadDefinitions() {{{3
func! s:CommentAnyWay.OneLine.LoadDefinitions()
    let ff_space        = s:GetVar( 'cs_ff_space' )
    let fb_space        = s:GetVar( 'cs_fb_space' )
    let bf_space        = s:GetVar( 'cs_bf_space' )
    let bb_space        = s:GetVar( 'cs_bb_space' )
    let oneline_comment = s:GetVar( 'cs_oneline_comment' )
    let wrap_forward    = s:GetVar( 'cs_wrap_forward' )
    let wrap_back       = s:GetVar( 'cs_wrap_back' )
    let priority        = s:GetVar( 'cs_oneline_priority' )

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
" }}}3

" s:LoadVimComments() {{{3
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
" }}}3

" s:ChangeOnelineComment( ... ) {{{3
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

    call s:CommentAnyWay.OneLine.LoadDefinitions()    " rebuild comment string.

    if b:cs_oneline_comment ==# '"'
        call s:EchoWith( "changed to '". b:cs_oneline_comment ."'.", 'ModeMsg' )
    else
        call s:EchoWith( 'changed to "'. b:cs_oneline_comment .'".', 'ModeMsg' )
    endif
endfunc
" }}}3
" }}}2

" MULTI COMMENT {{{2
let s:CommentAnyWay.MultiLine = deepcopy( s:CommentAnyWay.Base )
let s:CommentAnyWay.MultiLine['mappings'] = {
    \ 'm' : 'MultiComment',
\ }

" TODO: sync with OneLine.Init() deriving Base.Init().
" s:CommentAnyWay.MultiLine.Init() dict {{{3
func! s:CommentAnyWay.MultiLine.Init() dict
    let self.pos            = ''
    let self.lnum           = 0
    let self.range          = []
    let self.head_space     = ''
    let self.MAX_SRCH_LINES = 100
    let self.range_buffer   = ''
endfunc
" }}}3

" TODO
" s:CommentAnyWay.MultiLine.LoadDefinitions() dict {{{3
func! s:CommentAnyWay.MultiLine.LoadDefinitions() dict
    if g:cs_verbose
        call s:Warn( 'not implemented yet s:CommentAnyWay.MultiLine.LoadDefinitions()...' )
    endif
endfunc
" }}}3

" s:CommentAnyWay.MultiLine.Run() dict {{{3
func! s:CommentAnyWay.MultiLine.Run() dict
    let save_z_str  = getreg( 'z', 1 )
    let save_z_type = getregtype( 'z' )
    if a:firstline != a:lastline
        normal "zy
        let self.range_buffer = @z
    endif
    call setreg( 'z', save_z_str, save_z_type )

    call self.Comment()
endfunc
" }}}3

" TODO: range
" s:CommentAnyWay.MultiLine.Comment() {{{3
func! s:CommentAnyWay.MultiLine.Comment() dict
    " NOTE: no need to call ***.LoadVimComments(),
    " because called it from s:LoadWhenBufEnter()

    if ! self.ExistsDefinitions()
        call s:Warn( "current filetype doesn't support multi-line comment string." )
        return
    endif

    " build multi-comment string.
    let cmts_lis = self.BuildComments()
    if empty( cmts_lis ) | return | endif
    let cmt_str = join( cmts_lis, "\n" )

    let multiline_insert_pos = s:GetVar( 'cs_multiline_insert_pos' )
    let multiline_insert     = s:GetVar( 'cs_multiline_insert' )

    if ! self.HasRange()
        " has no range. (normal mode)
        call self.InsertString( cmt_str, multiline_insert_pos )
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
        call self.InsertString( cmt_str, multiline_insert_pos )
        if search( '%cursor%', 'Wbc' )
            if multiline_insert
                call feedkeys( 'v7l"_c', 'n' )
            else
                call feedkeys( 'v7l"_d', 'n' )
            endif
        endif
        call self.InsertString( self.range_buffer, 'here' )
    endif
endfunc
" }}}3

" s:CommentAnyWay.MultiLine.ExistsDefinitions( ... ) dict {{{3
func! s:CommentAnyWay.MultiLine.ExistsDefinitions( ... ) dict
    if a:0 ==# 0
        let table = s:FileType.priorities_table
    elseif type( a:1 ) ==# type( [] )
        let table = a:1
    endif

    for i in s:GetVar( 'cs_multiline_priority' )
        let option_or_setting = s:FileType.MultiLineString[ table[i] ]
        if has_key( option_or_setting, &ft )
          \ && s:HasAllKeys( option_or_setting[&ft], ['s', 'm', 'e'] )
            return 1
        endif
    endfor

    return 0
endfunc
" }}}3

" s:CommentAnyWay.MultiLine.BuildComments() {{{3
func! s:CommentAnyWay.MultiLine.BuildComments()
    let table       = s:FileType.priorities_table
    let result_lis  = []
    let debug       = {}

    let template = s:GetVar( 'cs_multiline_template' )

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
            return self.BuildComments()
        endif

        " matched: %s%, %m%, %e%
        " key    : s, m, e
        let [matched, key; unko] = lis

        for order in s:GetVar( 'cs_multiline_priority' )
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
" }}}3

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
