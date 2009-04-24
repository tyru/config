scriptencoding utf-8

"-----------------------------------------------------------------
" DOCUMENT {{{1
"==================================================
" Name: CommentAnyWay.vim
" Version: 0.2.2
" Author: vimuma
" Last Change: 2009-01-14.
"
"
"
" Change Log: {{{2
"   0.0.0: Initial release.
"   0.0.1: Fixed s:UnComment() uncomment nested commented line.
"   0.0.2: Stable release.
"   0.0.3: Rewrite code in Object-Oriented.
"   0.0.4: Fix bug that comment won't change when call :CSOnelineComment
"   0.0.5: Fix bug that s:Slurp() won't slurp. (just see 1 line.)
"   0.0.6: Stable release.
"   0.0.7: Support multi-line comment. but there were a few problems yet.
"   0.0.8: Fix some problems about multi-line. and insert at tail of current line when 'gca'.
"   0.0.9: Stable release.
"   0.1.0: Fix bug that :CSOnelineComment won't change comment again. add many global variables and |gcw|
"   0.1.1: Implement g:cs_multiline_priority and so on. and Fix some bugs.
"     and Change the g:cs_mapping_table mostly. old mappings are what a crazy mapings!!
"   0.1.2: Fix some bugs and implement |gco| and |gcO| and so on.
"   0.1.3: Implement wrap-line definition. and fix some bugs.
"   0.1.4: Implement JumpComment
"   0.1.5: Rewrite code in Object-Oriented.(at the time of 0.0.3, not OOP code!)
"   0.1.6: Implement VariousComment().
"   0.1.7: Stable release.
"   0.1.8: Fix bug that JumpComment() would comment 2 times.
"     and change the default value of g:cs_wrap_forward and g:cs_wrap_back
"   0.1.9: Fix bug that MultiLine.Comment() can't delete %c%, and that GetIndent()
"     get wrong indent num.
"   0.2.0: Implement insert if, while, for, switch. and so on.
"   0.2.1: Implement compound filetype specification of g:cs_filetype_table.
"   0.2.2: Fix some bugs that GetIndent() get wrong indent num again,
"     and that CSOnelineComment won't change comment again and again.
" }}}2
"
"
"
" Usage:
"   COMMANDS: {{{2
"     CSOnelineComment [comment]
"         (this takes arguments 0 or 1)
"         change current one-line comment.
"         but more smarter way is using |gcv|.
"
"     CSRevertComment
"         (this takes no arguments)
"         revert comment.
"   }}}2
"
"
"   MAPPING: {{{2
"     In normal mode:
"       If you typed digits string([1-9]) before typing these mappings,
"       behave like in visual mode.
"       so you want to see when you gave digits string, see "In visual mode".
"
"       gcc
"           if default. this is the same as |gct|.
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
"       gct
"           toggle comment/uncomment.
"       gcv{wrap}{action}
"           add various comment.
"       gco
"           jump(o) before add comment.
"       gcO
"           jump(O) before add comment.
"       gcmm
"           add multi-comment.
"       gcmi
"           add if statement.
"       gcmw
"           add while statement.
"       gcmf
"           add for statement.
"       gcms
"           add switch statement.
"       gcmd
"           add do ~ while statement.
"       gcmt
"           add try ~ catch statement.
"
"
"     In visual mode:
"
"       gcc
"           if default. this is the same as |gct|.
"       gcI
"           add one-line comment to the beginning of line.
"       gci
"           add one-line comment to the beginning of non-space string(\S).
"       gca
"           add one-line comment to the end of line.
"       gcu{type}
"           type is one of 'I i a w'.
"           remove one-line comment.
"       gcw
"           add one-line comment to wrap the line.
"       gct
"           toggle comment/uncomment.
"       gcv{string}
"           add various comments.
"       gcmm
"           add multi-comment.
"       gcmi
"           add if statement.
"       gcmw
"           add while statement.
"       gcmf
"           add for statement.
"       gcms
"           add switch statement.
"       gcmd
"           add do ~ while statement.
"       gcmt
"           add try ~ catch statement.
"
"   }}}2
"
"
"   EXAMPLES: {{{2
"     If global variables are all default value...
"
"     |gcI|
"       before:
"           '   testtesttest'
"       after:
"           '#    testtesttest'
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
"
"     |gcw|
"       before:
"           'aaaaaaa'
"       after:
"           '/* aaaaaaa */'
"
"     |gcv|
"       before:
"           '   some code here'
"       after:
"           type 'gcv# XXX:<CR>i'. so
"           '   # XXX: some code here'
"
"      multiline mappings(gcm*) insert the comments or the statements.
"
"      global variables change detailed behavior.
"      and all these mappings are also available in visual mode.
"
"    }}}2
"
"
"   GLOBAL VARIABLES: {{{2
"       There are two type variables(b:*** and g:***)
"       except cs_filetype_support, cs_filetype_table, cs_mapping_table,
"       g:cs_prefix.
"
"       And 'cs_ff_space', 'cs_fb_space', 'cs_bf_space', 'cs_bb_space',
"       'cs_wrap_forward', 'cs_wrap_back' will be replaced with common pattern.
"         TODO: add more patterns.
"         
"         multiline :
"           '%i%': indent space.(&tabstop)
"           '%o%': b:cs_oneline_comment or g:cs_oneline_comment
"           '%^%': the line which includes this is not inserted indent.
"       and cs_oneline_comment, are not
"       replaced with that patterns.
"
"
"
"     g:cs_filetype_table (default:read below.)
"         the default structure is:
"
"     g:cs_filetype_support (default:1)
"         if false, force some variables to be set
"           cs_oneline_priority   is [0]
"           cs_multiline_priority is [0]
"         (if you feel vim's response is slow while using my plugin,
"         make this true. but no filetype comment is supported.)
"
"     g:cs_mapping_table (default:read below.)
"         each map is required 'pass' and 'mode' at least.
"         the default structure is:
"           let s:cs_mapping_table = {
"               \ 'c' : {
"                   \ 'pass' : 't',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ },
"               \ 'I' : {
"                   \ 'pass' : 'I',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'i' : {
"                   \ 'pass' : 'i',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'a' : {
"                   \ 'pass' : 'a',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'w' : {
"                   \ 'pass' : 'w',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 't' : {
"                   \ 'pass' : 't',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'u' : {
"                   \ 'pass' : 'u',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'o' : {
"                   \ 'pass' : 'o',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'n',
"               \ }, 
"               \ 'O' : {
"                   \ 'pass' : 'O',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'n',
"               \ },
"               \ 'v' : {
"                   \ 'pass' : 'v',
"                   \ 'mode' : 'nv',
"               \ },
"               \ 'mm' : {
"                   \ 'pass' : 'mc',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ },
"               \ 'mc' : {
"                   \ 'pass' : 'mc',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'mi' : {
"                   \ 'pass' : 'mi',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'mw' : {
"                   \ 'pass' : 'mw',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'mf' : {
"                   \ 'pass' : 'mf',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ }, 
"               \ 'ms' : {
"                   \ 'pass' : 'ms',
"                   \ 'silent' : 1,
"                   \ 'mode' : 'nv',
"               \ },
"           \}
"
"
"     g:cs_prefix (default:gc)
"         the prefix of mapping.
"         example, if you did
"             let g:cs_prefix = ',c'
"         so you can add comment at the beginning of line
"         by typing ',cI' or ',ci'
"         
"         my favorite mapping is '<LocalLeader>c'.
"         my g:maplocalleader is ';'. so this is the same as ';c'.
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
"     cs_wrap_read_indent (default:1)
"         insert comment after indent space when |gcw|.
"
"     cs_wrap_forward (default:'%o%%o%%o% ')
"         if couldn't find wrap-line comment of current filetype.
"         use this as its comment.
"         this is added before the line when |gcw|.
"
"     cs_wrap_back (default:' %o%%o%%o%')
"         if couldn't find wrap-line comment of current filetype.
"         use this as its comment.
"         this is added after the line when |gcw|.
"
"     cs_I_enter_i_if_blank (default:1)
"         when |gcI|, if normal mode, and current line is blank line,
"         enter the insert mode after the comment.
"
"     cs_i_enter_i_if_blank (default:1)
"         when |gci|, if normal mode, and current line is blank line,
"         enter the insert mode after the comment.
"
"     cs_a_enter_i (default:1)
"         enter the insert mode after the comment.
"
"     cs_wrap_enter_i (default:1)
"         when |gcw|, if normal mode,
"         enter the insert mode after the comment.
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
"     TODO: cs_align_wrap (default:1)
"         if true, align |gcw| comment.
"
"     cs_multiline_insert_pos (default:'o')
"         'O': insert multi-line comment at current line, like 'O'.
"         'o': insert multi-line comment at next line, like 'o'.
"
"     cs_oneline_priority (default:[1, 0])
"         define priorities of the order of one-line comment.
"         0 : vim's |comments| option definition.
"         1 : my comment definition.
"         NOTE: if you do not want to my definition... just do
"           let g:cs_oneline_priority = [0]
"         but parser of |comments| might get wrong definition.
"
"     cs_multiline_priority (default:[1, 0])
"         define priorities of the order of multi-line comment.
"         0 : vim's |comments| option definition.
"         1 : my comment definition.
"         NOTE: if you do not want to my definition... just do
"           let g:cs_oneline_priority = [0]
"         but parser of |comments| might get wrong definition.
"   }}}2
"
"
"   TODO:
"     * do TODO. fix FIXME. check XXX.
"     * support comments type of
"           multi-line : '#if 0' ~ '#endif'
"       and manage many types of comments.
"     * for |gcv|, add more patterns(s:ReplacePat.[Comment/UnComment])
"       and user can pre-define the patterns.
"       (this is similar to :s, but fast.)
"     * add fold function.(&commentstring)
"     * MultiLine.UnComment()
"     * user defines template string.(or the function returning it)
"     * insert if, while, ... in visual mode.
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

