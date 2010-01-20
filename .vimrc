" vim:set fen fdm=marker:
scriptencoding utf-8
set cpo&vim


syntax enable
filetype plugin indent on


let mapleader = ';'
let maplocalleader = '\'


" Util Functions/Commands {{{
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
" s:glob
func! s:glob(expr)
    return split(glob(a:expr), "\n")
endfunc
" }}}


" Buffer local commands {{{
" Buffer local commands are useful to manage to make .vimrc reloadable.

" s:runtimepath {{{
let s:runtimepath = {}

func! s:runtimepath.init() dict
    let self.runtimepath = {}
    let self.counter = 0
    let self.updated = 0
    " Set current &runtimepath.
    for p in map(split(&runtimepath, ','), 'expand(v:val)')
        if !has_key(self.runtimepath, p)
            let self.runtimepath[p] = self.counter
            let self.counter += 1
        endif
    endfor
endfunc

func! s:runtimepath.add(...) dict
    for p in map(copy(a:000), 'expand(v:val)')
        if !has_key(self.runtimepath, p)
            let self.runtimepath[p] = self.counter
            let self.counter += 1
            let self.updated = 1
        endif
    endfor
endfunc

func! s:runtimepath.get() dict
    return sort(keys(self.runtimepath), 's:_sort_runtimepath')
endfunc
func! s:_sort_runtimepath(s1, s2)
    let p = s:runtimepath.runtimepath
    if p[a:s1] ==# p[a:s2]
        return 0
    elseif p[a:s1] > p[a:s2]
        return 1
    else
        return -1
    endif
endfunc

func! s:runtimepath.update() dict
    if !self.updated | return | endif

    let runtimepath_list = self.get()
    " let runtimepath_list = filter(runtimepath_list, 'isdirectory(v:val)')
    let &runtimepath = join(runtimepath_list, ',')

    call self.init()
endfunc


call s:runtimepath.init()


command! -buffer -nargs=+ AddRuntimePath call s:runtimepath.add(<f-args>)
command! -buffer          UpdateRuntimePath call s:runtimepath.update()
" }}}
" s:lazy_autocmd {{{
let s:lazy_autocmd = {}

func! s:lazy_autocmd.init() dict
    let self.autocmd_list = []
    let self.autocmd_delete_list = []
endfunc

func! s:lazy_autocmd.register(arg) dict
    call add(self.autocmd_list, a:arg)
endfunc

func! s:lazy_autocmd.delete(arg) dict
    call add(self.autocmd_delete_list, a:arg)
endfunc

func! s:lazy_autocmd.execute() dict
    augroup MyVimrc
        autocmd!

        for i in self.autocmd_list
            execute 'autocmd' i
        endfor

        for i in self.autocmd_delete_list
            execute 'autocmd!' i
        endfor
    augroup END

    call self.init()
endfunc


call s:lazy_autocmd.init()


command! -buffer -nargs=* AutoCommand call s:lazy_autocmd.register(<q-args>)
command! -buffer          ExecuteAutoCommand call s:lazy_autocmd.execute()
" }}}
" }}}

" &runtimepath {{{
if has("win32")
    AddRuntimePath $HOME/.vim
endif
AddRuntimePath $HOME/.vim/mine

for s:rtp in s:glob('$HOME/.vim/+vcs/*')
    call s:runtimepath.add(s:rtp)
endfor
unlet s:rtp
" }}}

" autocmd {{{
func! s:vimenter_handler()
    " Color
    set bg=dark
    colorscheme desert
endfunc

" colorscheme (on windows, setting colorscheme in .vimrc does not work)
AutoCommand VimEnter * call s:vimenter_handler()

" open on read-only if swap exists
AutoCommand SwapExists * let v:swapchoice = 'o'

" autocmd CursorHold,CursorHoldI *   silent! update
AutoCommand QuickfixCmdPost make,grep,grepadd,vimgrep,helpgrep   copen

" sometimes &modeline becomes false
AutoCommand BufReadPre *    setlocal modeline

" filetype {{{
AutoCommand BufNewFile,BufReadPre *.as
            \ setlocal ft=actionscript syntax=actionscript
AutoCommand BufNewFile,BufReadPre *.c
            \ setlocal ft=c
AutoCommand BufNewFile,BufReadPre *.cpp
            \ setlocal ft=cpp
AutoCommand BufNewFile,BufReadPre *.h
            \ setlocal ft=c.cpp
AutoCommand BufNewFile,BufReadPre *.cs
            \ setlocal ft=cs
AutoCommand BufNewFile,BufReadPre *.java
            \ setlocal ft=java
AutoCommand BufNewFile,BufReadPre *.js
            \ setlocal ft=javascript
AutoCommand BufNewFile,BufReadPre *.pl,*.pm
            \ setlocal ft=perl
AutoCommand BufNewFile,BufReadPre *.ps1
            \ setlocal ft=powershell
AutoCommand BufNewFile,BufReadPre *.py,*.pyc
            \ setlocal ft=python
AutoCommand BufNewFile,BufReadPre *.rb
            \ setlocal ft=ruby
AutoCommand BufNewFile,BufReadPre *.scm
            \ setlocal ft=scheme
AutoCommand BufNewFile,BufReadPre _vimperatorrc,.vimperatorrc
            \ setlocal ft=vimperator syntax=vimperator
AutoCommand BufNewFile,BufReadPre *.scala
            \ setlocal ft=scala
AutoCommand BufNewFile,BufReadPre *.lua
            \ setlocal ft=lua
AutoCommand BufNewFile,BufReadPre *.avs
            \ setlocal syntax=avs
AutoCommand BufNewFile,BufReadPre *.tmpl
            \ setlocal ft=html
AutoCommand BufNewFile,BufReadPre *.mkd
            \ setlocal ft=mkd
AutoCommand BufNewFile,BufReadPre *.md
            \ setlocal ft=mkd

" delete autocmd for ft=mkd.
" TODO -bang for s:lazy_autocmd.delete().
" AutoCommand! filetypedetect BufNewFile,BufRead *.md
" }}}
" }}}


" arpeggio {{{
" arpeggio's function should be Vim built-in :p
let g:arpeggio_timeoutlen = 70
call arpeggio#load()
" }}}


" Encoding {{{
set fencs-=iso-2022-jp-3
set fencs-=utf-8
set fencs+=iso-2022-jp,iso-2022-jp-3
let &fencs = 'utf-8,' . &fencs

" set enc=... {{{
func! ChangeEncoding()
    if expand( '%' ) == ''
        call s:warn("current file is empty.")
        return
    endif
    let result =
                \ prompt#prompt("re-open with...", {
                \   'menu': [
                \     'cp932',
                \     'shift-jis',
                \     'iso-2022-jp',
                \     'euc-jp',
                \     'utf-8',
                \     'ucs-bom'
                \   ],
                \   'escape': 1,
                \   'one_char': 1,
                \   'execute': 'edit ++enc=%s'})
    if result !=# "\e"
        echomsg printf("re-open with '%s'.", result)
    endif
endfunc

silent Arpeggio nnoremap <silent> <Leader>1    :call ChangeEncoding()<CR>
" }}}
" set fenc=... {{{
func! ChangeFileEncoding()
    let enc = prompt#prompt("changing file encoding to...", {
                \ 'menu': [
                \ 'cp932',
                \ 'shift-jis',
                \ 'iso-2022-jp',
                \ 'euc-jp',
                \ 'utf-8',
                \ 'ucs-bom'
                \ ],
                \ 'escape': 1,
                \ 'one_char': 1,
                \ 'execute': 'set fenc=%s'})
    if enc ==# "\e"
        return
    endif
    if enc == 'ucs-bom'
        set bomb
    else
        set nobomb
    endif
    echomsg printf("changing file encoding to '%s'.", enc)
endfunc

silent Arpeggio nnoremap <silent> <Leader>2    :call ChangeFileEncoding()<CR>
" }}}
" set ff=... {{{
func! ChangeNL()
    let result = prompt#prompt("changing newline format to...", {
                \ 'menu': ['dos', 'unix', 'mac'],
                \ 'one_char': 1,
                \ 'escape': 1,
                \ 'execute': 'set ff=%s'})
    if result !=# "\e"
        echomsg printf("changing newline format to '%s'.", result)
    endif
endfunc

silent Arpeggio nnoremap <silent> <Leader>3    :call ChangeNL()<CR>
" }}}
" }}}

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
        \   'html': 2,
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

" do what ~/.vim/ftplugin/* does in .vimrc
" because of my laziness :p
AutoCommand FileType *   call s:LoadWhenFileType()
" }}}
" }}}


" Options {{{

" TODO
" command -buffer -nargs=* Set
"             \   set <q-args>

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

" visual bell
set visualbell
set t_vb=

set t_ti= t_te=

" }}}

" Mappings and/or Abbreviations {{{
" map {{{
" operator {{{
" paste to clipboard
noremap <Leader>y     "+y
noremap <Leader>Y     "*y

" do not destroy noname register.
noremap x   "_x
noremap <Leader>d   "_d
" }}}
" motion/textobj {{{
noremap <silent> j          gj
noremap <silent> k          gk
noremap <silent> gj         j
noremap <silent> gk         k

noremap <silent> H  w
noremap <silent> L  b

noremap <silent> ]k        :call search('^\S', 'Ws')<CR>
noremap <silent> [k        :call search('^\S', 'Wsb')<CR>
" }}}
" misc. {{{
noremap <silent> <Space>j           <C-f>
noremap <silent> <Space>k           <C-b>
noremap <silent> <Space><Space>     <Space>

Arpeggio noremap A(    %i)<Esc>%i(
Arpeggio noremap A[    %i]<Esc>%i[
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
nnoremap <silent> g$            :tablast<CR>
nnoremap <silent> g0            :tabfirst<CR>

" make
nnoremap <silent>   gm      :make<CR>
nnoremap <silent>   gc      :cclose<CR>

" open only current line's fold.
func! s:fold_all_expand()
    silent! %foldclose!
    normal! zvzz
endfunc
nnoremap z<Space>   :call <SID>fold_all_expand()<CR>

" hlsearch
nnoremap gh    :set hlsearch!<CR>

" sync @* and @+
" @* -> @+
" nnoremap ,*+    :let @+ = @*<CR>:echo printf('[%s]', @+)<CR>
" @+ -> @*
" nnoremap ,+*    :let @* = @+<CR>:echo printf('[%s]', @*)<CR>

nnoremap ZZ <Nop>

nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>q :<C-u>q<CR>

nnoremap <silent> gK    K
" }}}
" map! {{{
noremap! <C-f>   <Right>
noremap! <C-b>   <Left>
noremap! <C-a>   <Home>
noremap! <C-e>   <End>
noremap! <C-d>   <Del>
noremap! <C-g><C-i>  <Insert>

Arpeggio noremap! $( ()<Left>
Arpeggio noremap! 4[ []<Left>
Arpeggio noremap! $< <><Left>
Arpeggio noremap! ${ {}<Left>

Arpeggio noremap! $) \(\)<Left><Left>
Arpeggio noremap! 4] \[\]<Left><Left>
Arpeggio noremap! $> \<\><Left><Left>
Arpeggio noremap! $} \{\}<Left><Left>

Arpeggio noremap! #( 「」<Left>
Arpeggio noremap! 3[ 『』<Left>
Arpeggio noremap! #< 【】<Left>
Arpeggio noremap! #{ 〔〕<Left>
" }}}
" imap {{{
" delete characters in ...
inoremap <C-z>                <C-o>di

" omni
" inoremap <C-n>     <C-x><C-n>
" inoremap <C-p>     <C-x><C-p>

" paste register
inoremap <C-r><C-u>  <C-r><C-p>+
inoremap <C-r><C-i>  <C-r><C-p>*
inoremap <C-r><C-o>  <C-r><C-p>"

" delete string to the end of line.
inoremap <C-k>   <C-o>D

" jump to next/previous line.
Arpeggio inoremap gk    <C-o>O
Arpeggio inoremap gj    <C-o>o
" }}}
" cmap {{{
if &wildmenu
    cnoremap <C-f> <Space><BS><Right>
    cnoremap <C-b> <Space><BS><Left>
endif

" paste register
cnoremap <C-r><C-u>  <C-r>+
cnoremap <C-r><C-i>  <C-r>*
cnoremap <C-r><C-o>  <C-r>"

" delete string to the end of line.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" }}}
" abbr {{{
inoreab <expr> date@      strftime("%Y-%m-%d")
inoreab <expr> time@      strftime("%H:%M")
inoreab <expr> dt@        strftime("%Y-%m-%d %H:%M")

cnoreab   h@     tab help
" }}}
" }}}

" Commands {{{
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
" ListChars {{{
command! ListChars call s:ListChars()
func! s:ListChars()
    let lcs = prompt#prompt('changing &listchars to...', {
    \       'menu': [
    \           'tab:>-,extends:>,precedes:<,eol:.',
    \           'tab:>-',
    \           'tab:\ \ ',
    \       ],
    \       'one_char': 1,
    \       'escape': 1,
    \       'execute': 'set listchars=%s'})
    if lcs !=# "\e"
        echomsg printf("changing &listchars to '%s'.", lcs)
    endif
endfunc
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
" CdCurrent {{{
"   Change current directory to current file's one.
command! -nargs=0 LcdCurrent lcd %:p:h
command! -nargs=0 CdCurrent  cd %:p:h
nnoremap <silent> <Leader>cd   :LcdCurrent<CR>
nnoremap <silent> ,cd          :CdCurrent<CR>
" }}}
" Ack {{{
if executable('ack')
    func! s:ack(...)
        let save_grepprg = &l:grepprg
        try
            let &l:grepprg = 'ack -a'
            execute 'grep' join(a:000, ' ')
        finally
            let &l:grepprg = save_grepprg
        endtry
    endfunc
    command! -nargs=+ Ack call s:ack(<f-args>)
endif
" }}}
" }}}


" For Plugins {{{
" my plugins {{{
" shell-mode {{{
let g:loaded_shell_mode = 1
" }}}
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
let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']
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
let dumbbuf_wrap_cursor = 0
let dumbbuf_remove_marked_when_close = 1
" let dumbbuf_shown_type = 'project'


" let dumbbuf_cursor_pos = 'keep'

" For (compatibility) test
"
" let dumbbuf_shown_type = 'foobar'
" let dumbbuf_listed_buffer_name = "*foo bar*"
" let g:dumbbuf_close_when_exec = 1
"
" let dumbbuf_verbose = 1
" }}}
" prompt {{{
" let prompt_debug = 1
" }}}
" }}}
" others {{{
" AutoDate {{{
let g:autodate_format = "%Y-%m-%d"
" }}}
" FuzzyFinder {{{
nnoremap <silent> <Leader>fd        :FufDir<CR>
nnoremap <silent> <Leader>ff        :FufFile<CR>
nnoremap <silent> <Leader>fh        :FufMruFile<CR>

let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']

let fuf_keyOpenTabpage = '<C-t>'
let fuf_keyNextMode    = '<C-l>'
let fuf_keyPrevMode    = '<C-h>'
let fuf_keyOpenSplit   = '<C-s>'
let fuf_keyOpenVsplit  = '<C-v>'
let fuf_enumeratingLimit = 20

" abbrev {{{
func! s:register_fuf_abbrev()
    let g:fuf_abbrevMap = {
        \ '^r@': map(copy(s:runtimepath.get()), 'v:val . "/"'),
        \ '^p@': map(copy(s:runtimepath.get()), 'v:val . "/plugin/"'),
        \ '^h@': ['~/'],
        \ '^m@' : ['~/work/memo/'],
        \ '^v@' : ['~/.vim/'],
        \ '^d@' : ['~/q/diary/'],
        \ '^s@' : ['~/work/scratch/'],
        \ '^w@' : ['~/work/'],
    \}

    if has('win32')
        let g:fuf_abbrevMap['^de@'] = [
        \   'C:' . substitute( $HOMEPATH, '\', '/', 'g' ) . '/デスクトップ/'
        \]
        let g:fuf_abbrevMap['^cy@'] = [
        \   exists('$CYGHOME') ? $CYGHOME : 'C:/cygwin/home/'. $USERNAME .'/'
        \]
        let g:fuf_abbrevMap['^ms@'] = [
        \   exists('$MSYSHOME') ? $MSYSHOME : 'C:/msys/home/'. $USERNAME .'/'
        \]
    else
        let g:fuf_abbrevMap['^de@'] = [
        \   '~/Desktop/'
        \]
    endif
endfunc

AutoCommand VimEnter * call s:register_fuf_abbrev()
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
" operator-replace {{{
map <Leader>r  <Plug>(operator-replace)
map <Leader>R  <Leader>r$
" }}}
" EasyGrep {{{
let EasyGrepFileAssociations = expand("$HOME/.vim/EasyGrepFileAssociations")
let EasyGrepMode = 2
let EasyGrepInvertWholeWord = 1
let EasyGrepRecursive = 1
let EasyGrepIgnoreCase = 0
" }}}
" skk.vim {{{
let skk_jisyo = '~/.skk-jisyo'
let skk_large_jisyo = '/usr/share/skk/SKK-JISYO'
let skk_control_j_key = '<C-y>'
let skk_manual_save_jisyo_keys = ''
let skk_egg_like_newline = 1
let skk_auto_save_jisyo = 1
let skk_imdisable_state = -1
" let skk_keep_state = 1
" }}}
" vimshell {{{
AddRuntimePath $HOME/work/git/vimproc
AddRuntimePath $HOME/work/git/vimshell

let g:VimShell_EnableInteractive = 2
" }}}
" quickrun {{{
let g:quickrun_no_default_key_mappings = 1
map <Space>r <Plug>(quickrun)
" }}}
" }}}
" }}}


" Misc. (bundled with kaoriya vim's .vimrc & etc.) {{{
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

AutoCommand BufReadPost * call s:AU_ReCheck_FENC()

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
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
endif
if has('mac')
    " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
    set iskeyword=@,48-57,_,128-167,224-235
endif
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


" Update &runtimepath. {{{
if !(exists('$VIMRC_DONT_ADD_RUNTIMEPATH') && $VIMRC_DONT_ADD_RUNTIMEPATH)
    UpdateRuntimePath
endif
" }}}

" Register autocmd. {{{
ExecuteAutoCommand
" }}}
