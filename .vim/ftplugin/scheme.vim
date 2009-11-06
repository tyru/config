" vim:set fdm=marker:

if exists("b:did_ftplugin") | finish | endif
if exists("loaded_scheme_ftplugin") | finish | endif

let b:did_ftplugin = 1
let s:save_cpo = &cpo
set cpo&vim


" TODO Use &operatorfunc, etc.
" Mappings {{{

nnoremap <buffer> <Leader>e       :call <SID>EvalFileNormal('e')<CR>
vnoremap <buffer> <Leader>e       :call <SID>EvalFileVisual('e')<CR>
nnoremap <buffer> <Leader>E       :call <SID>EvalFileNormal('E')<CR>
vnoremap <buffer> <Leader>E       :call <SID>EvalFileVisual('E')<CR>
nnoremap <buffer> <Leader><C-e>   :echo <SID>system('gosh', expand('%'))<CR>

" Utility functions {{{
" s:system {{{
func! s:system(command, ...)
    let args = [a:command] + map(copy(a:000), 'shellescape(v:val)')
    return system(join(args, ' '))
endfunc
" }}}
" s:EvalFileNormal(eval_main) {{{
func! s:EvalFileNormal(eval_main)
    normal! %v%
    call s:EvalFileVisual(a:eval_main)
endfunc
" }}}
" s:EvalFileVisual(eval_main) {{{
func! s:EvalFileVisual(eval_main) range
    let z_val = getreg('z', 1)
    let z_type = getregtype('z')
    normal! "zy

    try
        let curfile = expand('%')
        if !filereadable(curfile)
            call s:warn("can't load " . curfile . "...")
            return
        endif

        let lines = readfile(curfile) + ['(print'] + split(@z, "\n") + [')']

        let tmpfile = tempname() . localtime()
        call writefile(lines, tmpfile)

        if filereadable(tmpfile)
            if a:eval_main ==# 'e'
                " load tmpfile, execute the function 'main'
                echo s:system('gosh', tmpfile)
            elseif a:eval_main ==# 'E'
                " load tmpfile
                echo system(printf('cat %s | gosh', shellescape(tmpfile)))
            else
                call s:warn("this block never reached")
            endif
        else
            call s:warn("cannot write to " . tmpfile . "...")
        endif
    finally
        call setreg('z', z_val, z_type)
    endtry
endfunc
" }}}
" }}}
" }}}

" Global variables {{{
let g:is_gauche = 1
" }}}

" setlocal {{{
setlocal lisp
setlocal nocindent

" lispwords {{{
setlocal lispwords+=and-let*,begin0,call-with-client-socket,call-with-input-conversion,call-with-input-file
setlocal lispwords+=call-with-input-process,call-with-input-string,call-with-iterator,call-with-output-conversion,call-with-output-file
setlocal lispwords+=call-with-output-string,call-with-temporary-file,call-with-values,dolist,dotimes
setlocal lispwords+=if-match,let*-values,let-args,let-keywords*,let-match
setlocal lispwords+=let-optionals*,let-syntax,let-values,let/cc,let1
setlocal lispwords+=letrec-syntax,make,match,match-lambda,match-let
setlocal lispwords+=match-let*,match-letrec,match-let1,match-define,multiple-value-bind
setlocal lispwords+=parameterize,parse-options,receive,rxmatch-case,rxmatch-cond
setlocal lispwords+=rxmatch-if,rxmatch-let,syntax-rules,unless,until
setlocal lispwords+=when,while,with-builder,with-error-handler,with-error-to-port
setlocal lispwords+=with-input-conversion,with-input-from-port,with-input-from-process,with-input-from-string,with-iterator
setlocal lispwords+=with-module,with-output-conversion,with-output-to-port,with-output-to-process,with-output-to-string
setlocal lispwords+=with-port-locking,with-string-io,with-time-counter,with-signal-handlers 
" }}}
" }}}


let &cpo = s:save_cpo
