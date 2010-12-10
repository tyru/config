" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let b:undo_ftplugin =
\   'let &l:lispwords = '.string(&l:lispwords)
\    . '| let &l:lisp = '.string(&l:lisp)
\    . '| let &l:cindent = '.string(&l:cindent)
\    . '| let &l:complete = '.string(&l:complete)


let g:is_gauche = 1


setlocal lisp
setlocal nocindent
setlocal complete=.,t,k,kspell


command!
\   -nargs=1
\   SchemeAddLispWords
\   let &l:lispwords .= ',' . <q-args>

SchemeAddLispWords and-let*
SchemeAddLispWords begin0
SchemeAddLispWords call-with-client-socket
SchemeAddLispWords call-with-input-conversion
SchemeAddLispWords call-with-input-file
SchemeAddLispWords call-with-input-process
SchemeAddLispWords call-with-input-string
SchemeAddLispWords call-with-iterator
SchemeAddLispWords call-with-output-conversion
SchemeAddLispWords call-with-output-file
SchemeAddLispWords call-with-output-string
SchemeAddLispWords call-with-temporary-file
SchemeAddLispWords call-with-values
SchemeAddLispWords dolist
SchemeAddLispWords dotimes
SchemeAddLispWords if-match
SchemeAddLispWords let*-values
SchemeAddLispWords let*-values
SchemeAddLispWords let-args
SchemeAddLispWords let-keywords*
SchemeAddLispWords let-match
SchemeAddLispWords let-optionals*
SchemeAddLispWords let-syntax
SchemeAddLispWords let-values
SchemeAddLispWords let/cc
SchemeAddLispWords let1
SchemeAddLispWords letrec-syntax
SchemeAddLispWords make
SchemeAddLispWords match
SchemeAddLispWords match-define
SchemeAddLispWords match-lambda
SchemeAddLispWords match-let
SchemeAddLispWords match-let*
SchemeAddLispWords match-let1
SchemeAddLispWords match-letrec
SchemeAddLispWords multiple-value-bind
SchemeAddLispWords parameterize
SchemeAddLispWords parse-options
SchemeAddLispWords receive
SchemeAddLispWords rxmatch-case
SchemeAddLispWords rxmatch-cond
SchemeAddLispWords rxmatch-if
SchemeAddLispWords rxmatch-let
SchemeAddLispWords syntax-rules
SchemeAddLispWords unless
SchemeAddLispWords until
SchemeAddLispWords when
SchemeAddLispWords while
SchemeAddLispWords with-builder
SchemeAddLispWords with-error-handler
SchemeAddLispWords with-error-to-port
SchemeAddLispWords with-input-conversion
SchemeAddLispWords with-input-from-port
SchemeAddLispWords with-input-from-process
SchemeAddLispWords with-input-from-string
SchemeAddLispWords with-iterator
SchemeAddLispWords with-module
SchemeAddLispWords with-output-conversion
SchemeAddLispWords with-output-to-port
SchemeAddLispWords with-output-to-process
SchemeAddLispWords with-output-to-string
SchemeAddLispWords with-port-locking
SchemeAddLispWords with-signal-handlers
SchemeAddLispWords with-string-io
SchemeAddLispWords with-time-counter


let &cpo = s:save_cpo
