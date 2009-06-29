scriptencoding utf-8
set nocompatible
let s:save_cpo = &cpo
set cpo&vim

" TODO
" com! ReadAllFiles

"-----------------------------------------------------------------
" Colorscheme {{{1
"
" peachpuff
" evening, desert, slate, candycode, lettuce, rdark, wombat
" advantage, reloaded, hh***, hhd***, maroloccio
"
" eveningはdesertに文字列ハイライト足した感じ
" でもdesertも好きだったりする

fun! SetColorScheme()
    if has( 'gui' )
        " GUI版の設定
        colorscheme desert
    else
        " ターミナル版の設定
        colorscheme evening
    endif
endfun

call SetColorScheme()

" }}}1
"-----------------------------------------------------------------
" 基本設定＆KaoriYa版についてきたもの＆その他色々コピペ {{{1

" set options {{{2

" set matchpairs+=<:>       " これがあると->を入力したとき画面が点滅する
" set spell      " すげーけどキモい
" set wildignore=*.o,*.obj,*.la,*.a,*.exe,*.com,*.tds
set autoindent
set autoread
set backspace=indent,eol,start
set browsedir=buffer
set clipboard=
set complete=.,w,b,k
set diffopt=filler,vertical
set directory=$HOME/.vim/backup
set expandtab
set formatoptions-=atc
set guioptions-=T
set guioptions-=m
set history=50
set hlsearch
set ignorecase
set incsearch
set keywordprg=
set laststatus=2
set list
set listchars=tab:>-,extends:<
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
set updatetime=10000
set viminfo='50,h,f1,n$HOME/.viminfo
set visualbell
set whichwrap=
set wildchar=<Tab>
set wildmenu
set wrap
set wrapscan

if has('unix')
    set nofsync
    set swapsync=
endif

set backup
set backupdir=$HOME/.vim/backup
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif

" タイトル表示するかしないか
if has('gui')
    set title
else
    set notitle
endif

" マップリーダー
let mapleader = ','
let maplocalleader = ';'


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


if has("migemo")
    set migemo
endif
if exists('+shellslash')
    set shellslash
endif

syntax on
filetype plugin indent on


" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 日本語整形スクリプト(by. 西岡拓洋さん)用の設定
let format_allow_over_tw = 1    " ぶら下り可能幅


" ランタイムパスの設定
if has( "win32" ) && isdirectory( $HOME .'/.vim' )
    set runtimepath+=$HOME/.vim
endif
let s:runtime_dirs = [
            \ '$HOME/.vim/after',
            \ '$HOME/.vim/mine',
            \ '$HOME/.vim/chalice',
            \ '$HOME/.vim/hatena',
            \ '$HOME/.vim/xpt'
            \ ]
for dir in s:runtime_dirs
    if isdirectory(expand(dir))
        let &runtimepath .= ',' . expand(dir)
    endif
endfor
unlet s:runtime_dirs
" }}}2

" vimbackupの中の古いやつを削除する {{{2
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
                call s:Warn("can't delete " . i)
            endif
        endfor
        call writefile([localtime()], stamp_file)
    endif
endfunc

call s:DeleteBackUp()
delfunc s:DeleteBackUp
" }}}2

" 文字コードの設定 {{{2

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
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

" }}}2

" メニューファイルが存在しない場合は予め'guioptions'を調整しておく {{{2
if !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
    set guioptions+=M
endif

" }}}2

" ファイル名に大文字小文字の区別がないシステム用の設定 {{{2
"   (例: DOS/Windows/MacOS)

if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
    " tagsファイルの重複防止
    set tags=./tags,tags
endif

" }}}2

" コンソールでのカラー表示のための設定(暫定的にUNIX専用) {{{2
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
    unlet uname
endif

" }}}2

" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応 {{{2
if !has('gui_running') && has('xterm_clipboard')
    set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

" }}}2

" プラットホーム依存の特別な設定 {{{2

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
    " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
    set iskeyword=@,48-57,_,128-167,224-235
endif

" }}}2

" }}}1
"-----------------------------------------------------------------
" Commands {{{1

" Util Commands {{{
" s:Warn {{{
func! s:Warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}

" s:System {{{
func! s:System(command, ...)
    let args = [a:command] + map(copy(a:000), 'shellescape(v:val)')
    return system(join(args, ' '))
