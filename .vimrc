scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

"-----------------------------------------------------------------
" Colorscheme {{{1
"
" peachpuff
" evening, desert, slate, candycode, lettuce, rdark, wombat
" advantage, reloaded, hh***, hhd***, maroloccio
"
" eveningはdesertに文字列ハイライト足した感じ
" でもdesertも好きだったりする

" TODO: localtime()とか使ってrand()実装
fun! RandomColorScheme()
    if has( 'gui' )
        " GUI版の設定
        colorscheme evening
    else
        " ターミナル版の設定
        colorscheme evening
    endif
endfun

call RandomColorScheme()

" }}}1
"-----------------------------------------------------------------
" 基本設定＆KaoriYa版についてきたもの {{{1

" set options {{{2

set nocompatible  " Use Vim defaults (much better!)


" set clipboard=unnamed         " レジスタをWindowsのクリップボードと同期
" set matchpairs+=<:>       " これがあると->を入力したとき画面が点滅する
" set spell      " すげーけどキモい
set autoindent
set autoread        " ファイルに外部で変更があった場合再読み込み
set backspace=indent,eol,start
set browsedir=buffer          " browseで開くディレクトリをファイルと同じにする
set clipboard=
set complete+=k,U,d
set diffopt=filler,vertical
set directory=$HOME/.vim/backup " スワップファイルの設定
set expandtab
set formatoptions-=atc
set guioptions-=T
set guioptions-=m
set history=50    " keep 50 lines of command line history
set hlsearch
set ignorecase
set incsearch
set infercase                 " <C-n>とか<C-p>のとき小・大文字を無視
set keywordprg=
set laststatus=2
set list                      " 行末、タブなどを表示
set listchars=tab:>-,extends:<
set noshowcmd
set nosplitright            " :vs で左側に開く
set notimeout
set nowrap
set nrformats-=octal    " <C-a>で、007を010ではなく、008にする
set ruler
set scroll=5
set scrolloff=15
set shiftround
set shiftwidth=4
set shortmess+=I    " 最初のメッセージを表示しない
set showmatch
set smartcase
set smartindent
set smarttab
set splitbelow    " :sp で下に開く
set tabstop=4
set updatetime=10000
set viminfo='50,h,f1,n$HOME/.viminfo
set visualbell
set whichwrap=
set wildchar=<Tab>
" set wildignore=*.o,*.obj,*.la,*.a,*.exe,*.com,*.tds    " :e とかのファイル補完で無視される
set wildmenu
set wrapscan

set backup
set backupdir=$HOME/.vim/backup " バックアップファイルのディレクトリ
silent! call mkdir(&backupdir)

" タイトル表示するかしないか
if has('gui')
    set title
else
    set notitle
endif

" マップリーダー
let mapleader = ','
let maplocalleader = ';'


set statusline=%f%m%r%h%w\ [%{&fenc}][%{&ff}]\ [%p%%][%l/%L]\ [%{StatusLine('%:p:h',20)}]

func! StatusLine( path, maxwidth )
    let path = expand( a:path )

    " split current directory into 'dirs'.
    if exists( '+shellslash' )
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


if has( "migemo" )
    set migemo
endif
if exists( '+shellslash' )
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
    \ '$HOME/.vim/howm_vim',
    \ '$HOME/.vim/xpt'
\ ]
for dir in s:runtime_dirs
    if isdirectory(expand(dir))
        let &runtimepath .= ',' . expand(dir)
    endif
endfor
" }}}2

" vimbackupの中の、古いやつを削除する {{{2
func! s:DeleteBackUp()
    let f = $HOME .'/.vim/.vimbackup_deleted'
    if !filereadable( f )
        call writefile( [localtime()], f )
        return
    endif

    let [line] = readfile( f, '', 1 )
    let one_day_sec = 60 * 60 * 24    " 1日に何回も削除しようとしない
    if line =~# '^\d\+\n\=$' && str2nr( line ) - localtime() > one_day_sec
        if has( 'perl' )
            perl << EOF
            # globが使えない
            my $d = $HOME .'/.vim/backup/';
            return unless -d $d;
            for( readdir opendir( my $dh, $d ) ) {
                my $f = $d . $_;
                unlink $f   if -M $f > 30;    # 30日以上経過したファイル削除
            }
            closedir( $dh );
EOF
        elseif executable( 'perl' )
            call system( 'perl "'. $HOME .'/.vim/clean.pl"' )
        else
            return
        endif
        call writefile( [localtime()], f )
    endif
endfunc

call s:DeleteBackUp()
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
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
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
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
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

command! -range BSlash2Slash
    \ s/\\/\//g

" Chalice用 画像収集
if has(':M')
    command! SrchImageUri
        \ :M/h?ttp:\/\/.+\.(jpe?g|png|gif|bmp)\c
endif

" セッション保存 GUI 版
if has( 'gui_running' )
    command! Session       browse mksession
endif

" フォント切り替え {{{2
if has( "gui_running" ) && has( "win32" )
    " TODO: フォントサイズも保持する
    let s:fonts = [
        \ "MS_Gothic",
        \ "Osaka?等幅",
        \ "M+2VM+IPAG_circle",
        \ "きろ字",
        \ "ゆたぽん（コーディング）Bold"
    \ ]
    let s:fmt = 'set guifont=%embed% printfont=%embed%'
    command! ToggleFont
        \ call s:ListAndExecute( s:fonts, s:fmt )
    unlet s:fonts
    unlet s:fmt
endif
" }}}2

" CurFilePath {{{2
command! -register -nargs=? CurFilePath
    \ call s:CurFilePath(<reg>)

func! s:CurFilePath(...)
    let regname = a:0 == 0 ? '"' : a:1
    call setreg(regname, expand('%:p'))
endfunc
" }}}2

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

" Reload {{{2
"     ちょっとだけVimの設定を変えたとき再起動がめんどい
"     (そういう時に限っていっぱいタブ開いてたりして)
" XXX: 保存しようとするとなんかエラーが出る
command! Reload
    \ call s:Reload()

func! s:Reload()
    comclear
    abclear
    mapclear
    mapclear!

    for rc in ['.vimrc', '.gvimrc']
        if filereadable($HOME . '/' . rc)
            silent! execute 'source ' . $HOME . '/' . rc
        endif
    endfor
    silent! runtime! plugin/*.vim
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

func s:Dir( ... )
    let dir =   a:0 == 1 ? a:1 : '.'

    if !isdirectory( dir )
        echohl WarningMsg
        echo   dir .': No such a directory...'
        echohl None
        return
    endif

    if has( 'win32' )
        if dir =~ '[&()\[\]{}\^=;!+,`~ '. "']" && dir !~ '^".*"$'
            let dir = '"'. dir .'"'
        endif
        let dir = substitute( dir, '/', '\', 'g' )
        call system( 'explorer '. dir )
    else
        let dir = shellescape( dir )
        call system( 'gnome-open '. dir )
    endif

endfunc
" }}}2

" 環境によって動作が異なるコマンド {{{2
if has( 'gui_running' ) && has( 'win32' )
    command! GoDesktop   execute 'lcd C:' . $HOMEPATH . '\デスクトップ'
    command! SH          !start cmd.exe
else
    command! GoDesktop   lcd '~/Desktop'
endif

func s:DosEscape( str )
    return escape( a:str, "&()[]{}^=;!'+,`~ " )
endfunc
" }}}2

" s:Warn() {{{2
func! s:Warn( msg )
    echohl WarningMsg
    echo a:msg
    echohl None
endfunc
" }}}2

" s:ListAndExecute() {{{2
"
" TODO:
"     <C-a> or <C-x>(それか<Tab> or <S-Tab>)で
"     選択肢をインクリメント / デクリメント
" TODO:
"     Migemo対応
func! s:ListAndExecute( lis, template )

    " テンプレートのリスト(番号)を表示
    let i = 0
    let num_len = len( a:lis ) / 10 + 1
    while i < len( a:lis )
        echo printf( '%' . num_len . 'd: ' . a:lis[i], i + 1 )
        let i = i + 1
    endwhile

    " プロンプト
    while 1
        echo "\nPut the number:"
        let num = 0
        let continue_again = 0

        try

            " 候補があるあいだ
            while 1
                let tmp = s:GetNum()
                if tmp == -1
                    if num == 0
                        return ''
                    else
                        break
                    endif
                elseif tmp == 0 && num == 0
                    call s:Warn( 'out of id number. Try again.' )
                    let continue_again = 1
                    break
                endif

                let num = num * 10 + tmp
                if len( a:lis ) / ( num * 10 ) == 0
                    break
                endif

                " 絞り込まれた候補を表示
                call s:ListWithNumber( a:lis, num )
                " 取得した文字表示
                echon "\n:" . num

            endwhile

            if continue_again | continue | endif



            if string( num ) == ''
                return ''
            elseif string( num ) =~ '^\d\+$'
                " 数字の場合
                "

                if num < 1 || len( a:lis ) < num
                    " 範囲外
                    call s:Warn( 'out of num number. Try again.' )
                    continue
                endif

                " OK if reach here
                break
            else
                call s:Warn( 'non-digit characters found. Try again.' )
                continue
            endif
        catch /^escape/
            " ESCキーが押された
            return ''
        endtry
    endwhile

    exe substitute( a:template, '%embed%', a:lis[num - 1], 'g' )
    redraw

    return a:lis[num - 1]
endfunc
" }}}2

" s:GetNum() {{{2
func! s:GetNum()
    let char = getchar()
    if char == char2nr( "\<ESC>" )
        throw 'escape!'
    elseif char == char2nr( "\<CR>" )
        return -1
    endif
    return char - 48
endfunc
" }}}2

" s:ListWithNumber( list ) {{{2
"     テンプレートのリスト(番号)を表示
func! s:ListWithNumber( templ_list, id )
    let num_len = len( a:templ_list ) / 10 + 1
    let i       = 0

    if a:id != -1
        echo printf( '%' . num_len . 'd: ' . a:templ_list[a:id - 1], a:id )
    endif

    while i < len( a:templ_list )
        if a:id == -1 || i + 1 >= a:id * 10
            echo printf( '%' . num_len . 'd: ' . a:templ_list[i], i + 1 )
        endif
        let i = i + 1
    endwhile
endfunc
" }}}2

" MsSleep {{{2
command! -nargs=1 MsSleep
    \ call s:MsSleep( <f-args> )

func! s:MsSleep( ms )
    if has( 'win32' )
        echo "good night..."
        call libcallnr( 'kernel32.dll', 'Sleep', string( a:ms ) )
        echo "good morning!"
    else
        echohl WarningMsg
        echo "Not available yet."
        echohl None
    endif
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
command! FastEdit
    \ call s:FastEdit() 

let s:fast_editing = 0
func s:FastEdit()
    call garbagecollect()

    if s:fast_editing
        " autocomplpop
        if exists( ':AutoComplPopUnLock' )
            AutoComplPopUnLock
        endif
        " let &statusline = g:toggle_statusline[1]

        " ファイルタイプ(カラーとかインデントとか)
        filetype on
        filetype plugin indent on

        echo 'slow but high ability.'
    else
        " autocomplpop
        if exists( ':AutoComplPopLock' )
            AutoComplPopLock
        endif
        " let &statusline = g:toggle_statusline[0]

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

    for f in map(copy(a:000), 'expand(v:val)')
        if filereadable(f)
            call delete(f)
        else
            call s:Warn(f . ": No such a file")
        endif

        if filereadable(f)
            call s:Warn(printf("Can't delete '%s'", f))
        elseif f ==# expand('%')
            " 現在開いているファイルを削除する場合現在のバッファを削除する
            bwipeout
        endif
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
    let result = s:ListAndExecute( [ 'dos', 'unix', 'mac' ],
                \ 'set ff=%embed%' )
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
    autocmd BufNewFile,BufReadPre *.pl
                \ setlocal ft=perl
    autocmd BufNewFile,BufReadPre *.ps1
                \ setlocal ft=powershell
    autocmd BufNewFile,BufReadPre *.py
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
    " }}}3

augroup END
" }}}2

" 全角スペースを視覚化
" highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
" match ZenkakuSpace /　/

func! s:SetDict(...)
    execute "setlocal dict="
        \ . join(map(copy(a:000), '"$HOME/.vim/dict/" . v:val . ".dict"'), ',')
endfunc

" s:LoadWhenFileType() {{{2
func! s:LoadWhenFileType()

    " 辞書ファイル
    call s:SetDict(&filetype)
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
            call s:SetDict('c')
        elseif &filetype == 'cpp'
            call s:SetDict('c', 'cpp')
        endif

    elseif &filetype == 'cs'
        TabChange 4
        compiler cs

    elseif &filetype == 'css'
        TabChange 2

    elseif &filetype == 'html' || &filetype == 'javascript' || &filetype == 'css'
        TabChange 2
        call s:SetDict('html', 'javascript', 'css')

    elseif &filetype == 'java'
        TabChange 4
        " for javadoc
        setlocal iskeyword+=@-@
        compiler javac
        setlocal makeprg=javac\ %

    elseif &filetype == 'scala'
        TabChange 4
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
        " モジュールをサーチしない(はず)
        setlocal path=
        setlocal makeprg=perl\ -c\ %

    elseif &filetype == 'yaml'
        TabChange 2

    else
        TabChange 4
    endif

endfunc
" }}}2

func! s:LoadWhenBufNewFile()
endfunc

" }}}1
"-----------------------------------------------------------------
" For Lisp(Scheme,Gauche) {{{1


" Schemeでもないかなコレ
let g:lisp_rainbow = 1

command! LispSetup            call s:LispSetup()

" s:EvalItNormal() {{{2
func! s:EvalItNormal()
    " カーソル下の１文字をyank
    norm "zyl
    " 閉じ括弧じゃなかったらそれ以前の括弧を探す
    if @z != ')' || @z != '('
        call search( '(\|)', 'Wb' )
    endif
    " 選択
    norm v%
    " eval
    call s:EvalItVisual()
endfunc
" }}}2

" s:EvalItVisual() {{{2
func! s:EvalItVisual() range
    norm "zy

    let lines = ['(print', @z, ')']

    call writefile( lines, $HOME . '/.vimgosh.temp' )
    echo system( 'gosh "' . $HOME . '/.vimgosh.temp"' )
    call delete( $HOME . '/.vimgosh.temp' )
    exe "norm \<Esc>"

endfunc
" }}}2

" s:LispSetup() {{{2
func! s:LispSetup()
    set lisp
    set nocindent
    nnoremap <silent> <LocalLeader>a        %%i(<Esc>l%a)<Esc>%a
    nnoremap <silent> <LocalLeader>A        %%mz%s]<Esc>`zs[<Esc>
    nnoremap <silent> <LocalLeader>z        %%mz%x`zx
    " <LocalLeader><C-e> でスクリプトの結果表示
    nnoremap <LocalLeader><C-e>
                \ :echo system( "gosh " . escape( expand('%:p:h') . '/' . @%, ' &\' ) )<CR>
    " <LocalLeader>e でリストを評価
    vnoremap <LocalLeader>e       :call <SID>EvalItVisual()<CR>
    nnoremap <LocalLeader>e       :call <SID>EvalItNormal()<CR>

    " Gauche(scheme)
    if @% =~? '\.scm$' || @% ==# '.gaucherc'
        let g:is_gauche = 1
    endif

    set lispwords+=and-let*,begin0,call-with-client-socket,call-with-input-conversion,call-with-input-file
    set lispwords+=call-with-input-process,call-with-input-string,call-with-iterator,call-with-output-conversion,call-with-output-file
    set lispwords+=call-with-output-string,call-with-temporary-file,call-with-values,dolist,dotimes
    set lispwords+=if-match,let*-values,let-args,let-keywords*,let-match
    set lispwords+=let-optionals*,let-syntax,let-values,let/cc,let1
    set lispwords+=letrec-syntax,make,match,match-lambda,match-let
    set lispwords+=match-let*,match-letrec,match-let1,match-define,multiple-value-bind
    set lispwords+=parameterize,parse-options,receive,rxmatch-case,rxmatch-cond
    set lispwords+=rxmatch-if,rxmatch-let,syntax-rules,unless,until
    set lispwords+=when,while,with-builder,with-error-handler,with-error-to-port
    set lispwords+=with-input-conversion,with-input-from-port,with-input-from-process,with-input-from-string,with-iterator
    set lispwords+=with-module,with-output-conversion,with-output-to-port,with-output-to-process,with-output-to-string
    set lispwords+=with-port-locking,with-string-io,with-time-counter,with-signal-handlers 
endfunc
" }}}2
" }}}1
"-----------------------------------------------------------------
" Mappings or Abbreviation {{{1
"
"
" <silent>を付けるのは完結する動作のみ

" ~~ map ~~ {{{2
"
noremap <silent> j          gj
noremap <silent> k          gk

noremap <silent> <LocalLeader><LocalLeader>         <LocalLeader>
noremap <silent> <Leader><Leader>                   <Leader>
noremap <silent> ;;        ;
noremap <silent> ,,        ,

" クリップボードにコピー
noremap <LocalLeader>y     "+y

" }}}2

" ~~ n ~~ {{{2

nnoremap <silent> n     nzz
nnoremap <silent> N     Nzz

nnoremap <silent> *     :call <SID>Srch( 0, '*' )<CR>
nnoremap <silent> #     :call <SID>Srch( 0, '#' )<CR>
nnoremap <silent> g*    :call <SID>Srch( 1, '*' )<CR>
nnoremap <silent> g#    :call <SID>Srch( 1, '#' )<CR>

" XXX
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

" ただ'\C'をつけるだけ
func s:Srch( g, vect )
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

" 現在のバッファを新しいタブで開く
" (2つ以上のバッファがウィンドウ内にない場合はなにもしない)
nnoremap <silent> <LocalLeader>tn         :call <SID>CurrentInNewTab()<CR>
" XXX
func! <SID>CurrentInNewTab()
    if winnr( '$' ) != 1
        let cur_bufnr = bufnr( '%' )
        hide
        tabnew
        exe cur_bufnr . 'buffer'
    endif
endfunc

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
nnoremap <C-n>          gt
nnoremap <C-p>          gT

" 保存ダイアログ
if has( 'gui_running' )
    nnoremap <C-s>      :browse confirm saveas<CR>
endif

" フルスクリーン/ウインドウ
nnoremap <silent> <F11>   :call <SID>ToggleFullScr()<CR>

let s:fullscr = 0
func! <SID>ToggleFullScr()
    if s:fullscr == 0
        Revert
        let s:fullscr = 1
    elseif s:fullscr == 1
        ScreenMode 4
        let s:fullscr = 2
    else
        ScreenMode 7
        let s:fullscr = 0
    endif
endfunc

" メニューバー表示/非表示
nnoremap <silent> <F5>    :call <SID>ToggleMenuBar()<CR>

let s:menu_bar_toggled = 0
func! <SID>ToggleMenuBar()
    if s:menu_bar_toggled == 0
        set guioptions+=m
        let s:menu_bar_toggled = 1
    else
        set guioptions-=m
        let s:menu_bar_toggled = 0
    endif
endfunc

" 先頭が \S の行に飛ぶ
noremap <silent> ]k        m`:call search( '^\S', 'W' )<CR>
noremap <silent> [k        m`:call search( '^\S', 'Wb' )<CR>

" ^i と ^o を逆にする
nnoremap <silent>  <C-i>              <C-o>
nnoremap <silent>  <C-o>              <C-i>

" make
nnoremap <silent>   gm      :make<CR>
nnoremap <silent>   gc      :cclose<CR>

nnoremap <silent> <C-w><C-t>    :tabedit<CR>


func! s:NarrowWidely()
    %foldclose
    silent! %foldclose!
    normal zvzz
endfunc
nnoremap <silent> <LocalLeader>nn   :call <SID>NarrowWidely()<CR>


nnoremap <silent> <LocalLeader>cd   :CdCurrent<CR>

" }}}2

" ~~ o ~~ {{{2
" onoremap うZEEEEEEEEEEEEE
func s:ClearOmap()
    omapclear
    execute 'onoremap '. g:maplocalleader .'y  "*y'
endfunc
call s:ClearOmap()
" }}}2

" -- map! -- {{{2
noremap! <C-f>   <Right>
noremap! <C-b>   <Left>

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

" dicwin
let plugin_dicwin_disable = 1

" cmdex
let plugin_cmdex_disable = 1
" :CdCurrent - Change current directory to current file's one.
command! -nargs=0 CdCurrent lcd %:p:h

" matchit
let b:match_ignorecase = 1

" AutoDate
let g:autodate_format = "%Y-%m-%d"

" FencView
let g:fencview_autodetect = 0

" taglist
if ! executable('ctags')
    let loaded_taglist = 1
endif

" Netrw
let g:netrw_liststyle = 1
let g:netrw_cygwin    = 1

" VimExplorer
nnoremap <silent> <S-F5>    :VE .<CR>

" FuzzyFinder {{{2
nnoremap <silent> <LocalLeader>fb       :FuzzyFinderBuffer<CR>
nnoremap <silent> <LocalLeader>fd       :FuzzyFinderDir<CR>
nnoremap <silent> <LocalLeader>ff       :FuzzyFinderFile<CR>
nnoremap <silent> <LocalLeader>fh       :FuzzyFinderMruFile<CR>

let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Tag':{}, 'TaggedFile':{}}

" let g:FuzzyFinderOptions.Base.migemo_support   = 1    " よくSEGVる
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
" }}}2

" MRU
nnoremap <silent> <C-h>     :MRU<CR>
let MRU_Max_Entries   = 100
let MRU_Add_Menu      = 0
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\c\|\.howm-keys$'

" Align
let Align_xstrlen    = 3       "マルチバイト
let DrChipTopLvlMenu = ""
command! -nargs=0 AlignReset call Align#AlignCtrl( "default" )
cabbrev   al    Align

" Chalice {{{2
"
" プレビュー機能無効
let chalice_preview      = 0
let chalice_startupflags = "bookmark"

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
    set ft=2ch_thread
endfunc
" }}}2

" howm-mode {{{2
let howm_dir = "~/howm"
let howm_instantpreview = 1
let howm_grepprg = ""
let howm_findprg = ""
let howm_mapleader = 'g'

" ~/howm/tags.howmを開く(空白行を含むパスには多分未対応)
func! <SID>OpenHowmTagsFile()
    let howm_tags_file = expand( g:howm_dir ) .'/tags.howm'
    if !filereadable( howm_tags_file )
        echohl WarningMsg
        echo 'Not found howm tags file.'
        echohl None
        return
    endif

    if &modified
        execute 'sp '. howm_tags_file
    else
        execute 'edit '. howm_tags_file
    endif
endfunc

execute 'nnoremap <unique><silent> '.
            \ g:howm_mapleader .',l   :call <SID>OpenHowmTagsFile()<CR>'
" }}}2

" QuickBuf
let qb_hotkey = '<LocalLeader>b'

" changelog
" let changelog_username = ""

" autocomplpop
inoremap <expr> <CR> pumvisible() ? "\<C-Y>\<CR>" : "\<CR>"
let g:AutoComplPop_MappingDriven = 1

" Narrow
nnoremap <silent>   <LocalLeader>na     :Narrow<CR>
nnoremap <silent>   <LocalLeader>nw     :Widen<CR>

" skk {{{2
let skk_jisyo = "~/.skk-jisyo"
let skk_large_jisyo = '~/.vim/skk/SKK-JISYO.L'
let skk_auto_save_jisyo = 1
let skk_show_candidates_count = 3
let skk_use_face = 1
let skk_egg_like_newline = 1
let skk_rom_kana_rules = ""
    \. "a   あ  ア\<NL>"
    \. "bb  っ  ッ  b\<NL>"
    \. "ba  ば  バ\<NL>"
    \. "be  べ  ベ\<NL>"
    \. "bi  び  ビ\<NL>"
    \. "bo  ぼ  ボ\<NL>"
    \. "bu  ぶ  ブ\<NL>"
    \. "bya びゃ    ビャ\<NL>"
    \. "bye びぇ    ビェ\<NL>"
    \. "byi びぃ    ビィ\<NL>"
    \. "byo びょ    ビョ\<NL>"
    \. "byu びゅ    ビュ\<NL>"
    \. "cc  っ  ッ  c\<NL>"
    \. "cha ちゃ    チャ\<NL>"
    \. "che ちぇ    チェ\<NL>"
    \. "chi ち  チ\<NL>"
    \. "cho ちょ    チョ\<NL>"
    \. "chu ちゅ    チュ\<NL>"
    \. "cya ちゃ    チャ\<NL>"
    \. "cye ちぇ    チェ\<NL>"
    \. "cyi ちぃ    チィ\<NL>"
    \. "cyo ちょ    チョ\<NL>"
    \. "cyu ちゅ    チュ\<NL>"
    \. "dd  っ  ッ  d\<NL>"
    \. "da  だ  ダ\<NL>"
    \. "de  で  デ\<NL>"
    \. "dha でゃ    デャ\<NL>"
    \. "dhe でぇ    デェ\<NL>"
    \. "dhi でぃ    ディ\<NL>"
    \. "dho でょ    デョ\<NL>"
    \. "dhu でゅ    デュ\<NL>"
    \. "di  ぢ  ヂ\<NL>"
    \. "do  ど  ド\<NL>"
    \. "du  づ  ヅ\<NL>"
    \. "dya ぢゃ    ヂャ\<NL>"
    \. "dye ぢぇ    ヂェ\<NL>"
    \. "dyi ぢぃ    ヂィ\<NL>"
    \. "dyo ぢょ    ヂョ\<NL>"
    \. "dyu ぢゅ    ヂュ\<NL>"
    \. "e   え  エ\<NL>"
    \. "ff  っ  ッ  f\<NL>"
    \. "fa  ふぁ    ファ\<NL>"
    \. "fe  ふぇ    フェ\<NL>"
    \. "fi  ふぃ    フィ\<NL>"
    \. "fo  ふぉ    フォ\<NL>"
    \. "fu  ふ  フ\<NL>"
    \. "fya ふゃ    フャ\<NL>"
    \. "fye ふぇ    フェ\<NL>"
    \. "fyi ふぃ    フィ\<NL>"
    \. "fyo ふょ    フョ\<NL>"
    \. "fyu ふゅ    フュ\<NL>"
    \. "gg  っ  ッ  g\<NL>"
    \. "ga  が  ガ\<NL>"
    \. "ge  げ  ゲ\<NL>"
    \. "gi  ぎ  ギ\<NL>"
    \. "go  ご  ゴ\<NL>"
    \. "gu  ぐ  グ\<NL>"
    \. "gya ぎゃ    ギャ\<NL>"
    \. "gye ぎぇ    ギェ\<NL>"
    \. "gyi ぎぃ    ギィ\<NL>"
    \. "gyo ぎょ    ギョ\<NL>"
    \. "gyu ぎゅ    ギュ\<NL>"
    \. "ha  は  ハ\<NL>"
    \. "he  へ  ヘ\<NL>"
    \. "hi  ひ  ヒ\<NL>"
    \. "ho  ほ  ホ\<NL>"
    \. "hu  ふ  フ\<NL>"
    \. "hya ひゃ    ヒャ\<NL>"
    \. "hye ひぇ    ヒェ\<NL>"
    \. "hyi ひぃ    ヒィ\<NL>"
    \. "hyo ひょ    ヒョ\<NL>"
    \. "hyu ひゅ    ヒュ\<NL>"
    \. "i   い  イ\<NL>"
    \. "jj  っ  ッ  j\<NL>"
    \. "ja  じゃ    ジャ\<NL>"
    \. "je  じぇ    ジェ\<NL>"
    \. "ji  じ  ジ\<NL>"
    \. "jo  じょ    ジョ\<NL>"
    \. "ju  じゅ    ジュ\<NL>"
    \. "jya じゃ    ジャ\<NL>"
    \. "jye じぇ    ジェ\<NL>"
    \. "jyi じぃ    ジィ\<NL>"
    \. "jyo じょ    ジョ\<NL>"
    \. "jyu じゅ    ジュ\<NL>"
    \. "kk  っ  ッ  k\<NL>"
    \. "ka  か  カ\<NL>"
    \. "ke  け  ケ\<NL>"
    \. "ki  き  キ\<NL>"
    \. "ko  こ  コ\<NL>"
    \. "ku  く  ク\<NL>"
    \. "kya きゃ    キャ\<NL>"
    \. "kye きぇ    キェ\<NL>"
    \. "kyi きぃ    キィ\<NL>"
    \. "kyo きょ    キョ\<NL>"
    \. "kyu きゅ    キュ\<NL>"
    \. "ma  ま  マ\<NL>"
    \. "me  め  メ\<NL>"
    \. "mi  み  ミ\<NL>"
    \. "mo  も  モ\<NL>"
    \. "mu  む  ム\<NL>"
    \. "mya みゃ    ミャ\<NL>"
    \. "mye みぇ    ミェ\<NL>"
    \. "myi みぃ    ミィ\<NL>"
    \. "myo みょ    ミョ\<NL>"
    \. "myu みゅ    ミュ\<NL>"
    \. "n   ん  ン\<NL>"
    \. "n'  ん  ン\<NL>"
    \. "na  な  ナ\<NL>"
    \. "ne  ね  ネ\<NL>"
    \. "ni  に  ニ\<NL>"
    \. "nn  ん  ン\<NL>"
    \. "no  の  ノ\<NL>"
    \. "nu  ぬ  ヌ\<NL>"
    \. "nya にゃ    ニャ\<NL>"
    \. "nye にぇ    ニェ\<NL>"
    \. "nyi にぃ    ニィ\<NL>"
    \. "nyo にょ    ニョ\<NL>"
    \. "nyu にゅ    ニュ\<NL>"
    \. "o   お  オ\<NL>"
    \. "pp  っ  ッ  p\<NL>"
    \. "pa  ぱ  パ\<NL>"
    \. "pe  ぺ  ペ\<NL>"
    \. "pi  ぴ  ピ\<NL>"
    \. "po  ぽ  ポ\<NL>"
    \. "pu  ぷ  プ\<NL>"
    \. "pya ぴゃ    ピャ\<NL>"
    \. "pye ぴぇ    ピェ\<NL>"
    \. "pyi ぴぃ    ピィ\<NL>"
    \. "pyo ぴょ    ピョ\<NL>"
    \. "pyu ぴゅ    ピュ\<NL>"
    \. "rr  っ  ッ  r\<NL>"
    \. "ra  ら  ラ\<NL>"
    \. "re  れ  レ\<NL>"
    \. "ri  り  リ\<NL>"
    \. "ro  ろ  ロ\<NL>"
    \. "ru  る  ル\<NL>"
    \. "rya りゃ    リャ\<NL>"
    \. "rye りぇ    リェ\<NL>"
    \. "ryi りぃ    リィ\<NL>"
    \. "ryo りょ    リョ\<NL>"
    \. "ryu りゅ    リュ\<NL>"
    \. "ss  っ  ッ  s\<NL>"
    \. "sa  さ  サ\<NL>"
    \. "se  せ  セ\<NL>"
    \. "sha しゃ    シャ\<NL>"
    \. "she しぇ    シェ\<NL>"
    \. "shi し  シ\<NL>"
    \. "sho しょ    ショ\<NL>"
    \. "shu しゅ    シュ\<NL>"
    \. "si  し  シ\<NL>"
    \. "so  そ  ソ\<NL>"
    \. "su  す  ス\<NL>"
    \. "sya しゃ    シャ\<NL>"
    \. "sye しぇ    シェ\<NL>"
    \. "syi しぃ    シィ\<NL>"
    \. "syo しょ    ショ\<NL>"
    \. "syu しゅ    シュ\<NL>"
    \. "tt  っ  ッ  t\<NL>"
    \. "ta  た  タ\<NL>"
    \. "te  て  テ\<NL>"
    \. "tha てぁ    テァ\<NL>"
    \. "the てぇ    テェ\<NL>"
    \. "thi てぃ    ティ\<NL>"
    \. "tho てょ    テョ\<NL>"
    \. "thu てゅ    テュ\<NL>"
    \. "ti  ち  チ\<NL>"
    \. "to  と  ト\<NL>"
    \. "tsu つ  ツ\<NL>"
    \. "tu  つ  ツ\<NL>"
    \. "tya ちゃ    チャ\<NL>"
    \. "tye ちぇ    チェ\<NL>"
    \. "tyi ちぃ    チィ\<NL>"
    \. "tyo ちょ    チョ\<NL>"
    \. "tyu ちゅ    チュ\<NL>"
    \. "u   う  ウ\<NL>"
    \. "vv  っ  ッ  v\<NL>"
    \. "va  う゛ぁ  ヴァ\<NL>"
    \. "ve  う゛ぇ  ヴェ\<NL>"
    \. "vi  う゛ぃ  ヴィ\<NL>"
    \. "vo  う゛ぉ  ヴォ\<NL>"
    \. "vu  う゛    ヴ\<NL>"
    \. "ww  っ  ッ  w\<NL>"
    \. "wa  わ  ワ\<NL>"
    \. "we  うぇ    ウェ\<NL>"
    \. "wi  うぃ    ウィ\<NL>"
    \. "wo  を  ヲ\<NL>"
    \. "wu  う  ウ\<NL>"
    \. "xx  っ  ッ  x\<NL>"
    \. "xa  ぁ  ァ\<NL>"
    \. "xe  ぇ  ェ\<NL>"
    \. "xi  ぃ  ィ\<NL>"
    \. "xka か  ヵ\<NL>"
    \. "xke け  ヶ\<NL>"
    \. "xo  ぉ  ォ\<NL>"
    \. "xtsu    っ  ッ\<NL>"
    \. "xtu っ  ッ\<NL>"
    \. "xu  ぅ  ゥ\<NL>"
    \. "xwa ゎ  ヮ\<NL>"
    \. "xwe ゑ  ヱ\<NL>"
    \. "xwi ゐ  ヰ\<NL>"
    \. "xya ゃ  ャ\<NL>"
    \. "xyo ょ  ョ\<NL>"
    \. "xyu ゅ  ュ\<NL>"
    \. "yy  っ  ッ  y\<NL>"
    \. "ya  や  ヤ\<NL>"
    \. "ye  いぇ    イェ\<NL>"
    \. "yo  よ  ヨ\<NL>"
    \. "yu  ゆ  ユ\<NL>"
    \. "zz  っ  ッ  z\<NL>"
    \. "z,  ‥\<NL>"
    \. "z-  ～\<NL>"
    \. "z.  …\<NL>"
    \. "z/  ・\<NL>"
    \. "z[  『\<NL>"
    \. "z]  』\<NL>"
    \. "za  ざ  ザ\<NL>"
    \. "ze  ぜ  ゼ\<NL>"
    \. "zh  ←\<NL>"
    \. "zi  じ  ジ\<NL>"
    \. "zj  ↓\<NL>"
    \. "zk  ↑\<NL>"
    \. "zl  →\<NL>"
    \. "zo  ぞ  ゾ\<NL>"
    \. "zu  ず  ズ\<NL>"
    \. "zya じゃ    ジャ\<NL>"
    \. "zye じぇ    ジェ\<NL>"
    \. "zyi じぃ    ジィ\<NL>"
    \. "zyo じょ    ジョ\<NL>"
    \. "zyu じゅ    ジュ\<NL>"
    \. "-   ー\<NL>"
    \. ":   ：\<NL>"
    \. ";   ；\<NL>"
    \. "!   ！\<NL>"
    \. "?   ？\<NL>"
    \. "[   「\<NL>"
    \. "]   」\<NL>"
    \. "z   　\<NL>"
" }}}2

" gtags
nnoremap <silent> g<C-i>    :Gtags -f %<CR>
nnoremap <silent> g<C-j>    :GtagsCursor<CR>
nnoremap <silent> gn    :cn<CR>
nnoremap <silent> gN    :cN<CR>

" xptemplate {{{2
let g:xptemplate_key = '<C-k>'
" }}}2

" ----------- 自分の -----------------------

" DictionarizeBuffer
let g:loaded_dictionarize_buffer = 1

" shell-mode
let loaded_shell_mode = 1

" CommentAnyWay {{{2
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
" }}}2

" nextfile {{{2
let nf_include_dotfiles = 1
let nf_loop_files = 1
" }}}2

let s:vt_filetype_files = [
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
let g:vt_filetype_files = join(s:vt_filetype_files, ',')
unlet s:vt_filetype_files

let s:vt_files_using_template = [
    \ 'csharp.cs',
    \ 'javasrc.java',
    \ 'perl.pl',
    \ 'perlmodule.pm',
    \ 'header.h',
    \ 'scala.scala',
    \ 'vimscript.vim'
\ ]
let g:vt_files_using_template = join(s:vt_files_using_template, ',')
unlet s:vt_files_using_template

" }}}1
"-----------------------------------------------------------------
" その他 {{{1
call setreg( '/', '', '' )
call setreg( '"', '', '' )
" }}}1
"-----------------------------------------------------------------

let &cpo = s:save_cpo
" vim:fdm=marker:fen:
