" vim:set fen fdm=marker:
" Basic {{{
scriptencoding utf-8
set cpo&vim

syntax enable
filetype plugin indent on

language messages C
language time C
" }}}
" Utilities {{{
" Function {{{
function! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction "}}}
function! s:SNR(map) "{{{
    return printf("\<SNR>%d_%s", s:SID(), a:map)
endfunction "}}}

function! s:warn(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction "}}}
function! s:system(command, ...) "{{{
    return system(join([a:command] + map(copy(a:000), 'shellescape(v:val)'), ' '))
endfunction "}}}
function! s:glob(expr) "{{{
    return split(glob(a:expr), "\n")
endfunction "}}}
function! s:globpath(paths, expr) "{{{
    return split(globpath(a:paths, a:expr), "\n")
endfunction "}}}
function! s:getchar(...) "{{{
    let c = call('getchar', a:000)
    return type(c) == type("") ? c : nr2char(c)
endfunction "}}}
function! s:one_of(elem, list) "{{{
    if type(a:elem) == type([])
        " Same as `s:one_of(a:elem[0], a:list) || s:one_of(a:elem[1], a:list) ...`
        for i in a:elem
            if s:one_of(i, a:list)
                return 1
            endif
        endfor
        return 0
    else
        return !empty(filter(copy(a:list), 'v:val ==# a:elem'))
    endif
endfunction "}}}
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
function! s:stringf(fmt, ...) "{{{
    return call('printf', [a:fmt] + map(copy(a:000), 'string(v:val)'))
endfunction "}}}
function! s:mapf(list, fmt) "{{{
    return map(copy(a:list), "printf(a:fmt, v:val)")
endfunction "}}}
function! s:string_pp(val) "{{{
    return string(a:val)    " TODO Pretty print
endfunction "}}}
function! s:each_char(str) "{{{
    return split(a:str, '\zs')
endfunction "}}}


" For mappings
function! s:execute_multiline_expr(excmds, ...) "{{{
    let expr = join(s:mapf(copy(a:excmds), ":\<C-u>%s\<CR>"), '')
    if a:0 == 0
        echo join(s:mapf(copy(a:excmds), ':<C-u>%s<CR>'), '')
    else
        echo a:1
    endif
    return expr
endfunction "}}}
function! s:execute_multiline(excmds, ...) "{{{
    " XXX: This depends on :execute's behavior
    " that it executes each line separated by "\<CR>".
    " Is it specified?
    execute call('s:execute_multiline_expr', [a:excmds] + a:000)
endfunction "}}}

function! s:get_tilde_col(lnum) "{{{
    return match(getline(a:lnum), '\S') + 1
endfunction "}}}
function! s:at_right_of_tilde_col() "{{{
    return col('.') > s:get_tilde_col('.')
endfunction "}}}
function! s:at_left_of_tilde_col() "{{{
    return col('.') < s:get_tilde_col('.')
endfunction "}}}

function! s:map_leader(key) "{{{
    let g:mapleader = a:key
    nnoremap <Leader> <Nop>
endfunction "}}}
function! s:map_localleader(key) "{{{
    let g:maplocalleader = a:key
    nnoremap <LocalLeader> <Nop>
endfunction "}}}
function! s:map_prefix_key(modes, prefix_name, prefix_key) "{{{
    let named_map = printf('<SID>[%s]', a:prefix_name)
    let prefix    = a:prefix_key
    for m in s:each_char(a:modes)
        execute printf('%snoremap %s    <Nop>', m, named_map)
        " remap for named map.
        execute printf('%smap     %s    %s', m, prefix, named_map)
        " pressing prefix key twice is same as pressing prefix key.
        " execute printf('%snoremap %s%s  %s', m, prefix, prefix, prefix)
    endfor
endfunction "}}}
function! s:map_orig_key(modes, key) "{{{
    for m in s:each_char(a:modes)
        execute printf('%snoremap <SID>[orig]%s %s', m, a:key, a:key)
    endfor
endfunction "}}}

function! s:with_options(cmd, opt) "{{{
    for [name, value] in items(a:opt)
        call setbufvar('%', name, value)
    endfor
    return a:cmd
endfunction "}}}

function! s:do_excmd(...) "{{{
    for ex in a:000
        execute ex
    endfor
    return ''
endfunction "}}}


" Error
function! s:assertion_failure(msg) "{{{
    return 'assertion failure: ' . a:msg
endfunction "}}}
" }}}
" Commands {{{
augroup vimrc
    autocmd!
augroup END

command!
\   -bang -nargs=*
\   MyAutocmd
\   autocmd<bang> vimrc <args>


" Debug macros {{{
"
" NOTE: Do not make this function.
" Evaluate arguments at same scope.
"
" I was confused as if I wrote C macro

" :VarDump
command!
\   -bang -nargs=+ -complete=expression
\   VarDump
\
\   echohl Debug
\   | echomsg join(map([<f-args>], 'printf("  %s = %s", v:val, s:string_pp(eval(v:val)))'), ', ')
\   | if <bang>0
\   |   try
\   |     throw ''
\   |   catch
\   |     ShowStackTrace
\   |   endtry
\   | endif
\   | echohl None


" :ShowStackTrace
command!
\   -bar -bang
\   ShowStackTrace
\
\   echohl Debug
\   | if <bang>0
\   |   echom printf('[%s] at [%s]', v:exception, v:throwpoint)
\   | else
\   |   echom printf('[%s]', v:throwpoint)
\   | endif
\   | echohl None


" :Assert
command!
\   -nargs=+
\   Assert
\
\   if !eval(<q-args>)
\   |   throw s:assertion_failure(<q-args>)
\   | endif


" :Decho
command!
\   -nargs=+
\   Decho
\
\   echohl Debug
\   | echomsg <args>
\   | echohl None
" }}}
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
    set tags+=.;
endif
set showfulltag
set notagbsearch

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
" function! Dir()
"     let d = fnamemodify(getcwd(), ':~')
"     let d = substitute(d, '\/$', '', '')
"     return d
" endfunction

" tab
set showtabline=2
let &tabline     = '%{tabpagenr()}. [%{expand("%:t")}] - %{&fenc},%{&ff}'
let &guitablabel = '%{tabpagenr()}. [%{expand("%:t")}] - %{&fenc},%{&ff}'

" statusline
set laststatus=2
let &statusline = '[%{&ft}] [%l/%L]%( [%M%R%H%W]%)'
"let &statusline .= '/(%{eskk#get_mode()})'

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
" set debug=beep

" restore screen
set norestorescreen
set t_ti=
set t_te=

" timeout
set notimeout

" fillchars
set fillchars=stl:\ ,stlnc::,vert:\ ,fold:-,diff:-

" cursor behavior in insertmode
set whichwrap=b,s
set backspace=indent,eol,start
set formatoptions=mMcroqnl2

" fold
set foldenable
" set foldmethod=marker

" misc.
set diffopt=filler,vertical
set helplang=ja,en
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

" colorscheme (on windows, setting colorscheme in .vimrc does not work)
MyAutocmd VimEnter * set bg=dark | colorscheme desert

" open on read-only if swap exists
MyAutocmd SwapExists * let v:swapchoice = 'o'

" autocmd CursorHold,CursorHoldI *   silent! update
MyAutocmd QuickfixCmdPost * QuickFix

" InsertLeave, InsertEnter
MyAutocmd InsertLeave * setlocal nocursorline
MyAutocmd InsertEnter * setlocal cursorline ignorecase

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
MyAutocmd FileType rb
            \ setlocal ft=ruby
MyAutocmd FileType scm
            \ setlocal ft=scheme

" delete autocmd for ft=mkd.
MyAutocmd VimEnter * autocmd! filetypedetect BufNewFile,BufRead *.md
" }}}
" }}}
" Initializing {{{

" runtimepath {{{
set runtimepath&

if has("win32")
    set runtimepath+=$HOME/.vim
endif


function! s:is_action(name) "{{{
    return s:get_action(a:name) !=# -1
endfunction "}}}
function! s:get_action(name) "{{{
    let action = {
    \   'shift'   : 'let &rtp = join(split(&rtp, ",")[1:], ",")',
    \   'pop'     : 'let &rtp = join(split(&rtp, ",")[:-2], ",")',
    \   'unshift' : 'let &rtp = join(s:glob(path) + split(&rtp, ","), ",")',
    \   'push'    : 'let &rtp = join(split(&rtp, ",") + s:glob(path), ",")',
    \   'clear'   : 'let &rtp = ""',
    \   'finish'  : 'return',
    \}
    return get(action, a:name, -1)
endfunction "}}}
function! s:add_rtp_from_file(file) "{{{
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
endfunction "}}}
call s:add_rtp_from_file('~/.vimruntimepath.lst')
" }}}


call emap#load()
call emap#set_sid(s:SID())
" call emap#set_sid_from_sfile(expand('<sfile>'))
" call emap#set_pragmas('ignore-spaces')

let g:arpeggio_timeoutlen = 40
call arpeggio#load()

call altercmd#load()
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
function! ChangeEncoding()
    if expand('%') == ''
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
endfunction

nnoremap <SID>[comma]ta     :call ChangeEncoding()<CR>
" }}}
" set fenc=... {{{
function! ChangeFileEncoding()
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
endfunction

nnoremap <SID>[comma]ts    :<C-u>call ChangeFileEncoding()<CR>
" }}}
" set ff=... {{{
function! ChangeNL()
    let result = prompt#prompt("changing newline format to...", {
                \ 'menu': ['dos', 'unix', 'mac'],
                \ 'one_char': 1,
                \ 'escape': 1,
                \ 'execute_if': 'val != ""',
                \ 'executef': 'set ff=%s'})
    if result !=# "\e"
        echomsg printf("changing newline format to '%s'.", result)
    endif
endfunction

nnoremap <SID>[comma]td    :<C-u>call ChangeNL()<CR>
" }}}
" }}}
" FileType {{{
function! s:each_filetype() "{{{
    return split(&l:filetype, '\.')
endfunction "}}}

" TODO: Write 'operator-camel' and camelize these functions.
" s:SetDict {{{
function! s:SetDict()
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
endfunction
" }}}
" s:SetTabWidth {{{
function! s:SetTabWidth()
    if s:one_of(s:each_filetype(), ['css', 'xml', 'html', 'lisp', 'scheme', 'yaml'])
        CodingStyle Short indent
    else
        CodingStyle My style
    endif
endfunction
" }}}
" s:SetCompiler {{{
function! s:SetCompiler()
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
endfunction
" }}}
" s:LoadWhenFileType() {{{
function! s:LoadWhenFileType()
    if &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
    endif

    call s:SetDict()
    call s:SetTabWidth()
    call s:SetCompiler()
endfunction "}}}

MyAutocmd FileType *   call s:LoadWhenFileType()
" }}}
" Mappings and/or Abbreviations {{{


" TODO
"
" MapOriginal:
"   MapOriginal j
"   MapOriginal k
"
" MapPrefix:
"   MapPrefix [n] prefix_name rhs
"
" MapLeader:
"   MapLeader ;
"
" MapLocalLeader:
"   MapLocalLeader ,
"
" MapOp:
"   " Map [nvo] lhs rhs
"   MapOp lhs rhs
"
" MapMotion:
"   " Map [nvo] lhs rhs
"   MapMotion lhs rhs
"
" MapObject:
"   " Map [vo] lhs rhs
"   MapObject lhs rhs
"
" DisableMap:
"   " Map [n] $ <Nop>
"   " Map [n] % <Nop>
"   " .
"   " .
"   " .
"   DisableMap [n] $ % & ' ( ) ^



" TODO Do not clear mappings set by plugins.
" mapclear
" mapclear!
" " mapclear!!!!
" lmapclear



" Define frequently used mapping sequences.
DefMap [nvo] -noremap clipboard "+
DefMap [nvo] -noremap primary   "*
DefMap [nvo] -noremap blackhole "_
DefMap [nvo] -noremap delete-char x
DefMap [nvo] -noremap delete* d

" Set up prefix keys. {{{

" [orig]
call s:map_prefix_key('n', 'orig', 'q')
call s:map_orig_key('n', 'q')
" <Leader>
call s:map_leader(';')
" <LocalLeader>
call s:map_localleader('\')
" [comma]
call s:map_prefix_key('n', 'comma', ',')
" [excmd]
call s:map_prefix_key('n', 'excmd', '<Space>')
" }}}

" map {{{
" operator {{{

call emap#set_pragmas('ignore-spaces') "{{{

" paste to clipboard
Map [nvo] -noremap <Leader>y     <clipboard> y
Map [nvo] -noremap <SID>[comma]y <primary>   y
Map [nvo] -noremap <Leader>d     <clipboard> d
Map [nvo] -noremap <SID>[comma]d <primary>   d

" do not destroy noname register.
Map [nvo] x        <blackhole> <delete-char>
Map [nvo] <Space>d <blackhole> <delete*>

call emap#unset_pragmas('ignore-spaces')    " end.
" }}}

Map [nvo] -noremap <Leader>e =

" operator-... for ex command {{{
" from :help operator-user
let s:op_command_command = ''

function! Set_op_command(command)
    let s:op_command_command = a:command
endfunction

function! Op_command(motion_wiseness)
    execute "'[,']" s:op_command_command
endfunction
" }}}
" operator-sort {{{
Map [nvo] <Leader>s <Plug>(operator-sort)

call operator#user#define('sort', 'Op_command',
\                         'call Set_op_command("sort")')
" }}}
" operator-retab {{{
Map [nvo] <Leader>t <Plug>(operator-retab)

call operator#user#define('retab', 'Op_command',
\                         'call Set_op_command("retab")')
" }}}
" operator-join {{{
Map [nvo] <Leader>j <Plug>(operator-join)

call operator#user#define('join', 'Op_command',
\                         'call Set_op_command("join")')
" }}}
" operator-uniq {{{
Map [nvo] <Leader>u <Plug>(operator-uniq)

call operator#user#define('uniq', 'Op_command',
\                         'call Set_op_command("sort u")')
" }}}
" operator-narrow {{{
Map [nvo]          <Leader>na <Plug>(operator-narrow)
Map [nvo] -noremap <Leader>nw :<C-u>Widen<CR>

call operator#user#define('narrow', 'Op_command',
\                         'call Set_op_command("Narrow")')

let g:narrow_allow_overridingp = 1
" }}}
" operator-replace {{{
Map [nvo] <Leader>r  <Plug>(operator-replace)
" }}}
" }}}
" motion/textobj {{{
Map [nvo] -noremap j gj
Map [nvo] -noremap k gk
call s:map_orig_key('nvo', 'j')
call s:map_orig_key('nvo', 'k')

Map [nvo] -noremap ]k :<C-u>call search('^\S', 'Ws')<CR>
Map [nvo] -noremap [k :<C-u>call search('^\S', 'Wsb')<CR>

Map [vo] iF <Plug>(textobj-fold-i)
Map [vo] aF <Plug>(textobj-fold-a)

Map [nvo] -noremap gp %

Map [vo] -noremap aa a>
Map [vo] -noremap ia i>
Map [vo] -noremap ar a]
Map [vo] -noremap ir i]
" }}}
" }}}
" nmap {{{
" open only current line's fold.
Map [n] -noremap z<Space> zMzvzz

" folding mappings easy to remember.
Map [n] -noremap zl zo
Map [n] -noremap zh zc

Map [n] -noremap d<Space> 0d$
Map [n] -noremap y<Space> 0y$
Map [n] -noremap c<Space> 0c$

" http://vim-users.jp/2009/08/hack57/
Map [n] -noremap d<CR> :<C-u>call append(expand('.'), '')<CR>j
Map [n] -noremap c<CR> :<C-u>call append(expand('.'), '')<CR>jI

Map [n] -noremap <SID>[excmd]me :<C-u>messages<CR>
Map [n] -noremap <SID>[excmd]di :<C-u>display<CR>

Map [n] -noremap g; ~

Map [n] -noremap    + <C-a>
Map [n] -noremap -- - <C-x>

" execute most used command quickly {{{
Map [n] -noremap <SID>[excmd]w      :<C-u>write<CR>
Map [n] -noremap <SID>[excmd]q      :<C-u>quit<CR>
Map [n] -noremap <SID>[excmd]co     :<C-u>close<CR>
Map [n] -noremap <SID>[excmd]h      :<C-u>hide<CR>
" }}}
" edit .vimrc quickly {{{
Map [n] -noremap <SID>[excmd]ee     :<C-u>edit<CR>
Map [n] -noremap <SID>[excmd]ev     :<C-u>edit $MYVIMRC<CR>
Map [n] -noremap <SID>[excmd]e.     :<C-u>edit .<CR>

Map [n] -noremap <SID>[excmd]tt     :<C-u>tabedit<CR>
Map [n] -noremap <SID>[excmd]tv     :<C-u>tabedit $MYVIMRC<CR>
Map [n] -noremap <SID>[excmd]t.     :<C-u>tabedit .<CR>

Map [n] -noremap -expr <SID>[excmd]sv <SID>execute_multiline_expr(['source $MYVIMRC', 'setfiletype vim'], ':source $MYVIMRC')
" }}}
" cmdwin {{{
set cedit=<C-z>
function! s:cmdwin_enter()
    Map [ni] -noremap -buffer <C-z>         <C-c>
    Map [ni] -noremap -buffer <C-z>         <C-c>
    Map [n]  -noremap -buffer <Esc>         :<C-u>quit<CR>
    Map [n]  -noremap -buffer <C-w>k        :<C-u>quit<CR>
    Map [n]  -noremap -buffer <C-w><C-k>    :<C-u>quit<CR>

    startinsert!
endfunction
MyAutocmd CmdwinEnter * call s:cmdwin_enter()

let loaded_cmdbuf = 1
Map [n] -noremap g: q:
Map [n] -noremap g/ q/
Map [n] -noremap g? q?
" }}}
" walking between tabs {{{
Map [n] -noremap <C-n>         gt
Map [n] -noremap <C-p>         gT
Map [n] -noremap <C-g><C-n>    :<C-u>tablast<CR>
Map [n] -noremap <C-g><C-p>    :<C-u>tabfirst<CR>
" }}}
" moving tabs {{{
Map [n] -noremap <Left>    :<C-u>execute 'tabmove' tabpagenr() - 2<CR>
Map [n] -noremap <Right>   :<C-u>execute 'tabmove' tabpagenr()<CR>
" NOTE: gVim only
Map [n] -noremap <S-Left>  :<C-u>execute 'tabmove' 0<CR>
Map [n] -noremap <S-Right> :<C-u>execute 'tabmove' tabpagenr('$')<CR>
" }}}
" walk between windows {{{
" NOTE: gVim only
Map [n] -noremap <M-j>     <C-w>j
Map [n] -noremap <M-k>     <C-w>k
Map [n] -noremap <M-h>     <C-w>h
Map [n] -noremap <M-l>     <C-w>l
" }}}
" toggle options {{{
function! s:toggle_option(option_name) "{{{
    if exists('&' . a:option_name)
        execute 'setlocal' a:option_name . '!'
        execute 'setlocal' a:option_name . '?'
    endif
endfunction "}}}

Map [n] -noremap <SID>[excmd]oh :<C-u>call <SID>toggle_option('hlsearch')<CR>
Map [n] -noremap <SID>[excmd]oi :<C-u>call <SID>toggle_option('ignorecase')<CR>
Map [n] -noremap <SID>[excmd]op :<C-u>call <SID>toggle_option('paste')<CR>
Map [n] -noremap <SID>[excmd]ow :<C-u>call <SID>toggle_option('wrap')<CR>
Map [n] -noremap <SID>[excmd]oe :<C-u>call <SID>toggle_option('expandtab')<CR>
Map [n] -noremap <SID>[excmd]ol :<C-u>call <SID>toggle_option('list')<CR>
Map [n] -noremap <SID>[excmd]om :<C-u>call <SID>toggle_option('modeline')<CR>

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


Map [n] -noremap <SID>[excmd]ot :<C-u>call <SID>toggle_tab_options()<CR>

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

Map [n] -noremap <SID>[excmd]OI :<C-u>OptInit<CR>


silent OptInit
" }}}
" close help/quickfix window {{{
" via kana's vimrc.

" s:winutil {{{
unlet! s:winutil
let s:winutil = {}

function! s:winutil.close(winnr) "{{{
    if s:winutil.exists(a:winnr)
        execute a:winnr . 'wincmd w'
        execute 'wincmd c'
        return 1
    else
        return 0
    endif
endfunction "}}}

function! s:winutil.exists(winnr) "{{{
    return winbufnr(a:winnr) !=# -1
endfunction "}}}


function! s:winutil.get_winnr_like(expr) "{{{
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

function! s:winutil.close_first_like(expr) "{{{
    let winnr_list = s:winutil.get_winnr_like(a:expr)
    " Close current window if current matches a:expr.
    let winnr_list = s:move_current_winnr_to_head(winnr_list)
    if empty(winnr_list)
        return
    endif

    let prev_winnr = winnr()
    try
        for winnr in winnr_list
            call s:winutil.close(winnr)
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

" TODO Simplify
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

lockvar 1 s:winutil
" }}}

" s:window {{{
unlet! s:window
let s:window = {'_group_order': [], '_groups': {}}

function! s:window.register(group_name, functions) "{{{
    call add(s:window._group_order, a:group_name)
    let s:window._groups[a:group_name] = a:functions
endfunction "}}}

function! s:window.get_all_groups() "{{{
    return map(copy(s:window._group_order), 'deepcopy(s:window._groups[v:val])')
endfunction "}}}

lockvar 1 s:window
" }}}

" cmdwin {{{
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

call s:window.register('cmdwin', {'close': function('s:close_cmdwin_window'), 'determine': function('s:is_cmdwin_window')})
" }}}

" help {{{
function! s:close_help_window() "{{{
    return s:winutil.close_first_like('s:is_help_window(winnr)')
endfunction "}}}
function! s:is_help_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'help'
endfunction "}}}

call s:window.register('help', {'close': function('s:close_help_window'), 'determine': function('s:is_help_window')})
" }}}

" quickfix {{{
function! s:close_quickfix_window() "{{{
    " cclose
    return s:winutil.close_first_like('s:is_quickfix_window(winnr)')
endfunction "}}}
function! s:is_quickfix_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'quickfix'
endfunction "}}}

call s:window.register('quickfix', {'close': function('s:close_quickfix_window'), 'determine': function('s:is_quickfix_window')})
" }}}

" ref {{{
function! s:close_ref_window() "{{{
    return s:winutil.close_first_like('s:is_ref_window(winnr)')
endfunction "}}}
function! s:is_ref_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&filetype') ==# 'ref'
endfunction "}}}

call s:window.register('ref', {'close': function('s:close_ref_window'), 'determine': function('s:is_ref_window')})
" }}}

" quickrun {{{
function! s:close_quickrun_window() "{{{
    return s:winutil.close_first_like('s:is_quickrun_window(winnr)')
endfunction "}}}
function! s:is_quickrun_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&filetype') ==# 'quickrun'
endfunction "}}}

call s:window.register('quickrun', {'close': function('s:close_quickrun_window'), 'determine': function('s:is_quickrun_window')})
" }}}

" unlisted {{{
function! s:close_unlisted_window() "{{{
    return s:winutil.close_first_like('s:is_unlisted_window(winnr)')
endfunction "}}}
function! s:is_unlisted_window(winnr) "{{{
    return !getbufvar(winbufnr(a:winnr), '&buflisted')
endfunction "}}}

call s:window.register('unlisted', {'close': function('s:close_unlisted_window'), 'determine': function('s:is_unlisted_window')})
" }}}


function! s:close_certain_window() "{{{
    let curwinnr = winnr()
    let groups = s:window.get_all_groups()

    " Close current.
    for group in groups
        if group.determine(curwinnr)
            call group.close()
            return
        endif
    endfor

    " Or close outside buffer.
    for group in groups
        if group.close()
            return 1
        endif
    endfor
endfunction "}}}


Map [n] -noremap <SID>[excmd]c: :<C-u>call <SID>close_cmdwin_window()<CR>
Map [n] -noremap <SID>[excmd]ch :<C-u>call <SID>close_help_window()<CR>
Map [n] -noremap <SID>[excmd]cQ :<C-u>call <SID>close_quickfix_window()<CR>
Map [n] -noremap <SID>[excmd]cr :<C-u>call <SID>close_ref_window()<CR>
Map [n] -noremap <SID>[excmd]cq :<C-u>call <SID>close_quickrun_window()<CR>
Map [n] -noremap <SID>[excmd]cb :<C-u>call <SID>close_unlisted_window()<CR>

Map [n] -noremap <SID>[excmd]cc :<C-u>call <SID>close_certain_window()<CR>
" }}}
" close tab with also prefix <SID>[excmd]c. {{{
" tab
Map [n] -noremap <SID>[excmd]ct :<C-u>tabclose<CR>
" uindou
Map [n] -noremap <SID>[excmd]cu :<C-u>close<CR>
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
endfunction "}}}

" move current buffer into a new tab.
Map [n] -noremap <SID>[excmd]mt :<C-u>call <SID>move_window_into_tab_page(0)<Cr>
" }}}
" netrw - vimperator-like keymappings {{{
function! s:filetype_netrw() "{{{
    Map [n] <buffer> gu -
endfunction "}}}

MyAutocmd FileType netrw call s:filetype_netrw()
" }}}
" 'Y' to yank till the end of line. {{{

DefMap [n] -noremap yank-$ y$

Map [n] Y             <yank-$>
Map [n] <Leader>Y     <register-+><yank-$>
Map [n] <SID>[comma]Y <register-*><yank-$>

" }}}
" Back to col '$' when current col is right of col '$'. {{{
if has('virtualedit') && s:one_of(split(&virtualedit, ','), ['all', 'onemore'])
    DefMap [n] -expr -noremap $-if-right-of-$    col('.') >= col('$') ? '$' : ''
    DefMap [n]       -noremap Paste              P
    DefMap [n]       -noremap paste              p
    Map [n] P <$-if-right-of-$><Paste>
    Map [n] p <$-if-right-of-$><paste>
endif
" }}}
" }}}
" map! {{{
Map [ic] -noremap <C-f> <Right>
Map [ic] -noremap <C-b> <Left>
Map [ic] -noremap <C-a> <Home>
Map [ic] -noremap <C-e> <End>
Map [ic] -noremap <C-d> <Del>
Map [ic] -noremap <C-l> <Tab>

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

" paste register
Map [i] -noremap <C-r><C-u>  <C-r><C-p>+
Map [i] -noremap <C-r><C-i>  <C-r><C-p>*
Map [i] -noremap <C-r><C-o>  <C-r><C-p>"
Map [i] -noremap <C-r>       <C-r><C-r>

" shift left (indent)
Map [i] -noremap <C-q>   <C-d>

" make <C-w> and <C-u> undoable.
Map [i] -noremap <C-w> <C-g>u<C-w>
Map [i] -noremap <C-u> <C-g>u<C-u>

Map [i] -noremap <C-@> <C-a>

Map [i] -noremap <S-CR> <C-o>O
Map [i] -noremap <C-CR> <C-o>o
" }}}
" cmap {{{
if &wildmenu
    Map [c] -noremap <C-f> <Space><BS><Right>
    Map [c] -noremap <C-b> <Space><BS><Left>
endif

" paste register
Map [c] -noremap <C-r><C-u>  <C-r>+
Map [c] -noremap <C-r><C-i>  <C-r>*
Map [c] -noremap <C-r><C-o>  <C-r>"

Map [c] -noremap -expr /  getcmdtype() == '/' ? '\/' : '/'
Map [c] -noremap -expr ?  getcmdtype() == '?' ? '\?' : '?'
" }}}
" abbr {{{
inoreab <expr> date@      strftime("%Y-%m-%d")
inoreab <expr> time@      strftime("%H:%M")
inoreab <expr> dt@        strftime("%Y-%m-%d %H:%M")

AlterCommand th     tab<Space>help
AlterCommand t      tabedit
AlterCommand sf     setf
AlterCommand hg     helpgrep

" For typo.
AlterCommand qw     wq
AlterCommand amp    map
" }}}

" Indent/Dedent {{{
Map [n] -noremap g, <<
Map [n] -noremap g. >>
Map [v] -noremap g, <
Map [v] -noremap g. >
" }}}
" Mappings with option value. {{{
Map [n] -noremap -expr / <SID>with_options('/', {'&hlsearch': 1})
Map [n] -noremap -expr ? <SID>with_options('?', {'&hlsearch': 1})

Map [n] -noremap -expr * <SID>with_options('*', {'&hlsearch': 1, '&ignorecase': 0})
Map [n] -noremap -expr # <SID>with_options('#', {'&hlsearch': 1, '&ignorecase': 0})

Map [nv] -noremap -expr : <SID>with_options(':', {'&ignorecase': 1})

Map [n] -noremap -expr gd <SID>with_options('gd', {'&hlsearch': 1})
Map [n] -noremap -expr gD <SID>with_options('gD', {'&hlsearch': 1})
" }}}
" Emacs like kill-line. {{{
Map [i] -noremap -expr <C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
Map [c] -noremap       <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" }}}
" Make searching directions consistent {{{
  " 'zv' is harmful for Operator-pending mode and it should not be included.
  " For example, 'cn' is expanded into 'cnzv' so 'zv' will be inserted.
Map [nv] -noremap -expr n <SID>search_forward_p() ? 'nzv' : 'Nzv'
Map [nv] -noremap -expr N <SID>search_forward_p() ? 'Nzv' : 'nzv'
Map [o]  -noremap -expr n <SID>search_forward_p() ? 'n' : 'N'
Map [o]  -noremap -expr N <SID>search_forward_p() ? 'N' : 'n'

function! s:search_forward_p()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction
" }}}
" Walk between columns at 0, ^, $. {{{
" imap
Map [i] -noremap -expr <C-a> <SID>at_right_of_tilde_col() ? "\<C-o>^" : "\<Home>"
Map [i] -noremap -expr <C-e> <SID>at_left_of_tilde_col()  ? "\<C-o>^" : "\<End>"

" motion
Map [nvo] -noremap -expr H <SID>at_right_of_tilde_col() ? "^" : "0"
Map [nvo] -noremap -expr L <SID>at_left_of_tilde_col()  ? "^" : "$"
" }}}
" Disable unused keys. {{{
Map [n] -noremap ZZ <Nop>
Map [n] -noremap U  <Nop>
Map [v] -noremap K  <Nop>
" }}}
" Expand abbreviation {{{
" http://gist.github.com/347852
" http://gist.github.com/350207

Map [i] -noremap -expr <SID>(bs-ctrl-])    getline('.')[col('.') - 2] ==# "\<C-]>" ? "\<BS>" : ''
Map [i]                <C-]>               <C-]><SID>(bs-ctrl-])

