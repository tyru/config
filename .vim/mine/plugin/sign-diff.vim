" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: sign-diff
" Version: 0.0.3
" Author:  tyru <tyru.exe+vim@gmail.com>
" Last Change: 2009-07-26.
"
" GetLatestVimScripts: 2712 1 :AutoInstall: sign-diff
"
" Description:
"   show the diff status at left sidebar
"
" Change Log: {{{
"   0.0.0: Initial Upload
"   0.0.1:
"   - strict check the global options.
"   - no new files are created when g:SD_comp_with is default value.
"   - fix some bugs.
"   0.0.2:
"   - supports GetLatestVimScripts
"   - supports Windows (but cmd.exe shows up at front most...)
"   - fix the bug that the changed lines are highlighted as the added lines...
"   - supports difftext(the one changed line). if you wish to let this plugin
"   behave same as previous version, put "let g:SD_sign_text = '*'" and
"   "let g:SD_hl_difftext = 'DiffAdd'" into your .vimrc
"   0.0.3:
"   - fix warning of SDEnable. sorry.
"   - add g:SD_disable.
" }}}
" Usage: {{{
"   Commands: {{{
"       SDAdd
"           add current file to diff list.
"           current buffer will be diffed with
"           the written file's buffer.
"           if you want to change that, see g:SD_comp_with.
"       SDUpdate
"           update signs.
"       SDEnable
"           start showing signs.
"       SDDisable
"           stop showing signs.
"       SDToggle
"           toggle showing signs.
"       SDList
"           list all signs in current file
"   }}}
"
"   Global Variables: {{{
"       g:SD_disable (default:0)
"           if true, SDDisable when start up.
"
"       g:SD_backupdir (default:'~/.vim-sign-diff')
"           backup directory to save some backup of current file.
"           this dir will be mkdir-ed if doesn't exist.
"
"       g:SD_diffopt (default:&diffopt)
"           script local value of &diffopt.
"
"       g:SD_diffexpr (default:&diffexpr)
"           script local value of &diffopt.
"
"       g:SD_hl_diffadd (default:'DiffAdd')
"           highlight group of the added line(s).
"
"       g:SD_hl_diffchange (default:'DiffChange')
"           highlight group of the changed line(s).
"
"       g:SD_hl_diffdelete (default:'DiffDelete')
"           highlight group of the deleted line(s).
"
"       g:SD_hl_difftext (default:'DiffText')
"           highlight group of the one changed line.
"
"       g:SD_sign_add (default:'+')
"           sign of the added line(s).
"
"       g:SD_sign_change (default:'*')
"           sign of the changed line(s).
"
"       g:SD_sign_delete (default:'-')
"           sign of the changed line(s).
"
"       g:SD_sign_text (default:'@')
"           sign of the one changed line.
"           see :help hl-DiffText
"
"       g:SD_comp_with (default:['written', 'buffer'])
"           g:SD_comp_with is List of two items.
"           valid items are 'buffer'(same as 1), 'written',
"           or number of revisions to revert.
"           get diff output like the following.
"           (if this value is default)
"           $ diff written buffer > output
"
"       g:SD_autocmd_add (default:['BufReadPost'])
"           do autocmd for adding signs with these group
"
"       g:SD_autocmd_update (default:['CursorHold', 'InsertLeave'])
"           do autocmd for updating signs with these group
"
"       g:SD_delete_files_vimleave (default:1)
"           when starting VimLeave event,
"           delete all files under g:SD_backupdir.
"
"       g:SD_no_update_within_seconds (default:3)
"           won't update within this seconds.
"           0 to update each autocmd.
"           see g:SD_autocmd_add and g:SD_autocmd_update
"           about timing to throw event.
"   }}}
"
"   Tips: {{{
"       I suggest the following map.
"           nnoremap <C-l>  :SDUpdate<CR><C-l>
"   }}}
" }}}
"   TODO: {{{
"       - SDDiffThis, SDDiffPatch, etc...
"       - show diff also ordinary style (:diff*)
"       - jumping to the added/changed/deleted line.
"       this may be easy to implemenet.
"       but can't decide the interface...(quickfix?)
"       - update signs when undo?
"       - save only patches,
"       do not write whole current buffer
"       - show signs at foldcolumn?(option)
"   }}}
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_sign_diff') && g:loaded_sign_diff != 0
    finish
endif
let g:loaded_sign_diff = 1
" }}}
" Check Some Features {{{
let features = [
    \ "has('signs')",
    \ "has('diff')",
    \ "exists('*mkdir') || executable('mkdir')",
    \ "executable('diff')"
\ ]
for feat in features
    if !eval(feat)
        echohl WarningMsg
        echo printf('need %s. script is not loaded.', feat)
        echohl None

        finish
    endif
endfor

unlet features
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Scope Variables {{{
let s:files = {}
let s:enabled = 1
let s:backupdir = {}
let s:previous_time = 0
let s:check_comp_with = 0
let s:def_comp_with = ['written', 'buffer']
" }}}
" Global Variables {{{
if !exists('g:SD_debug')
    let g:SD_debug = 0
endif

if !exists('g:SD_disable')
    let g:SD_disable = 0
endif
if !exists('g:SD_backupdir')
    let g:SD_backupdir = '~/.vim-sign-diff'
endif
if !exists('g:SD_diffopt')
    let g:SD_diffopt = &diffopt
endif
if !exists('g:SD_diffexpr')
    let g:SD_diffexpr = &diffexpr
endif
if !exists('g:SD_hl_diffadd')
    let g:SD_hl_diffadd = "DiffAdd"
endif
if !exists('g:SD_hl_diffchange')
    let g:SD_hl_diffchange = "DiffChange"
endif
if !exists('g:SD_hl_diffdelete')
    let g:SD_hl_diffdelete = "DiffDelete"
endif
if !exists('g:SD_hl_difftext')
    let g:SD_hl_difftext = "DiffText"
endif
if !exists('g:SD_sign_add')
    let g:SD_sign_add = '+'
endif
if !exists('g:SD_sign_change')
    let g:SD_sign_change = '*'
endif
if !exists('g:SD_sign_delete')
    let g:SD_sign_delete = '-'
endif
if !exists('g:SD_sign_text')
    let g:SD_sign_text = '@'
endif
if !exists('g:SD_comp_with')
    let g:SD_comp_with = s:def_comp_with
else
    let s:check_comp_with = 1
endif
if !exists('g:SD_autocmd_add')
    let g:SD_autocmd_add = ['BufReadPost']
endif
if !exists('g:SD_autocmd_update')
    let g:SD_autocmd_update = ['CursorHold', 'InsertLeave', 'BufWritePost']
endif
if !exists('g:SD_delete_files_vimleave')
    let g:SD_delete_files_vimleave = 1
endif
if !exists('g:SD_show_signs_always')    " TODO
    let g:SD_show_signs_always = 0
endif
if !exists('g:SD_no_update_within_seconds')
    let g:SD_no_update_within_seconds = 3
endif
" }}}

" Functions {{{

" Util Functions {{{

" Debug {{{
if g:SD_debug
    let s:debug_errmsg = []

    func! s:debug(cmd, ...)
        if a:cmd ==# 'on'
            let g:SD_debug = 1
        elseif a:cmd ==# 'off'
            let g:SD_debug = 0
        elseif a:cmd ==# 'msg'
            for i in s:debug_errmsg
                echo i
            endfor
        elseif a:cmd ==# 'eval'
            redraw
            execute join(a:000, ' ')
        endif
    endfunc

    com! -nargs=+ SDDebug
        \ call s:debug(<f-args>)
endif

" s:debugmsg {{{
func! s:debugmsg(...)
    if g:SD_debug
        call s:apply('s:warn', a:000)
    endif
endfunc
" }}}

" }}}

" s:apply {{{
func! s:apply(funcname, args)
    let args_str = ''
    let i = 0
    while i < len(a:args)
        if args_str == ''
            let args_str = s:uneval(a:args[0])
        else
            let args_str .= ', ' . s:uneval(a:args[i])
        endif
        let i += 1
    endwhile
    return eval(printf('%s(%s)', a:funcname, args_str))
endfunc
" }}}

" s:warn {{{
func! s:warn(...)
    if a:0 == 0
        return
    elseif a:0 == 1
        let msg = a:1
    else
        let msg = s:apply('printf', a:000)
    endif

    echohl WarningMsg
    echo msg
    sleep 1
    redraw
    echohl None

    call add(s:debug_errmsg, msg)
endfunc
" }}}

" s:run_with_local_opt {{{
func! s:run_with_local_opt(cmd, options, is_expr, bufname)
    let is_expr = a:is_expr
    let saved_opt = {}

    " save
    for var in keys(a:options)
        let saved_opt[var] = getbufvar(a:bufname, var)
        call setbufvar(a:bufname, var, a:options[var])
    endfor

    try
        if is_expr
            let retval = eval(a:cmd)
        else
            execute a:cmd
        endif

        let success = 1
    catch
        let success = 0
    endtry

    " restore
    for var in keys(saved_opt)
        call setbufvar(a:bufname, var, saved_opt[var])
    endfor

    if is_expr
        return retval
    else
        return success
    endif
endfunc
" }}}

" s:uneval {{{
func! s:uneval(expr)
    let expr = a:expr

    if type(expr) == type(0)
        return expr + 0

    elseif type(expr) == type("")
        " how ugly
        let table = [
            \ 'n',
            \ 't'
        \ ]
        let expr = substitute(expr, '\', escape('\\', '\'), 'g')
        let expr = substitute(expr, '"', escape('\"', '\'), 'g')
        for i in table
            let pat = eval(printf('"\%s"', i))
            let sub = eval(printf('"\\%s"', i))
            " "\n" -> '\n'
            let expr = substitute(expr, pat, escape(sub, '\'), 'g')
        endfor
        let expr = '"'.expr.'"'
        return expr
        " return printf('"%s"', escape(expr, "\n\t\"\\"))

    elseif type(expr) == type(function('tr'))
        return printf("function('%s')", string(expr))

    elseif type(expr) == type([])
        let lis = map(copy(expr), 's:uneval(v:val)')
        return '['.join(lis, ',').']'

    elseif type(expr) == type({})
        let keys = keys(expr)
        let pairs = map(keys, 's:uneval(copy(v:val)).":".s:uneval(copy(expr[v:val]))')
        return '{'.join(pairs, ',').'}'

    else
        let v:errmsg = printf('undefined type number '.type(expr))
    endif
endfunc
" }}}

" s:has_elem {{{
func! s:has_elem(expr, elem)
    if type(a:expr) == type([])
        for v in a:expr
            if v ==# a:elem
                return 1
            endif
        endfor
    elseif type(a:expr) == type({})
        for v in values(a:expr)
            if v ==# a:elem
                return 1
            endif
        endfor
    endif

    return 0
endfunc
" }}}

" s:mkdir {{{
func! s:mkdir(path, ...)
    if exists('*mkdir')
        " just call mkdir() with same args as current args
        call s:apply('mkdir', [a:path] + a:000)
    elseif executable('mkdir')
        let opt = a:0 == 0 ? '' : '-'.a:1
        let cmd = printf('mkdir %s %s',
                        \ shellescape(opt), shellescape(a:path))
        call system(cmd)
    endif
endfunc
" }}}

" s:fix_within_range {{{
func! s:fix_within_range(val, range)
    if empty(a:range) | return | endif
    let val = a:val < a:range[0] ? a:range[0] : a:val
    let val = a:val > a:range[-1] ? a:range[-1] : a:val
    return val
endfunc
" }}}

" s:is_available_buffer {{{
func! s:is_available_buffer(buf)
    if a:buf == '' | return 0 | endif
    if bufname(a:buf) == '' | return 0 | endif
    if !(0+getbufvar(a:buf, '&modifiable')) | return 0 | endif
    if getbufvar(a:buf, '&bufhidden') == ''
        if getbufvar(a:buf, '&hidden') | return 0 | endif
    else
        return 0
    endif
    return filereadable(a:buf)
endfunc
" }}}

" }}}


" s:init {{{
func! s:init()
    " signs
    let defs = [
        \ {
            \ 'name'   : 'SD_group_add',
            \ 'texthl' : g:SD_hl_diffadd,
            \ 'text'   : g:SD_sign_add
        \ },
        \ {
            \ 'name'   : 'SD_group_change',
            \ 'texthl' : g:SD_hl_diffchange,
            \ 'text'   : g:SD_sign_change
        \ },
        \ {
            \ 'name'   : 'SD_group_delete',
            \ 'texthl' : g:SD_hl_diffdelete,
            \ 'text'   : g:SD_sign_delete
        \ },
        \ {
            \ 'name'   : 'SD_group_text',
            \ 'texthl' : g:SD_hl_difftext,
            \ 'text'   : g:SD_sign_text
        \ }
    \ ]
    for i in defs
        let text = strpart(i.text, 0, 2)
        let hl = i.texthl == '' ? '' : 'texthl='. i.texthl
        execute printf('sign define %s text=%s %s',
                \ i.name, text, hl)
    endfor

    let dir = expand(g:SD_backupdir)
    let s:backupdir = {
        \ 'root'   : dir,
        \ 'backup' : dir.'/backup',
        \ 'patch'  : dir.'/patch'
    \ }
    let lock = dir.'/lock'

    " mkdir if doesn't exist
    unlet i
    for i in values(s:backupdir)
        if !isdirectory(i)
            call s:mkdir(i, 'p')
        endif
    endfor
    if isdirectory(lock)
        echohl WarningMsg
        echomsg 'directory %s is deprecated. please remove it manually.'
        echohl None
    endif

    if s:check_comp_with
        let integer = '\m^\d\+$'
        let expr    = 'v:val ==# "buffer" || v:val ==# "written" || v:val =~# integer'
        let tests = [
            \ 'type(g:SD_comp_with) == type([])',
            \ 'len(g:SD_comp_with) == 2',
            \ 'g:SD_comp_with[0] !=# g:SD_comp_with[1]',
            \ 'filter(g:SD_comp_with, expr) ==# g:SD_comp_with'
        \ ]
        for i in tests
            if !eval(i)
                call s:warn("invalid g:SD_comp_with. use default."
                            \ . ":failed test %s, g:SD_comp_with %s",
                            \ i, string(g:SD_comp_with))
                let g:SD_comp_with = s:def_comp_with
            endif
        endfor
    endif

    if g:SD_disable
        SDDisable
    endif
endfunc
" }}}

" s:get_revision {{{
func! s:get_revision()
    return localtime()
endfunc
" }}}

" s:revision_to_filename {{{
func! s:revision_to_filename(revision, filename)
    return printf('%s/%s-%s',
                \ s:backupdir.backup,
                \ a:revision,
                \ fnamemodify(a:filename, ':t'))
endfunc
" }}}

" s:commit_file {{{
func! s:commit_file(filename, ...)
    let path_tail = fnamemodify(a:filename, ':t')
    let path_full = fnamemodify(a:filename, ':p')
    let opt      = {'with_no_revision':0}
    if a:0 != 0
        call extend(opt, a:1, 'force')
    endif

    if opt.with_no_revision
        let revision = 0
    else
        let revision = s:get_revision()
    endif
    let revname = s:revision_to_filename(revision, path_tail)

    let cmd = 'silent write! '.revname
    let opt = { '&writebackup':0, '&backup':0, '&swapfile':0 }
    let is_expr = 0
    if !s:run_with_local_opt(cmd, opt, is_expr, path_full)
        return 0
    endif

    if has_key(s:files, path_tail)
        call add(s:files[path_tail].revision, revision)
    else
        let s:files[path_tail] = {
            \ 'revision':[revision],
            \ 'patch':[],
            \ 'signed_lines':{},
            \ 'fullpath':fnamemodify(a:filename, ':p')
        \ }
    endif

    return 1
endfunc
" }}}

" s:add_diff {{{
func! s:add_diff(filename)
    if !s:enabled | return | endif
    let path_tail = fnamemodify(a:filename, ':t')

    if !s:is_available_buffer(a:filename)
        return
    endif

    if has_key(s:files, path_tail)
        " added already
        return
    endif

    " write backup and
    " add current buffer to the list
    if !s:commit_file(a:filename)
        call s:warn(v:errmsg)
    endif
endfunc
" }}}

" s:update_diff_signs {{{
func! s:update_diff_signs(filename)
    if !s:enabled
        return
    endif
    let path_tail = fnamemodify(a:filename, ':t')
    let path_full = fnamemodify(a:filename, ':p')
    let comp_with = map(copy(g:SD_comp_with), 'v:val == -1 ? "buffer" : v:val')
    let s:cmp_curfile_and_buffer =
                \ s:has_elem(comp_with, 'written')
                \ && s:has_elem(comp_with, 'buffer')

    if !s:is_available_buffer(a:filename)
        if has_key(s:files, path_tail)
            " delete current buffer from the list
            unlet s:files[path_tail]
        endif
        return
    endif

    try
        let v:errmsg = ""
        call s:add_diff(a:filename)
        if v:errmsg != ""
            throw 'clear_signs'
        endif

        if localtime() - s:previous_time < g:SD_no_update_within_seconds
            " no update
            return
        endif
        let s:previous_time = localtime()

        " in order not to run diff unnecessarily
        if s:cmp_curfile_and_buffer && !&modified
            " not modified
            throw 'clear_signs'
        endif

        if s:cmp_curfile_and_buffer
            " save the space of HDD :D
            " always writes <backupdir>/0-<filename>
            if !s:commit_file(a:filename, {'with_no_revision':1})
                call s:warn(v:errmsg)
                throw 'clear_signs'
            endif
        else
            if !s:commit_file(a:filename)
                call s:warn(v:errmsg)
                throw 'clear_signs'
            endif
        endif

        " new.file is the committed file.
        " orig.file is the previous.
        let [orig, new] = s:diffed_two_files(a:filename)

        if orig.file ==# new.file
            call s:warn('trying to diff same file...(diff %s %s)',
                                        \ orig.file, new.file)
            throw 'clear_signs'
        endif


        let output_file = printf('%s/%s-%s-%s',
                    \ s:backupdir.patch, orig.revision, new.revision, path_tail)

        " '/' -> '\'
        if has('win32')
            let pat = '\m\([^\\]\)/'
            let sub = '\1\\'
            let [orig.file, new.file, output_file] =
                        \ map([orig.file, new.file, output_file],
                                \ 'substitute(v:val, pat, sub, "g")')
        endif

        " convert to literal
        let [orig_lt, new_lt, output_lt] =
                    \ map([orig.file, new.file, output_file], 's:uneval(v:val)')

        " build literals to call s:do_diff_two_files
        let cmd = s:apply('printf',
                    \ ['s:do_diff_two_files(%s, %s, %s)',
                    \ orig_lt, new_lt, output_lt])

        let opt = {
            \ '&diffexpr'   : g:SD_diffexpr,
            \ '&diffopt'    : g:SD_diffopt,
            \ '&shellslash' : 0,
            \ '&shellquote' : ''
        \ }
        let is_expr = 1

        if filereadable(output_file)
            call delete(output_file)
        endif

        " diff orig.file new.file > output_file
        let ran_shell = s:run_with_local_opt(cmd, opt, is_expr, path_full)

        " 'diff' program's return value(from 'man diff')
        "   0: no differences were found
        "   1: some differences were found
        "   2: trouble
        if !filereadable(output_file)
            if ran_shell
                if v:shell_error == 2
                    let msg = "error: diff program returned error status number"
                else
                    let msg = "error: diff program works properly,"
                    let msg .= " but output file was not created due to broken pipe."
                endif
                call s:warn(msg)
                call s:debugmsg('output_file:'.output_file)
            endif
            throw 'clear_signs'
        endif


        let patch = s:files[path_tail].patch
        call add(patch, output_file)

        try
            let diffed_lines = readfile(output_file)
            if empty(diffed_lines)
                " no difference
                throw 'clear_signs'
            endif
        catch
            " read error or throwing 'clear_signs'
            throw 'clear_signs'
        endtry

        " parse normal diff format and make signs
        call s:make_signs(a:filename, diffed_lines)

    catch /^clear_signs$/
        " clear all signs
        call s:clear_signs(a:filename)

    catch /^nop$/
        " nop
        " (maybe not reached)
    endtry
endfunc
" }}}

" s:diffed_two_files {{{
func! s:diffed_two_files(filename)
    let path      = a:filename
    let path_tail = fnamemodify(a:filename, ':t')
    let skel         = {'revision' : '', 'file' : ''}
    let two          = []
    if has_key(s:files, path_tail)
        let revisions    = s:files[path_tail].revision
    else
        throw 'clear_signs'
    endif

    for i in g:SD_comp_with
        let cur = copy(skel)
        call add(two, cur)

        if i ==# 'written'
            let cur.revision = 'written'
            let cur.file     = path
        elseif i ==# 'buffer'
            let cur.revision = get(revisions, -1, -1)
            if cur.revision ==# -1
                call s:warn("couldn't get revision number of -1")
                throw 'clear_signs'
            endif
            let cur.file = s:revision_to_filename(cur.revision, path_tail)
        elseif i =~# '\m^\d*$'
            let cur.revision = get(revisions, -i, -1)
            if cur.revision == -1
                call s:warn("couldn't get revision number of %d", -i)
                throw 'clear_signs'
            endif
            let cur.file = s:revision_to_filename(cur.revision, path_tail)
        else
            call s:warn(i.": unknown g:SD_comp_with option value")
            throw 'clear_signs'
        endif

        if !filereadable(cur.file)
            " for the next time
            " to be able to read two files committed
            throw 'nop'
        endif
    endfor

    return two
endfunc
" }}}

" s:do_diff_two_files {{{
func! s:do_diff_two_files(orig, new, output)
    " NOTE:
    " can't be readable file
    " if did shellescape() before s:do_diff_two_files().
    " (at least win32 environment)
    if !filereadable(a:orig) || !filereadable(a:new)
        return 0    " didn't run system()
    endif

    if &diffexpr == ''
        " from diff-diffexpr
        let opt = []
        if &diffopt =~# "icase"
            call add(opt, '-i')
        endif
        if &diffopt =~# "iwhite"
            call add(opt, '-b')
        endif

        let args = [join(opt, ' '), a:orig, a:new, a:output]
        let exec = s:apply('printf',
                    \ ['silent !diff %s %s %s > %s'] +
                    \ map(args, 'v:val == "" ? "" : shellescape(v:val)'))
        execute exec
        return 1
    else
        " TODO
        "
        " echo eval(&diffexpr)
        call s:warn('not implement when &diffexpr is NOT empty...')
        " what is diff_filler() and diff_hlID()?
        return 0
    endif
endfunc
" }}}

" s:make_signs {{{
func! s:make_signs(filename, lines)

    call s:clear_signs(a:filename)

    let id = 12345    " begin with this value
    let mode = ''
    let begin = ''
    let end = ''

    " TODO
    " ShowMarksとidがかぶらないようにする
    " ShowMarksのマークを上書きしないようにする
    let signed_lines = s:files[fnamemodify(a:filename, ':t')].signed_lines


    for i in range(0, len(a:lines) - 1)
        let line = a:lines[i]

        let m = matchlist(line, '\m\(\d\+\(,\d\+\)\=\)\([acd]\)\(\d\+\(,\d\+\)\=\)')
        if empty(m)
            continue
        endif

        if m[1] == '' || m[3] == '' || m[4] == ''
            call s:warn('parse error 002: line %d', i+1)
            throw 'clear_signs'
        endif

        let [begin, mode, end] = [m[1], m[3], m[4]]

        let b = begin =~ '\m,' ? split(begin, ',') : [begin, '']
        let e = end   =~ '\m,' ? split(end, ',')   : [end, '']

        if mode ==# 'a'
            let hl_name = 'SD_group_add'
            let from = e[0]
            let to   = e[1] == '' ? e[0] : e[1]

        elseif mode ==# 'c'
            let hl_name = 'SD_group_change'
            let from = e[0]
            let to   = e[1] == '' ? e[0] : e[1]
            if from == to
                let hl_name = 'SD_group_text'
            endif

        elseif mode ==# 'd'
            let hl_name = 'SD_group_delete'
            let from = e[0]
            let to   = e[1] == '' ? e[0] : e[1]

            " some settings
            let from += 1
            let to   += 1
            let from = s:fix_within_range(from, range(1, line('$')))
            let to   = s:fix_within_range(to, range(1, line('$')))

        else
            call s:warn('parse error: unknown error at '.(i+1))
            throw 'clear_signs'
        endif

        " TODO add different signs for
        " the most top of lines or the most bottom of lines.

        for j in range(from, to)
            " override even if the line is signed
            let signed_lines[j] = {'hl':hl_name, 'id':id}
            let exec = printf('sign place %d name=%s line=%d file=%s',
                        \ id, hl_name, j, fnamemodify(a:filename, ':p'))
            execute exec
        endfor
        " one id each mode
        let id += 1
    endfor
endfunc
" }}}

" s:clear_signs {{{
func! s:clear_signs(filename)
    let filename = a:filename
    let path_tail = fnamemodify(filename, ':t')
    let path_full = fnamemodify(filename, ':p')
    if !s:is_available_buffer(a:filename) || !has_key(s:files, path_tail)
        return
    endif

    let signed_lines = s:files[path_tail].signed_lines
    for lnum in keys(signed_lines)
        " delete all signs of id in path_full each line
        execute printf('sign unplace %s file=%s', signed_lines[lnum].id, path_full)
    endfor
    let s:files[path_tail].signed_lines = {}
endfunc
" }}}

" s:clean_up {{{
func! s:clean_up()
    for f in split(glob(s:backupdir.backup . '/*'), "\n")
        let m = matchlist(fnamemodify(f, ':t'), '\m^\(\d\+\)-\(.\+\)$')
        if !empty(m)
        \ && has_key(s:files, m[2])
        \ && bufexists(s:files[m[2]].fullpath)
            " delete original file
            call delete(f)
        endif
    endfor
    for f in split(glob(s:backupdir.patch . '/*'), "\n")
        call delete(f)
    endfor
endfunc
" }}}

" s:toggle_signs {{{
func! s:toggle_signs()
    if s:enabled
        SDDisable
    else
        SDEnable
    endif
endfunc
" }}}

" s:list_signs {{{
func! s:list_signs(filename)
    if s:is_available_buffer(a:filename)
        execute 'sign place file=' . a:filename
    endif
endfunc
" }}}

" }}}

" Commands {{{
command! SDAdd
            \ call s:add_diff(expand('%'))
command! SDUpdate
            \ call s:update_diff_signs(expand('%'))
command! SDEnable
            \ call s:update_diff_signs(expand('%')) |
            \ let s:enabled = 1
command! SDDisable
            \ call s:clear_signs(expand('%')) |
            \ let s:enabled = 0
command! SDToggle
            \ call s:toggle_signs()
command! SDList
            \ call s:list_signs(expand('%'))
" }}}
" Mappings {{{
" if !hasmapto('<C-l>', 'n')
"     nnoremap <unique><silent> <C-l>
"                 \ :SDUpdate<CR><C-l>
" endif
" }}}
" Autocmd {{{
augroup SignDiffGroup
    autocmd!

    for i in g:SD_autocmd_add
        execute printf("autocmd %s * SDAdd", i)
    endfor

    for i in g:SD_autocmd_update
        execute printf('autocmd %s * SDUpdate', i)
    endfor

    if g:SD_delete_files_vimleave
        autocmd VimLeave * call s:clean_up()
    endif
augroup END
" }}}

" Init {{{
call s:init()
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
