scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

"-----------------------------------------------------------------
" Util Functions {{{
" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunc
" }}}

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
"-----------------------------------------------------------------
" basic settings (bundled with kaoriya vim's .vimrc & etc.) {{{

" set options {{{
set autoindent
set autoread
set backspace=indent,eol,start
set helplang=ja,en
set browsedir=buffer
set clipboard=
set complete=.,w,b,k,t
set diffopt=filler,vertical
set expandtab
set formatoptions=mMcroqnl2
set guioptions-=T
set guioptions-=m
set history=50
set hlsearch
set ignorecase
set incsearch
set keywordprg=
set laststatus=2
set list
set listchars=tab:>-,extends:>,precedes:<,eol:.
set noshowcmd
set nosplitright
set notimeout
set nrformats-=octal
set ruler
set scroll=5
set scrolloff=15
set shiftround
set shiftwidth=4
set shortmess+=I
set showfulltag
set showmatch
set smartcase
set smartindent
set smarttab
set splitbelow
set switchbuf="useopen,usetab"
set tabstop=4
set textwidth=0
set viminfo='50,h,f1,n$HOME/.viminfo
set visualbell
set whichwrap=b,s
set wildchar=<Tab>
set wildignore=*.o,*.obj,*.la,*.a,*.exe,*.com,*.tds
set wildmenu
set wrap

if has('emacs_tags') && has('path_extra')
    " find 'tags' rewinding current directory
    set tags+=.;
endif

" Life Changing (unstable?)
if has('virtualedit')
    set virtualedit=all
endif

" speed optimization related to fsync...
if has('unix')
    set nofsync
    set swapsync=
endif


" backupdir
set backup
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif

if has('gui_running')
    set title
else
    set notitle
endif

" マップリーダー
let mapleader = ';'
let maplocalleader = ','


set statusline=%f%m%r%h%w\ [%{&fenc}][%{&ff}]\ [%p%%][%l/%L]\ [%{ShrinkPath('%:p:h',20)}]

func! ShrinkPath( path, maxwidth )
    let path = expand( a:path )

    " split current directory into 'dirs'.
    if has( 'win32' )
        let sep = "\\"
    else
        let sep = "/"
    endif
    let dirs =  reverse( split( path, sep ) )   " 後ろから参照

    let path_str = ''
    for dir in dirs
        if path_str == ''
            let path_str = dir . path_str
        else
            let path_str = dir . sep . path_str
        endif

        if strlen( path_str ) > a:maxwidth
            let path_str = strpart( path_str, strlen( path_str ) - a:maxwidth - 3 )
            let path_str = "..." . path_str
            break
        endif
    endfor

    return path_str
endfunc


" migemo
if has("migemo")
    set migemo
endif

" convert "\\" to "/" on win32 like environment
if exists('+shellslash')
    set shellslash
endif

syntax on
filetype plugin indent on


" runtimepath
if has("win32")
    set runtimepath+=$HOME/.vim
endif
let s:runtime_dirs = [
    \'$HOME/.vim/after',
    \'$HOME/.vim/mine',
    \'$HOME/.vim/chalice',
    \'$HOME/.vim/xpt',
    \'$HOME/.vim/vimdoc_ja',
\ ]
for dir in s:runtime_dirs
    if isdirectory(expand(dir))
        let &runtimepath .= ',' . expand(dir)
    endif
endfor
unlet s:runtime_dirs
" }}}

" delete old files in ~/.vim/backup {{{
func! s:DeleteBackUp()
    if has('win32')
        if exists('$TMP')
            let stamp_file = $TMP . '/.vimbackup_deleted'
        elseif exists('$TEMP')
            let stamp_file = $TEMP . '/.vimbackup_deleted'
        else
            return
        endif
    else
        let stamp_file = '/tmp/.vimbackup_deleted'
    endif

    if !filereadable(stamp_file)
        call writefile([localtime()], stamp_file)
        return
    endif

    let [line] = readfile(stamp_file)
    let one_day_sec = 60 * 60 * 24    " 1日に何回も削除しようとしない

    if localtime() - str2nr(line) > one_day_sec
        let backup_files = split(expand(&backupdir . '/*'), "\n")
        let thirty_days_sec = one_day_sec * 30
        call filter(backup_files, 'localtime() - getftime(v:val) > thirty_days_sec')
        for i in backup_files
            if delete(i) != 0
                call s:warn("can't delete " . i)
            endif
        endfor
        call writefile([localtime()], stamp_file)
    endif
endfunc

call s:DeleteBackUp()
delfunc s:DeleteBackUp
" }}}

" japanese encodings {{{
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
        " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
endif
function! s:AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
        let &fileencoding=&encoding
    endif
endfunction

" supports fileformats in this order
set fileformats=unix,dos,mac
" assume the specific characters like "□" or "○" as 2 bytes to
" display (for vim in terminal)
if exists('&ambiwidth')
    set ambiwidth=double
endif
" }}}

" support of colors in terminal (unix only) {{{
if has('unix') && !has('gui_running')
    let uname = system('uname')
    if uname =~? "linux"
        set term=builtin_linux
    elseif uname =~? "freebsd"
        set term=builtin_cons25
    elseif uname =~? "Darwin"
        set term=beos-ansi
    else
        set term=builtin_xterm
    endif
endif
" }}}

" when $DISPLAY is set and vim runs under terminal, vim's start-up will be very slow {{{
if !has('gui_running') && has('xterm_clipboard')
    set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif
let did_install_default_menus = 1
" }}}

" " WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正 {{{
" if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
"     let $PATH = $VIM . ';' . $PATH
" endif
" if has('mac')
"     " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
"     set iskeyword=@,48-57,_,128-167,224-235
" endif
" }}}

" about japanese input method {{{
if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  highlight CursorIM guibg=Purple guifg=NONE
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIMの入力開始キーを設定:
    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
    "set imactivatekey=s-space
  endif
  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif
" }}}

" }}}
"-----------------------------------------------------------------
" Commands {{{

" HelpTagAll {{{
"   do :helptags to all doc/ in &runtimepath
command! HelpTagAll
            \ call s:HelpTagAll()

func! s:HelpTagAll()
    for path in split( &runtimepath, ',' )
        if isdirectory( path . '/doc' )
            " add :silent! because Vim warns "No match ..."
            " if there are no files in path . '/doc/*',
            silent! exe 'helptags ' . path . '/doc'
        endif
    endfor
endfunc
" }}}

" MTest {{{
"   convert Perl's regex to Vim's regex
command! -nargs=? MTest
            \ call s:MTest( <q-args> )

func! s:MTest( ... )

    let regex = a:1
    " backup
    let searched = @/
    let hilight = &hlsearch

    " convert
    silent exe "M" . regex
    let @" = @/

    let @/ = searched
    let &hlsearch = hilight

    echo @"
endfunc
" }}}

" Open {{{
command! -nargs=? -complete=dir Open
            \ call s:Open( <f-args> )

func! s:Open( ... )
    let dir =   a:0 == 1 ? a:1 : '.'

    if !isdirectory( dir )
        call s:warn(dir .': No such a directory')
        return
    endif

    if has( 'win32' )
        if dir =~ '[&()\[\]{}\^=;!+,`~ '. "']" && dir !~ '^".*"$'
            let dir = '"'. dir .'"'
        endif
        call s:system('explorer', dir)
    else
        call s:system('gnome-open', dir)
    endif
endfunc
" }}}

" commands related to specific environments {{{
if has('gui_running')
    if has( 'win32' )
        command! GoDesktop   execute 'lcd C:' . $HOMEPATH . '\デスクトップ'
        command! SH          !start cmd.exe
    else
        command! GoDesktop   lcd '~/Desktop'
    endif
endif
" }}}

" s:ListAndExecute() {{{
func! s:ListAndExecute( lis, template )
    " display the list
    let i = 0
    while i < len( a:lis )
        echo printf('%d: %s', i + 1, a:lis[i])
        let i = i + 1
    endwhile

    while 1
        echon "\n:"
        let ch = getchar()
        if ch == char2nr( "\<ESC>" )
            return ""
        endif
        let num = ch - 48

        " is digit?
        if string( num ) =~ '^\d\+$'
            if num < 1 || len( a:lis ) < num
                " out of range
                call s:warn( 'out of num number. Try again.' )
            else
                break
            endif
        else
            call s:warn( 'non-digit characters found. Try again.' )
        endif
    endwhile

    execute substitute( a:template, '%embed%', a:lis[num - 1], 'g' )
    redraw

    return a:lis[num - 1]
endfunc
" }}}

" s:ListChars() {{{
command! ListChars
            \ call s:ListAndExecute([
                    \'tab:>-,extends:>,precedes:<,eol:.',
                    \'tab:>-',
                    \'tab:\\ \\ ',
                \],
                \'set listchars=%embed%')
" }}}

" FastEdit {{{
"   this is useful when Vim is very slow?
"   currently just toggling syntax highlight.
nnoremap <silent> <Leader>fe        :call <SID>FastEdit()<CR>

let s:fast_editing = 0
func! s:FastEdit()
    call garbagecollect()

    if s:fast_editing

        " filetype (color, indent, etc.)
        syntax on
        filetype plugin indent on

        redraw
        let s:fast_editing = 0
        echo 'slow but high ability.'
    else

        " filetype (color, indent, etc.)
        syntax off
        filetype plugin indent off

        redraw
        let s:fast_editing = 1
        echo 'fast browsing.'
    endif
endfunc
" }}}

" DelFile {{{
command! -complete=file -nargs=+ DelFile
            \ call s:DelFile(<f-args>)

func! s:DelFile(...)
    if a:0 == 0 | return | endif

    for i in map(copy(a:000), 'expand(v:val)')
        for j in split(i, "\n")
            " delete the file
            if filereadable(j)
                call delete(j)
            else
                call s:warn(j . ": No such a file")
            endif
            " delete also that buffer
            if filereadable(j)
                call s:warn(printf("Can't delete '%s'", j))
            elseif j ==# expand('%')
                bwipeout
            endif
        endfor
    endfor
endfunc
" }}}

" TabChange {{{
command! -nargs=1 TabChange
            \ call s:TabChange( <f-args> )

func! s:TabChange( width )
    if a:width =~ '^\d\+$'
        exe "setlocal ts=" . a:width
        exe "setlocal sw=" . a:width
    endif
endfunc
" }}}

" Mkdir {{{
func! s:Mkdir(...)
    for i in a:000 | call mkdir(i, 'p') | endfor
endfunc
command! -nargs=+ -complete=dir Mkdir
            \ call s:Mkdir(<f-args>)
" }}}

" s:GccSyntaxCheck(...) {{{
func! s:GccSyntaxCheck(...)
    if expand('%') ==# '' | return | endif

    " compiler
    if &filetype ==# 'c'
        let gcc = 'gcc'
    elseif &filetype ==# 'cpp'
        let gcc = 'g++'
    else
        return
    endif

    " options
    let opt = {}
    for i in a:000
        let opt[i] = 1
    endfor

    let makeprg = &l:makeprg
    let &l:makeprg = gcc . ' -Wall -W -pedantic -fsyntax-only %'

    if has_key(opt, '-q') && opt['-q']
        silent make
    else
        make
    endif

    let &l:makeprg = makeprg
endfunc

command! -nargs=* GccSyntaxCheck
            \ call s:GccSyntaxCheck(<f-args>)
" }}}

" }}}
"-----------------------------------------------------------------
" Encoding {{{

set fencs-=iso-2022-jp-3
set fencs+=iso-2022-jp,iso-2022-jp-3

" set enc=... {{{
func! <SID>ChangeEncoding()
    if expand( '%' ) == ''
        echo "current file is empty."
        return
    endif
    let lis = [ 'cp932',
                \ 'shift-jis',
                \ 'iso-2022-jp',
                \ 'euc-jp',
                \ 'utf-8',
                \ 'ucs-bom' ]
    let enc = s:ListAndExecute( lis, 'edit ++enc=%embed%' )

    if enc != ''
        echo "Change the encoding to " . enc
    endif
endfunc
nnoremap <silent> <F2>    :call <SID>ChangeEncoding()<CR>
" }}}

" set fenc=... {{{
func! <SID>ChangeFileEncoding()
    let lis = [ 'cp932',
                \ 'shift-jis',
                \ 'iso-2022-jp',
                \ 'euc-jp',
                \ 'utf-8',
                \ 'ucs-bom' ]
    let enc = s:ListAndExecute( lis, 'set fenc=%embed%' )
    if enc == 'ucs-bom'
        set bomb
    else
        set nobomb
    endif

    if enc != ''
        echo "Change the file encoding to " . enc
    endif
endfunc
nnoremap <silent> <F3>    :call <SID>ChangeFileEncoding()<CR>
" }}}

" set ff=... {{{
func! <SID>ChangeNL()
    let result = s:ListAndExecute( [ 'dos', 'unix', 'mac' ], 'set ff=%embed%' )
    if result != ''
        echo 'Converting newline...' . result
    endif
endfunc
nnoremap <silent> <F4>    :call <SID>ChangeNL()<CR>
" }}}

" }}}
"-----------------------------------------------------------------
" AutoCommand {{{
augroup MyVimrc
    autocmd!

    " check encoding
    autocmd BufReadPost * call s:AU_ReCheck_FENC()

    " colorscheme (on windows, setting colorscheme in .vimrc does not work)
    autocmd VimEnter * colorscheme chocolate

    " open on read-only if swap exists
    autocmd SwapExists * let v:swapchoice = 'o'

    " autocmd CursorHold,CursorHoldI *   silent! update
    autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,helpgrep   copen

    " do what ~/.vim/ftplugin/* does in .vimrc
    " because of my laziness :p
    autocmd FileType *   call s:LoadWhenFileType()

    " sometimes &modeline becomes false
    autocmd BufReadPre *    setlocal modeline

    " filetype {{{
    autocmd BufNewFile,BufReadPre *.as
                \ setlocal ft=actionscript syntax=actionscript
    autocmd BufNewFile,BufReadPre *.c
                \ setlocal ft=c
    autocmd BufNewFile,BufReadPre *.cpp
                \ setlocal ft=cpp
    autocmd BufNewFile,BufReadPre *.cs
                \ setlocal ft=cs
    autocmd BufNewFile,BufReadPre *.java
                \ setlocal ft=java
    autocmd BufNewFile,BufReadPre *.js
                \ setlocal ft=javascript
    autocmd BufNewFile,BufReadPre *.pl,*.pm
                \ setlocal ft=perl
    autocmd BufNewFile,BufReadPre *.ps1
                \ setlocal ft=powershell
    autocmd BufNewFile,BufReadPre *.py,*.pyc
                \ setlocal ft=python
    autocmd BufNewFile,BufReadPre *.rb
                \ setlocal ft=ruby
    autocmd BufNewFile,BufReadPre *.scm
                \ setlocal ft=scheme
    autocmd BufNewFile,BufReadPre _vimperatorrc,.vimperatorrc
                \ setlocal ft=vimperator syntax=vimperator
    autocmd BufNewFile,BufReadPre *.scala
                \ setlocal ft=scala
    autocmd BufNewFile,BufReadPre *.lua
                \ setlocal ft=lua
    autocmd BufNewFile,BufReadPre *.avs
                \ setlocal syntax=avs
    autocmd BufNewFile,BufReadPre *.tmpl
                \ setlocal ft=html
    autocmd BufNewFile,BufReadPre *.mkd
                \ setlocal ft=mkd
    autocmd BufNewFile,BufReadPre *.md
                \ setlocal ft=mkd

    " delete for ft=mkd
    autocmd! filetypedetect BufNewFile,BufRead *.md
    " }}}

augroup END
" }}}
"-----------------------------------------------------------------
" FileType {{{

" ToggleFileType {{{
command! ToggleFileType call s:ToggleFileType()

let s:load_filetype = 1
func! s:ToggleFileType()
    if s:load_filetype
        let s:load_filetype = 0
        echomsg "will NOT load filetype"
    else
        let s:load_filetype = 1
        echomsg "load filetype"
    endif
endfunc
" }}}

" s:SetDict {{{
func! s:SetDict(...)
    execute "setlocal dict=" .
                \join(map(copy(a:000), '"$HOME/.vim/dict/" . v:val . ".dict"'), ',')
endfunc
" }}}

" s:LoadWhenFileType() {{{
func! s:LoadWhenFileType()
    if ! s:load_filetype
        " call s:warn("skip loading filetype config...")
        return
    endif


    call s:SetDict(&filetype)

    " デフォルト(ftplugin/*.vimで用意されていない場合)のomnifunc
    if exists("+omnifunc") && &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
    endif

    if &filetype == 'actionscript'
        TabChange 4

    elseif &filetype == 'c' || &filetype == 'cpp'
        TabChange 4
        if &filetype == 'cpp'
            call s:SetDict('c', 'cpp')
        endif

        setlocal makeprg&
        compiler gcc

    elseif &filetype == 'cs'
        TabChange 4
        compiler cs

    elseif &filetype == 'css'
        TabChange 2

    elseif &filetype == 'xml'
        TabChange 2
        inoremap <buffer>   </    </<C-x><C-o>

    elseif &filetype == 'html' || &filetype == 'javascript' || &filetype == 'css'
        TabChange 2
        if &filetype == 'html'
            call s:SetDict('html', 'javascript', 'css')
            inoremap <buffer>   </    </<C-x><C-o>
        endif

    elseif &filetype == 'java'
        TabChange 2
        " for javadoc
        setlocal iskeyword+=@-@
        setlocal makeprg=javac\ %
        compiler javac

    elseif &filetype == 'scala'
        TabChange 2
        " for javadoc
        setlocal iskeyword+=@-@
        setlocal includeexpr=substitute(v:fname,'\\.','/','g')
        setlocal suffixesadd=.scala
        setlocal suffixes+=.class
        setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/
        setlocal commentstring=//%s
        setlocal formatoptions-=t formatoptions+=croql
        call s:SetDict('java', 'scala')

    elseif &filetype == 'lisp' || &filetype == 'scheme'
        TabChange 2

        setlocal lisp
        setlocal nocindent

        nnoremap <buffer> <Leader>e       :call <SID>EvalFileNormal('e')<CR>
        vnoremap <buffer> <Leader>e       :call <SID>EvalFileVisual('e')<CR>
        nnoremap <buffer> <Leader>E       :call <SID>EvalFileNormal('E')<CR>
        vnoremap <buffer> <Leader>E       :call <SID>EvalFileVisual('E')<CR>
        nnoremap <buffer> <Leader><C-e>   :echo <SID>system('gosh', expand('%'))<CR>

        let g:is_gauche = 1

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

    elseif &filetype == 'perl'
        TabChange 4
        " add perl's path.
        " executing 'gf' command on module name opens its module.
        if exists('$PERL5LIB') && !exists('b:perl_already_added_path')
            for i in split(expand('$PERL5LIB'), ':')
                execute 'setlocal path+=' . i
            endfor
            let b:perl_already_added_path = 1
        endif

        setlocal suffixesadd=.pm
        setlocal makeprg=perl\ -c\ %
        " jumping to sub definition.
        nnoremap <buffer> ]]    :call search('^\s*sub .* {$', 'sW')<CR>
        nnoremap <buffer> [[    :call search('^\s*sub .* {$', 'bsW')<CR>
        nnoremap <buffer> ][    :call search('^}$', 'sW')<CR>
        nnoremap <buffer> []    :call search('^}$', 'bsW')<CR>

        compiler perl

    elseif &filetype == 'yaml'
        TabChange 2

    else
        TabChange 4
    endif
endfunc
" }}}

" }}}
"-----------------------------------------------------------------
" Mappings or Abbreviation {{{

" ~~ map ~~ {{{
"
noremap <silent> j          gj
noremap <silent> k          gk

noremap <silent> <LocalLeader><LocalLeader>         <LocalLeader>
noremap <silent> <Leader><Leader>                   <Leader>

" クリップボードにコピー
noremap <Leader>y     "+y

noremap <silent> H  5h
noremap <silent> L  5l
" }}}

" ~~ n ~~ {{{

nnoremap <silent> n     nzz
nnoremap <silent> N     Nzz

" add '\C' to the pattern
nnoremap <silent> *     :call <SID>dont_ignore_case('*')<CR>
nnoremap <silent> #     :call <SID>dont_ignore_case('#')<CR>
nnoremap <silent> g*    :call <SID>dont_ignore_case('g*')<CR>
nnoremap <silent> g#    :call <SID>dont_ignore_case('g#')<CR>
func! s:dont_ignore_case(cmd)
    let pos = getpos(".")

    execute 'normal! ' . a:cmd
    let @/ .= '\C'

    call setpos(".", pos)

    execute 'normal! ' . a:cmd
    set hlsearch
endfunc

" fix up all indents
nnoremap <silent> =<Space>    mqgg=G`qzz<CR>

" do not destroy noname register when pressed 'x'
nnoremap <silent> x       "_x

" window size of gVim itself
nnoremap <C-Right>    :set columns+=5<CR>
nnoremap <C-Left>     :set columns-=5<CR>
nnoremap <C-Up>       :set lines+=1<CR>
nnoremap <C-Down>     :set lines-=1<CR>

" window size in gVim
nnoremap <S-Right>  <C-w>>
nnoremap <S-Left>   <C-w><
nnoremap <S-Up>     <C-w>+
nnoremap <S-Down>   <C-w>-

" tab
nnoremap <silent> <C-n>         gt
nnoremap <silent> <C-p>         gT
nnoremap <silent> <C-Tab>       gt
nnoremap <silent> <C-S-Tab>     gT

" jump to the line matched '^\S'
noremap <silent> ]k        m`:call search( '^\S', 'W' )<CR>
noremap <silent> [k        m`:call search( '^\S', 'Wb' )<CR>

" make
nnoremap <silent>   gm      :make<CR>
nnoremap <silent>   gc      :cclose<CR>

" open only current line's fold.
func! s:FoldAllExpand()
    %foldclose
    silent! %foldclose!
    normal! zvzz
endfunc
nnoremap <silent> <Leader>nn   :call <SID>FoldAllExpand()<CR>

" wrap () with ().
nnoremap <Leader>a        %%i(<Esc>l%a)<Esc>%a
" change () to [].
nnoremap <Leader>A        %%mz%s]<Esc>`zs[<Esc>
" delete ().
nnoremap <Leader>z        %%mz%x`zx
" move current atoms in () to upper ().
nnoremap <Leader>Z        %%da(h"_da(P

nnoremap <silent> Q     gQ

" :vimgrep
nnoremap g/    :<C-u>vimgrep /<C-r>// *
nnoremap ,/    :<C-u>vimgrep // *<Left><Left><Left>

" hlsearch
nnoremap gh    :set hlsearch!<CR>

" sync @* and @+
" @* -> @+
nnoremap ,*+    :let @+ = @*<CR>:echo printf('[%s]', @+)<CR>
" @+ -> @*
nnoremap ,+*    :let @* = @+<CR>:echo printf('[%s]', @*)<CR>

" }}}

" ~~ o ~~ {{{
" omapclear
" }}}

" -- map! -- {{{
noremap! <C-f>   <Right>
noremap! <C-b>   <Left>
noremap! <M-f>   <C-Right>
noremap! <M-b>   <C-Left>
noremap! <C-a>   <Home>
noremap! <C-e>   <End>
noremap! <C-d>   <Del>
noremap! <C-k>   <C-o>D

noremap! <M-(>         ()<Left>
noremap! <M-[>         []<Left>
noremap! <M-<>         <><Left>
noremap! <M-{>         {}<Left>
noremap! <M-)>         \(\)<Left><Left>
noremap! <M-]>         \[\]<Left><Left>
noremap! <M->>         \<\><Left><Left>
noremap! <M-}>         \{\}<Left><Left>

noremap! <C-r><C-o>  <C-r><C-p>"
noremap! <C-r><C-r>  <C-r><C-p>+
" }}}

" ~~ i ~~ {{{
inoremap <S-CR>  <C-o>O
inoremap <C-CR>  <C-o>o

" <Space><BS> for saving current pos
inoremap <C-l>  <Space><BS><C-o><C-l>

" delete in parenthesis
inoremap <C-z>                <C-o>di(
" }}}

" ~~ c ~~ {{{
if &wildmenu
    cnoremap <C-f> <Space><BS><Right>
    cnoremap <C-b> <Space><BS><Left>
endif
" }}}

" abbr {{{

iabbrev <expr> date@      strftime("%Y-%m-%d")
iabbrev <expr> time@      strftime("%H:%M")
iabbrev <expr> datetime@  strftime("%Y-%m-%d %H:%M")

cabbrev   h@     tab help

" }}}

" }}}
"-----------------------------------------------------------------
" For Plugins {{{

" my plugins {{{

" CommentAnyWay {{{
let ca_prefix  = '<Leader>c'
let ca_verbose = 1    " debug

let ca_filetype_table = {
    \ 'oneline' : {
        \ 'dosbatch' : 'rem ###',
    \ },
    \ 'wrapline' : {
        \ 'html' : [ "<!-- ", " -->" ],
        \ 'css' : [ "/* ", " */" ],
    \ },
\ }

" nnoremapじゃダメ
nmap go      <Leader>co
nmap gO      <Leader>cO
" }}}

" nextfile {{{
let g:nf_map_next = ',n'
let g:nf_map_previous = ',p'
let nf_include_dotfiles = 1    " don't skip dotfiles
let nf_loop_files = 1    " loop at the end of file
let nf_ignore_ext = ['o']    " ignore object file
" }}}

" vimtemplate {{{
let g:vt_template_dir_path = expand("$HOME/.vim/template")
let g:vt_command = ''
let g:vt_author = "tyru"
let g:vt_email = "tyru.exe@gmail.com"

let s:files_tmp = {
    \'cppsrc.cpp'    : "cpp",
    \'csharp.cs'     : "cs",
    \'csrc.c'        : "c",
    \'header.h'      : "c",
    \'hina.html'     : "html",
    \'javasrc.java'  : "java",
    \'perl.pl'       : "perl",
    \'perlmodule.pm' : "perl",
    \'python.py'     : "python",
    \'scala.scala'   : "scala",
    \'scheme.scm'    : "scheme",
    \'vimscript.vim' : "vim"
\}
let g:vt_filetype_files = join(map(keys(s:files_tmp), 'v:val . "=" . s:files_tmp[v:val]'), ',')
unlet s:files_tmp
" }}}

" winmove {{{

" デフォルトマッピングにしたいがTTBaseのアクティブウィンドウを動かすプラグインのマッピングとの共存を考えた結果がこれ
let g:wm_move_down  = '<C-M-j>'
let g:wm_move_up    = '<C-M-k>'
let g:wm_move_left  = '<C-M-h>'
let g:wm_move_right = '<C-M-l>'
" }}}

" sign-diff {{{

" 現在未使用...
" (作ってから自分はどっちかと言うと
" ウィンドウにあまり情報を出したくない派なので要らないなと気付いた)
let g:SD_disable = 1

let g:SD_debug = 1
nnoremap <silent> <C-l>     :SDUpdate<CR><C-l>
" }}}

" DumbBuf {{{
let dumbbuf_hotkey = '<Leader>b'
" たまにQuickBuf.vimの名残で<Esc>を押してしまう
let dumbbuf_mappings = {
    \'n': {
        \'<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
    \}
\}
let dumbbuf_single_key = 1
let dumbbuf_updatetime = 1    " mininum value of updatetime.

let dumbbuf_cursor_pos = 'keep'
let dumbbuf_shown_type = 'listed'

" for test
"
" let dumbbuf_shown_type = 'foobar'
" let dumbbuf_listed_buffer_name = "*foo bar*"
" let dumbbuf_verbose = 1
" }}}

" }}}

" others {{{

" dicwin
let plugin_dicwin_disable = 1

" cmdex
let plugin_cmdex_disable = 1
" :CdCurrent - Change current directory to current file's one.
command! -nargs=0 CdCurrent lcd %:p:h
nnoremap <silent> <Leader>cd   :CdCurrent<CR>

" AutoDate
let g:autodate_format = "%Y-%m-%d"

" FencView
let g:fencview_autodetect = 0

" Netrw
let g:netrw_liststyle = 1
let g:netrw_cygwin    = 1

" FuzzyFinder {{{
nnoremap <silent> <Leader>fd       :FufRenewCache<CR>:FufDir<CR>
nnoremap <silent> <Leader>ff       :FufRenewCache<CR>:FufFile<CR>
nnoremap <silent> <Leader>fh       :FufRenewCache<CR>:FufMruFile<CR>

let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']

let fuf_keyOpenTabpage = '<C-CR>'
let fuf_keyNextMode    = '<C-l>'
let fuf_keyPrevMode    = '<C-h>'
let fuf_keyOpenSplit   = '<C-s>'
let fuf_keyOpenVsplit  = '<C-v>'

" abbrev {{{
let fuf_abbrevMap = {
    \'^plug' : ['~/.vim/plugin/', '~/.vim/plugin/', '~/.vim/mine/plugin/'],
    \'^home' : ['~/'],
\}
if exists('$CYGHOME')  | let fuf_abbrevMap['^cyg']  = $CYGHOME  | endif
if exists('$MSYSHOME') | let fuf_abbrevMap['^msys'] = $MSYSHOME | endif

if has('win32')
    let fuf_abbrevMap['^desk'] = [
                \   'C:' . substitute( $HOMEPATH, '\', '/', 'g' ) . '/デスクトップ/'
                \ ]
    let fuf_abbrevMap['^cyg'] = [
                \   'C:/cygwin/home/'. $USERNAME .'/'
                \ ]
    let fuf_abbrevMap['^msys'] = [
                \   'C:/msys/home/'. $USERNAME .'/'
                \ ]
else
    let fuf_abbrevMap['^desk'] = [
                \     '~/Desktop/'
                \ ]
endif
" }}}
" }}}

" MRU
nnoremap <silent> <C-h>     :MRU<CR>
let MRU_Max_Entries   = 500
let MRU_Add_Menu      = 0
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\c\'

" Align
let Align_xstrlen    = 3       " multibyte
let DrChipTopLvlMenu = ""
command! -nargs=0 AlignReset call Align#AlignCtrl("default")
cabbrev   al    Align

" Chalice
let chalice_preview      = 0
let chalice_startupflags = "bookmark"

" changelog
let changelog_username = "tyru"

" gtags {{{

let loaded_gtags = 1

" let s:gtags_found = 0
" 
" func! s:JumpTags()
"     if expand('%') == '' | return | endif
" 
"     if exists(':GtagsCursor')
"         " next C-]
"         echo "gtags.vim is not installed. do default <C-]>..."
"         sleep 2
"         nunmap <C-]>
"         execute "normal! \<C-]>"
"         return
"     endif
" 
"     let gtags = expand('%:h') . '/GTAGS'
"     if filereadable(gtags)
"         if ! s:gtags_found
"             " if gtags found, echo this message at only first time.
"             echo "found GTAGS. use gtags for jumping..."
"             sleep 2
"             let s:gtags_found = 1
"         endif
"         lcd %:p:h
"         GtagsCursor
"         lcd -
"     else
"         execute "normal! \<C-]>"
"     endif
" endfunc
" 
" nnoremap <silent> g<C-i>    :Gtags -f %<CR>
" nnoremap <silent> <C-]>    :call <SID>JumpTags()<CR>
" }}}

" xptemplate
let xptemplate_key = '<C-t>'

" operator-replace
map ,r  <Plug>(operator-replace)

" taglist {{{
let Tlist_Ctags_Cmd = 'ctags'
nnoremap <silent> \t :TlistToggle<CR>

let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 1
let Tlist_Compact_Format = 1
let Tlist_Display_Prototype = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
" }}}

" }}}

" }}}
"-----------------------------------------------------------------

let &cpo = s:save_cpo
" vim:set fen fdm=marker:
