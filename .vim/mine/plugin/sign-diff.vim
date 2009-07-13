" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: sign-diff
" Version: 0.0.0
" Author:  tyru <tyru.exe+vim@gmail.com>
" Last Change: 2009-07-13.
"
" Change Log: {{{
"   0.0.0: Initial Upload
" }}}
"
" Description:
"   Show diffed status at left side bar
"
" Usage: {{{
"   Commands: {{{
"       SDUpdate
"           update sign diff.
"       SDEnable
"           enable sign diff.
"       SDDisable
"           disable sign diff.
"       SDToggle
"           toggle sign diff.
"   }}}
"
"   Mappings: {{{
"       <C-l>
"           update diff marks and :redraw.
"   }}}
"
"   Global Variables: {{{
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
"       g:SD_mark_add (default:'+')
"           mark of the added line.
"
"       g:SD_mark_change (default:'*')
"           mark of the changed line.
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
"           do autocmd for adding marks with these group
"
"       g:SD_autocmd_update (default:['CursorHold', 'InsertLeave', 'FocusLost'])
"           do autocmd for updating marks with these group
"
"       g:SD_delete_files_vimleave (default: 1)
"           when starting VimLeave event,
"           delete all files under g:SD_backupdir.
"   }}}
"
"   Tips: {{{
"       I suggest the following map.
"           nnoremap <C-l>  :SDUpdate<CR><C-l>
"   }}}
" }}}
"
"   TODO:
"       - SDDiffThis, SDDiffPatch, etc...
"       - show diff ordinary style (:diff*)
"       - How should I highlight the deleted line(s)?
"       - if the global variable is enabled,
"       have only two files to be diffed for full HDD.
"       (have patch data as hidden buffer?)
"       - support for Windows
"       (diff program won't create output file...)
"       - jumping to the added/changed/deleted line.
"       this is easy to implemenet.
"       but can't decide user interface...
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
let s:lockfile = ''
let s:backupdir = {}
" }}}
" Global Variables {{{
if !exists('g:SD_debug')
    let g:SD_debug = 0
endif

if !exists('g:SD_backupdir')
    let g:SD_backupdir = expand('~/.vim-sign-diff')
else
    let g:SD_backupdir = expand(g:SD_backupdir)
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
" if !exists('g:SD_hl_diffdelete')    " TODO
"     let g:SD_hl_diffdelete = "DiffDelete"
" endif
" if !exists('g:SD_hl_difftext')    " TODO
"     let g:SD_hl_difftext = "DiffText"
" endif
if !exists('g:SD_mark_add')
    let g:SD_mark_add = '+'
endif
if !exists('g:SD_mark_change')
    let g:SD_mark_change = '*'
endif
" if !exists('g:SD_mark_delete')    " TODO
"     let g:SD_mark_delete = '-'
" endif
if !exists('g:SD_comp_with')
    let g:SD_comp_with = ['written', 'buffer']
else
    let msg = "invalid g:SD_comp_with. use default."

    if len(g:SD_comp_with) != 2
        echohl WarningMsg
        echo msg
        echohl None
            let g:SD_comp_with = ['written', 'buffer']
    endif
    for i in g:SD_comp_with
        if i !=# 'buffer' && i !=# 'written' && i !~# '\m^\d+$'
            echohl WarningMsg
            echo msg
            echohl None
            let g:SD_comp_with = ['written', 'buffer']
        endif
    endfor

    unlet msg
endif
if !exists('g:SD_autocmd_add')
    let g:SD_autocmd_add = ['BufReadPost']
endif
if !exists('g:SD_autocmd_update')
    let g:SD_autocmd_update = ['CursorHold', 'InsertLeave', 'BufWritePost', 'FocusLost']
endif
if !exists('g:SD_delete_files_vimleave')
    let g:SD_delete_files_vimleave = 1
endif
if !exists('g:SD_show_signs_always')    " TODO
    let g:SD_show_signs_always = 0
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
        elseif a:cmd ==# 'err'
            for i in s:debug_errmsg
                echo i
            endfor
        elseif a:cmd ==# 'eval'
            redraw
            echo eval(join(a:000, ' '))
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
            let args_str = s:literal(a:args[0])
        else
            let args_str .= ', ' . s:literal(a:args[i])
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

    let s:debug_errmsg += [msg]
endfunc
" }}}

" s:run_with_local_opt {{{
func! s:run_with_local_opt(cmd, options, ...)
    let is_expr = a:0 == 0 ? 0 : a:1
    let saved_opt = {}
    let curpath = expand('%')

    " save
    for var in keys(a:options)
        let saved_opt[var] = getbufvar(curpath, var)
        call setbufvar(curpath, var, a:options[var])
    endfor

    try
        if is_expr
            call s:debugmsg('eval(%s)', a:cmd)
            let retval = eval(a:cmd)
        else
            call s:debugmsg('execute '.a:cmd)
            execute a:cmd
        endif

        let success = 1
    catch
        let success = 0
    endtry

    " restore
    for var in keys(saved_opt)
        call setbufvar(curpath, var, saved_opt[var])
    endfor

    if is_expr
        return retval
    else
        return success
    endif
endfunc
" }}}

" s:literal {{{
func! s:literal(expr)
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
        let lis = map(copy(expr), 's:literal(v:val)')
        return '['.join(lis, ',').']'

    elseif type(expr) == type({})
        let keys = keys(expr)
        let pairs = map(keys, 's:literal(copy(v:val)).":".s:literal(copy(expr[v:val]))')
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
        call system(printf('mkdir %s %s', opt, a:path))
    endif
endfunc
" }}}

" }}}


" s:init {{{
func! s:init()
    " signs
    let defs = [
        \ {
            \ 'name' : 'SD_sign_add',
            \ 'texthl' : g:SD_hl_diffadd,
            \ 'mark' : g:SD_mark_add
        \ },
        \ {
            \ 'name' : 'SD_sign_change',
            \ 'texthl' : g:SD_hl_diffchange,
            \ 'mark' : g:SD_mark_change
        \ }
    \ ]
        " \ {
        "     \ 'name' : 'SD_sign_delete',
        "     \ 'texthl' : g:SD_hl_diffdelete,
        "     \ 'mark' : g:SD_mark_delete
        " \ }
    " \ ]
    for i in defs
        let text = strpart(i.mark, 0, 2)
        let hl = i.texthl == '' ? '' : 'texthl='.i.texthl
        execute printf('sign define %s text=%s %s',
                \ i.name, text, hl)
    endfor

    let s:backupdir = {
        \ 'root':g:SD_backupdir,
        \ 'backup':g:SD_backupdir.'/backup',
        \ 'patch':g:SD_backupdir.'/patch',
        \ 'lock':g:SD_backupdir.'/lock'
    \ }

    " mkdir if doesn't exist g:SD_backupdir
    if !isdirectory(s:backupdir.backup)
        call s:mkdir(s:backupdir.backup, 'p')
    endif
    if !isdirectory(s:backupdir.patch)
        call s:mkdir(s:backupdir.patch, 'p')
    endif
    if !isdirectory(s:backupdir.lock)
        call s:mkdir(s:backupdir.lock, 'p')
        let tempname = fnamemodify(tempname(), ':t')
        let s:lockfile = s:backupdir.lock . '/' . localtime().'-'.tempname)
        call writefile([], s:lockfile)
    endif

    call s:clean_up(0)
endfunc
" }}}

" s:get_revision {{{
func! s:get_revision()
    return localtime()
endfunc
" }}}

" s:revision_to_filename {{{
func! s:revision_to_filename(revision, filename)
    return printf('%s/backup/%s-%s',
                \ g:SD_backupdir, a:revision, a:filename)
endfunc
" }}}

" s:commit_file {{{
func! s:commit_file(filename)
    let filename = fnamemodify(a:filename, ':t')
    let revision = s:get_revision()
    let revname = s:revision_to_filename(revision, filename)

    let cmd = 'silent write! '.revname
    let opt = { '&writebackup':0, '&backup':0, '&swapfile':0 }
    if !s:run_with_local_opt(cmd, opt)
        let v:errmsg = "can't write to ".revname
        return 0
    endif
    call s:debugmsg('wrote '.revname)

    if has_key(s:files, filename)
        let s:files[filename].revision += [revision]
    else
        let s:files[filename] = {
            \ 'revision':[revision],
            \ 'patch':[],
            \ 'signed_ids':{}
        \ }
    endif

    return 1
endfunc
" }}}

" s:add_diff {{{
func! s:add_diff(file)
    if !s:enabled | return | endif

    if a:file == ''
        return
    endif

    if has_key(s:files, a:file)
        " added already
        return
    endif
    call s:debugmsg('add %s to s:files...', a:file)

    " create backup file.
    " this file will be diffed with latest file.
    if !s:commit_file(a:file)
        call s:warn(v:errmsg)
    endif
endfunc
" }}}