Map [c] -noremap -expr <SID>(bs-ctrl-])    getcmdline()[getcmdpos() - 2] ==# "\<C-]>" ? "\<BS>" : ''
Map [c]                <C-]>               <C-]><SID>(bs-ctrl-])
" }}}

" [jump] {{{
call s:map_prefix_key('n', 'jump', 'go')


" NOTE: Disabled.
" open <cfile> {{{
" nnoremap <SID>[jump]f :<C-u>call <SID>open_cfile()<CR>

function! s:open_cfile() "{{{
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
endfunction "}}}
" }}}


" TODO Jump using tag files.
" }}}
" [compl] {{{
call s:map_prefix_key('i', 'compl', '<Tab>')
" Do <C-n> while pumvisible().
execute 'imap <expr> <Tab> pumvisible() ? "\<C-n>" : ' . string(maparg('<Tab>', 'i'))


Map [i] -noremap <SID>[compl]<Tab> <C-n>

Map [i] -noremap <SID>[compl]n <C-x><C-n>
Map [i] -noremap <SID>[compl]p <C-x><C-p>

Map [i] -noremap <SID>[compl]] <C-x><C-]>
" Map [i] -noremap <SID>[compl]d <C-x><C-d>
Map [i] -noremap <SID>[compl]i <C-x><C-i>
Map [i] -noremap <SID>[compl]k <C-x><C-k>
Map [i] -noremap <SID>[compl]l <C-x><C-l>
" Map [i] -noremap <SID>[compl]s <C-x><C-s>
" Map [i] -noremap <SID>[compl]t <C-x><C-t>

Map [i] -noremap -expr <SID>[compl]o <SID>omni_or_user_func()

function! s:omni_or_user_func() "{{{
    if &omnifunc != ''
        return "\<C-x>\<C-o>"
    elseif &completefunc != ''
        return "\<C-x>\<C-u>"
    else
        return "\<C-n>"
    endif
endfunction "}}}


" Map [i] -noremap <SID>[compl]j <C-n>
" Map [i] -noremap <SID>[compl]k <C-p>
" TODO
" call submode#enter_with('c', 'i', '', '<SID>[compl]j', '<C-n>')
" call submode#enter_with('c', 'i', '', '<SID>[compl]k', '<C-p>')
" call submode#leave_with('c', 'i', '', '<CR>')
" call submode#map       ('c', 'i', '', 'j', '<C-n>')
" call submode#map       ('c', 'i', '', 'k', '<C-p>')


" }}}
" }}}
" Commands {{{
" HelpTagsAll {{{
"   do :helptags to all doc/ in &runtimepath
command!
\   -bar -nargs=?
\   HelpTagsAll
\   call s:HelpTagsAll(<f-args>)

function! s:HelpTagsAll(...)
    " FIXME Use pathogen.vim!!
    for path in split(&runtimepath, ',')
        let doc = path . '/doc'
        if isdirectory(doc)
            " add :silent! because Vim warns "No match ..."
            " if there are no files in '{doc}/*',
            silent! execute 'helptags' join(a:000) doc
        endif
    endfor
endfunction
" }}}
" MTest {{{
"   convert Perl's regex to Vim's regex
command! -nargs=? MTest
            \ call s:MTest( <q-args> )

function! s:MTest( ... )

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
endfunction
" }}}
" Open {{{
command!
\   -nargs=? -complete=dir
\   Open
\   call s:Open(<f-args>)

function! s:Open(...)
    let dir =   a:0 == 1 ? a:1 : '.'

    if !isdirectory(dir)
        call s:warn(dir .': No such a directory')
        return
    endif

    if has('win32')
        " if dir =~ '[&()\[\]{}\^=;!+,`~ '. "']" && dir !~ '^".*"$'
        "     let dir = '"'. dir .'"'
        " endif
        call s:system('explorer', dir)
    else
        call s:system('gnome-open', dir)
    endif
endfunction
" }}}
" ListChars {{{
command!
\   -bar
\   ListChars
\   call s:set_listchars()

function! s:set_listchars()
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
endfunction
" }}}
" GarbageCorrect {{{
" Correct garbages right now.
command!
\   -bar -bang
\   GarbageCorrect
\   call s:garbagecollect(<bang>0)

function! s:garbagecollect(banged)
    " garbagecollect()
    call garbagecollect()

    " &undolevels
    if a:banged
        " Undo history will be lost!!
        let save = &undolevels
        set undolevels=0
        let &undolevels = save
    endif
endfunction
" }}}
" DelFile {{{
"
" TODO Delete recursively.


command! -complete=file -nargs=+ DelFile
            \ call s:DelFile(<f-args>)

function! s:DelFile(...)
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
endfunction
" }}}
" Mkdir {{{
function! s:Mkdir(...)
    for i in a:000
        call mkdir(expand(i), 'p')
    endfor
endfunction
command! -nargs=+ -complete=dir Mkdir
            \ call s:Mkdir(<f-args>)
" }}}
" GccSyntaxCheck {{{
function! s:GccSyntaxCheck(...)
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
endfunction

command! -nargs=* GccSyntaxCheck
            \ call s:GccSyntaxCheck(<f-args>)
" }}}
" Ack {{{
function! s:ack(...)
    let save_grepprg = &l:grepprg
    try
        let &l:grepprg = 'ack'
        execute 'grep' join(a:000, ' ')
    finally
        let &l:grepprg = save_grepprg
    endtry
endfunction

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

AlterCommand epa EchoPath
AlterCommand rtp EchoPath<Space>rtp

command!
\   -nargs=+ -complete=option
\   EchoPath
\   call s:show_path(<f-args>)

function! s:show_path(...) "{{{
    let optname = a:1
    let delim = a:0 >= 2 ? a:2 : ','
    let optval = getbufvar('%', '&' . optname)
    for i in split(optval, delim)
        echo i
    endfor
endfunction "}}}
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

function! s:tr_split_arg(arg) "{{{
    let arg = a:arg
    let arg = substitute(arg, '^\s*', '', '')
    if arg == ''
        throw 'argument_error'
    endif

    let sep = arg[0]
    return split(arg, '\%(\\\)\@<!' . sep)
endfunction "}}}

function! s:tr(lnum_from, lnum_to, arg) "{{{
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
endfunction "}}}

function! s:trr(lnum_from, lnum_to, arg) "{{{
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
endfunction "}}}

" Replace pat1 to str1, pat2 to str2,
" from current position to the end of the file.
function! s:tr_replace(lnum_from, lnum_to, pat1, str1, pat2, str2) "{{{
    " TODO
endfunction "}}}
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
" GlobPath {{{
command!
\   -bar -nargs=1
\   GlobPath
\   echo globpath(&rtp, <q-args>)

AlterCommand gp GlobPath
" }}}
" QuickFix {{{
" Select prefered command from cwindow, copen, and so on.

command!
\   -bar -nargs=?
\   QuickFix
\   if !empty(getqflist()) | cwindow <args> | endif

AlterCommand qf QuickFix
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

Map [n] -expr <SID>(mode-noremap) <SID>mode_noremap()
Map [n] -expr <SID>(mode-noremap-feedkeys) <SID>mode_noremap_feedkeys()

let s:mode_noremap_keys = ''

function! s:mode_noremap() "{{{
    let c = s:getchar()
    if c == "\<Esc>"
        return ''
    else
        let s:mode_noremap_feedkeys = c
        call s:mode_noremap_feedkeys()
        return "\<SID>(mode-noremap)"
    endif
endfunction "}}}

function! s:mode_noremap_feedkeys() "{{{
    call feedkeys(s:mode_noremap_feedkeys, 'n')
    return ''
endfunction "}}}
" }}}
"}}}

" TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
AlterCommand cd  TabpageCD

Map [n] -noremap <SID>[comma]cd  :<C-u>TabpageCD %:p:h<CR>
Map [n] -noremap <Leader>cd      :<C-u>lcd %:p:h<CR>

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
  Map [n] -buffer <Enter>  :<C-u>exec 'colors' getline('.')<CR>
  Map [n] -buffer q        :<C-u>close<CR>
endf
com! SelectColorScheme   :cal s:SelectColorScheme()
" }}}
" Grep {{{
" http://vim-users.jp/2010/03/hack130/
" http://webtech-walker.com/archive/2010/03/17093357.html
AlterCommand gr[ep] Grep

command!
\   -bar -complete=file -nargs=+
\   Grep
\   call s:grep([<f-args>])

function! s:grep(args)
    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
    execute 'vimgrep' '/' . a:args[0] . '/j' target
endfunction
" }}}
" }}}
" For Plugins {{{
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
" }}}
" nextfile {{{
let g:nf_map_next     = ''
let g:nf_map_previous = ''
nmap <SID>[comma]n <Plug>(nextfile-next)
nmap <SID>[comma]p <Plug>(nextfile-previous)

let g:nf_include_dotfiles = 1    " don't skip dotfiles
let g:nf_loop_files = 1    " loop at the end of file
let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']
" }}}
" vimtemplate {{{
let g:vt_mapping = 'gt'
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
let g:SD_disable = 1

" let g:SD_debug = 1
if !g:SD_disable
    Map [n] -silent <C-l> :SDUpdate<CR><C-l>
endif
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
let skk_sticky_key = ';'
" }}}
" eskk {{{
let g:eskk_debug = 1
let g:eskk_debug_wait_ms = 0

let g:eskk_no_default_mappings = 1
Map [ic] <C-g><C-j> <Plug>(eskk-toggle)
Map [l]  ;          <Plug>(eskk-sticky-key)

" let g:eskk_no_default_mappings = 1
" Arpeggio map! fj <Plug>(eskk-enable)
" Arpeggio lmap fk <Plug>(eskk-disable)
" Map [l] ;      <Plug>(eskk-sticky-key)

" }}}
" stickykey {{{

" I use stickykey for emergency use.
" So these mappings are little bit difficult to press, but I don't care.

Map [nvoicl] <C-g><C-s> <Plug>(stickykey-shift-remap)
Map [nvoicl] <C-g><C-c> <Plug>(stickykey-ctrl-remap)
Map [nvoicl] <C-g><C-a> <Plug>(stickykey-alt-remap)
" I don't have Macintosh :(
" Map [nvoicl] <C-g><C-m> <Plug>(stickykey-command-remap)

" }}}
" restart {{{
AlterCommand res[tart] Restart
" }}}
" AutoDate {{{
let g:autodate_format = "%Y-%m-%d"
" }}}
" FuzzyFinder {{{
call s:map_prefix_key('n', 'anything', 's')

Map [n] -noremap <SID>[anything]d        :<C-u>FufDir<CR>
Map [n] -noremap <SID>[anything]f        :<C-u>FufFile<CR>
Map [n] -noremap <SID>[anything]h        :<C-u>FufMruFile<CR>
Map [n] -noremap <SID>[anything]r        :<C-u>FufRenewCache<CR>

let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']

let fuf_keyOpenTabpage = '<C-t>'
let fuf_keyNextMode    = '<C-l>'
let fuf_keyPrevMode    = '<C-h>'
let fuf_keyOpenSplit   = '<C-s>'
let fuf_keyOpenVsplit  = '<C-v>'
let fuf_enumeratingLimit = 20
let fuf_previewHeight = 0

" abbrev {{{
function! s:register_fuf_abbrev()
    let g:fuf_abbrevMap = {
        \ '^r@': map(split(&runtimepath, ','), 'v:val . "/"'),
        \ '^p@': map(split(&runtimepath, ','), 'v:val . "/plugin/"'),
        \ '^h@': ['~/'],
        \ '^v@' : ['~/.vim/'],
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
endfunction

MyAutocmd VimEnter * call s:register_fuf_abbrev()
" }}}
" }}}
" MRU {{{
Map [n] -noremap <C-h> :<C-u>MRU<CR>
let MRU_Max_Entries   = 500
let MRU_Add_Menu      = 0
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\c\'
" }}}
" changelog {{{
let changelog_username = "tyru"
" }}}
" Gtags {{{
function! s:JumpTags() "{{{
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
endfunction "}}}

Map [n] -noremap g<C-i>    :Gtags -f %<CR>
Map [n] -noremap <C-]>     :call <SID>JumpTags()<CR>
" }}}
" vimshell {{{
AlterCommand vsh[ell] VimShell

let g:VimShell_EnableInteractive = 2
let g:VimShell_NoDefaultKeyMappings = 1

MyAutocmd FileType vimshell call s:vimshell_settings()

function! s:vimshell_settings() "{{{
    " Define aliases.
    call vimshell#altercmd#define('df', 'df -h')
    call vimshell#altercmd#define('diff', 'diff --unified')
    call vimshell#altercmd#define('du', 'du -h')
    call vimshell#altercmd#define('free', 'free -m -l -t')
    call vimshell#altercmd#define('j', 'jobs -l')
    call vimshell#altercmd#define('jobs', 'jobs -l')
    call vimshell#altercmd#define('l.', 'ls -d .*')
    call vimshell#altercmd#define('l', 'll')
    call vimshell#altercmd#define('la', 'ls -A')
    call vimshell#altercmd#define('less', 'less -r')
    call vimshell#altercmd#define('ll', 'ls -lh')
    call vimshell#altercmd#define('sc', 'screen')
    call vimshell#altercmd#define('whi', 'which')
    call vimshell#altercmd#define('whe', 'where')
    call vimshell#altercmd#define('go', 'gopen')

    if executable('perldocjp')
        call vimshell#altercmd#define('perldoc', 'perldocjp')
    endif

    let less_sh = s:globpath(&rtp, 'macros/less.sh')
    if !empty(less_sh)
        call vimshell#altercmd#define('vless', less_sh[0])
    endif

    " Add/Remove some mappings.
    nunmap <buffer> <C-n>
    nunmap <buffer> <C-p>
    Map [i] -noremap -buffer <C-l> <Space><Bar><Space>

    " setlocal backspace-=eol
endfunction "}}}
" }}}
" quickrun {{{
let g:loaded_quicklaunch = 1

let g:quickrun_no_default_key_mappings = 1
Map [nvo] <Space>r <Plug>(quickrun)

if !exists('s:loaded_vimrc')
    let g:quickrun_config = {}
    let g:quickrun_config.markdown = {'command' : 'pandoc'}
endif
" }}}
" submode {{{

" Move GUI window.
call submode#enter_with('guiwinmove', 'n', '', 'mgw')
call submode#leave_with('guiwinmove', 'n', '', '<Esc>')
call submode#map       ('guiwinmove', 'n', 'r', 'j', '<Plug>(winmove-down)')
call submode#map       ('guiwinmove', 'n', 'r', 'k', '<Plug>(winmove-up)')
call submode#map       ('guiwinmove', 'n', 'r', 'h', '<Plug>(winmove-left)')
call submode#map       ('guiwinmove', 'n', 'r', 'l', '<Plug>(winmove-right)')

" Change GUI window size.
call submode#enter_with('guiwinsize', 'n', '', 'mgs', '<Nop>')
call submode#leave_with('guiwinsize', 'n', '', '<Esc>')
call submode#map       ('guiwinsize', 'n', '', 'j', ':set lines-=1<CR>')
call submode#map       ('guiwinsize', 'n', '', 'k', ':set lines+=1<CR>')
call submode#map       ('guiwinsize', 'n', '', 'h', ':set columns-=5<CR>')
call submode#map       ('guiwinsize', 'n', '', 'l', ':set columns+=5<CR>')

" Change current window size.
call submode#enter_with('winsize', 'n', '', 'mws', '<Nop>')
call submode#leave_with('winsize', 'n', '', '<Esc>')
call submode#map       ('winsize', 'n', '', 'j', '<C-w>-:redraw<CR>')
call submode#map       ('winsize', 'n', '', 'k', '<C-w>+:redraw<CR>')
call submode#map       ('winsize', 'n', '', 'h', '<C-w><:redraw<CR>')
call submode#map       ('winsize', 'n', '', 'l', '<C-w>>:redraw<CR>')

" undo/redo
call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#leave_with('undo/redo', 'n', '', '<Esc>')
call submode#map       ('undo/redo', 'n', '', '-', 'g-')
call submode#map       ('undo/redo', 'n', '', '+', 'g+')

" Tab walker.
call submode#enter_with('tabwalker', 'n', '', 'mtw', '<Nop>')
call submode#leave_with('tabwalker', 'n', '', '<Esc>')
call submode#map       ('tabwalker', 'n', '', 'h', 'gT:redraw<CR>')
call submode#map       ('tabwalker', 'n', '', 'l', 'gt:redraw<CR>')
call submode#map       ('tabwalker', 'n', '', 'H', ':execute "tabmove" tabpagenr() - 2<CR>')
call submode#map       ('tabwalker', 'n', '', 'L', ':execute "tabmove" tabpagenr()<CR>')

" FIXME: Weird character is showed.
" call submode#enter_with('indent/dedent', 'i', '', '<C-q>', '<C-d>')
" call submode#enter_with('indent/dedent', 'i', '', '<C-t>', '<C-t>')
" call submode#leave_with('indent/dedent', 'i', '', '<Esc>')
" call submode#map       ('indent/dedent', 'i', '', 'h', '<C-d>')
" call submode#map       ('indent/dedent', 'i', '', 'l', '<C-t>')

" TODO Stash &scroll value.
" TODO Use <SID>[excmd]j, <SID>[excmd]k
call submode#enter_with('s', 'n', '', '<Space>j', '<C-d>:redraw<CR>')
call submode#enter_with('s', 'n', '', '<Space>k', '<C-u>:redraw<CR>')
call submode#leave_with('s', 'n', '', '<Esc>')
call submode#map       ('s', 'n', '', 'j', '<C-d>:redraw<CR>')
call submode#map       ('s', 'n', '', 'k', '<C-u>:redraw<CR>')
call submode#map       ('s', 'n', '', 'a', ':let &l:scroll -= 3<CR>')
call submode#map       ('s', 'n', '', 's', ':let &l:scroll += 3<CR>')
" }}}
" ref {{{
" 'K' for ':Ref'.
AlterCommand ref Ref
AlterCommand alc Ref<Space>alc
AlterCommand man Ref<Space>man

call s:map_orig_key('n', 'K')

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
function! s:delete_backup()
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
endfunction

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
" End. {{{


if !exists('s:loaded_vimrc')
    GarbageCorrect    " first time
else
    GarbageCorrect!
endif

set secure

let s:loaded_vimrc = 1
" }}}