endfunc
" }}}
" }}}


command! -range BSlashToSlash
            \ s/\\/\//g
command! -range SlashToBSlash
            \ s/\//\\/g

" セッション保存 GUI 版
if has( 'gui_running' )
    command! Session       browse mksession
endif

" HelpTagAll {{{2
"     runtimepathの全てのdocディレクトリに
"     helptagsする
command! HelpTagAll
            \ call s:HelpTagAll()

func! s:HelpTagAll()
    for path in split( &runtimepath, ',' )
        if isdirectory( path . '/doc' )
            "" path . '/doc/*' に何もないと
            "" No match ... ってエラーが出るので :silent!
            silent! exe 'helptags ' . path . '/doc'
        endif
    endfor
endfunc
" }}}2

" ToggleEol {{{2
" 末尾の$を表示したりしなかったり
command! ToggleEol
            \ call s:ToggleEol()

let s:listchars_eol_toggled = 0
func! s:ToggleEol()
    if s:listchars_eol_toggled
        set listchars=tab:>-,extends:<
        let s:listchars_eol_toggled = 0
    else
        set listchars=tab:>-,eol:$,extends:<
        let s:listchars_eol_toggled = 1
    endif
endfunc
" }}}2

" MTest {{{2
"     Perlの正規表現をVimの正規表現に
command! -nargs=? MTest
            \ call s:MTest( <q-args> )

func! s:MTest( ... )

    let regex = a:1
    " backup
    let searched = @/
    let hilight = &hlsearch

    " 変換
    silent exe "M" . regex
    let @" = @/

    let @/ = searched
    let &hlsearch = hilight

    echo @"
endfunc
" }}}2

" Dir {{{2
command! -nargs=? -complete=dir Dir
            \ call s:Dir( <f-args> )

func! s:Dir( ... )
    let dir =   a:0 == 1 ? a:1 : '.'

    if !isdirectory( dir )
        call s:Warn(dir .': No such a directory')
        return
    endif

    if has( 'win32' )
        if dir =~ '[&()\[\]{}\^=;!+,`~ '. "']" && dir !~ '^".*"$'
            let dir = '"'. dir .'"'
        endif
        let dir = substitute( dir, '/', '\', 'g' )
        call s:Sysmtem('explorer', dir)
    else
        let dir = shellescape( dir )
        call s:Sysmtem('gnome-open', dir)
    endif
endfunc
" }}}2

" 環境によって動作が異なるコマンド {{{2
if has('gui_running')
    if has( 'win32' )
        command! GoDesktop   execute 'lcd C:' . $HOMEPATH . '\デスクトップ'
        command! SH          !start cmd.exe
    else
        command! GoDesktop   lcd '~/Desktop'
    endif
endif
" }}}2

" s:ListAndExecute() {{{2
func! s:ListAndExecute( lis, template )
    " リスト表示
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

        " 数字の場合
        if string( num ) =~ '^\d\+$'
            if num < 1 || len( a:lis ) < num
                " 範囲外
                call s:Warn( 'out of num number. Try again.' )
            else
                break
            endif
        else
            call s:Warn( 'non-digit characters found. Try again.' )
        endif
    endwhile

    execute substitute( a:template, '%embed%', a:lis[num - 1], 'g' )
    redraw

    return a:lis[num - 1]
endfunc
" }}}2

" s:ListChars() {{{2
command! ListChars
            \ call s:ListChars()

func! s:ListChars()
    call s:ListAndExecute( [  '',
                \                 'tab:>-,extends:<',
                \                 'tab:>-,eol:$,extends:<',
                \                 'tab:>\\ ',
                \                 'tab:>\\ ,extends:<' ],
                \              'set listchars=%embed%' )
endfunc
" }}}2

" FastEdit {{{2
"   遅いときは役に立つかも
nnoremap <LocalLeader>fe        :call <SID>FastEdit()<CR>

let s:fast_editing = 0
func! s:FastEdit()
    call garbagecollect()

    if s:fast_editing

        " ファイルタイプ(カラーとかインデントとか)
        filetype on
        filetype plugin indent on

        echo 'slow but high ability.'
    else

        " ファイルタイプ
        filetype off
        filetype plugin indent off

        " 不可逆
        " autocmd! CursorMoved
        " autocmd! CursorMovedI

        echo 'fast browsing.'
    endif

    let s:fast_editing = s:fast_editing ? 0 : 1
endfunc
" }}}2

" DelFile {{{2
command! -complete=file -nargs=+ DelFile
            \ call s:DelFile(<f-args>)

func! s:DelFile(...)
    if a:0 == 0 | return | endif

    for i in map(copy(a:000), 'expand(v:val)')
        for j in split(i, "\n")
            if filereadable(j)
                call delete(j)
            else
                call s:Warn(j . ": No such a file")
            endif

            if filereadable(j)
                call s:Warn(printf("Can't delete '%s'", j))
            elseif j ==# expand('%')
                " 現在開いているファイルを削除する場合現在のバッファを削除する
                bwipeout
            endif
        endfor
    endfor
endfunc
" }}}2

" TabChange {{{2
command! -nargs=1 TabChange
            \ call s:TabChange( <f-args> )

func! s:TabChange( width )
    if a:width =~ '^\d\+$'
        exe "setlocal ts=" . a:width
        exe "setlocal sw=" . a:width
    endif
endfunc
" }}}2

" Mkdir {{{2
func! s:Mkdir(...)
    for i in a:000 | call mkdir(i, 'p') | endfor
endfunc
command! -nargs=+ -complete=dir Mkdir
            \ call s:Mkdir(<f-args>)
" }}}2

" WhoseCommand {{{2
func! s:WhoseCommand(cmd)
    set verbose=7
    " show 'Last set from ...'
    execute 'com ' . a:cmd
    set verbose=0
endfunc

command! -nargs=1 -complete=command
            \ WhoseCommand
            \ call s:WhoseCommand(<f-args>)
" }}}2

" s:GccSyntaxCheck(...) {{{2
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
" }}}2

" }}}1
"-----------------------------------------------------------------
" Encoding {{{1

set fencs-=iso-2022-jp-3
set fencs+=iso-2022-jp,iso-2022-jp-3

" set enc=... {{{2
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
" }}}2

" set fenc=... {{{2
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
" }}}2

" set ff=... {{{2
func! <SID>ChangeNL()
    let result = s:ListAndExecute( [ 'dos', 'unix', 'mac' ], 'set ff=%embed%' )
    if result != ''
        echo 'Converting newline...' . result
    endif
endfunc
nnoremap <silent> <F4>    :call <SID>ChangeNL()<CR>
" }}}2

" }}}1
"-----------------------------------------------------------------
" FileType and AutoCommand {{{1

" augroup MyVimrc {{{2
augroup MyVimrc
    autocmd!

    " autocmd CursorHold,CursorHoldI *   silent! update
    autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,helpgrep   copen

    " ftpluginディレクトリ作るのめんどい
    autocmd FileType *   call s:LoadWhenFileType()

    " filetype {{{3
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
    " }}}3

augroup END
" }}}2

func! s:SetDict(...)
    execute "setlocal dict="
                \ . join(map(copy(a:000), '"$HOME/.vim/dict/" . v:val . ".dict"'), ',')
endfunc


" s:LoadWhenFileType() {{{2
func! s:LoadWhenFileType()

    call s:SetDict(&filetype)    " dict

    " デフォルト(ftplugin/*.vimで用意されていない場合)のomnifunc
    if exists("+omnifunc") && &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
    endif

    if &filetype == 'actionscript'
        TabChange 4

    elseif &filetype == 'c' || &filetype == 'cpp'
        TabChange 4
        compiler gcc
        if &filetype == 'c'
            let gcc = 'gcc'
            call s:SetDict('c')
        elseif &filetype == 'cpp'
            let gcc = 'g++'
            call s:SetDict('c', 'cpp')
        endif

        let curdir = expand('%:p:h') . '/'
        if curdir . filereadable('Makefile') || filereadable('makefile')
            let &l:makeprg = 'make'
        else
            let &l:makeprg = gcc . ' -Wall -W -pedantic -fsyntax-only %'
        endif

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
        call s:SetDict('html', 'javascript', 'css')
        if &filetype == 'html'
            inoremap <buffer>   </    </<C-x><C-o>
        endif

    elseif &filetype == 'java'
        TabChange 2
        " for javadoc
        setlocal iskeyword+=@-@
        compiler javac
        setlocal makeprg=javac\ %

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
        call s:LispSetup()

    elseif &filetype == 'perl'
        TabChange 4
        compiler perl
        if exists('$PERL5LIB')
            for i in split(expand('$PERL5LIB'), ':')
                execute 'setlocal path+=' . i
            endfor
        endif
        setlocal suffixesadd=.pm
        setlocal makeprg=perl\ -c\ %

    elseif &filetype == 'yaml'
        TabChange 2

    else
        TabChange 4
    endif

endfunc
" }}}2

" }}}1
"-----------------------------------------------------------------
" For Lisp(Scheme,Gauche) {{{1


" 端末の時だと見づらくなる
if has('gui_running')
    let g:lisp_rainbow = 1
endif

command! LispSetup            call s:LispSetup()

" s:EvalFileNormal(eval_main) {{{2
func! s:EvalFileNormal(eval_main)
    normal! %v%
    call s:EvalFileVisual(a:eval_main)
endfunc
" }}}2

" s:EvalFileVisual(eval_main) {{{2
func! s:EvalFileVisual(eval_main) range
    let z_val = getreg('z', 1)
    let z_type = getregtype('z')
    normal! "zy

    try
        let curfile = expand('%')
        if !filereadable(curfile)
            call s:Warn("can't load " . curfile . "...")
            return
        endif

        let lines = readfile(curfile) + ['(print'] + split(@z, "\n") + [')']

        let tmpfile = tempname() . localtime()
        call writefile(lines, tmpfile)

        if filereadable(tmpfile)
            if a:eval_main ==# 'e'
                " ファイル全体を評価し、mainを実行する
                echo s:System('gosh', tmpfile)
            elseif a:eval_main ==# 'E'
                " ファイル全体を評価する
                echo system(printf('cat %s | gosh', shellescape(tmpfile)))
            else
                call s:Warn("this block never reached")
            endif
        else
            call s:Warn("cannot write to " . tmpfile . "...")
        endif
    finally
        call setreg('z', z_val, z_type)
    endtry
endfunc
" }}}2

" s:LispSetup() {{{2
func! s:LispSetup()
    if exists('b:LispSetup') && b:LispSetup != 0 | return | endif

    setlocal lisp
    setlocal nocindent

    nnoremap <buffer> <LocalLeader>e       :call <SID>EvalFileNormal('e')<CR>
    vnoremap <buffer> <LocalLeader>e       :call <SID>EvalFileVisual('e')<CR>
    nnoremap <buffer> <LocalLeader>E       :call <SID>EvalFileNormal('E')<CR>
    vnoremap <buffer> <LocalLeader>E       :call <SID>EvalFileVisual('E')<CR>
    nnoremap <buffer> <LocalLeader><C-e>   :echo <SID>System('gosh', expand('%'))<CR>

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


    let b:LispSetup = 1
endfunc
" }}}2
" }}}1
"-----------------------------------------------------------------
" Mappings or Abbreviation {{{1

" ~~ map ~~ {{{2
"
noremap <silent> j          gj
noremap <silent> k          gk

noremap <silent> <LocalLeader><LocalLeader>         <LocalLeader>
noremap <silent> <Leader><Leader>                   <Leader>

" クリップボードにコピー
noremap <LocalLeader>y     "*y

" }}}2

" ~~ n ~~ {{{2

nnoremap <silent> n     nzz
nnoremap <silent> N     Nzz

nnoremap <silent> *     :call <SID>Srch( 0, '*' )<CR>
nnoremap <silent> #     :call <SID>Srch( 0, '#' )<CR>
nnoremap <silent> g*    :call <SID>Srch( 1, '*' )<CR>
nnoremap <silent> g#    :call <SID>Srch( 1, '#' )<CR>
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

" ただ'\C'をつけるだけなのに・・・
func! s:Srch( g, vect )
    if a:g
        let word = s:EscapeRegexp( expand( '<cword>' ) ) .'\C'
    else
        let word = '\<'. s:EscapeRegexp( expand( '<cword>' ) ) .'\>\C'
    endif
    if a:vect == '*'
        call feedkeys( "/". word ."\<CR>", 'n' )
    else
        call feedkeys( "gew?". word ."\<CR>", 'n' )
    endif
endfunc

" 全部インデント
nnoremap <silent> =<Space>    mqgg=G`qzz<CR>

" ハイライトを消す(silentはつけない)
nnoremap /       :nohls<CR>/

" レジスタに記憶しない
nnoremap <silent> x       "_x

" ウインドウサイズ変更
nnoremap <C-Right>    :set columns+=5<CR>
nnoremap <C-Left>     :set columns-=5<CR>
nnoremap <C-Up>       :set lines+=1<CR>
nnoremap <C-Down>     :set lines-=1<CR>

" 小窓サイズ変更
nnoremap <S-Right>  <C-w>>
nnoremap <S-Left>   <C-w><
nnoremap <S-Up>     <C-w>+
nnoremap <S-Down>   <C-w>-

" タブ移動
nnoremap <silent> <C-n>         gt
nnoremap <silent> <C-p>         gT
nnoremap <silent> <C-Tab>       gt
nnoremap <silent> <C-S-Tab>     gT

" 保存ダイアログ
if has( 'gui_running' )
    nnoremap <C-s>      :browse confirm saveas<CR>
endif

" 先頭が \S の行に飛ぶ
noremap <silent> ]k        m`:call search( '^\S', 'W' )<CR>
noremap <silent> [k        m`:call search( '^\S', 'Wb' )<CR>

" make
nnoremap <silent>   gm      :make<CR>
nnoremap <silent>   gc      :cclose<CR>

func! s:FoldAllExpand()
    %foldclose
    silent! %foldclose!
    normal zvzz
endfunc
nnoremap <silent> <LocalLeader>nn   :call <SID>FoldAllExpand()<CR>

nnoremap <silent> <LocalLeader>cd   :CdCurrent<CR>

nnoremap <silent> gn    :cn<CR>
nnoremap <silent> gN    :cN<CR>

" for lisp ?
nnoremap <silent> <LocalLeader>a        %%i(<Esc>l%a)<Esc>%a
nnoremap <silent> <LocalLeader>A        %%mz%s]<Esc>`zs[<Esc>
nnoremap <silent> <LocalLeader>z        %%mz%x`zx
nnoremap <silent> <LocalLeader>Z        %%da(h"_da(P

" }}}2

" ~~ o ~~ {{{2
" onoremapがうざいので
func! s:ClearOmap()
    omapclear
    execute 'onoremap '. g:maplocalleader .'y  "*y'
endfunc
call s:ClearOmap()
" }}}2

" -- map! -- {{{2
noremap! <C-f>   <Right>
noremap! <C-b>   <Left>
noremap! <M-f>   <C-Right>
noremap! <M-b>   <C-Left>
noremap! <C-a>   <Home>
noremap! <C-e>   <End>

" 括弧
noremap! <M-(>         ()<Left>
noremap! <M-[>         []<Left>
noremap! <M-<>         <><Left>
noremap! <M-{>         {}<Left>
noremap! <M-)>         \(\)<Left><Left>
noremap! <M-]>         \[\]<Left><Left>
noremap! <M->>         \<\><Left><Left>
noremap! <M-}>         \{\}<Left><Left>
" }}}2

" ~~ i ~~ {{{2
inoremap <S-CR>  <C-o>O
inoremap <C-CR>  <C-o>o

inoremap <C-r><C-o>  <C-r><C-p>"
inoremap <C-r><C-r>  <C-r><C-p>+

inoremap <C-l>  <Space><BS><C-o><C-l>

inoremap <buffer> <C-z>                <C-o>di(
inoremap <buffer> <C-S-z>              <C-o>da(
" }}}2

" ~~ c ~~ {{{2

" 親フォルダ補完
cnoremap <C-x>    <C-r>=expand('%:p:h')<CR>/
" ファイル補完
cnoremap <C-z>   <C-r>%

cnoremap <C-r><C-o>  <C-r>"
cnoremap <C-r><C-r>  <C-r>+
" }}}2

" abbr {{{2

iabbrev <expr> date@      strftime("%Y-%m-%d")
iabbrev <expr> time@      strftime("%H:%M")
iabbrev <expr> datetime@  strftime("%Y-%m-%d %H:%M")

cabbrev   h@     tab help

" }}}2

" }}}1
"-----------------------------------------------------------------
" For Plugins {{{1

" プラグイン {{{2

" dicwin
let plugin_dicwin_disable = 1

" cmdex
let plugin_cmdex_disable = 1
" :CdCurrent - Change current directory to current file's one.
command! -nargs=0 CdCurrent lcd %:p:h

" AutoDate
let g:autodate_format = "%Y-%m-%d"

" FencView
let g:fencview_autodetect = 0

" Netrw
let g:netrw_liststyle = 1
let g:netrw_cygwin    = 1

" FuzzyFinder {{{3
nnoremap <silent> <LocalLeader>b        :FuzzyFinderBuffer<CR>
nnoremap <silent> <LocalLeader>fd       :FuzzyFinderDir<CR>
nnoremap <silent> <LocalLeader>ff       :FuzzyFinderFile<CR>
nnoremap <silent> <LocalLeader>fh       :FuzzyFinderMruFile<CR>
nnoremap <silent> <LocalLeader>ft       :FuzzyFinderTag<CR>
nnoremap <silent> <LocalLeader>fT       :FuzzyFinderTaggedFile<CR>
nnoremap <silent> <LocalLeader>t        :FuzzyFinderTagWithCursorWord<CR>


let g:FuzzyFinderOptions = {
    \ 'Base':{},
    \ 'Buffer':{ "mode_available" : 1 },
    \ 'File':{ "mode_available" : 1 },
    \ 'Dir':{ "mode_available" : 1 },
    \ 'MruFile':{ "mode_available" : 1 },
    \ 'MruCmd':{ "mode_available" : 0 },
    \ 'Bookmark':{ "mode_available" : 0 },
    \ 'Tag':{ "mode_available" : 1 },
    \ 'TaggedFile':{ "mode_available" : 1 },
    \ 'GivenFile':{ "mode_available" : 0 },
    \ 'GivenDir':{ "mode_available" : 0 },
    \ 'GivenCmd':{ "mode_available" : 0 },
    \ 'CallbackFile':{ "mode_available" : 0 },
    \ 'CallbackItem':{ "mode_available" : 0 },
\ }

" let g:FuzzyFinderOptions.Base.migemo_support   = 1    " 何故かSEGVる
let g:FuzzyFinderOptions.Base.key_open_tab     = '<C-CR>'
let g:FuzzyFinderOptions.Base.key_next_mode    = '<C-l>'
let g:FuzzyFinderOptions.Base.key_prev_mode    = '<C-h>'
let g:FuzzyFinderOptions.Base.key_open_split   = '<C-s>'
let g:FuzzyFinderOptions.Base.key_open_vsplit  = '<C-v>'
let g:FuzzyFinderOptions.Base.lasting_cache    = 0

""" 短縮形
let g:FuzzyFinderOptions.Base.abbrev_map  = {
            \   '^plug' : [ '~/.vim/plugin/', '~/.vim/plugin/' ],
            \   '^home' : [ '~/' ],
            \   '^cyg' : [ $CYGHOME ],
            \   '^msys' : [ $MSYSHOME ],
            \ }
if isdirectory( $HOME .'/.vim/mine/plugin' )
    let g:FuzzyFinderOptions.Base.abbrev_map['^plug'] += [
                \ '~/.vim/mine/plugin/'
                \ ]
endif

" デスクトップ
if has( 'win32' )
    let g:FuzzyFinderOptions.Base.abbrev_map['^plug'] += [
                \   '~/vimfiles/plugin/'
                \ ]
    let g:FuzzyFinderOptions.Base.abbrev_map['^desk'] = [
                \   'C:' . substitute( $HOMEPATH, '\', '/', 'g' ) . '/デスクトップ/'
                \ ]
    let g:FuzzyFinderOptions.Base.abbrev_map['^cyg'] = [
                \   'C:/cygwin/home/'. $USERNAME .'/'
                \ ]
    let g:FuzzyFinderOptions.Base.abbrev_map['^msys'] = [
                \   'C:/msys/home/'. $USERNAME .'/'
                \ ]
else
    let g:FuzzyFinderOptions.Base.abbrev_map['^desk'] = [
                \     '~/Desktop/'
                \ ]
endif
" }}}3

" MRU
nnoremap <silent> <C-h>     :MRU<CR>
let MRU_Max_Entries   = 500
let MRU_Add_Menu      = 0
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\c\'

" Align
let Align_xstrlen    = 3       "マルチバイト
let DrChipTopLvlMenu = ""
command! -nargs=0 AlignReset call Align#AlignCtrl( "default" )
cabbrev   al    Align

" Chalice {{{
"
" プレビュー機能無効
let chalice_preview      = 0
let chalice_startupflags = "bookmark"

" 画像収集
if exists(':M')
    command! SrchImageUri
                \ :M/h?ttp:\/\/.+\.(jpe?g|png|gif|bmp)\c
endif

nnoremap <silent> ,cv    :call Chalice_ThreadCopy( 'v' )<CR>
nnoremap <silent> ,cs    :call Chalice_ThreadCopy( 's' )<CR>
nnoremap <silent> ,ct    :call Chalice_ThreadCopy( 't' )<CR>

func! Chalice_ThreadCopy( open_to )
    1yank x
    %yank y

    if a:open_to == 'v'
        let new_reg_name = "vnew " . strpart(@x, 7)
    elseif a:open_to == 's'
        let new_reg_name = "new " . strpart(@x, 7)
    elseif a:open_to == 't'
        let new_reg_name = "tabe " . strpart(@x, 7)
    endif

    exe new_reg_name
    put y
    1delete
    setlocal ft=2ch_thread
endfunc
" }}}

" changelog
let changelog_username = "tyru"

" Narrow
nnoremap <silent>   <LocalLeader>na     :Narrow<CR>
nnoremap <silent>   <LocalLeader>nw     :Widen<CR>

" gtags
let s:gtags_found = 0
func! s:JumpTags()
    if expand('%') == '' | return | endif

    let gtags = expand('%:h') . '/GTAGS'
    if exists(':GtagsCursor') && filereadable(gtags)
        if ! s:gtags_found
            echo "found GTAGS. use gtags for jumping..."
            sleep 2
            let s:gtags_found = 1
        endif
        lcd %:p:h
        GtagsCursor
        lcd -
    else
        execute "normal! \<C-]>"
    endif
endfunc

nnoremap <silent> g<C-i>    :Gtags -f %<CR>
nnoremap <silent> <C-]>    :call <SID>JumpTags()<CR>

" xptemplate
let xptemplate_key = '<C-k>'

" }}}2

" 自分の {{{2

" DictionarizeBuffer
let g:loaded_dictionarize_buffer = 1

" shell-mode

" CommentAnyWay {{{
let g:ca_prefix  = maplocalleader . 'c'
let g:ca_verbose = 1    " debug
let g:ca_oneline_comment = "//"

let g:ca_filetype_table = {
            \ 'oneline' : {
            \ 'dosbatch' : 'rem ###'
            \ },
            \ 'wrapline' : {
            \ 'html' : [ "<!-- ", " -->" ],
            \ 'css' : [ "/* ", " */" ]
            \ }
            \ }

" nnoremapじゃダメ
nmap go      <LocalLeader>co
nmap gO      <LocalLeader>cO
" }}}

" nextfile {{{
let nf_include_dotfiles = 1
let nf_loop_files = 1
let nf_ignore_ext = ['o']
" }}}

" vimtemplate {{{
let g:vt_command = ''
let g:vt_author = "tyru"
let g:vt_email = "tyru.exe@gmail.com"

let s:tmp = [
            \ 'cppsrc.cpp=cpp',
            \ 'header.h=cpp',
            \ 'csrc.c=c',
            \ 'csharp.cs=cs',
            \ 'hina.html=html',
            \ 'javasrc.java=java',
            \ 'perl.pl=perl',
            \ 'perlmodule.pm=perl',
            \ 'python.py=python',
            \ 'scala.scala=scala',
            \ 'vimscript.vim=vim'
            \ ]
let g:vt_filetype_files = join(s:tmp, ',')
unlet s:tmp    " for memory
" }}}

" winmove {{{
let g:wm_move_down  = '<C-M-j>'
let g:wm_move_up    = '<C-M-k>'
let g:wm_move_left  = '<C-M-h>'
let g:wm_move_right = '<C-M-l>'
" }}}

" }}}2

" }}}1
"-----------------------------------------------------------------
" その他 {{{1
call setreg( '/', '', '' )
call setreg( '"', '', '' )
" }}}1
"-----------------------------------------------------------------

let &cpo = s:save_cpo
" vim:fdm=marker:fen:
