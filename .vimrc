" vim:set fen fdm=marker:
scriptencoding utf-8
set cpo&vim

syntax enable
filetype plugin indent on

let mapleader = ';'
let maplocalleader = '\'
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

if has('virtualedit')
    set virtualedit=all
endif

" speed optimization related to fsync...
if has('unix')
    set nofsync
    set swapsync=
endif

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

" &migemo
if has("migemo")
    set migemo
endif

" convert "\\" to "/" on win32 like environment
if exists('+shellslash')
    set shellslash
endif

" &runtimepath
if has("win32")
    set runtimepath+=$HOME/.vim
endif
set runtimepath+=$HOME/.vim/mine

" visual bell
set t_vb=

set t_ti= t_te=

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
" ListChars {{{
command! ListChars
            \ call s:ListAndExecute([
            \       'tab:>-,extends:>,precedes:<,eol:.',
            \       'tab:>-',
            \       'tab:\\ \\ ',
            \   ],
            \   'set listchars=%embed%')
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
" GccSyntaxCheck {{{
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
" Restart {{{
command! Restart    call s:restart()
func! s:restart()
    if !has('gui_running')
        call s:warn("can't restart vim, not gvim.")
        return;
    endif

    try
        bmodified
        call s:warn("modified buffer(s) exist!")
        return
    catch
        " nop.
    endtry

    call s:system('gvim')
    qall
endfunc
" }}}
" CdCurrent {{{
"   Change current directory to current file's one.
command! -nargs=0 CdCurrent lcd %:p:h
nnoremap <silent> <Leader>cd   :CdCurrent<CR>
" }}}
" }}}
"-----------------------------------------------------------------
" Encoding {{{
set fencs-=iso-2022-jp-3
set fencs+=iso-2022-jp,iso-2022-jp-3
let &fencs = 'utf-8,' . &fencs
" set enc=... {{{
func! <SID>ChangeEncoding()
    if expand( '%' ) == ''
        echo "current file is empty."
        return
    endif
    let enc = s:ListAndExecute([
                \ 'cp932',
                \ 'shift-jis',
                \ 'iso-2022-jp',
                \ 'euc-jp',
                \ 'utf-8',
                \ 'ucs-bom'
                \ ], 'edit ++enc=%embed%')
    if enc != ''
        echo "Change the encoding to " . enc
    endif
endfunc
nnoremap <silent> <F2>    :call <SID>ChangeEncoding()<CR>
" }}}
" set fenc=... {{{
func! <SID>ChangeFileEncoding()
    let enc = s:ListAndExecute([
                \ 'cp932',
                \ 'shift-jis',
                \ 'iso-2022-jp',
                \ 'euc-jp',
                \ 'utf-8',
                \ 'ucs-bom'
                \ ], 'set fenc=%embed%')
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
    autocmd VimEnter * set bg=dark | colorscheme desert

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
    autocmd BufNewFile,BufReadPre *.h
                \ setlocal ft=c.cpp
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
        echomsg "DON'T load my filetype config"
    else
        let s:load_filetype = 1
        echomsg "load my filetype config"
    endif
endfunc
" }}}
" s:SetDict {{{
func! s:SetDict(ft)
    if !exists('s:filetype_vs_dictionary')
        let s:filetype_vs_dictionary = {
        \   'c': ['c', 'cpp'],
        \   'cpp': ['c', 'cpp'],
        \   'html': ['html', 'css', 'javascript'],
        \   'scala': ['scala', 'java'],
        \ }
    endif
    let ftypes = has_key(s:filetype_vs_dictionary, a:ft) ?
                \   s:filetype_vs_dictionary[a:ft]
                \   : [a:ft]
    for ft in ftypes
        let dict_path = expand(printf('$HOME/.vim/dict/%s.dict', ft))
        if filereadable(dict_path)
            execute 'setlocal dictionary+=' . dict_path
        endif
    endfor
endfunc
" }}}
" s:SetTabWidth {{{
func! s:SetTabWidth(ft)
    if !exists('s:filetype_vs_tabwidth')
        let s:filetype_vs_tabwidth = {
        \   'css': 2,
        \   'xml': 2,
        \   'lisp': 2,
        \   'scheme': 2,
        \   'yaml': 2,
        \ }
    endif
    execute 'TabChange'
            \ has_key(s:filetype_vs_tabwidth, a:ft) ?
            \   s:filetype_vs_tabwidth[a:ft]
            \   : 4
endfunc
" }}}
" s:SetCompiler {{{
func! s:SetCompiler(ft)
    if !exists('s:filetype_vs_compiler')
        let s:filetype_vs_compiler = {
        \   'c': 'gcc',
        \   'cpp': 'gcc',
        \   'html': 'tidy',
        \   'java': 'javac',
        \}
    endif
    try
        execute 'compiler'
                \ has_key(s:filetype_vs_compiler, a:ft) ?
                \   s:filetype_vs_compiler[a:ft]
                \   : a:ft
    catch
        " to supress warnings
    endtry
endfunc
" }}}
" TODO Move these settings to ~/.vim/ftplugin/*
" s:LoadWhenFileType() {{{
func! s:LoadWhenFileType()
    if ! s:load_filetype
        " call s:warn("skip loading filetype config...")
        return
    endif

    " Set default &omnifunc
    if exists("+omnifunc") && &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
    endif
    " Set dictionary for reserved keywords, etc.
    call s:SetDict(&filetype)
    " Set tab width
    call s:SetTabWidth(&filetype)
    " Set compiler
    call s:SetCompiler(&filetype)

    " Misc.
    if &filetype == 'xml' || &filetype == 'html'
        inoremap <buffer>   </    </<C-x><C-o>
    elseif &filetype == 'vimperator'
        setl comments=f:\"
    endif
endfunc
" }}}
" }}}
"-----------------------------------------------------------------
" Mappings and/or Abbreviations {{{
" map {{{
" operator {{{
" paste to clipboard
noremap <Leader>y     "+y
" }}}
" motion/textobj {{{
noremap <silent> j          gj
noremap <silent> k          gk

noremap <silent> H  5h
noremap <silent> L  5l

noremap <silent> ]k        :call search('^\S', 'Ws')<CR>
noremap <silent> [k        :call search('^\S', 'Wsb')<CR>
" }}}
" misc. {{{
noremap <silent> <Space>j           <C-f>
noremap <silent> <Space>k           <C-b>
noremap <silent> <Space><Space>     <Space>
" }}}
" }}}
" nmap {{{
nnoremap <silent> <LocalLeader><LocalLeader>         <LocalLeader>
nnoremap <silent> <Leader><Leader>                   <Leader>

nnoremap <silent> n     nzz
nnoremap <silent> N     Nzz

" add '\C' to the pattern
" FIXME behave like option 'c' included...
for [s:pat, s:flags] in [['*', 's'], ['#', 'bs'], ['g*', 's'], ['g#', 'bs']]
    execute printf("nnoremap <silent> %s :call <SID>dont_ignore_case(%s, %s)<CR>", s:pat, string(s:pat), string(s:flags))
endfor
nnoremap <silent> ;*    :call <SID>dont_ignore_case('*', 's')<CR>:vimgrep /<C-r>// %<CR>

func! s:dont_ignore_case(cmd, flags)
    let pos = getpos('.')
    execute 'normal! ' . a:cmd
    let @/ .= '\C'
    call setpos('.', pos)

    call search(@/, a:flags)
    call feedkeys(":set hls\<CR>", 'n')
endfunc

" fix up all indents
nnoremap <silent> <Space>=    mqgg=G`qzz<CR>

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
" nnoremap ,*+    :let @+ = @*<CR>:echo printf('[%s]', @+)<CR>
" @+ -> @*
" nnoremap ,+*    :let @* = @+<CR>:echo printf('[%s]', @*)<CR>

nnoremap ZZ <Nop>
" }}}
" map! {{{
noremap! <C-f>   <Right>
noremap! <C-b>   <Left>
noremap! <C-a>   <Home>
noremap! <C-e>   <End>
noremap! <C-d>   <Del>
noremap! <C-k>   <C-o>D

noremap! <C-h><C-f>         ()<Left>
noremap! <C-h><C-d>         []<Left>
noremap! <C-h><C-s>         <><Left>
noremap! <C-h><C-a>         {}<Left>
noremap! <C-h>f         \(\)<Left><Left>
noremap! <C-h>d         \[\]<Left><Left>
noremap! <C-h>s         \<\><Left><Left>
noremap! <C-h>a         \{\}<Left><Left>

noremap! <C-h><C-h>         「」<Left>
noremap! <C-h><C-j>         『』<Left>
noremap! <C-h><C-k>         【】<Left>

noremap! <C-r><C-o>  <C-r><C-p>"
noremap! <C-r><C-r>  <C-r><C-p>+
" }}}
" imap {{{
inoremap <C-h>o         <C-o>O
inoremap <C-h><C-o>     <C-o>o

" delete characters in parenthesis
inoremap <C-z>                <C-o>di(

" omni
" inoremap <C-n>     <C-x><C-n>
" inoremap <C-p>     <C-x><C-p>
" }}}
" cmap {{{
if &wildmenu
    cnoremap <C-f> <Space><BS><Right>
    cnoremap <C-b> <Space><BS><Left>
endif
" }}}
" abbr {{{
iabbrev <expr> date@      strftime("%Y-%m-%d")
iabbrev <expr> time@      strftime("%H:%M")
iabbrev <expr> datetime@  strftime("%Y-%m-%d %H:%M")
iabbrev <expr> w3cdtf@    strftime("%Y-%m-%dT%H:%M:%S+09:00")


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

nmap go      <Leader>co
nmap gO      <Leader>cO
" }}}
" nextfile {{{
let g:nf_map_next = ',n'
let g:nf_map_previous = ',p'
let g:nf_include_dotfiles = 1    " don't skip dotfiles
let g:nf_loop_files = 1    " loop at the end of file
let g:nf_ignore_ext = ['o']    " ignore object file
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
let g:wm_move_down  = '<C-M-j>'
let g:wm_move_up    = '<C-M-k>'
let g:wm_move_left  = '<C-M-h>'
let g:wm_move_right = '<C-M-l>'
" }}}
" sign-diff {{{
"
" 現在未使用...
" (作ってから自分はどっちかと言うと
" ウィンドウにあまり情報を出したくない派なので要らないなと気付いた)
let g:SD_disable = 1

" let g:SD_debug = 1
" nnoremap <silent> <C-l>     :SDUpdate<CR><C-l>
" }}}
" DumbBuf {{{
let dumbbuf_hotkey = '<Leader>b'
" たまにQuickBuf.vimの名残で<Esc>を押してしまう
let dumbbuf_mappings = {
    \'n': {
        \'<Esc>': {'alias_to': 'q'},
    \}
\}
let dumbbuf_single_key  = 1
let dumbbuf_updatetime  = 1    " mininum value of updatetime.
let dumbbuf_wrap_cursor = 0
let dumbbuf_remove_marked_when_close = 1
let dumbbuf_shown_type = 'project'


" let dumbbuf_cursor_pos = 'keep'

" For (compatibility) test
"
" let dumbbuf_shown_type = 'foobar'
" let dumbbuf_listed_buffer_name = "*foo bar*"
" let g:dumbbuf_close_when_exec = 1
"
" let dumbbuf_verbose = 1
" }}}
" }}}
" others {{{
" AutoDate {{{
let g:autodate_format = "%Y-%m-%d"
" }}}
" FuzzyFinder {{{
nnoremap <silent> <Leader>fd        :FufRenewCache<CR>:FufDir<CR>
nnoremap <silent> <Leader>ff        :FufRenewCache<CR>:FufFile<CR>
nnoremap <silent> <Leader>fh        :FufRenewCache<CR>:FufMruFile<CR>

let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']

let fuf_keyOpenTabpage = '<C-CR>'
let fuf_keyNextMode    = '<C-l>'
let fuf_keyPrevMode    = '<C-h>'
let fuf_keyOpenSplit   = '<C-s>'
let fuf_keyOpenVsplit  = '<C-v>'

" abbrev {{{
let fuf_abbrevMap = {
    \ '^plug@': ['~/.vim/plugin/', '~/.vim/plugin/', '~/.vim/mine/plugin/'],
    \ '^home@': ['~/'],
    \ '^memo@' : ['~/work/memo'],
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
" MRU {{{
nnoremap <silent> <C-h>     :MRU<CR>
let MRU_Max_Entries   = 500
let MRU_Add_Menu      = 0
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\c\'
" }}}
" Align {{{
let Align_xstrlen    = 3       " multibyte
let DrChipTopLvlMenu = ""
command! -nargs=0 AlignReset call Align#AlignCtrl("default")
cabbrev   al    Align
" }}}
" changelog {{{
let changelog_username = "tyru"
" }}}
" Gtags {{{
func! s:JumpTags()
    if expand('%') == '' | return | endif

    if !exists(':GtagsCursor')
        echo "gtags.vim is not installed. do default <C-]>..."
        sleep 2
        " unmap this function.
        " use plain <C-]> next time.
        nunmap <C-]>
        execute "normal! \<C-]>"
        return
    endif

    let gtags = expand('%:h') . '/GTAGS'
    if filereadable(gtags)
        " use gtags if found GTAGS.
        lcd %:p:h
        GtagsCursor
        lcd -
    else
        " or use ctags.
        execute "normal! \<C-]>"
    endif
endfunc

nnoremap <silent> g<C-i>    :Gtags -f %<CR>
nnoremap <silent> <C-]>     :call <SID>JumpTags()<CR>
" }}}
" xptemplate {{{
let xptemplate_key = '<C-t>'
" }}}
" operator-replace {{{
map <Leader>r  <Plug>(operator-replace)
" }}}
" git {{{
let g:git_no_map_default = 1
let g:git_command_edit = 'rightbelow vnew'
" let g:git_bufhidden = 'wipe'
nnoremap <Leader>gd :<C-u>GitDiff<Enter>
nnoremap <Leader>gD :<C-u>GitDiff --cached<Enter>
nnoremap <Leader>gs :<C-u>GitStatus<Enter>
nnoremap <Leader>gl :<C-u>GitLog<Enter>
nnoremap <Leader>gL :<C-u>GitLog -p<Enter>
" nnoremap <Leader>ga :<C-u>GitAdd<Enter>
" nnoremap <Leader>gA :<C-u>GitAdd <cfile><Enter>
" nnoremap <Leader>gc :<C-u>GitCommit<Enter>
" nnoremap <Leader>gC :<C-u>GitCommit --amend<Enter>
" nnoremap <Leader>gp :<C-u>Git push
" }}}
" EasyGrep {{{
let EasyGrepFileAssociations = expand("$HOME/.vim/EasyGrepFileAssociations")
let EasyGrepMode = 2
let EasyGrepInvertWholeWord = 1
let EasyGrepRecursive = 1
let EasyGrepIgnoreCase = 0
" }}}
" quickrun {{{
nmap ,r <Plug>(quickrun)
map  ,R <Plug>(quickrun-op)
" }}}
" }}}
" }}}
"-----------------------------------------------------------------
