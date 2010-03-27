" vim:set fen fdm=marker:
scriptencoding utf-8
set cpo&vim


syntax enable
filetype plugin indent on


language messages C
language time C


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
func! s:getchar(...) "{{{
    let c = call('getchar', a:000)
    return type(c) == type("") ? c : nr2char(c)
endfunc "}}}
func! s:one_of(elem, list) "{{{
    return !empty(filter(copy(a:list), 'v:val ==# a:elem'))
endfunc "}}}
function! s:uniq(list) "{{{
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
function! s:uniq_path(path, ...) "{{{
    let sep = a:0 != 0 ? a:1 : ','
    if type(a:path) == type([])
        return join(s:uniq(a:path), sep)
    else
        return join(s:uniq(split(a:path, sep)), sep)
    endif
endfunction "}}}
function! s:has_idx(list, idx) "{{{
    let idx = a:idx
    " Support negative index?
    " let idx = a:idx >= 0 ? a:idx : len(a:list) + a:idx
    return 0 <= idx && idx < len(a:list)
endfunction "}}}
" }}}
" Commands {{{
augroup vimrc
    autocmd!
    " Create 'vimrc' augroup.
augroup END

command! -bang -nargs=* MyAutocmd autocmd<bang> vimrc <args>
" }}}
" }}}
" Options {{{

set all&


" runtimepath {{{

if has("win32")
    set runtimepath+=$HOME/.vim
endif


func! s:is_action(name) "{{{
    return s:get_action(a:name) !=# -1
endfunc "}}}
func! s:get_action(name) "{{{
    let action = {
    \   'shift'   : 'let &rtp = join(split(&rtp, ",")[1:], ",")',
    \   'pop'     : 'let &rtp = join(split(&rtp, ",")[:-2], ",")',
    \   'unshift' : 'let &rtp = join(s:glob(path) + split(&rtp, ","), ",")',
    \   'push'    : 'let &rtp = join(split(&rtp, ",") + s:glob(path), ",")',
    \   'clear'   : 'let &rtp = ""',
    \   'finish'  : 'return',
    \}
    return get(action, a:name, -1)
endfunc "}}}
func! s:add_rtp_from_file(file) "{{{
    let file = expand(a:file)
    if !filereadable(file) | return | endif

    for line in readfile(file)
        let line = substitute(line, '^\s\+', '', '')
        let line = substitute(line, '\s\+$', '', '')
        if line =~# '^$\|^#' | continue | endif

        let m = matchlist(line, '\(\w\+\)\s\+\(\S\+\)')
        if empty(m)
            if s:is_action(line)
                let [action, path] = [line, '']
            else
                let [action, path] = ['push', line]
            endif
        else
            let [action, path] = m[1:2]
        endif

        execute s:get_action(action)
    endfor
endfunc "}}}
call s:add_rtp_from_file('~/.vimruntimepath.lst')
" }}}

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
set noequalalways

" completion
set complete=.,w,b,u,t,i,d,k,kspell
set wildmenu
set wildchar=<Tab>
set wildignore=*.o,*.obj,*.la,*.a,*.exe,*.com,*.tds
set pumheight=20

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
let &titlestring = '%{getcwd()} %{haslocaldir() ? "(local)" : ""}'
" func! Dir()
"     let d = fnamemodify(getcwd(), ':~')
"     let d = substitute(d, '\/$', '', '')
"     return d
" endfunc

" tab
set showtabline=2
let &tabline     = '%{tabpagenr()}:%{expand("%:t")}%( (%M%R%H%W)%)'
let &guitablabel = '%{tabpagenr()}:%{expand("%:t")}%( (%M%R%H%W)%)'

" statusline
set laststatus=2
"let &statusline = '(%{&ft})(%{&fenc})(%{&ff})/(%p%%)(%l/%L)/(%{eskk#get_mode()})'
let &statusline = '(%{&ft})(%{&fenc})(%{&ff})/(%p%%)(%l/%L)'

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

" fold
set foldenable
" set foldmethod=marker

" misc.
set autoread
set diffopt=filler,vertical
set helplang=ja,en
set hidden
set history=50
set keywordprg=
set lazyredraw
set nojoinspaces
set noshowcmd
set nrformats=hex
set shortmess=aI
set switchbuf=useopen,usetab
set textwidth=0
set viminfo='50,h,f1,n$HOME/.viminfo
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

" aliases
MyAutocmd FileType mkd
            \ setlocal ft=markdown
MyAutocmd FileType js
            \ setlocal ft=javascript
MyAutocmd FileType c++
            \ setlocal ft=cpp
MyAutocmd FileType py
            \ setlocal ft=python
MyAutocmd FileType pl
            \ setlocal ft=perl
MyAutocmd FileType sch
            \ setlocal ft=scheme

" delete autocmd for ft=mkd.
MyAutocmd VimEnter * autocmd! filetypedetect BufNewFile,BufRead *.md
" }}}
" }}}
" Encoding {{{
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
let &fileencodings = s:uniq_path(
\   ['utf-8']
\   + split(&fileencodings, ',')
\   + ['iso-2022-jp', 'iso-2022-jp-3']
\)

set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif

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

nnoremap <silent> [subleader]ta     :call ChangeEncoding()<CR>
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

nnoremap <silent> [subleader]ts    :<C-u>call ChangeFileEncoding()<CR>
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

nnoremap <silent> [subleader]td    :<C-u>call ChangeNL()<CR>
" }}}
" }}}
" FileType {{{
func! s:each_filetype() "{{{
    return split(&l:filetype, '\.')
endfunc "}}}

" s:SetDict {{{
func! s:SetDict()
    let filetype_vs_dictionary = {
    \   'c': ['c', 'cpp'],
    \   'cpp': ['c', 'cpp'],
    \   'html': ['html', 'css', 'javascript'],
    \   'scala': ['scala', 'java'],
    \}

    let dicts = []
    for ft in s:each_filetype()
        for ft in get(filetype_vs_dictionary, ft, [ft])
            let dict_path = expand(printf('$HOME/.vim/dict/%s.dict', ft))
            if filereadable(dict_path)
                call add(dicts, dict_path)
            endif
        endfor
    endfor

    " FIXME Use pathogen.vim!!
    for d in dicts
        let &l:dictionary = join(s:uniq(dicts), ',')
    endfor
endfunc
" }}}
" s:SetTabWidth {{{
func! s:SetTabWidth()
    if s:one_of(&l:filetype, ['css', 'xml', 'html', 'lisp', 'scheme', 'yaml'])
        CodingStyle Short indent
    else
        CodingStyle My style
    endif
endfunc
" }}}
" s:SetCompiler {{{
func! s:SetCompiler()
    let filetype_vs_compiler = {
    \   'c': 'gcc',
    \   'cpp': 'gcc',
    \   'html': 'tidy',
    \   'java': 'javac',
    \}
    try
        for ft in s:each_filetype()
            execute 'compiler' get(filetype_vs_compiler, ft, ft)
        endfor
    catch /E666:/    " compiler not supported: ...
    endtry
endfunc
" }}}
" s:LoadWhenFileType() {{{
func! s:LoadWhenFileType()
    if &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
    endif

    call s:SetDict()
    call s:SetTabWidth()
    call s:SetCompiler()

    " Misc.
    if s:one_of('perl', s:each_filetype())
        setlocal complete=.,w,b,u,t,k,kspell
    endif
endfunc

" do what ~/.vim/ftplugin/* does in .vimrc
" because of my laziness :p
MyAutocmd FileType *   call s:LoadWhenFileType()
" }}}
" }}}
" Mappings and/or Abbreviations {{{

" TODO Do not clear mappings set by plugins.
" mapclear
" mapclear!
" " mapclear!!!!
" lmapclear

" Set up prefix keys. {{{
let mapleader = ';'
nnoremap <Leader>       <Nop>
nnoremap [origleader]<Leader>   <Leader>

let maplocalleader = '\'
nnoremap <LocalLeader>  <Nop>
nnoremap [origleader]<LocalLeader>  <LocalLeader>

nnoremap    [subleader]     <Nop>
nmap        ,               [subleader]
nnoremap    [origleader],   ,

nnoremap    [cmdleader]     <Nop>
nmap        <Space>         [cmdleader]
nnoremap    [origleader]<Space>     <Space>

nnoremap    [origleader]    <Nop>
nmap        q               [origleader]
nnoremap    [origleader]q   q

let s:submode_leader = 'm'
execute 'nnoremap' s:submode_leader '<Nop>'
nnoremap    [origleader]m   m
" }}}

let g:arpeggio_timeoutlen = 40
call arpeggio#load()

" map {{{
" operator {{{
" paste to clipboard
noremap <Leader>y       "+y
noremap [subleader]y    "*y
noremap <Leader>d       "+d
noremap [subleader]d    "*d

" do not destroy noname register.
noremap x           "_x
noremap <Space>d    "_d

" map default keys to <Leader> sequence keys.
noremap <Leader>? g?
noremap <Leader>e =

" operator-... for ex command {{{
let s:op_command_command = ''

function! Set_op_command(command)
    let s:op_command_command = a:command
endfunction

function! Op_command(motion_wiseness)
    execute "'[,']" s:op_command_command
endfunction
" }}}
" operator-sort {{{
map <Leader>s <Plug>(operator-sort)

call operator#user#define('sort', 'Op_command',
\                         'call Set_op_command("sort")')
" }}}
" operator-retab {{{
map <Leader>t <Plug>(operator-retab)

call operator#user#define('retab', 'Op_command',
\                         'call Set_op_command("retab")')
" }}}
" operator-join {{{
map <Leader>j <Plug>(operator-join)

call operator#user#define('join', 'Op_command',
\                         'call Set_op_command("join")')
" }}}
" operator-uniq {{{
map <Leader>u <Plug>(operator-uniq)

call operator#user#define('uniq', 'Op_command',
\                         'call Set_op_command("sort u")')
" }}}
" }}}
" motion/textobj {{{
noremap <silent> j          gj
noremap <silent> k          gk
noremap <silent> [origleader]j j
noremap <silent> [origleader]k k

noremap <silent> ]k        :<C-u>call search('^\S', 'Ws')<CR>
noremap <silent> [k        :<C-u>call search('^\S', 'Wsb')<CR>

omap iF <Plug>(textobj-fold-i)
vmap iF <Plug>(textobj-fold-i)
omap aF <Plug>(textobj-fold-a)
vmap aF <Plug>(textobj-fold-a)

onoremap gp %
vnoremap gp %
" }}}
" misc. {{{
noremap <silent> <Space>j           <C-f>
noremap <silent> <Space>k           <C-b>
" }}}
" }}}
" nmap {{{
" open only current line's fold.
nnoremap <silent> z<Space> zMzvzz

" annoying for me
nnoremap ZZ <Nop>

" folding mappings easy to remember.
nnoremap <silent> zl    zo
nnoremap <silent> zh    zc

nnoremap <silent> d<Space>  0d$
nnoremap <silent> y<Space>  0y$
nnoremap <silent> c<Space>  0c$

nnoremap r gR
nnoremap R gr

nnoremap [cmdleader]m :<C-u>messages<CR>
nnoremap [cmdleader]d :<C-u>display<CR>

" remap far keys {{{
" TODO More like i_CTRL-a, i_CTRL-e of my hack.
nnoremap <silent> gh  ^
nnoremap <silent> gl  $

nnoremap <silent> g]  }
nnoremap <silent> g[  {

nnoremap <silent> Y y$

nnoremap <silent> +     #
nnoremap <silent> g+    g#

" Use matchit.vim % or not.
" nmap <silent> gp %
nnoremap <silent> gp %

nnoremap <silent> g; ~
" }}}
" execute most used command quickly {{{
nnoremap <silent> [cmdleader]w      :<C-u>write<CR>
nnoremap <silent> [cmdleader]q      :<C-u>quit<CR>
nnoremap <silent> [cmdleader]co     :<C-u>close<CR>
" }}}
" edit .vimrc quickly {{{
nnoremap <silent> [cmdleader]ee     :<C-u>edit<CR>
nnoremap <silent> [cmdleader]ev     :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> [cmdleader]e.     :<C-u>edit .<CR>

nnoremap <silent> [cmdleader]tt     :<C-u>tabedit<CR>
nnoremap <silent> [cmdleader]tv     :<C-u>tabedit $MYVIMRC<CR>
nnoremap <silent> [cmdleader]t.     :<C-u>tabedit .<CR>

nnoremap <silent> [cmdleader]sv     :<C-u>source $MYVIMRC<CR>
" }}}
" cmdwin {{{
set cedit=<C-z>
func! s:cmdwin_enter()
    inoremap <buffer> <C-z>         <C-c>
    nnoremap <buffer> <C-z>         <C-c>
    nnoremap <buffer> <Esc>         :<C-u>quit<CR>
    nnoremap <buffer> <C-w>k        :<C-u>quit<CR>
    nnoremap <buffer> <C-w><C-k>    :<C-u>quit<CR>

    startinsert!
endfunc
MyAutocmd CmdwinEnter * call s:cmdwin_enter()

let loaded_cmdbuf = 1
nnoremap g: q:
nnoremap g/ q/
nnoremap g? q?
" }}}
" walking between tabs {{{
nnoremap <silent> <C-n>         gt
nnoremap <silent> <C-p>         gT
nnoremap <silent> <C-g><C-n>    :<C-u>tablast<CR>
nnoremap <silent> <C-g><C-p>    :<C-u>tabfirst<CR>
" }}}
" moving tabs {{{
nnoremap <silent> <Left>    :<C-u>execute 'tabmove' tabpagenr() - 2<CR>
nnoremap <silent> <Right>   :<C-u>execute 'tabmove' tabpagenr()<CR>
" NOTE: gVim only
nnoremap <silent> <S-Left>  :<C-u>execute 'tabmove' 0<CR>
nnoremap <silent> <S-Right> :<C-u>execute 'tabmove' tabpagenr('$')<CR>
" }}}
" walk between windows {{{
" NOTE: gVim only
nnoremap <silent> <M-j>     <C-w>j
nnoremap <silent> <M-k>     <C-w>k
nnoremap <silent> <M-h>     <C-w>h
nnoremap <silent> <M-l>     <C-w>l
" }}}
" open <cfile> {{{
nnoremap <silent> gf :<C-u>call <SID>open_cfile()<CR>

func! s:open_cfile() "{{{
    let option = {
    \   'buffer': 'edit <cfile>',
    \   'window': 'Split <cfile>',
    \   'tab'   : 'tabedit <cfile>',
    \}
    let choice = prompt#prompt("open with...", {
    \   'menu': keys(option),
    \   'one_char': 1,
    \   'escape': 1,
    \})
    if has_key(option, choice)
        execute option[choice]
    endif
endfunc "}}}
" }}}
" toggle options {{{
func! s:toggle_option(option_name) "{{{
    if exists('&' . a:option_name)
        execute 'setlocal' a:option_name . '!'
        execute 'setlocal' a:option_name . '?'
    endif
endfunc "}}}

nnoremap <silent> [cmdleader]oh :<C-u>call <SID>toggle_option('hlsearch')<CR>
nnoremap <silent> [cmdleader]oi :<C-u>call <SID>toggle_option('ignorecase')<CR>
nnoremap <silent> [cmdleader]op :<C-u>call <SID>toggle_option('paste')<CR>
nnoremap <silent> [cmdleader]ow :<C-u>call <SID>toggle_option('wrap')<CR>
nnoremap <silent> [cmdleader]oe :<C-u>call <SID>toggle_option('expandtab')<CR>
nnoremap <silent> [cmdleader]ol :<C-u>call <SID>toggle_option('list')<CR>
nnoremap <silent> [cmdleader]om :<C-u>call <SID>toggle_option('modeline')<CR>

" Select coding style. {{{
"
" These settings is only about tab.
" See the followings for the details:
"   http://www.jukie.net/bart/blog/vim-and-linux-coding-style
"   http://yuanjie-huang.blogspot.com/2009/03/vim-in-gnu-coding-style.html
"   http://en.wikipedia.org/wiki/Indent_style
" But wikipedia is dubious, I think :(

let s:coding_styles = {}
let s:coding_styles['My style']      = 'set expandtab   tabstop=4 shiftwidth=4 softtabstop&'
let s:coding_styles['Short indent']  = 'set expandtab   tabstop=2 shiftwidth=2 softtabstop&'
let s:coding_styles['GNU']           = 'set expandtab   tabstop=8 shiftwidth=2 softtabstop=2'
let s:coding_styles['BSD']           = 'set noexpandtab tabstop=8 shiftwidth=4 softtabstop&'    " XXX
let s:coding_styles['Linux']         = 'set noexpandtab tabstop=8 shiftwidth=8 softtabstop&'

command!
\   -bar -nargs=1 -complete=customlist,s:coding_style_complete
\   CodingStyle
\   execute get(s:coding_styles, <f-args>, '')

function! s:coding_style_complete(...) "{{{
    return keys(s:coding_styles)
endfunction "}}}


nnoremap <silent> [cmdleader]ot :<C-u>call <SID>toggle_tab_options()<CR>

function! s:toggle_tab_options() "{{{
    let choice = prompt#prompt('Which do you prefer?:', {
    \   'one_char': 1,
    \   'menu': keys(s:coding_styles),
    \   'escape': 1,
    \})
    execute get(s:coding_styles, choice, '')
endfunction "}}}
" }}}


" FIXME: Bad name :(
command!
\   -bar
\   OptInit
\   call s:optinit()
function! s:optinit() "{{{
    set hlsearch ignorecase nopaste wrap expandtab list modeline
    echo 'Initialized frequently toggled options.'
endfunction "}}}

nnoremap <silent> [cmdleader]OI :<C-u>OptInit<CR>


silent OptInit
" }}}
" close help/quickfix window {{{
" via kana's vimrc.

function! s:get_windows_nr_like(expr) "{{{
    let ret = []
    let winnr = 1
    while winnr <= winnr('$')
        let bufnr = winbufnr(winnr)
        if eval(a:expr)
            call add(ret, winnr)
        endif
        let winnr = winnr + 1
    endwhile
    return ret
endfunction "}}}

function! s:move_current_winnr_to_head(winnr_list) "{{{
    let winnr_list = a:winnr_list
    let curwinnr = winnr()
    let counter = 0
    while s:has_idx(winnr_list, counter)
        let nr = winnr_list[counter]
        if curwinnr ==# nr
            call remove(winnr_list, counter)
            return [nr] + winnr_list
        endif
        let counter += 1
    endwhile
    return winnr_list
endfunction "}}}

function! s:close_first_window_like(expr) "{{{
    let winnr_list = s:get_windows_nr_like(a:expr)
    " Close current window if current matches a:expr.
    let winnr_list = s:move_current_winnr_to_head(winnr_list)
    if empty(winnr_list)
        return
    endif

    let prev_winnr = winnr()
    try
        for winnr in winnr_list
            call s:close_window(winnr)
            return 1    " closed.
        endfor
        return 0
    finally
        " Back to previous window.
        let cur_winnr = winnr()
        if cur_winnr !=# prev_winnr && winbufnr(prev_winnr) !=# -1
            execute prev_winnr . 'wincmd w'
        endif
    endtry
endfunction "}}}

function! s:winexists(winnr) "{{{
    return winbufnr(a:winnr) !=# -1
endfunction "}}}

function! s:close_window(winnr) "{{{
    if s:winexists(a:winnr)
        execute a:winnr . 'wincmd w'
        execute 'wincmd c'
        return 1
    else
        return 0
    endif
endfunction "}}}


function! s:close_help_window() "{{{
    return s:close_first_window_like('s:is_help_window(winnr)')
endfunction "}}}
function! s:is_help_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'help'
endfunction "}}}

function! s:close_quickfix_window() "{{{
    return s:close_first_window_like('s:is_quickfix_window(winnr)')
endfunction "}}}
function! s:is_quickfix_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'quickfix'
endfunction "}}}

function! s:close_ref_window() "{{{
    return s:close_first_window_like('s:is_ref_window(winnr)')
endfunction "}}}
function! s:is_ref_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&filetype') ==# 'ref'
endfunction "}}}

let s:in_cmdwin = 0
MyAutocmd CmdwinEnter * let s:in_cmdwin = 1
MyAutocmd CmdwinLeave * let s:in_cmdwin = 0
function! s:close_cmdwin_window() "{{{
    if s:in_cmdwin
        quit
        return 1
    else
        return 0
    endif
endfunction "}}}
function! s:is_cmdwin_window(winnr) "{{{
    return s:in_cmdwin
endfunction "}}}


function! s:close_certain_window() "{{{
    " Close current.
    let curwinnr = winnr()
    for pred_fn in [
    \   's:is_cmdwin_window',
    \   's:is_help_window',
    \   's:is_quickfix_window',
    \   's:is_ref_window',
    \]
        if {pred_fn}(curwinnr)
            call s:close_window(curwinnr)
            return
        endif
    endfor

    " Or close outside buffer.
    for close_fn in [
    \   's:close_cmdwin_window',
    \   's:close_help_window',
    \   's:close_quickfix_window',
    \   's:close_ref_window'
    \]
        if {close_fn}()
            return 1
        endif
    endfor
endfunction "}}}


nnoremap <silent> [cmdleader]ch :<C-u>call <SID>close_help_window()<CR>
nnoremap <silent> [cmdleader]ck :<C-u>call <SID>close_quickfix_window()<CR>
nnoremap <silent> [cmdleader]cr :<C-u>call <SID>close_ref_window()<CR>
nnoremap <silent> [cmdleader]cc :<C-u>call <SID>close_certain_window()<CR>
" }}}
" move window into tabpage {{{
" http://vim-users.jp/2009/12/hack106/
"
function! s:move_window_into_tab_page(target_tabpagenr) "{{{
  " Move the current window into a:target_tabpagenr.
  " If a:target_tabpagenr is 0, move into new tab page.
  if a:target_tabpagenr < 0  " ignore invalid number.
    return
  endif
  let original_tabnr = tabpagenr()
  let target_bufnr = bufnr('')
  let window_view = winsaveview()

  if a:target_tabpagenr == 0
    tabnew
    tabmove  " Move new tabpage at the last.
    execute target_bufnr 'buffer'
    let target_tabpagenr = tabpagenr()
  else
    execute a:target_tabpagenr 'tabnext'
    let target_tabpagenr = a:target_tabpagenr
    topleft new  " FIXME: be customizable?
    execute target_bufnr 'buffer'
  endif
  call winrestview(window_view)

  execute original_tabnr 'tabnext'
  if 1 < winnr('$')
    close
  else
    enew
  endif

  execute target_tabpagenr 'tabnext'
endfunction " }}}

" move current buffer into a new tab.
nnoremap <silent> [cmdleader]mt :<C-u>call <SID>move_window_into_tab_page(0)<Cr>
" }}}
" netrw - vimperator-like keymappings {{{
function! s:filetype_netrw() "{{{
    nmap     <buffer> gu -
endfunction " }}}

MyAutocmd FileType netrw call s:filetype_netrw()
" }}}
" }}}
" map! {{{
noremap! <C-f>   <Right>
noremap! <C-b>   <Left>
noremap! <C-a>   <Home>
noremap! <C-e>   <End>
noremap! <C-d>   <Del>
noremap! <C-l>   <Tab>

silent Arpeggio noremap! $( ()<Left>
silent Arpeggio noremap! 4[ []<Left>
silent Arpeggio noremap! $< <><Left>
silent Arpeggio noremap! ${ {}<Left>

silent Arpeggio noremap! $' ''<Left>
silent Arpeggio noremap! *" ""<Left>
silent Arpeggio noremap! $` ``<Left>

silent Arpeggio noremap! $) \(\)<Left><Left>
silent Arpeggio noremap! 4] \[\]<Left><Left>
silent Arpeggio noremap! $> \<\><Left><Left>
silent Arpeggio noremap! $} \{\}<Left><Left>

silent Arpeggio noremap! #( 「」<Left>
silent Arpeggio noremap! 3[ 『』<Left>
silent Arpeggio noremap! #< 【】<Left>
silent Arpeggio noremap! #{ 〔〕<Left>
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

" shift left (indent)
inoremap <C-q>   <C-d>

" make <C-w> and <C-u> undoable.
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

inoremap <C-@> <C-a>

inoremap <S-CR> <C-o>O
inoremap <C-CR> <C-o>o

" completion {{{

silent Arpeggio inoremap qn    <C-n>
silent Arpeggio inoremap qp    <C-p>
silent Arpeggio inoremap xn    <C-x><C-n>
silent Arpeggio inoremap xp    <C-x><C-p>
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : <SID>complete(1)
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : <SID>complete(0)

" This was originally from kana's hack <SID>keys_to_complete().
func! s:complete(next) "{{{
    " TODO Get all items.
    if &l:filetype ==# 'vim'
        return "\<C-x>\<C-v>"
    elseif strlen(&l:omnifunc)
        return "\<C-x>\<C-o>"
    elseif strlen(&l:completefunc)
        return "\<C-x>\<C-u>"
    " elseif strlen(&l:dictionary)
    "     return "\<C-x>\<C-k>"
    else
        return a:next ? "\<C-n>" : "\<C-p>"
    endif
endfunc "}}}
" }}}
" go to head, or tail. {{{
inoremap <expr> <C-a> <SID>goto_head()
func! s:goto_head() "{{{
    let col = col('.')
    let lnum = line('.')
    let tilda_col = match(getline(lnum), '\S') + 1

    if col > tilda_col
        " go to ^ pos.
        return "\<C-o>^"
    else
        " go to head.
        return "\<Home>"
    endif
endfunc "}}}

inoremap <expr> <C-e> <SID>goto_tail()
func! s:goto_tail() "{{{
    let col = col('.')
    let lnum = line('.')
    let tilda_col = match(getline(lnum), '\S') + 1

    if col < tilda_col
        " go to ^ pos.
        return "\<C-o>^"
    else
        " go to tail.
        return "\<End>"
    endif
endfunc "}}}
" }}}
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

cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'
" }}}
" abbr {{{
inoreab <expr> date@      strftime("%Y-%m-%d")
inoreab <expr> time@      strftime("%H:%M")
inoreab <expr> dt@        strftime("%Y-%m-%d %H:%M")

call altercmd#load()
AlterCommand th     tab<Space>help
AlterCommand t      tabedit
AlterCommand qw     wq
AlterCommand sf     setf
" }}}

" indent/dedent {{{
nnoremap g, <<
nnoremap g. >>
vnoremap g, <
vnoremap g. >
" }}}

" Mappings with option value. {{{

func! s:generate_assign_fn(dict) "{{{
    let assign_fn = values(map(a:dict, "printf('let &l:%s = %s', v:key, string(v:val))"))
    return empty(assign_fn) ? '' : ":\<C-u>" . join(assign_fn, '|') . "\<CR>"
endfunc "}}}

func! s:do_nmap_with(cmd, beforeopt, afteropt) "{{{
    return
    \   printf('%s%s%s',
    \       s:generate_assign_fn(a:beforeopt),
    \       a:cmd,
    \       s:generate_assign_fn(a:afteropt))
endfunc "}}}

func! s:do_nmap_before(cmd, beforeopt) "{{{
    return s:do_nmap_with(a:cmd, a:beforeopt, {})
endfunc "}}}

func! s:do_nmap_after(cmd, afteropt) "{{{
    return s:do_nmap_with(a:cmd, {}, a:afteropt)
endfunc "}}}

nnoremap <expr> / <SID>do_nmap_before('/', {'hlsearch': 1})
nnoremap <expr> ? <SID>do_nmap_before('?', {'hlsearch': 1})

nnoremap <silent><expr> * <SID>do_nmap_before('*', {'hlsearch': 1, 'ignorecase': 0})
nnoremap <silent><expr> + <SID>do_nmap_before('#', {'hlsearch': 1, 'ignorecase': 0})

nnoremap <expr> : <SID>do_nmap_before(':', {'ignorecase': 1})
" TODO
" vnoremap <expr> : <SID>do_vmap_before(':', {'ignorecase': 1})
" }}}

" Emacs like kill-line. {{{
inoremap <expr> <C-k>  (col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" }}}

" Make searching directions consistent {{{
  " 'zv' is harmful for Operator-pending mode and it should not be included.
  " For example, 'cn' is expanded into 'cnzv' so 'zv' will be inserted.
nnoremap <expr> n  <SID>search_forward_p() ? 'nzv' : 'Nzv'
nnoremap <expr> N  <SID>search_forward_p() ? 'Nzv' : 'nzv'
vnoremap <expr> n  <SID>search_forward_p() ? 'nzv' : 'Nzv'
vnoremap <expr> N  <SID>search_forward_p() ? 'Nzv' : 'nzv'
onoremap <expr> n  <SID>search_forward_p() ? 'n' : 'N'
onoremap <expr> N  <SID>search_forward_p() ? 'N' : 'n'

function! s:search_forward_p()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction
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
command!
\   HelpTagAll
\   call s:HelpTagAll()

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
" LcdCurrent, CdCurrent {{{
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

AlterCommand ack Ack
command!
\   -bar -nargs=+
\   Ack
\   call s:ack(<f-args>)
" }}}
" SetTitle {{{
command! -nargs=+ SetTitle
\   let &titlestring = <q-args>
" }}}
" EchoPath {{{

AlterCommand ept EchoPath
AlterCommand rtp EchoPath<Space>rtp

command!
\   -nargs=+ -complete=option
\   EchoPath
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
        if &l:readonly && a:0 == 0
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
"
" TODO

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
" Expand {{{
command!
\   -nargs=?
\   Expand
\   echo expand(<q-args> != '' ? <q-args> : '%:p')

AlterCommand ep Expand
" }}}
" Has {{{
AlterCommand has Has

command!
\   -bar -nargs=1
\   Has
\   echo has(<q-args>)
" }}}
" ExMode, ExModeInteractive {{{
command!
\   ExMode
\   call feedkeys('Q', 'n')
command!
\   ExModeInteractive
\   call feedkeys('gQ', 'n')

AlterCommand ex     ExMode
AlterCommand exi    ExModeInteractive
" }}}

" ...Mode {{{
" NoremapMode {{{

" TODO
" - submode
" - feedkeys()
" - Save and clear all mappings. Restore before leaving.

command!
\   -bar
\   NoremapMode
\   call s:mode_noremap()

nmap <expr> <SID>(mode-noremap) <SID>mode_noremap()
nmap <expr> <SID>(mode-noremap-feedkeys) <SID>mode_noremap_feedkeys()

let s:mode_noremap_keys = ''

func! s:mode_noremap() "{{{
    let c = s:getchar()
    if c == "\<Esc>"
        return ''
    else
        let s:mode_noremap_feedkeys = c
        call s:mode_noremap_feedkeys()
        return "\<SID>(mode-noremap)"
    endif
endfunc "}}}

func! s:mode_noremap_feedkeys() "{{{
    call feedkeys(s:mode_noremap_feedkeys, 'n')
    return ''
endfunc "}}}
" }}}
"}}}

" TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
AlterCommand cd  TabpageCD
nnoremap <silent> [subleader]cd   :TabpageCD %:p:h<CR>

command! -complete=dir -nargs=? TabpageCD
\   execute 'cd' fnameescape(expand(<q-args>))
\ | let t:cwd = getcwd()

MyAutocmd TabEnter *
\   if !exists('t:cwd')
\ |   let t:cwd = getcwd()
\ | endif
\ | execute 'cd' fnameescape(expand(t:cwd))
" }}}
" s:split_nicely_with() {{{
AlterCommand sp[lit]    Split
AlterCommand h[elp]     Help
AlterCommand new        New

command!
\   -bar -nargs=* -complete=file
\   Split
\   call s:split_nicely_with('split', <f-args>)

command!
\   -bar -nargs=* -complete=help
\   Help
\   call s:split_nicely_with('help', <f-args>)

command!
\   -bar -nargs=* -complete=file
\   New
\   call s:split_nicely_with('new', <f-args>)


function! s:vertically()
    return 80*2 * 15/16 <= winwidth(0)  " FIXME: threshold customization
endfunction

" Originally from kana's s:split_nicely().
function! s:split_nicely_with(...)
    if s:vertically()
        execute 'vertical' join(a:000, ' ')
    else
        execute join(a:000, ' ')
    endif
endfunction
" }}}
" SelectColorScheme {{{
" via http://gist.github.com/314439
" via http://gist.github.com/314597
fun! s:SelectColorScheme()
  30vnew

  let files = split(globpath(&rtp, 'colors/*.vim'), "\n")
  for idx in range(0, len(files) - 1)
    let file = files[idx]
    let name = matchstr(file , '\w\+\(\.vim\)\@=')
    call setline(idx + 1, name)
  endfor

  file ColorSchemeSelector
  setlocal bufhidden=wipe
  setlocal buftype=nofile
  setlocal nonu
  setlocal nomodifiable
  setlocal cursorline
  nmap <buffer>  <Enter>  :<C-u>exec 'colors' getline('.')<CR>
  nmap <buffer>  q        :<C-u>close<CR>
endf
com! SelectColorScheme   :cal s:SelectColorScheme()
" }}}
" Grep {{{
" http://vim-users.jp/2010/03/hack130/
" http://webtech-walker.com/archive/2010/03/17093357.html
AlterCommand gr[ep] Grep

command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
function! s:grep(args)
    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
    execute 'vimgrep' '/' . a:args[0] . '/j ' . target
    if len(getqflist()) != 0 | copen | endif
endfunction
" }}}
" }}}
" For Plugins {{{
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
let g:nf_include_dotfiles = 1    " don't skip dotfiles
let g:nf_loop_files = 1    " loop at the end of file
let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']
" }}}
" vimtemplate {{{
let g:vt_mapping = '[subleader]vt'
let g:vt_command = ''
let g:vt_template_dir_path = expand("~/.vim/template")
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
" skk {{{
let skk_jisyo = '~/.skk-jisyo'
let skk_large_jisyo = '/usr/share/skk/SKK-JISYO'

let skk_control_j_key = '<C-j>'
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
" eskk {{{
let g:eskk_debug = 1
let g:eskk_debug_wait_ms = 0

let g:eskk_no_default_mappings = 1
map! <C-g><C-j> <Plug>(eskk-toggle)
lmap ;      <Plug>(eskk-sticky-key)

" let g:eskk_no_default_mappings = 1
" Arpeggio map! fj <Plug>(eskk-enable)
" Arpeggio lmap fk <Plug>(eskk-disable)
" lmap ;      <Plug>(eskk-sticky-key)

" }}}
" stickykey {{{

" I use stickykey for emergency use.
" So these mappings are little bit difficult to press, but I don't care.

map  <C-g><C-s> <Plug>(stickykey-shift-remap)
map! <C-g><C-s> <Plug>(stickykey-shift-remap)
lmap <C-g><C-s> <Plug>(stickykey-shift-remap)

map  <C-g><C-c> <Plug>(stickykey-ctrl-remap)
map! <C-g><C-c> <Plug>(stickykey-ctrl-remap)
lmap <C-g><C-c> <Plug>(stickykey-ctrl-remap)

map  <C-g><C-a> <Plug>(stickykey-alt-remap)
map! <C-g><C-a> <Plug>(stickykey-alt-remap)
lmap <C-g><C-a> <Plug>(stickykey-alt-remap)

" I don't have Macintosh :(
" map  <C-g><C-m> <Plug>(stickykey-command-remap)
" map! <C-g><C-m> <Plug>(stickykey-command-remap)
" lmap <C-g><C-m> <Plug>(stickykey-command-remap)
" }}}
" restart {{{
AlterCommand res[tart] Restart
" }}}
" submode-scroll {{{
runtime! plugin/submode/scroll.vim
call submode#enter_with(g:submode_scroll_submode_name, 'n', 'rs', s:submode_leader . 's', '<Plug>(submode-scroll-enter)')
call submode#leave_with(g:submode_scroll_submode_name, 'n', 'rs', '<Esc>')
call submode#map(g:submode_scroll_submode_name, 'n', 'rs', 'j', '<Plug>(submode-scroll-scroll-down)')
call submode#map(g:submode_scroll_submode_name, 'n', 'rs', 'k', '<Plug>(submode-scroll-scroll-up)')
call submode#map(g:submode_scroll_submode_name, 'n', 'rs', 'a', '<Plug>(submode-scroll-pace-down)')
call submode#map(g:submode_scroll_submode_name, 'n', 'rs', 's', '<Plug>(submode-scroll-pace-up)')
" }}}
" AutoDate {{{
let g:autodate_format = "%Y-%m-%d"
" }}}
" FuzzyFinder {{{
nmap     s                 [anything-leader]
nnoremap [anything-leader] <Nop>

nnoremap <silent> [anything-leader]d        :<C-u>FufDir<CR>
nnoremap <silent> [anything-leader]f        :<C-u>FufFile<CR>
nnoremap <silent> [anything-leader]h        :<C-u>FufMruFile<CR>
nnoremap <silent> [anything-leader]r        :<C-u>FufRenewCache<CR>

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
        \ '^v@' : ['~/.vim/'],
        \ '^d@' : ['~/q/diary/'],
        \ '^w@' : ['~/work/'],
        \ '^s@' : ['~/work/scratch/'],
        \ '^m@' : ['~/work/memo/'],
        \ '^g@' : ['~/work/git/'],
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
" vimshell {{{
AlterCommand vsh[ell] VimShell

let g:VimShell_EnableInteractive = 2
let g:VimShell_NoDefaultKeyMappings = 1
" }}}
" quickrun {{{
let g:quickrun_no_default_key_mappings = 1
map <Space>r <Plug>(quickrun)

let g:loaded_quicklaunch = 1

if !exists('g:quickrun_config')
    let g:quickrun_config = {}
    let g:quickrun_config.markdown = {'command' : 'pandoc'}
endif
" }}}
" submode {{{

" Moving window.
call submode#enter_with('winmove', 'n', '', s:submode_leader . 'w')
call submode#leave_with('winmove', 'n', '', '<Esc>')
call submode#map('winmove', 'n', 'r', 'j', '<Plug>(winmove-down)')
call submode#map('winmove', 'n', 'r', 'k', '<Plug>(winmove-up)')
call submode#map('winmove', 'n', 'r', 'h', '<Plug>(winmove-left)')
call submode#map('winmove', 'n', 'r', 'l', '<Plug>(winmove-right)')

" Change window size of gVim itself
call submode#enter_with('guiwinsize', 'n', '', s:submode_leader . 'W', '<Nop>')
call submode#leave_with('guiwinsize', 'n', '', '<Esc>')
call submode#map('guiwinsize', 'n', '', 'j', ':<C-u>set lines-=1<CR>')
call submode#map('guiwinsize', 'n', '', 'k', ':<C-u>set lines+=1<CR>')
call submode#map('guiwinsize', 'n', '', 'h', ':<C-u>set columns-=5<CR>')
call submode#map('guiwinsize', 'n', '', 'l', ':<C-u>set columns+=5<CR>')

call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#leave_with('undo/redo', 'n', '', '<Esc>')
call submode#map('undo/redo', 'n', '', '-', 'g-')
call submode#map('undo/redo', 'n', '', '+', 'g+')
" }}}
" prettyprint {{{
AlterCommand p      PP
AlterCommand pp     PrettyPrint
" }}}
" ref {{{
" 'K' for ':Ref'.
AlterCommand ref Ref
nnoremap <silent> gK        K
let g:ref_use_vimproc = 0
let g:ref_open = 'Split'
if executable('perldocjp')
    let g:ref_perldoc_cmd = 'perldocjp'
endif
" }}}
" chalice {{{
let chalice_bookmark = expand('$HOME/.vim/chalice.bmk')
" }}}
" indent/vim.vim {{{
let g:vim_indent_cont = 0
" }}}
" }}}
" Backup {{{
" TODO Rotate backup files like writebackupversioncontrol.vim
" (I didn't use it, though)

" Delete old files in ~/.vim/backup {{{
func! s:delete_backup()
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
    let one_day_sec = 60 * 60 * 24    " Won't delete old files many times within one day.

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

call s:delete_backup()
" }}}
" }}}
" Misc. (bundled with kaoriya vim's .vimrc & etc.) {{{
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
" about japanese input method {{{
if has('multi_byte_ime') || has('xim')
  " Cursor color when IME is on.
  highlight CursorIM guibg=Purple guifg=NONE
  set iminsert=0 imsearch=0

  if has('xim') && has('GUI_GTK')
    " XIMの入力開始キーを設定:
    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
    set imactivatekey=Henkan
  endif
endif
" }}}
" }}}


set secure
