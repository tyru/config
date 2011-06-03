" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


function! tyru#util#undo_ftplugin_helper#load()
    " dummy function to load this script.
endfunction

function! tyru#util#undo_ftplugin_helper#new()
    return deepcopy(s:Helper)
endfunction



function s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction
let s:SID_PREFIX = s:SID()
delfunction s:SID

function! s:local_func(funcname) "{{{
    return function(
    \   '<SNR>' . s:SID_PREFIX . '_' . a:funcname
    \)
endfunction "}}}



function! s:validate_option_name(option)
    if a:option !~# '^[a-z]\+$'
        throw 'option name must be all lowercase letters.'
    endif
    if a:option =~# '^no'
        throw 'option name must not start with "no".'
    endif
endfunction

function! s:validate_variable_name(variable)
    let prefix = '\%(a:\|b:\|g:\|l:\|s:\|t:\|v:\|w:\)'
    let word = '[a-zA-Z_]\+'
    if a:variable !~# '^'.prefix.'\='.word.'$'.'\C'
        throw 'variable name is invalid.'
    endif
endfunction

function! s:get_option(option)
    " getbufvar() only see buffer-local options
    " not global options.
    " (e.g.: getbufvar('%', '&hlsearch') returns "")
    return eval('&' . a:option)
endfunction

function! s:get_variable(variable)
    " getbufvar() only see buffer-local options
    " not global options.
    " (e.g.: getbufvar('%', '&hlsearch') returns "")
    return eval(a:variable)
endfunction

function! s:save_old_option_value(this, option)
    let value = s:get_option(a:option)
    call add(
    \   a:this._restore_functions,
    \   printf('let &%s=%s', a:option, string(value))
    \)
endfunction

function! s:save_old_variable_value(this, variable)
    try
        let Value = s:get_variable(a:variable)
        let function = printf('let %s=%s', a:variable, string(Value))
    catch /E121:/
        " E121: Undefined variable: hoge
        let function = printf('unlet! %s', a:variable)
    endtry

    call add(
    \   a:this._restore_functions,
    \   function
    \)
endfunction

function! s:save_old_mapping(this, mode, lhs)
    call add(
    \   a:this._restore_functions,
    \   printf('call %s.restore()',
    \           string(savemap#save_map(a:mode, a:lhs)))
    \)
endfunction



function! s:Helper_set(option, ...) dict
    call s:validate_option_name(a:option)
    call s:save_old_option_value(self, a:option)
    let value = a:0 ? a:1 : 1
    call setbufvar('%', '&' . a:option, value)
endfunction

function! s:Helper_unset(option, ...) dict
    call s:validate_option_name(a:option)
    call s:save_old_option_value(self, a:option)
    let value = a:0 ? a:1 : 0
    call setbufvar('%', '&' . a:option, value)
endfunction

function! s:Helper_prepend(option, value) dict
    call s:validate_option_name(a:option)
    call s:save_old_option_value(self, a:option)
    let value = a:value . ',' . s:get_option(a:option)
    call setbufvar('%', '&' . a:option, value)
endfunction

function! s:Helper_append(option, value) dict
    call s:validate_option_name(a:option)
    call s:save_old_option_value(self, a:option)
    let value = s:get_option(a:option) . ',' . a:value
    call setbufvar('%', '&' . a:option, value)
endfunction

function! s:Helper_let(variable, Value) dict
    call s:validate_variable_name(a:variable)
    call s:save_old_variable_value(self, a:variable)
    let {a:variable} = a:Value
endfunction

function! s:Helper_unlet(variable) dict
    call s:validate_variable_name(a:variable)
    call s:save_old_variable_value(self, a:variable)
    unlet {a:variable}
endfunction

function! s:Helper_map(modes, lhs, rhs) dict
    if a:modes ==# '' || a:lhs ==# '' || a:rhs ==# ''
        return
    endif
    for _ in split(a:modes, '\zs')
        call s:save_old_mapping(self, _, a:lhs)
        execute _.'noremap <buffer>' a:lhs a:rhs
    endfor
endfunction

function! s:Helper_unmap(modes, lhs, rhs) dict
    if a:modes ==# '' || a:lhs ==# '' || a:rhs ==# ''
        return
    endif
    for _ in split(a:modes, '\zs')
        call s:save_old_mapping(self, _, a:lhs)
        execute _.'unmap <buffer>' a:lhs a:rhs
    endfor
endfunction

function! s:Helper_restore_option(option) dict
    call s:save_old_option_value(self, a:option)
endfunction

function! s:Helper_restore_variable(variable) dict
    call s:save_old_variable_value(self, a:variable)
endfunction

function! s:Helper_restore_mapping(lhs) dict
    call s:save_old_mapping(self, a:lhs)
endfunction

function! s:Helper_make_undo_ftplugin() dict
    return join(
    \   (exists('b:undo_ftplugin') ? [b:undo_ftplugin] : [])
    \   + self._restore_functions
    \, '|')
endfunction


let s:Helper = {
\   '_restore_functions': [],
\
\   'set': s:local_func('Helper_set'),
\   'unset': s:local_func('Helper_unset'),
\   'prepend': s:local_func('Helper_prepend'),
\   'append': s:local_func('Helper_append'),
\   'let': s:local_func('Helper_let'),
\   'unlet': s:local_func('Helper_unlet'),
\   'map': s:local_func('Helper_map'),
\   'unmap': s:local_func('Helper_unmap'),
\   'restore_option': s:local_func('Helper_restore_option'),
\   'restore_variable': s:local_func('Helper_restore_variable'),
\   'restore_mapping': s:local_func('Helper_restore_mapping'),
\
\   'make_undo_ftplugin': s:local_func('Helper_make_undo_ftplugin'),
\}


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