" s:update_diff_marks {{{
func! s:update_diff_marks()
    if !s:enabled | return | endif
    let curpath_tail = expand('%:t')
    let curpath      = expand('%')
    if curpath == '' | return | endif

    try
        if filereadable(curpath)
            " add current buffer
            let v:errmsg = ""
            call s:add_diff(curpath)
            if v:errmsg != "" | throw 'clear_marks' | endif
        else
            if has_key(s:files, curpath_tail)
                call s:debugmsg('delete %s from s:files...', curpath_tail)
                unlet s:files[curpath_tail]
            endif
            throw 'clear_marks'
        endif

        " in order not to run diff unnecessarily
        let comp_with = map(copy(g:SD_comp_with), 'v:val == -1 ? "buffer" : v:val')
        if s:has_elem(comp_with, 'written')
        \ && s:has_elem(comp_with, 'buffer')
        \ && !&modified
            call s:debugmsg('no difference. (diff %s %s)', comp_with[0], comp_with[1])
            throw 'clear_marks'
        endif

        let [orig, new] = s:diffed_two_files(curpath)

        if orig.file ==# new.file
            call s:warn('trying to diff same file...(diff %s %s)',
                                        \ orig.file, new.file)
            throw 'clear_marks'
        endif


        let output_file = printf('%s/patch/%s-%s-%s',
                    \ g:SD_backupdir, orig.revision, new.revision, curpath_tail)

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
                    \ map([orig.file, new.file, output_file], 's:literal(v:val)')

        " build literals to call s:do_diff_two_files
        let cmd = s:apply('printf',
                    \ ['s:do_diff_two_files(%s, %s, %s)',
                    \ orig_lt, new_lt, output_lt])

        let opt = {
            \ '&diffexpr'   : g:SD_diffexpr,
            \ '&diffopt'    : g:SD_diffopt,
            \ '&shellslash' : 0
        \ }
        let is_expr = 1

        if filereadable(output_file)
            call delete(output_file)
        endif

        " diff orig.file new.file > output_file
        let ran_shell = s:run_with_local_opt(cmd, opt, is_expr)

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
            endif
            throw 'clear_marks'
        endif


        let patches = s:files[curpath_tail].patch
        let patches += [output_file]

        try
            let v:errmsg = ""
            let diffed_lines = readfile(patches[-1])
            let prev_diffed = get(patches, -2, -1)
            if prev_diffed !=# -1
                let prev_diffed_lines = readfile(prev_diffed)
            endif
        catch
            call s:warn('error:'.v:errmsg)
            throw 'clear_marks'
        endtry

        if empty(diffed_lines)
            call s:debugmsg('no difference.')
            throw 'clear_marks'
        endif
        " XXX
        " if prev_diffed !=# -1 && diffed_lines ==# prev_diffed_lines
        "     call s:debugmsg("no change between %s..%s", patches[-2], patches[-1])
        "     " doesn't change marks
        "     return
        " endif

    catch /^clear_marks$/
        " clear all marks
        call s:clear_marks()
        return
    endtry

    call s:sign_marks(curpath, diffed_lines)
endfunc
" }}}

" s:diffed_two_files {{{
func! s:diffed_two_files(filename)
    let curpath      = a:filename
    let curpath_tail = fnamemodify(a:filename, ':t')
    let skel         = {'revision' : '', 'file' : ''}
    let two          = []
    let revisions    = s:files[curpath_tail].revision

    for i in g:SD_comp_with
        let cur = copy(skel)
        let two += [cur]

        if i ==# 'written'
            let cur.revision = 'written'
            let cur.file     = curpath
        elseif i ==# 'buffer'
            let cur.revision = get(revisions, -1, -1)
            if cur.revision ==# -1
                call s:warn("couldn't get revision number of -1")
                throw 'clear_marks'
            endif
            let cur.file = s:revision_to_filename(cur.revision, curpath_tail)
        elseif i =~# '\m^\d*$'
            let cur.revision = get(revisions, -i, -1)
            if cur.revision == -1
                call s:warn("couldn't get revision number of %d", -i)
                throw 'clear_marks'
            endif
            let cur.file = s:revision_to_filename(cur.revision, curpath_tail)
        else
            call s:warn(i.": unknown g:SD_comp_with option value")
            throw 'clear_marks'
        endif
    endfor

    return two
endfunc
" }}}

" s:do_diff_two_files {{{
func! s:do_diff_two_files(orig, new, output)
    if !filereadable(a:orig) || !filereadable(a:new)
        call s:debugmsg('readable %s:%d, readable %s:%d',
                    \ a:orig, filereadable(a:orig),
                    \ a:new, filereadable(a:new))
        return 0    " didn't run system()
    endif

    if &diffexpr == ''
        " from diff-diffexpr
        let opt = []
        if &diffopt =~# "icase"
            let opt += ['-i']
        endif
        if &diffopt =~# "iwhite"
            let opt += ['-b']
        endif

        let args = [join(opt, ' '), a:orig, a:new, a:output]
        let exec = s:apply('printf',
                    \ ['diff %s %s %s > %s'] +
                    \ map(args, 'v:val == "" ? "" : shellescape(v:val)'))
        call s:debugmsg('shell exec [%s]', exec)
        call system(exec)
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

