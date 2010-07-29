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
    return system(join([a:command] + map(copy(a:000), 'shellescape(v:val)'), ' '))
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
    let s:dict = {}
    let counter = 1
    for i in a:list
        if !has_key(s:dict, i)
            let s:dict[i] = counter
            let counter += 1
        endif
    endfor

    function! s:cmp(a, b)
        return a:a == a:b ? 0 : a:a > a:b ? 1 : -1
    endfunction

    function! s:c(a, b)
        let [a, b] = [a:a, a:b]
        return eval(s:expr)
    endfunction

    try
        let s:expr = 's:cmp(s:dict[a], s:dict[b])'
        return sort(keys(s:dict), 's:c')
    finally
        delfunc s:cmp
        delfunc s:c
        unlet s:expr
        unlet s:dict
    endtry
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


" Path
function! tyru#util#split_path(path, ...) "{{{
    " TODO: More strict
    let sep = a:0 != 0 ? a:1 : ','
    return split(a:path, sep)
endfunction "}}}
function! tyru#util#join_path(path_list, ...) "{{{
    " TODO: More strict
    let sep = a:0 != 0 ? a:1 : ','
    return join(a:path_list, sep)
endfunction "}}}


" System
function! tyru#util#follow_symlink(path) "{{{
    " FIXME
    "
    " TODO Reveive depth of following times.
    "
    " Complain: Why can't Vim deal with symbolic link?

    perl <<EOF
    my $dest = sub { ($_) = @_; $_ = readlink while -l; $_ }->(VIM::Eval('a:path'));
    # TODO: More strict
    VIM::DoCommand sprintf "let dest = '%s'", $dest;
EOF

    return dest
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


" Parsing
function! tyru#util#skip_white(q_args) "{{{
    return substitute(a:q_args, '^\s*', '', '')
endfunction "}}}
function! tyru#util#parse_one_arg_from_q_args(q_args) "{{{
    let arg = tyru#util#skip_white(a:q_args)
    let head = matchstr(arg, '^.\{-}[^\\]\ze\([ \t]\|$\)')
    let rest = strpart(arg, strlen(head))
    return [head, rest]
endfunction "}}}
function! tyru#util#eat_n_args_from_q_args(q_args, n) "{{{
    let rest = a:q_args
    for _ in range(1, a:n)
        let rest = tyru#util#parse_one_arg_from_q_args(rest)[1]
    endfor
    let rest = tyru#util#skip_white(rest)    " for next arguments.
    return rest
endfunction "}}}




" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
finish

" Trying to reproduce ex_call bug...

function! tyru#util#get_bar()
    let obj = {}

    function! obj.Set()
        " ...
    endfunction

    function! obj.Get()
        " ...
    endfunction

    return obj
endfunction

function! tyru#util#foo()
    let self = {'cond': 0}
    if !self.cond
        call tyru#util#get_bar().Set(tyru#util#get_bar().Get())
    endif
endfunction