" DEFINE DEBUG FUNC/COM IF g:cs_verbose {{{2
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
    if a:0 ==# 0
        call s:EchoWith( a:msg, 'WarningMsg' )
    else
        let [errID, msg] = [a:msg, a:1]
        call s:EchoWith( 'Sorry, internal error.', 'WarningMsg' )
        call s:EchoWith( printf( "errID:%s\nmsg:%s", errID, msg ), 'WarningMsg' )
    endif
endfunc
" }}}2

" s:EchoWith( msg, hi ) {{{2
func! s:EchoWith( msg, hi )
    execute 'echohl '. a:hi
    echo a:msg
    echohl None
endfunc
" }}}2

" s:RunWithPos( pos ) range {{{2
func! s:RunWithPos( pos ) range
    if a:pos =~# '\.'
        let [pos, mode] = split( a:pos, '\.' )
    else
        let pos = a:pos
        let mode = 'n'
    endif

    let z_str  = getreg( 'z', 1 )
    let z_type = getregtype( 'z' )
    " for speed-optimization
    let s:Options = [ { 'name' : 'lazyredraw',
                      \ 'value' : &lazyredraw,
                      \ 'type' : 'bool' } ]
    setl lazyredraw

    let mapping = s:CommentAnyWay.Base.FindMapping( pos )
    if mapping !=# ''
        call s:CommentAnyWay[mapping].Init()
        let s:CommentAnyWay[mapping].pos       = pos
        let s:CommentAnyWay[mapping].has_range = mode == 'v'
        let s:CommentAnyWay[mapping].range     = [a:firstline, a:lastline]
        let s:CommentAnyWay[mapping].parent    = mapping
        call s:CommentAnyWay[mapping].Run()
    else
        if g:cs_verbose
            call s:Warn( printf( 'no key for %s.', pos ) )
            call s:Warn( printf( 'mapping:%s', mapping ) )
        endif
    endif

    call s:RestoreOptions()
    call setreg( 'z', z_str, z_type )
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
        let var = i .':'. a:varname
        if exists( var )
            return deepcopy( eval( var ) )
        endif
    endfor

    let v:errmsg = printf( "Can't get variable '%s'", a:varname )
    throw 'variable error'
endfunc
" }}}2

" TODO: cache
" s:GetFileTypeDef( dict, ... ) {{{2
func! s:GetFileTypeDef( dict, ... )
    let retval = a:0 == 0 ? '' : a:1
    if &ft ==# '' | return retval | endif
    " NOTE: compound filetype is ignored.
    let cur_ftype = get( split( &ft, '\.' ), 0 )

    for key in keys( a:dict )
        for ftype in split( key, '\.' )
            if cur_ftype ==# ftype
                return deepcopy( a:dict[key] )
            endif
        endfor
    endfor
    return retval
endfunc
" }}}2

" s:FilterFileType( dict, template ) {{{2
func! s:FilterFileType( dict, template )
    let template = deepcopy( a:template )
    for key in keys( a:dict )
        " get rid of ftype(all key's filetype) from keys of a:template,
        for ftype in split( key, '\.' )
            " rename key if found ftype.
            for templ_key in keys( template )
                if index( split( templ_key, '\.' ), ftype ) != -1
                    " rename
                    let lis = filter( split( templ_key, '\.' ), 'v:val !=# ftype' )
                    if ! empty( lis )
                        let new_key_name = join( lis, '.' )
                        let template[new_key_name] = template[templ_key]
                    endif
                    unlet template[templ_key]
                endif
            endfor
        endfor
    " add key to template
    let template[key] = deepcopy( a:dict[key] )
    endfor
    return template
endfunc
" }}}2

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
" }}}2

" s:RestoreOptions() {{{2
func! s:RestoreOptions()
    if ! empty( s:Options )
        for opt in s:Options
            if opt.type == 'string'
                execute printf( 'setlocal %s=%s', opt.name, opt.value )
            else
                execute printf( 'let &%s = %s', opt.name, opt.value )
            endif
        endfor
        let s:Options = []
    endif
    " no inserted string.
    return ''
endfunc
" }}}2

" s:InsertCommentFromMap( flag ) {{{2
func! s:InsertCommentFromMap( flag )
    let [fcomment, bcomment, wrap_forward, wrap_back]
            \ = s:CommentAnyWay.OneLine.GetOneLineComment()
    let str = ''

    if a:flag =~? 'i'  | let str .= fcomment     | endif
    if a:flag =~# 'a'  | let str .= bcomment     | endif
    if a:flag =~# 'wf' | let str .= wrap_forward | endif
    if a:flag =~# 'wb' | let str .= wrap_back    | endif

    return str
endfunc
" }}}2

func! s:ExpandTab( sp_num )
    return &expandtab ? 
        \ repeat( ' ', a:sp_num )
        \ : repeat( "\t", a:sp_num / &tabstop)
endfunc
" }}}1
"-----------------------------------------------------------------
" GLOBAL VARIABLES {{{1
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
" g:cs_I_enter_i_if_blank
if ! exists( 'g:cs_I_enter_i_if_blank' )
    let g:cs_I_enter_i_if_blank = 1
endif
" g:cs_i_enter_i_if_blank
if ! exists( 'g:cs_i_enter_i_if_blank' )
    let g:cs_i_enter_i_if_blank = 1
endif
" g:cs_a_enter_i
if ! exists( 'g:cs_a_enter_i' )
    let g:cs_a_enter_i = 1
endif
" g:cs_wrap_enter_i
if ! exists( 'g:cs_wrap_enter_i' )
    let g:cs_wrap_enter_i = 1
endif
" g:cs_align_forward
if ! exists( 'g:cs_align_forward' )
    let g:cs_align_forward = 1
endif
" g:cs_align_back
if ! exists( 'g:cs_align_back' )
    let g:cs_align_back = 1
endif
" g:cs_align_wrap
if ! exists( 'g:cs_align_wrap' )
    let g:cs_align_wrap = 1
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
    let g:cs_wrap_forward = '%o%%o%%o% '
endif
" g:cs_wrap_back
if ! exists( 'g:cs_wrap_back' )
    let g:cs_wrap_back = ' %o%%o%%o%'
endif
" g:cs_i_read_indent
if ! exists( 'g:cs_i_read_indent' )
    let g:cs_i_read_indent = 1
endif
" g:cs_wrap_read_indent
if ! exists( 'g:cs_wrap_read_indent' )
    let g:cs_wrap_read_indent = 1
endif
" cs_filetype_support
if ! exists( 'g:cs_filetype_support' )
    let g:cs_filetype_support = 1
endif

" cs_multiline_insert_pos {{{2
if exists( 'g:cs_multiline_insert_pos' )
    if g:cs_multiline_insert_pos ==? 'o'
        call s:Warn( 'g:cs_multiline_insert_pos is allowed one of "o O".' )
        let g:cs_multiline_insert_pos = 'o'
    endif
else
    let g:cs_multiline_insert_pos = 'o'
endif
" }}}2

" g:cs_toggle_comment {{{2
if exists( 'g:cs_toggle_comment' )
    if g:cs_toggle_comment !~# '^[Iiaw]$'
        let msg = 'g:cs_toggle_comment is allowed one of "I i a w".'
        call s:Warn( msg )
        let g:cs_toggle_comment = 'i'
    endif
else
    let g:cs_toggle_comment = 'i'
endif
" }}}2

" g:cs_jump_comment {{{2
if exists( 'g:cs_jump_comment' )
    if g:cs_jump_comment !=? 'i'
        call s:Warn( 'g:cs_jump_comment is allowed "o O".' )
        let g:cs_jump_comment = 'i'
    endif
else
    let g:cs_jump_comment = 'i'
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
" NOTE: THIS IS NOT A GLOBAL VARIABLE!!
let s:cs_filetype_table = {
    \ 'oneline' : {
        \ 'actionscript.c.cpp.cs.d.java.javascript.objc' : '//',
        \ 'asm.lisp.scheme' : ';',
        \ 'vb'           : "'",
        \ 'perl.python.ruby' : '#',
        \ 'vim.vimperator' : '"',
        \ 'dosbatch'     : 'rem',
    \ },
    \ 'wrapline' : {
        \ 'actionscript.c.cpp.cs.d.java.javascript.objc' : ['/* '  , ' */'],
        \ 'html'         : [ "<!-- ", " -->" ],
    \ },
    \ 'multiline' : {
        \ 'comment' : {
            \ 'actionscript.c.cpp.cs.d.javascript.objc' : ['/*', ' * %c%', ' */'],
            \ 'java' : ['/**', ' * %c%', ' */'],
            \ 'scheme' : ['#|', '%i%%c%', '|#'],
            \ 'perl.ruby' : ['%^%=pod', '%c%', '%^%=cut'],
            \ 'html' : ["<!--", '%i%%c%', '-->'],
        \ },
        \ 'if': {
            \ 'actionscript.c.cpp.cs.d.java.javascript.objc.perl' : ['if( %c% ) {', '}'],
            \ 'ruby' : ['if %c%', 'end'],
            \ 'python' : ['if %c%:'],
            \ 'vim' : ['if %c%', 'endif'],
            \ 'dosbatch' : ['if %c% (', ')'],
        \ },
        \ 'while' : {
            \ 'actionscript.c.cpp.cs.d.java.javascript.objc.perl' : ['while( %c% ) {', '}'],
            \ 'ruby' : ['while %c%', 'end'],
            \ 'python' : ['while %c%:'],
            \ 'vim' : ['while %c%', 'endwhile'],
        \ },
        \ 'for': {
            \ 'actionscript.c.cpp.cs.d.java.javascript.objc' : ['for( %c%; ; ) {', '}'],
            \ 'perl' : ['for( %c% ) {', '}'],
            \ 'ruby' : ['for %c% in ', 'end'],
            \ 'python' : ['for %c% in :'],
            \ 'vim' : ['for %c% in', 'endfor'],
            \ 'dosbatch' : ['for %c% in () do (', ')'],
        \ },
        \ 'switch': {
            \ 'actionscript.c.cpp.cs.d.java.javascript.objc' : ['switch( %c% ) {', '}'],
            \ 'perl' : ['given( %c% ) {', '}'],
            \ 'ruby' : ['case %c%', 'end'],
        \ },
        \ 'try' : {
            \ 'actionscript.cpp.cs.d.java' : ['try {', '} catch( %c% ) {', '}'],
            \ 'objc' : ['@try {', '} @catch( %c% ) {', '}'],
            \ 'vim' : ['try', 'catch %c%', 'endtry']
        \ },
        \ 'do' : {
            \ 'actionscript.c.cpp.cs.d.java.javascript.objc' : ['do {', '} while( %c% );'],
            \ 'perl' : ['do {', '%c%', '};'],
        \ },
    \ },
\ }
if exists( 'g:cs_filetype_table' )
    if g:cs_filetype_support
        try
            for [key, val] in items( g:cs_filetype_table )
                " key: 'oneline', 'wrapline', ...
                if key ==# 'multiline'
                    " val: 'comment', 'if', 'while', ...
                    for i in keys( val )
                        let g:cs_filetype_table[key][i]
                            \ = s:FilterFileType( val[i], s:cs_filetype_table[key][i])
                    endfor
                else
                    " val: 'actionscript.c.cpp ...'
                    let g:cs_filetype_table[key]
                        \ = s:FilterFileType( val, s:cs_filetype_table[key] )
                endif
            endfor
        catch /^type error$/
            call s:Warn( 'type error: g:cs_filetype_table is Dictionary. use default.' )
            let g:cs_filetype_table = s:cs_filetype_table
        endtry
    else
        " even if no support is needed,
        " user's g:cs_filetype_table remains.
    endif
else
    let g:cs_filetype_table = s:cs_filetype_table
endif
unlet s:cs_filetype_table

if ! g:cs_filetype_support
    let g:cs_oneline_priority   = [0]
    let g:cs_multiline_priority = [0]
endif
" }}}2

" cs_mapping_table {{{2
" NOTE: this will be unlet in s:Init().
" NOTE: THIS IS NOT A GLOBAL VARIABLE!!
let s:cs_mapping_table = {
    \ 'c' : {
        \ 'pass' : 't',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ },
    \ 'I' : {
        \ 'pass' : 'I',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'i' : {
        \ 'pass' : 'i',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'a' : {
        \ 'pass' : 'a',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'w' : {
        \ 'pass' : 'w',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 't' : {
        \ 'pass' : 't',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'u' : {
        \ 'pass' : 'u',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'o' : {
        \ 'pass' : 'o',
        \ 'silent' : 1,
        \ 'mode' : 'n',
    \ }, 
    \ 'O' : {
        \ 'pass' : 'O',
        \ 'silent' : 1,
        \ 'mode' : 'n',
    \ },
    \ 'v' : {
        \ 'pass' : 'v',
        \ 'mode' : 'nv',
    \ },
    \ 'mm' : {
        \ 'pass' : 'mc',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ },
    \ 'mc' : {
        \ 'pass' : 'mc',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'mi' : {
        \ 'pass' : 'mi',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'mw' : {
        \ 'pass' : 'mw',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'mf' : {
        \ 'pass' : 'mf',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ }, 
    \ 'ms' : {
        \ 'pass' : 'ms',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ },
    \ 'md' : {
        \ 'pass' : 'md',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ },
    \ 'mt' : {
        \ 'pass' : 'mt',
        \ 'silent' : 1,
        \ 'mode' : 'nv',
    \ },
\}
if exists( 'g:cs_mapping_table' )
    try
        let g:cs_mapping_table =
            \ s:ExtendUserSetting( g:cs_mapping_table, s:cs_mapping_table )
    catch /^type error$/
        let msg = 'type error: g:cs_mapping_table is Dictionary. use default.' 
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

" NOTE: don't add these variables to s:CommentAnyWay,
" structures get so huge.(deepcopy Base to OneLine, MultiLine)
" NOTE:
" these keys are used when looking up which class(OneLine, MultiLine) is called.
" and values are used by OneLine.Slurp() and MultiLine.Run().
let s:Mappings = {
    \ 'I' : ['OneLine', { 'func' : 'Comment'       , 'slurp' : 1 } ],
    \ 'i' : ['OneLine', { 'func' : 'Comment'       , 'slurp' : 1 } ],
    \ 'a' : ['OneLine', { 'func' : 'Comment'       , 'slurp' : 1 } ],
    \ 'w' : ['OneLine', { 'func' : 'Comment'       , 'slurp' : 1 } ],
    \ 't' : ['OneLine', { 'func' : 'ToggleComment' , 'slurp' : 1 } ],
    \ 'u' : ['OneLine', { 'func' : 'UnComment'     , 'slurp' : 1 } ],
    \ 'v' : ['OneLine', { 'func' : 'VariousComment' } ],
    \ 'o' : ['OneLine', { 'func' : 'JumpComment' } ],
    \ 'O' : ['OneLine', { 'func' : 'JumpComment' } ],
    \ 'mc' : [ 'MultiLine', { 'func' : 'BuildString' } ], 
    \ 'mi' : [ 'MultiLine', { 'func' : 'BuildString' } ], 
    \ 'mw' : [ 'MultiLine', { 'func' : 'BuildString' } ], 
    \ 'mf' : [ 'MultiLine', { 'func' : 'BuildString' } ], 
    \ 'ms' : [ 'MultiLine', { 'func' : 'BuildString' } ], 
    \ 'md' : [ 'MultiLine', { 'func' : 'BuildString' } ], 
    \ 'mt' : [ 'MultiLine', { 'func' : 'BuildString' } ], 
\ }
let s:ReplacePat = { 'Comment': {}, 'UnComment': {} }
let s:FileType = {
    \ 'prev_filetype'   : '',
    \ 'priorities_table' : ['option', 'setting'],
    \ 'OneLineString'   : { 'setting' : {}, 'option' : {} },
    \ 'WrapString'      : { 'setting' : {} },
    \ 'MultiLineString' : { 'setting' : {}, 'option' : {} },
\ }
" dictionary, because of priority of restoring.
let s:Options = []
" " let s:StackTrace = []
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
    " user's(and my) settings of filetype.
    if has_key( g:cs_filetype_table, 'oneline' )
        let s:FileType.OneLineString.setting
                    \ = deepcopy( g:cs_filetype_table.oneline )
    endif
    if has_key( g:cs_filetype_table, 'wrapline' )
        let s:FileType.WrapString.setting
                    \ = deepcopy( g:cs_filetype_table.wrapline )
    endif
    if has_key( g:cs_filetype_table, 'multiline' )
        let s:FileType.MultiLineString.setting
                    \ = deepcopy( g:cs_filetype_table.multiline )
    endif
    unlet g:cs_filetype_table

    " mappings
    for [mapkey, map] in items( g:cs_mapping_table )
        if ! has_key( map, 'pass' ) || ! has_key( map, 'mode' )
            call s:Warn( 'missing a few keys in g:cs_mapping_table["'. mapkey .'"]' )
            continue
        endif
        if ! has_key( s:Mappings, map.pass )
            call s:Warn( 'no function found for mapping %s.' )
            continue
        endif

        " map each mode.
        for mode in split( map.mode, '\zs' )
            if has_key( map, 'silent' ) && map.silent
                let silent = '<silent>'
            else
                let silent = ''
            endif
            execute printf( '%snoremap <unique>%s %s :call <SID>RunWithPos( "%s" )<CR>', mode, silent, g:cs_prefix . mapkey, map.pass .'.'. mode )
        endfor

        let [class, mappings] = s:Mappings[map.pass]
        let dest_obj = s:CommentAnyWay[class]
        let dest_obj.mappings[map.pass] = mappings
    endfor
    unlet s:Mappings
    unlet g:cs_mapping_table

    " map no mapped the map to <Plug>***.
    " (to check indent num of current line)
    inoremap <silent><expr>
        \ <Plug>InsertComment_i    <SID>InsertCommentFromMap( "i" )

    " add FileType autocmd.
    augroup CSBufEnter
        autocmd!
        autocmd BufEnter *   call s:CommentAnyWay.Base.LoadWhenBufEnter()
    augroup END
    " delete CSStartUp group.
    augroup CSStartUp
        autocmd!
    augroup END
    augroup! CSStartUp

    " set comment string.
    call s:CommentAnyWay.Base.LoadWhenBufEnter()
endfunc
" }}}1
"-----------------------------------------------------------------
" FUNCTION DEFINITIONS {{{1

" BASE {{{2
let s:CommentAnyWay = {
    \ 'Base'      : { 'mappings' : {} },
    \ 'OneLine'   : {},
    \ 'MultiLine' : {},
\ }


" s:CommentAnyWay.Base.LoadVimComments() {{{3
func! s:CommentAnyWay.Base.LoadVimComments()
    if &ft ==# '' | return | endif
    let head_space = '0'
    let cmts_def_m = s:FileType.MultiLineString.option
    let cmts_def_o = s:FileType.OneLineString.option
    let cur_ftype  = get( split( &ft, '\.' ), 0 )
    if has_key( cmts_def_m, 'comment' )
     \ && ! empty( s:GetFileTypeDef( cmts_def_m.comment, [] ) )
        " has current filetype's definition.
        " so no need to load.(cache)
        return
    else
        " make a key
        let cmts_def_m = { 'comment' : { cur_ftype : [] } }
        let cmts_def_m_templ = { cur_ftype : {} }
    endif

    " load multi comment and oneline comment
    for i in split( &comments, ',' )
        let keep_empty    = 1
        let [flags; vals] = split( i, ':', keep_empty )
        " &comments =~# '0' is 0...
        if index( split( &comments, '\zs' ), '0' ) != -1 | continue | endif

        " for dosbatch
        call filter( vals, "v:val != ''" )
        if empty( vals ) | continue | endif
        let val = vals[0]

        " for one-line comment.
        if flags == ''
            if ! has_key( cmts_def_o, cur_ftype )
                let cmts_def_o[cur_ftype] = val
            endif
        endif

        let matched = matchstr( flags, '[sme]' )
        if matched ==# '' | continue | endif

        if matched ==# 's' && flags =~# '0'
            if has_key( cmts_def_m_templ[cur_ftype], 's' )
                unlet cmts_def_m_templ[cur_ftype]['s']
            endif
            continue
        elseif matched ==# 's' && flags =~# '[1-9][0-9]*'
            let head_space = matchstr( flags, '[1-9][0-9]*' )
        elseif matched ==# 'm' || matched ==# 'e'
            let val = repeat( ' ', head_space ) . val
        endif
        call extend( cmts_def_m_templ[cur_ftype], { matched : val }, 'force' )
    endfor

    " set multi-comment
    for i in ['s', 'm', 'e']
        if has_key( cmts_def_m_templ[cur_ftype], i )
            let cmts_def_m.comment[cur_ftype] += [ cmts_def_m_templ[cur_ftype][i] ]
        endif
    endfor
    " cmts_def_m is not same dict as s:FileType.***.option. (Why?)
    let s:FileType.MultiLineString.option = cmts_def_m
    " because the cache would work wrongly next BufEnter.
    if empty( cmts_def_m.comment[cur_ftype] ) | unlet cmts_def_m.comment | endif
endfunc
" }}}3

" s:CommentAnyWay.Base.LoadWhenBufEnter() {{{3
"   NOTE: don't return even when &ft is empty.
func! s:CommentAnyWay.Base.LoadWhenBufEnter()
    if &ft == ''
        let b:cs_oneline_comment = g:cs_oneline_comment
        let s:FileType.prev_filetype = ''
    else
        let cur_ftype = get( split( &ft, '\.' ), 0 )
        if cur_ftype !=# '' && cur_ftype ==# s:FileType.prev_filetype
            " cache
            return
        endif
        let s:FileType.prev_filetype = cur_ftype
    endif

    call s:CommentAnyWay.Base.LoadVimComments()    " load vim's 'comments' option.(for one or multi)
    for type in ['OneLine', 'MultiLine']
        call s:CommentAnyWay[type].LoadDefinitions()    " rebuild replace regexp.
    endfor
endfunc
" }}}3

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

" s:CommentAnyWay.Base.EnterInsertMode( prev_line ) dict {{{3
func! s:CommentAnyWay.Base.EnterInsertMode( prev_line ) dict
    let is_blankline = a:prev_line =~# '^\s*$'

    " insert at tail of current line when calling CommentOneLine()
    if self.pos ==# 'I'
        if is_blankline && s:GetVar( 'cs_I_enter_i_if_blank' )
            startinsert!
        endif
    elseif self.pos ==# 'i'
        if is_blankline && s:GetVar( 'cs_i_enter_i_if_blank' )
            startinsert!
        endif
    elseif self.pos ==# 'a'
        if s:GetVar( 'cs_a_enter_i' )
            startinsert!
        endif
    elseif self.pos ==# 'w' && is_blankline
        if s:GetVar( 'cs_wrap_enter_i' )
            let exec = '^'
            let len = strlen( s:CommentAnyWay.OneLine.GetOneLineComment()[2] )    " wrap_forward
            let exec .= len == 0    ? '' : len .'l'
            let exec .= 'i'
            call feedkeys( exec, 'n' )
        endif
    elseif self.pos =~# '^m'    " multi-comment
        normal! j
        if search( '%c%', 'Wbc' )
            " normal! v2l"_d
            " call feedkeys( 'a', 'n' )
            call feedkeys( 'v2l"_c', 'n' )
        endif
    endif
endfunc
" }}}3

" s:CommentAnyWay.Base.GetIndent( lnum ) dict {{{3
"   seek max indent num by searching the lines upward and downward.
"   NOTE: DON'T CALL ME AFTER INSERTING SOME STRINGS.
"   THIS UNDOES THAT BEHAVIOR.
func! s:CommentAnyWay.Base.GetIndent( lnum ) dict
    let cur_pos = getpos( '.' )
    call cursor( a:lnum, 1 )
    let s:Options += [ { 'name' : 'ai',
                       \ 'value' : &ai,
                       \ 'type' : 'bool' } ]
    setl ai

    let cmt = s:CommentAnyWay.OneLine.GetOneLineComment()[0]
    if cmt == ''
        " XXX: if word is special word of current filetype,
        " Vim indent 'word' automatically?
        " (so can't get the correct indent num)
        execute 'normal! Oword'
    else
        execute 'normal! O'. cmt
    endif
    let indent = indent( '.' )
    silent undo

    call setpos( '.', cur_pos )
    return indent
endfunc
" }}}3
" }}}2

" ONELINE COMMENT {{{2
let s:CommentAnyWay.OneLine = deepcopy( s:CommentAnyWay.Base )


" s:CommentAnyWay.OneLine.Init() dict {{{3
func! s:CommentAnyWay.OneLine.Init() dict
    let self.pos            = ''
    let self.lnum           = 0
    let self.range          = []
    let self.head_space     = ''
    let self.MAX_SRCH_LINES = 100
    let self.has_range      = 0
    let self.parent         = ''
    let self.uncomment_pos  = ''
endfunc
" }}}3

" s:CommentAnyWay.OneLine.Run() dict {{{3
func! s:CommentAnyWay.OneLine.Run() dict
    " save current line status.
    let prev_line = getline( self.range[0] )
    " get cs_align_forward
    " align comment position when 'gci'.
    if self.pos ==# 'i' && ( s:GetVar( 'cs_align_forward' ) || ! self.has_range && s:GetVar( 'cs_i_read_indent' ) )
        let self.head_space = s:ExpandTab( self.GetIndent( self.range[0] ) )
    elseif self.pos ==# 'w' && s:GetVar( 'cs_wrap_read_indent' )
        let self.head_space = s:ExpandTab( self.GetIndent( self.range[0] ) )
    else
        let self.head_space = ''
    endif

    " check uncomment pos.
    if self.pos ==# 'u'
        let self.uncomment_pos = nr2char( getchar() )    " get pos.
        if ! has_key( s:ReplacePat.UnComment, self.uncomment_pos )
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
        " for JumpComment(), VariousComment().
        let func = self.mappings[self.pos].func
        if type( func ) == type( "" )
            call self[func]()
        elseif type( func ) == type( function( 'tr' ) )
            call func()    " XXX: work?
        endif
    endif

    if ! self.has_range
        call self.EnterInsertMode( prev_line )
    endif
    nohlsearch
endfunc
" }}}3

" s:CommentAnyWay.OneLine.Slurp() dict {{{3
func! s:CommentAnyWay.OneLine.Slurp() dict
    let func = self.mappings[self.pos].func

    for self.lnum in range( self.range[0], self.range[1] )
        let line     = getline( self.lnum )
        if type( func ) == type( "" )
            let replaced = self[func]()
        elseif type( func ) == type( function( 'tr' ) )
            let replaced = func()
        endif
        if line != replaced | call setline( self.lnum, replaced ) | endif
    endfor
endfunc
" }}}3

" TODO: Align comment in case 'a'
" s:CommentAnyWay.OneLine.Comment() dict {{{3
func! s:CommentAnyWay.OneLine.Comment() dict
    let comment        = s:ReplacePat.Comment
    let line           = getline( self.lnum )
    let is_blankline   = line =~# '^\s*$'
    let is_i_align_cmt = self.pos ==# 'i' && ( s:GetVar( 'cs_align_forward' ) || ( ! self.has_range && s:GetVar( 'cs_i_read_indent' ) ) )

    if is_i_align_cmt
        let line = substitute( line, '^'. self.head_space, '', '')
        let line = substitute( line, comment['I'][0], comment['I'][1], '' )
        let line = self.head_space . line
    elseif self.pos ==# 'w' && s:GetVar( 'cs_wrap_read_indent' )
        let line = substitute( line, comment[self.pos][0], comment[self.pos][1], '' )
        if is_blankline
            let line = self.head_space . line
        endif
    else
        let line = substitute( line, comment[self.pos][0], comment[self.pos][1], '' )
    endif

    return line
endfunc
" }}}3

" s:CommentAnyWay.OneLine.UnComment() dict {{{3
func! s:CommentAnyWay.OneLine.UnComment() dict
    let uncomment = s:ReplacePat.UnComment[self.uncomment_pos]
    return substitute( getline( self.lnum ), uncomment[0], uncomment[1], '' )
endfunc
" }}}3

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
    let uncomment = s:ReplacePat.UnComment

    for i in ['I', 'i', 'a', 'w']
        if ! has_key( uncomment, i ) | continue | endif
        if matchstr( line, uncomment[i][0] ) !=# ''
            return 1
        endif
    endfor
    return 0
endfunc
" }}}3

" TODO: add more action (XXX:current support 'I', 'i')
" s:CommentAnyWay.OneLine.JumpComment() dict {{{3
func! s:CommentAnyWay.OneLine.JumpComment() dict
    let vect = self.pos

    " get comment pos.
    let pos = s:GetVar( 'cs_jump_comment' )


    let s:Options += [ { 'name' : 'ai',
                       \ 'value' : &ai,
                       \ 'type' : 'bool' } ]
    setl ai

    call feedkeys( vect, 'n' )    " jump.
    if !( pos ==# 'i' && s:GetVar( 'cs_align_forward' ) )
        call feedkeys( "\<Esc>0C", 'n' )
    endif

    call feedkeys( "\<Plug>InsertComment_i", 'm' )    " call s:InsertCommentFromMap( 'i' )
endfunc
" }}}3

" s:CommentAnyWay.OneLine.VariousComment() dict {{{3
func! s:CommentAnyWay.OneLine.VariousComment() dict
    " save values.
    call inputsave()
    let def = s:GetVar( 'cs_oneline_comment' )
    let s:Options +=
        \ [ { 'name' : 'eventignore', 'value' : &eventignore, 'type' : 'string' },
        \   { 'name' : 'filetype', 'value' : &ft, 'type' : 'string' } ]
    setl eventignore=all
    " LoadDefinitions() don't load any filetype definition.
    setl ft=

    " input comment string.
    let input_str = input( 'set definition:' )
    if input_str ==# '' | return | endif
    let b:cs_oneline_comment = input_str
    call self.LoadDefinitions()

    " input comment type.
    echon 'comment type:'
    let key = nr2char( getchar() )
    if key ==# "\<CR>" || key ==# "\<Esc>"
        return
    endif
    if self.FindMapping( key ) !=# 'OneLine' || key ==# 'v'
        return
    endif
    let self.pos = key
    call self.Run()

    " restore
    let b:cs_oneline_comment = def

    " reload filetype definition.
    call s:RestoreOptions()    " for loading definition.
    call self.LoadDefinitions()
    call inputrestore()
endfunc
" }}}3

" s:CommentAnyWay.OneLine.GetOneLineComment() {{{3
func! s:CommentAnyWay.OneLine.GetOneLineComment()
    let ff_space        = s:GetVar( 'cs_ff_space' )
    let fb_space        = s:GetVar( 'cs_fb_space' )
    let bf_space        = s:GetVar( 'cs_bf_space' )
    let bb_space        = s:GetVar( 'cs_bb_space' )
    let wrap_forward    = s:GetVar( 'cs_wrap_forward' )
    let wrap_back       = s:GetVar( 'cs_wrap_back' )
    let oneline_comment = s:GetVar( 'cs_oneline_comment' )

    " set filetype comment if exists.
    if &ft != ''
        """ NOTE: if no comment definition, just use upper value.
        " set one-line comment string.(e.g.: '"' when filetype is 'vim')
        let table = s:FileType.priorities_table
        for order in s:GetVar( 'cs_oneline_priority' )
            let cmts_def = s:FileType.OneLineString[ table[order] ]
            if s:GetFileTypeDef( cmts_def, '' ) != ''
                let oneline_comment = s:GetFileTypeDef( cmts_def )
                " IMPORTANT.
                break
            endif
        endfor
        " set wrap-line comment string.
        let cmts_def = s:FileType.WrapString.setting
        let def = s:GetFileTypeDef( cmts_def, [] )
        if ! empty( def )
            let [wrap_forward, wrap_back] = def
        endif
    endif

    " build commented string for searching its commented line.
    let fcomment = ff_space . oneline_comment . fb_space
    let bcomment = bf_space . oneline_comment . bb_space

    for i in ['fcomment', 'bcomment', 'wrap_forward', 'wrap_back']
        " %o% -> oneline_comment
        let fmt = 'let %s = substitute( %s, "%%o%%", oneline_comment, "g" )'
        execute printf( fmt, i, i )
    endfor

    return [fcomment, bcomment, wrap_forward, wrap_back]
endfunc
" }}}3

" s:CommentAnyWay.OneLine.LoadDefinitions() {{{3
func! s:CommentAnyWay.OneLine.LoadDefinitions()
    let oneline_comment = s:GetVar( 'cs_oneline_comment' )
    let [fcomment, bcomment, wrap_forward, wrap_back] = self.GetOneLineComment()
    let fescaped     = s:EscapeRegexp( fcomment )
    let bescaped     = s:EscapeRegexp( bcomment )

    let s:ReplacePat.Comment['I']
                \ = [ '^',
                \     fescaped ]
    let s:ReplacePat.UnComment['I']
                \ = [ '^'. fescaped,
                \     '' ]
    let s:ReplacePat.Comment['i']
                \ = [ '^\(\s*\)',
                \     '\1'. fescaped ]
    let s:ReplacePat.UnComment['i']
                \ = [ '^\(\s\{-}\)'. fescaped,
                \     '\1' ]
    let s:ReplacePat.Comment['a']
                \ = [ '$',
                \      bescaped ]
    let s:ReplacePat.UnComment['a']
                \ = [ bescaped .'[^'. oneline_comment .']*$',
                \     '' ]
    let fescaped = s:EscapeRegexp( wrap_forward )
    let bescaped = s:EscapeRegexp( wrap_back )
    let s:ReplacePat.Comment['w']
                \ = [ '^\(\s*\)\(.*\)$',
                \     '\1'. fescaped .'\2'. bescaped ]
    let s:ReplacePat.UnComment['w']
                \ = [ fescaped .'\(.*\)'. bescaped,
                \     '\1' ]
endfunc
" }}}3

" s:CommentAnyWay.OneLine.ChangeOnelineComment( ... ) {{{3
func! s:CommentAnyWay.OneLine.ChangeOnelineComment( ... )
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

    let save_ft = &ft
    setl ft=
    call s:CommentAnyWay.OneLine.LoadDefinitions()    " rebuild comment string.
    let &ft = save_ft

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


" TODO: sync with OneLine.Init() deriving Base.Init().
" s:CommentAnyWay.MultiLine.Init() dict {{{3
func! s:CommentAnyWay.MultiLine.Init() dict
    let self.pos            = ''
    let self.lnum           = 0
    let self.range          = []
    let self.head_space     = ''
    let self.MAX_SRCH_LINES = 100
    let self.has_range      = 0
    let self.parent         = ''
    let self.range_buffer   = ''
endfunc
" }}}3

" s:CommentAnyWay.MultiLine.LoadDefinitions() dict {{{3
func! s:CommentAnyWay.MultiLine.LoadDefinitions() dict
    " Nop.
endfunc
" }}}3

" s:CommentAnyWay.MultiLine.Run() dict {{{3
func! s:CommentAnyWay.MultiLine.Run() dict
    let func = self.mappings[self.pos].func
    if type( func ) == type( "" ) && ! has_key( self, self.mappings[self.pos].func )
        let fmt = "not implemented yet '%s'..."
        call s:Warn( printf( fmt, self.pos ) )
        return
    endif

    " range
    if self.has_range
        for lnum in range( self.range[0], self.range[1] )
            if self.range_buffer ==# ''
                let self.range_buffer = getline( lnum )
            else
                let self.range_buffer .= "\n". getline( lnum )
            endif
        endfor
    endif

    if type( func ) == type( "" )
        let cmt_lis = self[func]()
    elseif type( func ) == type( function( 'tr' ) )
        let cmt_lis = func()    " XXX: work?
    endif
    if empty( cmt_lis )
        call s:Warn( 'no definition found...' )
        return
    endif

    let ins_pos = s:GetVar( 'cs_multiline_insert_pos' )
    if self.has_range
        let sp_num = self.GetIndent( line( '.' ) )
    elseif ins_pos ==# 'o'
        let sp_num = self.GetIndent( line( '.' ) + 1 )
    elseif ins_pos ==# 'O'
        let sp_num = self.GetIndent( line( '.' ) )
    endif
    let indent_space = s:ExpandTab( sp_num )


    if ! self.has_range
        call self.InsertString( cmt_lis, ins_pos, indent_space )
        call self.EnterInsertMode( "" )
    else

        " delete selected lines and copy into register.
        let diff = self.range[1] - self.range[0]
        execute printf( 'normal! `<V%s"zd', diff == 0 ? '' : diff .'j' )

        " delete the minimum indent space of the lines.
        let ins_lines =
            \ map( split( @z, "\n" ), 'substitute( v:val, indent_space, "", "" )' )
        " add 1-indent space.
        let ins_sp = s:ExpandTab( &tabstop )
        call map( ins_lines, 'ins_sp . v:val' )

        " build and insert comment string.
        let cmt_lis = [ cmt_lis[0] ] + ins_lines + cmt_lis[1:]
        call self.InsertString( cmt_lis, 'O', indent_space )

        call self.EnterInsertMode( "" )
    endif
endfunc
" }}}3

" s:CommentAnyWay.MultiLine.InsertString( str_lines, pos, ins_space ) dict {{{3
func! s:CommentAnyWay.MultiLine.InsertString( str_lines, pos, ins_space ) dict
    " get rid of %^%. and flag turns off if found %^%.
    let insert_indent = 1
    let lines = []
    for line in deepcopy( a:str_lines )
        if line =~# '%^%'
            let line = substitute( line, '%^%', '', 'g' )
            let insert_indent = 0
        endif
        if line =~ "\n"
            let lines += split( line, "\n", 1 )
        else
            let lines += [ line ]
        endif
    endfor

    " build inserted string
    if ! insert_indent | let a:ins_space = '' | endif
    let lines  = map( lines, 'a:ins_space . v:val' )

    let @z         = join( lines, "\n" )
    let s:Options += [ { 'name' : 'paste',
                       \ 'value' : &paste,
                       \ 'type' : 'bool' } ]
    setl paste

    " insert
    if exists( ':AutoComplPopLock' )   | AutoComplPopLock   | endif
    if a:pos ==# 'o'
        silent put z
    else
        silent put! z
    endif
    if exists( ':AutoComplPopUnLock' ) | AutoComplPopUnlock | endif

    " restore
endfunc
" }}}3

" s:CommentAnyWay.MultiLine.BuildString() {{{3
func! s:CommentAnyWay.MultiLine.BuildString()
    let table       = s:FileType.priorities_table
    let result_lis  = []
    let debug       = []

    " set type of inserted string.
    " TODO: user defines template freely.
    " (make g:***_table and its structure
    " is { 'mc' : 'comment', 'mi' : 'if', ... })
    if self.pos ==# 'mc'
        let type = 'comment'
    elseif self.pos ==# 'mi'
        let type = 'if'
    elseif self.pos ==# 'mw'
        let type = 'while'
    elseif self.pos ==# 'mf'
        let type = 'for'
    elseif self.pos ==# 'ms'
        let type = 'switch'
    elseif self.pos ==# 'md'
        let type = 'do'
    elseif self.pos ==# 'mt'
        let type = 'try'
    endif


    for order in s:GetVar( 'cs_multiline_priority' )
        " cmts_def:
        " e.g.: { 'cpp': { 'comment' : [ '/*', ' * %c%', ' */' ], ... }, ... }
        let cmts_def = s:FileType.MultiLineString[ table[order] ]
        if has_key( cmts_def, type ) && ! empty( s:GetFileTypeDef( cmts_def[type], [] ) )
            " not deepcopy(or copy), indent increasing each time.
            let lines = s:GetFileTypeDef( cmts_def[type] )

            " %i% -> indent space
            let i = 0
            let space = s:ExpandTab( &tabstop )
            while i < len( lines )
                let fmt = 'let %s = substitute( %s, "%%i%%", space, "g" )'
                execute printf( fmt, 'lines[i]', 'lines[i]' )
                let i = i + 1
            endwhile

            return lines 
        endif
    endfor
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
            \ call s:CommentAnyWay.OneLine.ChangeOnelineComment( <f-args> )
command!                    CSRevertComment
            \ if exists( 'b:cs_oneline_comment' ) |
            \     unlet b:cs_oneline_comment |
            \ endif |
            \ call s:CommentAnyWay.OneLine.LoadDefinitions()
" }}}1
"-----------------------------------------------------------------
" MAPPINGS {{{1
""" see g:cs_mapping_table and s:Init()
" }}}1
"-----------------------------------------------------------------
" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1

" vim:set fdm=marker:fen:
