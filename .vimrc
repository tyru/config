" vim:set fen fdm=marker:
scriptencoding utf-8
set cpo&vim


syntax enable
filetype plugin indent on


let mapleader = ';'
let maplocalleader = '\'


" Util Functions/Commands {{{
" Function {{{
func! s:warn(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunc "}}}
func! s:system(command, ...) "{{{
    let args = [a:command] + map(copy(a:000), 'shellescape(v:val)')
    return system(join(args, ' '))
endfunc "}}}
func! s:glob(expr) "{{{
    return split(glob(a:expr), "\n")
endfunc "}}}
" }}}
" Commands {{{
augroup MyVimrc
    autocmd!
    " Create 'MyVimrc' augroup.
augroup END

command! -bang -nargs=* MyAutocmd autocmd<bang> MyVimrc <args>
" }}}
" }}}
" Options {{{
set all&

" indent
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4

" search
set hlsearch
set incsearch
set smartcase

" listchars
set list
set listchars=tab:>-,extends:>,precedes:<,eol:.

" scroll
set scroll=5
set scrolloff=15
" set scrolloff=9999

" shift
set shiftround
set shiftwidth=4

" window
set splitbelow
set nosplitright

" completion
set complete=.,w,b,u,t,i,d,k,kspell
set wildmenu
set wildchar=<Tab>
set wildignore=*.o,*.obj,*.la,*.a,*.exe,*.com,*.tds

" tags
if has('path_extra')
    " find 'tags' rewinding current directory
    set tags&
    set tags+=.;
endif
set showfulltag

" virtualedit
if has('virtualedit')
    set virtualedit=all
endif

" swap
set noswapfile
set updatecount=0
" set directory=$HOME/.vim/swap
" if !isdirectory(&directory)
"     call mkdir(&directory)
" endif

" fsync() is slow...
if has('unix')
    set nofsync
    set swapsync=
endif

" backup
set backup
set backupdir=$HOME/.vim/backup
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif

" title
set title
let &titlestring = '%{haslocaldir() ? "[local]" : ""}(%{Dir()})'
func! Dir()
    let d = fnamemodify(getcwd(), ':~')
    let d = substitute(d, '\/$', '', '')
    return d
endfunc

" tab
set showtabline=2
let &tabline     = '%{tabpagenr()}:%{expand("%:t")} [%M%R%H%W]'
let &guitablabel = '%{tabpagenr()}:%{expand("%:t")} [%M%R%H%W]'

" statusline
set laststatus=2
let &statusline = '(%{&ft})(%{&fenc})(%{&ff})/(%p%%)(%l/%L)/(%{skk7#get_mode()})'

" gui
set guioptions=aegitrhpF

" &migemo
if has("migemo")
    set migemo
endif

" convert "\\" to "/" on win32 like environment
if exists('+shellslash')
    set shellslash
endif

" visual bell
set novisualbell
MyAutocmd VimEnter * set t_vb=
set debug=beep

" restore screen
set norestorescreen
set t_ti=
set t_te=

" timeout
set notimeout

" fillchars
set fillchars=stl:\:,vert:\ ,fold:-,diff:-

" cursor behavior in insertmode
set whichwrap=b,s
set backspace=indent,eol,start
set formatoptions=mMcroqnl2

" misc.
set wrap
set autoread
set diffopt=filler,vertical
set helplang=ja,en
set history=50
set keywordprg=
set nojoinspaces
set noshowcmd
set nrformats=hex
set shortmess=aI
set switchbuf=useopen,usetab
set textwidth=0
set viminfo='50,h,f1,n$HOME/.viminfo


" runtimepath
if has("win32")
    set runtimepath+=$HOME/.vim
endif

func! s:add_rtp_from_file(file)
    let file = expand(a:file)
    if !filereadable(file) | return | endif

    for line in readfile(file)
        if line =~# '^\s*$' || line =~# '^\s*#'
            continue
        endif
        for path in s:glob(line)
            let &runtimepath .= ',' . path
        endfor
    endfor
endfunc
call s:add_rtp_from_file('$HOME/.vimruntimepath.lst')
" }}}
" Autocmd {{{

func! s:vimenter_handler()
    " Color
    set bg=dark
    colorscheme desert
endfunc

" colorscheme (on windows, setting colorscheme in .vimrc does not work)
MyAutocmd VimEnter * call s:vimenter_handler()

" open on read-only if swap exists
MyAutocmd SwapExists * let v:swapchoice = 'o'

" autocmd CursorHold,CursorHoldI *   silent! update
MyAutocmd QuickfixCmdPost make,grep,grepadd,vimgrep,helpgrep   copen

" sometimes &modeline becomes false
MyAutocmd BufReadPre *    setlocal modeline

" filetype {{{
MyAutocmd BufNewFile,BufReadPre *.as
            \ setlocal ft=actionscript syntax=actionscript
MyAutocmd BufNewFile,BufReadPre *.c
            \ setlocal ft=c
MyAutocmd BufNewFile,BufReadPre *.cpp
            \ setlocal ft=cpp
MyAutocmd BufNewFile,BufReadPre *.h
            \ setlocal ft=c.cpp
MyAutocmd BufNewFile,BufReadPre *.cs
            \ setlocal ft=cs
MyAutocmd BufNewFile,BufReadPre *.java
            \ setlocal ft=java
MyAutocmd BufNewFile,BufReadPre *.js
            \ setlocal ft=javascript
MyAutocmd BufNewFile,BufReadPre *.pl,*.pm
            \ setlocal ft=perl
MyAutocmd BufNewFile,BufReadPre *.ps1
            \ setlocal ft=powershell
MyAutocmd BufNewFile,BufReadPre *.py,*.pyc
            \ setlocal ft=python
MyAutocmd BufNewFile,BufReadPre *.rb
            \ setlocal ft=ruby
MyAutocmd BufNewFile,BufReadPre *.scm
            \ setlocal ft=scheme
MyAutocmd BufNewFile,BufReadPre _vimperatorrc,.vimperatorrc
            \ setlocal ft=vimperator syntax=vimperator
MyAutocmd BufNewFile,BufReadPre *.scala
            \ setlocal ft=scala
MyAutocmd BufNewFile,BufReadPre *.lua
            \ setlocal ft=lua
MyAutocmd BufNewFile,BufReadPre *.avs
            \ setlocal syntax=avs
MyAutocmd BufNewFile,BufReadPre *.tmpl
            \ setlocal ft=html
MyAutocmd BufNewFile,BufReadPre *.mkd
            \ setlocal ft=markdown
MyAutocmd BufNewFile,BufReadPre *.md
            \ setlocal ft=markdown
MyAutocmd FileType mkd
            \ setlocal ft=markdown

" delete autocmd for ft=mkd.
MyAutocmd VimEnter * autocmd! filetypedetect BufNewFile,BufRead *.md
" }}}
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
                \   'execute_if': 'val != ""',
                \   'executef': 'edit ++enc=%s'})
    if result !=# "\e"
        echomsg printf("re-open with '%s'.", result)
    endif
endfunc

nnoremap <silent> ,ta     :call ChangeEncoding()<CR>
nnoremap <silent> <F1>    :call ChangeEncoding()<CR>
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
                \ 'execute_if': 'val != ""',
                \ 'executef': 'set fenc=%s'})
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

nnoremap <silent> ,ts     :call ChangeFileEncoding()<CR>
nnoremap <silent> <F2>    :call ChangeFileEncoding()<CR>
" }}}
" set ff=... {{{
func! ChangeNL()
    let result = prompt#prompt("changing newline format to...", {
                \ 'menu': ['dos', 'unix', 'mac'],
                \ 'one_char': 1,
                \ 'escape': 1,
                \ 'execute_if': 'val != ""',
                \ 'executef': 'set ff=%s'})
    if result !=# "\e"
        echomsg printf("changing newline format to '%s'.", result)
    endif
endfunc

nnoremap <silent> ,td     :call ChangeNL()<CR>
nnoremap <silent> <F3>    :call ChangeNL()<CR>
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
MyAutocmd FileType *   call s:LoadWhenFileType()
" }}}
" }}}
" Mappings and/or Abbreviations {{{
let g:arpeggio_timeoutlen = 40
call arpeggio#load()

" map {{{
" operator {{{
" paste to clipboard
noremap <Leader>y   "+y
noremap <Leader>Y   "*y
noremap <Leader>d   "+d
noremap <Leader>D   "*d

" do not destroy noname register.
noremap x   "_x
noremap ,d   "_d


" operator-sort {{{
map <Leader>s <Plug>(operator-sort)

call operator#user#define('sort', 'Op_command',
\                         'call Set_op_command("sort")')

let s:op_command_command = ''

function! Set_op_command(command)
    let s:op_command_command = a:command
endfunction

function! Op_command(motion_wiseness)
    execute "'[,']" s:op_command_command
endfunction
" }}}
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
noremap <silent> <Space><Space>     <Space>

noremap <silent> <Space>j           <C-f>
noremap <silent> <Space>k           <C-b>
" }}}
" }}}
" nmap {{{
" All 'suffix key' should be like the following.
nnoremap <silent> <LocalLeader><LocalLeader>    <LocalLeader>
nnoremap <silent> <Leader><Leader>              <Leader>
nnoremap <silent> <Space><Space>                <Space>
nnoremap <silent> ,,                            ,

nnoremap <expr> <Plug>(vimrc-lastpat-next)      <SID>last_pattern(1)
nnoremap <expr> <Plug>(vimrc-lastpat-previous)  <SID>last_pattern(0)

func! s:last_pattern(next) "{{{
endfunc "}}}

" TODO Ignore last pattern direction
" I want the way to know last searched direction...
nnoremap <silent> n     nzz
nnoremap <silent> N     Nzz

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

" make
nnoremap <silent>   gm      :<C-u>make<CR>
nnoremap <silent>   gc      :<C-u>cclose<CR>

" open only current line's fold.
nnoremap <silent> z<Space> zMzvzz

" hlsearch
nnoremap gh    :<C-u>set hlsearch!<CR>

nnoremap ZZ <Nop>

nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>q :<C-u>q<CR>

nnoremap <silent> <C-g><C-n>    :<C-u>tablast<CR>
nnoremap <silent> <C-g><C-p>    :<C-u>tabfirst<CR>

nnoremap <silent> <Space>ev     :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Space>e.     :<C-u>edit .<CR>

nnoremap <silent> <Space>tv     :<C-u>tabedit $MYVIMRC<CR>
nnoremap <silent> <Space>t.     :<C-u>tabedit .<CR>

" cmdwin {{{
set cedit=<C-z>
func! s:cmdwin_enter()
    inoremap <buffer> <C-z>     <C-c>
    nnoremap <buffer> <C-z>     <C-c>
    inoremap <buffer> <Tab>     <C-X><C-V>
    inoremap <buffer> <S-Tab>   <C-p>

    startinsert!
endfunc
MyAutocmd CmdwinEnter * call s:cmdwin_enter()

" nnoremap g: q:
" nnoremap g/ q/
" nnoremap g? q?


" }}}

" gVim only {{{
nnoremap <silent> <M-j>     <C-w>j
nnoremap <silent> <M-k>     <C-w>k
nnoremap <silent> <M-h>     <C-w>h
nnoremap <silent> <M-l>     <C-w>l
" }}}
" }}}
" map! {{{
noremap! <C-f>   <Right>
noremap! <C-b>   <Left>
noremap! <C-a>   <Home>
noremap! <C-e>   <End>
noremap! <C-d>   <Del>

Arpeggio noremap! $( ()<Left>
Arpeggio noremap! 4[ []<Left>
Arpeggio noremap! $< <><Left>
Arpeggio noremap! ${ {}<Left>

Arpeggio noremap! $' ''<Left>
call arpeggio#map('ic', '', 0, '*"', '""<Left>')
Arpeggio noremap! $` ``<Left>

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
" inoremap <C-z>                <C-o>di

" omni
" inoremap <C-n>     <C-x><C-n>
" inoremap <C-p>     <C-x><C-p>

" paste register
inoremap <C-r><C-u>  <C-r><C-p>+
inoremap <C-r><C-i>  <C-r><C-p>*
inoremap <C-r><C-o>  <C-r><C-p>"

" delete string to the end of line.
func! s:kill_line()
    let curcol = col('.')
    if curcol == col('$')
        join!
        call cursor(line('.'), curcol)
    else
        normal! D
    endif
endfunc
inoremap <C-k>  <C-o>:<C-u>call <SID>kill_line()<CR>

" jump to next/previous line.
Arpeggio inoremap qk    <C-o>O
Arpeggio inoremap qj    <C-o>o

" shift left (indent)
inoremap <C-q>   <C-d>
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

call altercmd#load()
AlterCommand th     tab<Space>help
AlterCommand t      tabedit
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
    \       'execute_if': 'val != ""',
    \       'executef': 'set listchars=%s'})
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
    for i in a:000
        call mkdir(expand(i), 'p')
    endfor
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
" }}}
" Ack {{{
func! s:ack(...)
    let save_grepprg = &l:grepprg
    try
        let &l:grepprg = 'ack'
        execute 'grep' join(a:000, ' ')
    finally
        let &l:grepprg = save_grepprg
    endtry
endfunc
command! -nargs=+ Ack call s:ack(<f-args>)
" }}}
" SetTitle {{{
command! -nargs=+ SetTitle
\   let &titlestring = <q-args>
" }}}
" ShowPath {{{
command!
\   -nargs=+ -complete=option
\   ShowPath
\   call s:show_path(<f-args>)

func! s:show_path(...) "{{{
    let optname = a:1
    let delim = a:0 >= 2 ? a:2 : ','
    let optval = getbufvar('%', '&' . optname)
    for i in split(optval, delim)
        echo i
    endfor
endfunc "}}}
" }}}
" Write {{{
AlterCommand w[rite]    Write

" AlterCommand w[rite]    confirm<Space>write
" set directory=$HOME/.vim/backup

command!
\   -bang -nargs=? -complete=file
\   Write
\   call s:write("<bang>", <f-args>)

" :Write has some different points as follows:
" - It will ask when &readonly is true.
"
" TODO
" - It will ask when it rewrites a file
"   when specified the path.
" - :WriteQuit
func! s:write(bang, ...) "{{{
    let file = a:0 == 0 ? expand('%') : expand(a:1)
    let write_cmd = printf('write%s %s', a:bang, file)
    try
        if &l:readonly
            let msg = file . ': this file is readonly! overwrite?:'
            let r = prompt#prompt(msg, {
            \   'yes_no': 1,
            \   'escape': 1,
            \   'one_char': 1,
            \})
            " TODO prompt#prompt should return boolean value
            " when 'yesno' option is given.
            if r =~# '^\s*[yY]\%[[eE][sS]]'
                let write_cmd = 'setlocal noreadonly | ' . write_cmd
            else
                return
            endif
        endif

        " TODO when rewring a file

        execute write_cmd
    catch
        call s:warn(v:exception)
    endtry
endfunc "}}}
" }}}
" TR, TRR {{{
AlterCommand tr  TR
AlterCommand trr TRR

command!
\   -nargs=+ -range
\   TR
\   <C-u>call s:tr(<f-line1>, <f-line2>, <q-args>)

command!
\   -nargs=+ -range
\   TRR
\   <C-u>call s:trr(<f-line1>, <f-line2>, <q-args>)

func! s:tr_split_arg(arg) "{{{
    let arg = a:arg
    let arg = substitute(arg, '^\s*', '', '')
    if arg == ''
        throw 'argument_error'
    endif

    let sep = arg[0]
    return split(arg, '\%(\\\)\@<!' . sep)
endfunc "}}}

func! s:tr(lnum_from, lnum_to, arg) "{{{
    " TODO :lockmarks
    let reg_str = getreg('z', 1)
    let reg_type = getregtype('z')
    mark z
    call cursor(a:lnum_from, 1)
    try
        let [pat1, pat2] = s:tr_split_arg(a:arg)
        call call(
        \   's:tr_replace',
        \   [a:lnum_from, a:lnum_to, pat1, pat2, pat2, pat1]
        \)
    catch /^argument_error$/
        return
    catch
        call s:warn(v:exception)
    finally
        normal! 'z
        call setreg('z', reg_str, reg_type)
    endtry
endfunc "}}}

func! s:trr(lnum_from, lnum_to, arg) "{{{
    " TODO :lockmarks
    let reg_str = getreg('z', 1)
    let reg_type = getregtype('z')
    mark z
    call cursor(a:lnum_from, 1)
    try
        call call(
        \   's:tr_replace',
        \   [a:lnum_from, a:lnum_to]
        \       + s:tr_split_arg(a:arg)
        \)
    catch /^argument_error$/
        return
    catch
        call s:warn(v:exception)
    finally
        normal! 'z
        call setreg('z', reg_str, reg_type)
    endtry
endfunc "}}}

" Replace pat1 to str1, pat2 to str2,
" from current position to the end of the file.
func! s:tr_replace(lnum_from, lnum_to, pat1, str1, pat2, str2) "{{{
    " TODO
endfunc "}}}
" }}}
" AllBufMaps {{{
command!
\   AllBufMaps
\   map <buffer> | map! <buffer> | lmap <buffer>
" }}}

" from kana's .vimrc {{{
nnoremap <silent> <Leader>cd   :CD %:p:h<CR>

" CD - alternative :cd with more user-friendly completion  "{{{
command! -complete=dir -nargs=+ CD  TabpageCD <args>

AlterCommand cd  CD
" }}}
" TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
command! -nargs=? TabpageCD
\   execute 'cd' fnameescape(expand(<q-args>))
\ | let t:cwd = getcwd()

MyAutocmd TabEnter *
\   if !exists('t:cwd')
\ |   let t:cwd = getcwd()
\ | endif
\ | execute 'cd' fnameescape(expand(t:cwd))
" }}}
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
" let dumbbuf_close_when_exec = 1


" DumbBuf nmap s    split #<bufnr>
" DumbBuf nmap g    sbuffer <bufnr>
" call dumbbuf#map('n', '', 0, 'g', ':sbuffer %d')

" let dumbbuf_cursor_pos = 'keep'

" For (compatibility) test
"
" let dumbbuf_shown_type = 'foobar'
" let dumbbuf_listed_buffer_name = "*foo bar*"
"
" let dumbbuf_verbose = 1
" }}}
" prompt {{{
" let prompt_debug = 1
" }}}
" skk7 {{{
let skk7_debug = 1
let skk7_debug_wait_ms = 0
" }}}
" stickykey {{{
Arpeggio map  ,a <Plug>(stickykey-shift-remap)
Arpeggio map! ,a <Plug>(stickykey-shift-remap)
Arpeggio lmap ,a <Plug>(stickykey-shift-remap)

Arpeggio map  ,s <Plug>(stickykey-ctrl-remap)
Arpeggio map! ,s <Plug>(stickykey-ctrl-remap)
Arpeggio lmap ,s <Plug>(stickykey-ctrl-remap)

Arpeggio map  ,d <Plug>(stickykey-alt-remap)
Arpeggio map! ,d <Plug>(stickykey-alt-remap)
Arpeggio lmap ,d <Plug>(stickykey-alt-remap)

" I don't have Macintosh :(
" map  ,f <Plug>(stickykey-command-remap)
" map! ,f <Plug>(stickykey-command-remap)
" lmap ,f <Plug>(stickykey-command-remap)
" }}}
" restart {{{
AlterCommand res[tart] Restart
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
let fuf_previewHeight = 0

" abbrev {{{
func! s:register_fuf_abbrev()
    let g:fuf_abbrevMap = {
        \ '^r@': map(split(&runtimepath, ','), 'v:val . "/"'),
        \ '^p@': map(split(&runtimepath, ','), 'v:val . "/plugin/"'),
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

MyAutocmd VimEnter * call s:register_fuf_abbrev()
" }}}
" }}}
" MRU {{{
nnoremap <silent> <C-h>     :MRU<CR>
let MRU_Max_Entries   = 500
let MRU_Add_Menu      = 0
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\c\'
" }}}
" changelog {{{
let changelog_username = "tyru"
" }}}
" Gtags {{{
func! s:JumpTags() "{{{
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
endfunc "}}}

nnoremap <silent> g<C-i>    :Gtags -f %<CR>
nnoremap <silent> <C-]>     :call <SID>JumpTags()<CR>
" }}}
" operator-replace {{{
map <Leader>r  <Plug>(operator-replace)
" }}}
" skk {{{
let skk_jisyo = '~/.skk-jisyo'
let skk_large_jisyo = '/usr/share/skk/SKK-JISYO'

let skk_control_j_key = '<C-y>'
" let skk_control_j_key = ''
" Arpeggio map! fj    <Plug>(skk-enable-im)

let skk_manual_save_jisyo_keys = ''

let skk_egg_like_newline = 1
let skk_auto_save_jisyo = 1
let skk_imdisable_state = -1
" let skk_keep_state = 1

" applied krogue's patch ver.
let skk_sticky_key = ';'
" }}}
" vimshell {{{
let g:VimShell_EnableInteractive = 2
let g:VimShell_NoDefaultKeyMappings = 1
" }}}
" quickrun {{{
let g:quickrun_no_default_key_mappings = 1
map <Space>r <Plug>(quickrun)

let g:loaded_quicklaunch = 1
" }}}
" submode {{{

" Moving window.
call submode#enter_with('window-move', 'n', '', 'gwm', '<Nop>')
call submode#leave_with('window-move', 'n', '', "\<Esc>")
call submode#map('window-move', 'n', 'r', 'j', '<Plug>(winmove-down)')
call submode#map('window-move', 'n', 'r', 'k', '<Plug>(winmove-up)')
call submode#map('window-move', 'n', 'r', 'h', '<Plug>(winmove-left)')
call submode#map('window-move', 'n', 'r', 'l', '<Plug>(winmove-right)')

" Change the size of window.
call submode#enter_with('window-size', 'n', '', 'gwe', '<Nop>')
call submode#leave_with('window-size', 'n', '', "\<Esc>")
call submode#map('window-size', 'n', 'r', 'j', '<C-w>-')
call submode#map('window-size', 'n', 'r', 'k', '<C-w>+')
call submode#map('window-size', 'n', 'r', 'h', '<C-w><')
call submode#map('window-size', 'n', 'r', 'l', '<C-w>>')

" }}}
" prettyprint {{{
AlterCommand p      PP
AlterCommand pp     PrettyPrint
" }}}
" ref {{{
" 'K' for ':Ref'.
nnoremap          <C-k>     :Ref<Space>
nnoremap <silent> gK        K
" }}}
" chalice {{{
let chalice_bookmark = expand('$HOME/.vim/chalice.bmk')
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

MyAutocmd BufReadPost * call s:AU_ReCheck_FENC()

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
