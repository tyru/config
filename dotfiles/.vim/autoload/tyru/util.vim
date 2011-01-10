" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



" Misc.
function! tyru#util#each_char(str) "{{{
    return split(a:str, '\zs')
endfunction "}}}
function! tyru#util#has_char(str, char) "{{{
    return stridx(a:str, a:char) != -1
endfunction "}}}

function! tyru#util#warn(msg) "{{{
    call tyru#util#echomsg('WarningMsg', a:msg)
endfunction "}}}
function! tyru#util#warnf(...) "{{{
    call s:warn(call('printf', a:000))
endfunction "}}}
function! tyru#util#echomsg(hl, msg) "{{{
    execute 'echohl' a:hl
    echomsg a:msg
    echohl None
endfunction "}}}


" Wrapper for built-in functions.
function! tyru#util#system(command, ...) "{{{
    return system(join(
    \   [a:command] + map(copy(a:000), 'shellescape(v:val)')))
endfunction "}}}
function! tyru#util#glob(expr) "{{{
    return split(glob(a:expr), "\n")
endfunction "}}}
function! tyru#util#globpath(path, expr) "{{{
    return split(globpath(a:path, a:expr), "\n")
endfunction "}}}
function! tyru#util#getchar(...) "{{{
    let c = call('getchar', a:000)
    return type(c) == type("") ? c : nr2char(c)
endfunction "}}}


" List
function! tyru#util#has_elem(list, elem) "{{{
    return !empty(filter(copy(a:list), 'v:val ==# a:elem'))
endfunction "}}}
function! tyru#util#has_all_of(list, elem) "{{{
    " a:elem is List:
    "   a:list has a:elem[0] && a:list has a:elem[1] && ...
    " a:elem is not List:
    "   a:list has a:elem

    if type(a:elem) == type([])
        for i in a:elem
            if !tyru#util#has_elem(a:list, i)
                return 0
            endif
        endfor
        return 1
    else
        return tyru#util#has_elem(a:list, a:elem)
    endif
endfunction "}}}
function! tyru#util#has_one_of(list, elem) "{{{
    " a:elem is List:
    "   a:list has a:elem[0] || a:list has a:elem[1] || ...
    " a:elem is not List:
    "   a:list has a:elem

    if type(a:elem) == type([])
        for i in a:elem
            if tyru#util#has_elem(a:list, i)
                return 1
            endif
        endfor
        return 0
    else
        return tyru#util#has_elem(a:list, a:elem)
    endif
endfunction "}}}
function! tyru#util#uniq(list) "{{{
    let dict = {}
    for str_or_num in a:list
        let dict[str_or_num] = 1
    endfor
    return tyru#util#sort_by(keys(dict), 'tyru#util#cmp(dict[a], dict[b])', {'dict': dict})
endfunction "}}}
function! tyru#util#uniq_path(path, ...) "{{{
    let sep = a:0 != 0 ? a:1 : ','
    if type(a:path) == type([])
        return join(tyru#util#uniq(a:path), sep)
    else
        return join(tyru#util#uniq(split(a:path, sep)), sep)
    endif
endfunction "}}}
function! tyru#util#has_idx(list, idx) "{{{
    let idx = a:idx
    " Support negative index?
    " let idx = a:idx >= 0 ? a:idx : len(a:list) + a:idx
    return 0 <= idx && idx < len(a:list)
endfunction "}}}
function! tyru#util#mapf(list, fmt) "{{{
    return map(copy(a:list), "printf(a:fmt, v:val)")
endfunction "}}}
function! tyru#util#zip(list, list2) "{{{
    let ret = []
    let i = 0
    while tyru#util#has_idx(a:list, i) || tyru#util#has_idx(a:list2, i)
        call add(ret,
        \   (tyru#util#has_idx(a:list, i) ? [a:list[i]] : [])
        \   + (tyru#util#has_idx(a:list2, i) ? [a:list2[i]] : []))

        let i += 1
    endwhile
    return ret
endfunction "}}}
function! tyru#util#get_idx(list, elem, ...) "{{{
    let idx = 0

    while tyru#util#has_idx(a:list, idx)
        if a:list[idx] ==# a:elem
            return idx
        endif
        let idx += 1
    endwhile

    if a:0 == 0
        throw 'internal error'
    else
        return a:1
    endif
endfunction "}}}
function! tyru#util#reduce(list, expr) "{{{
    " TODO
endfunction "}}}
function! tyru#util#list2dict(list) "{{{
    if empty(a:list) || len(a:list) % 2
        return {}
    endif
    let dict = {}
    for i in range(0, a:list, 2)[: 1]
        let dict[a:list[i]] = a:list[i + 1]
    endfor
    return dict
endfunction "}}}
function! tyru#util#sort_by(list, expr, ...) "{{{
    let s:expr = a:expr
    let s:vars = a:0 ? a:1 : {}
    function! s:sort_func(a, b)
        let [a, b] = [a:a, a:b]
        for [name, val] in items(s:vars)
            execute 'let' name '=' string(val)
        endfor
        return eval(s:expr)
    endfunction

    try
        return sort(a:list, 's:sort_func')
    finally
        delfunc s:sort_func
        unlet! s:expr
        unlet! s:vars
    endtry
endfunction "}}}
function! tyru#util#cmp(a, b) "{{{
    let [a, b] = [a:a, a:b]
    return a ==# b ? 0 : a ># b ? 1 : -1
endfunction "}}}


" Path
function! tyru#util#remove_end_sep(path) "{{{
    " Remove separator at the end of a:path.
    let sep = pathogen#separator()
    let pat = (sep == '\' ? '\\' : '/') . '\+$'
    return substitute(a:path, pat, '', '')
endfunction "}}}
function! tyru#util#canonpath(path) "{{{
    let path = simplify(a:path)
    return tyru#util#remove_end_sep(path)
endfunction "}}}
function! tyru#util#dirname(path) "{{{
    let path = a:path
    let orig = path
    let path = tyru#util#remove_end_sep(path)
    if path == ''
        return orig    " root
    endif
    let path = fnamemodify(path, ':h')
    return path
endfunction "}}}
function! tyru#util#catfile(path, ...) "{{{
    let sep = pathogen#separator()
    let path = tyru#util#remove_end_sep(a:path)
    return join([path] + a:000, sep)
endfunction "}}}


function! tyru#util#execute_multiline_expr(excmds, ...) "{{{
    let expr = join(tyru#util#mapf(copy(a:excmds), ":\<C-u>%s\<CR>"), '')
    if a:0 == 0
        echo join(tyru#util#mapf(copy(a:excmds), ':<C-u>%s<CR>'), '')
    else
        echo a:1
    endif
    return expr
endfunction "}}}
function! tyru#util#execute_multiline(excmds, ...) "{{{
    " XXX: This depends on :execute's behavior
    " that it executes each line separated by "\<CR>".
    " Is it specified?
    execute call('tyru#util#execute_multiline_expr', [a:excmds] + a:000)
endfunction "}}}




" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