" s:sign_marks {{{
func! s:sign_marks(curpath, lines)

    call s:clear_marks()

    let mode = ''
    let begin = ''
    let end = ''
    " TODO
    " ShowMarksとidがかぶらないようにする
    " ShowMarksのマークを上書きしないようにする
    let signed_ids = s:files[fnamemodify(a:curpath, ':t')].signed_ids
    let id = 12345
    let i = 0
    while i < len(a:lines)
        let line = a:lines[i]

        let m = matchlist(line, '\m\([^acd]\+\)\([acd]\)\([^acd]\+\)')
        if empty(m)
            let i += 1
            continue
        endif

        if m[1] == '' || m[2] == '' || m[3] == ''
            call s:warn('parse error 002: line %d', i+1)
            return
        endif

        let [begin, mode, end] = m[1:3]
        call s:debugmsg('[%s][%s][%s]', begin, mode, end)

        " let b = begin =~ '\m,' ? split(begin, ',') : [begin, '']
        let e = end   =~ '\m,' ? split(end, ',')   : [end, '']

        if mode ==# 'a'
            let name = 'SD_sign_add'
            let from = e[0]
            let to   = e[1] == '' ? e[0] : e[1]

        elseif mode ==# 'c'
            let name = 'SD_sign_change'
            let from = e[0]
            let to   = e[1] == '' ? e[0] : e[1]
        elseif mode ==# 'd'
            " TODO: deleted lines are not highlighted.
            " let name = 'SD_sign_delete'
            let i += 1
            continue
        endif

        let signed_ids[id] = {'lnums':[], 'name':name}

        for j in range(from, to)
            execute printf('sign place %d name=%s line=%d file=%s',
                        \ id, name, j, fnamemodify(a:curpath, ':p'))
            let signed_ids[id].lnums += [j]
        endfor

        " one id each mode
        let id += 1

        let i += 1
    endwhile
endfunc
" }}}

" s:clear_marks {{{
func! s:clear_marks()
    let curpath_tail = expand('%:t')
    if curpath_tail == '' || !has_key(s:files, curpath_tail)
        return
    endif
    let signed_ids = s:files[curpath_tail].signed_ids
    for [id, info] in items(signed_ids)
        let i = 0
        while i < len(info.lnums)
            execute printf('sign unplace %s file=%s', id, expand('%:p'))
            let i += 1
        endwhile
    endfor
    let s:files[curpath_tail].signed_ids = {}
endfunc
" }}}

" s:clean_up {{{
func! s:clean_up(vimleave)
    let vims = split(glob(s:backupdir.lock . '/*'), "\n")
    call filter(vims, 'filereadable(v:val)')
    if len(vims) != 1 | return | endif

    for dir in keys(s:backupdir)
        if !isdirectory(dir) | continue | endif
        let files = split(glob(dir.'/*'), "\n")
        " let files += split(glob(dir.'/.*'), "\n")
        " call filter(files, 'fnamemodify(v:val, ":t") != ".."')
        for file in files
            if !filereadable(file) | continue | endif
            let lang = v:lang
            lang mes C
            redir => swappath
            swapname
            redir END
            execute 'lang mes '.lang

            call s:debugmsg(swappath)
            let swappath = get(
                \ matchlist(swappath, '\m\(swapname\n*\)\=\(\p\+\)'),
                \ 1,
                \ -1)
            if swappath ==# -1
                call s:warn(file.": couldn't get swap file name")
                return
            endif

            " don't delete file if swap file exists
            if swappath =~# 'No swap file' || !filereadable(swappath)
                call s:debugmsg("unlink %s...", file)
                call delete(file)
            endif
        endfor
    endfor

    if a:vimleave
        call delete(s:lockfile)
    endif
endfunc
" }}}

" s:toggle_marks {{{
func! s:toggle_marks()
    if s:enabled
        SDDisable
    else
        SDEnable
    endif
endfunc
" }}}

" }}}

" Commands {{{
command! SDUpdate
            \ call s:update_diff_marks()
command! SDEnable
            \ let s:enabled = 1 | 
            \ call s:update_diff_marks()
command! SDDisable
            \ call s:clear_marks() |
            \ let s:enabled = 0
command! SDToggle
            \ call s:toggle_marks()
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
        execute printf("autocmd %s * call s:add_diff(expand('%%:t'))", i)
    endfor

    for i in g:SD_autocmd_update
        execute printf('autocmd %s * SDUpdate', i)
    endfor

    if g:SD_delete_files_vimleave
        autocmd VimLeave * call s:clean_up(1)
    endif
augroup END
" }}}

" Init {{{
call s:init()
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
