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


" Misc.
function! s:each_char(str) "{{{
    return split(a:str, '\zs')
endfunction "}}}

function! s:warn(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction "}}}
function! s:warnf(...) "{{{
    call s:warn(call('printf', a:000))
endfunction "}}}


" Wrapper for built-in functions.
function! s:system(command, ...) "{{{
    return system(join([a:command] + map(copy(a:000), 'shellescape(v:val)'), ' '))
endfunction "}}}
function! s:glob(expr) "{{{
    return split(glob(a:expr), "\n")
endfunction "}}}
function! s:globpath(path, expr) "{{{
    return split(globpath(a:path, a:expr), "\n")
endfunction "}}}
function! s:getchar(...) "{{{
    let c = call('getchar', a:000)
    return type(c) == type("") ? c : nr2char(c)
endfunction "}}}


" List
function! s:has_elem(list, elem) "{{{
    return !empty(filter(copy(a:list), 'v:val ==# a:elem'))
endfunction "}}}
function! s:has_all_of(list, elem) "{{{
    " a:elem is List:
    "   a:list has a:elem[0] && a:list has a:elem[1] && ...
    " a:elem is not List:
    "   a:list has a:elem

    if type(a:elem) == type([])
        for i in a:elem
            if !s:has_elem(a:list, i)
                return 0
            endif
        endfor
        return 1
    else
        return s:has_elem(a:list, a:elem)
    endif
endfunction "}}}
function! s:has_one_of(list, elem) "{{{
    " a:elem is List:
    "   a:list has a:elem[0] || a:list has a:elem[1] || ...
    " a:elem is not List:
    "   a:list has a:elem

    if type(a:elem) == type([])
        for i in a:elem
            if s:has_elem(a:list, i)
                return 1
            endif
        endfor
        return 0
    else
        return s:has_elem(a:list, a:elem)
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
function! s:mapf(list, fmt) "{{{
    return map(copy(a:list), "printf(a:fmt, v:val)")
endfunction "}}}
function! s:zip(list, list2) "{{{
    let ret = []
    let i = 0
    while s:has_idx(a:list, i) || s:has_idx(a:list2, i)
        call add(ret,
        \   (s:has_idx(a:list, i) ? [a:list[i]] : [])
        \   + (s:has_idx(a:list2, i) ? [a:list2[i]] : []))

        let i += 1
    endwhile
    return ret
endfunction "}}}
function! s:get_idx(list, elem, ...) "{{{
    let idx = 0

    while s:has_idx(a:list, idx)
        if a:list[idx] ==# a:elem
            return idx
        endif
        let idx += 1
    endwhile

    if a:0 == 0
        throw 'internal error'
    else
        return a:1
    endif
endfunction "}}}


" Path
function! s:split_path(path, ...) "{{{
    " TODO: More strict
    let sep = a:0 != 0 ? a:1 : ','
    return split(a:path, sep)
endfunction "}}}
function! s:join_path(path_list, ...) "{{{
    " TODO: More strict
    let sep = a:0 != 0 ? a:1 : ','
    return join(a:path_list, sep)
endfunction "}}}


" System
function! s:follow_symlink(path) "{{{
    " FIXME
    "
    " TODO Reveive depth of following times.
    "
    " Complain: Why can't Vim deal with symbolic link?

    perl <<EOF
    my $dest = sub { ($_) = @_; $_ = readlink while -l; $_ }->(VIM::Eval('a:path'));
    # TODO: More strict
    VIM::DoCommand sprintf "let dest = '%s'", $dest;
EOF

    return dest
endfunction "}}}


" Mapping
function! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction "}}}
function! s:SNR(map) "{{{
    return printf("<SNR>%d_%s", s:SID(), a:map)
endfunction "}}}

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

function! s:map_leader(key) "{{{
    let g:mapleader = a:key
    Map [n] <Leader> <Nop>
endfunction "}}}
function! s:map_localleader(key) "{{{
    let g:maplocalleader = a:key
    Map [n] <LocalLeader> <Nop>
endfunction "}}}
function! s:map_prefix_key(modes, prefix_name, prefix_key) "{{{
    let modes = a:modes != '' ? a:modes : 'nvoiclxs'

    " execute 'DefMap' printf('[%s]', modes) a:prefix_name '<Nop>'
    " execute 'Map'         printf('[%s]', modes)            a:prefix_key  printf('<%s>', a:prefix_name)

    execute 'DefMacroMap' printf('[%s]', modes) a:prefix_name a:prefix_key

    " NOTE: Uncomment this due to Vim's mapping specification.
    " See this: http://d.hatena.ne.jp/thinca/20100525/1274799274
    "
    " execute 'Map'         printf('[%s]', modes) a:prefix_key '<Nop>'

    " TODO
    " DefMap [<eval modes>] <eval a:prefix_name> <Nop>
    " Map    [<eval modes>] <eval a:prefix_key>  <<eval a:prefix_name>>
endfunction "}}}
function! s:map_orig_key(modes, key) "{{{
    execute printf('Map [%s] <orig>%s %s', a:modes, a:key, a:key)

    " TODO
    " Map [<eval a:modes>] <orig><eval a:key> <eval a:key>
endfunction "}}}

function! s:expr_with_options(cmd, opt) "{{{
    for [name, value] in items(a:opt)
        call setbufvar('%', name, value)
    endfor
    return a:cmd
endfunction "}}}


" Parsing
function! s:skip_white(q_args) "{{{
    return substitute(a:q_args, '^\s*', '', '')
endfunction "}}}
function! s:parse_one_arg_from_q_args(q_args) "{{{
    let arg = s:skip_white(a:q_args)
    let head = matchstr(arg, '^.\{-}[^\\]\ze\([ \t]\|$\)')
    let rest = strpart(arg, strlen(head))
    return [head, rest]
endfunction "}}}
function! s:eat_n_args_from_q_args(q_args, n) "{{{
    let rest = a:q_args
    for _ in range(1, a:n)
        let rest = s:parse_one_arg_from_q_args(rest)[1]
    endfor
    let rest = s:skip_white(rest)    " for next arguments.
    return rest
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

" :Dump
command!
\   -bang -nargs=+ -complete=expression
\   Dump
\
\   echohl Debug
\   | echomsg printf("  %s = %s", <q-args>, string(eval(<q-args>)))
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

" :Eecho
command!
\   -nargs=+
\   Eecho
\
\   echohl ErrorMsg
\   | echomsg <args>
\   | echohl None
" }}}
" }}}
" }}}
" Options {{{

set all&

if 0    " for debug
    set msghistlen=9999
endif

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
set listchars=tab:>_,extends:>,precedes:<,eol:_

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
set pumheight=20

" tags
if has('path_extra')
    set tags+=.;
    set tags+=tags;
endif
set showfulltag
set notagbsearch

" cscope
if 0
    set cscopetag
    set cscopeverbose
endif

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
" TODO Show project name.
let &tabline     = '%N. [%t]'
let &guitablabel = &tabline

" statusline
set laststatus=2
let &statusline = '[%t] [%{&ft}] [%{&fenc},%{&ff}] %( [%M%R%H%W]%)'
let &statusline .= '%( %{eskk#is_enabled()?eskk#get_stl():SkkGetModeStr()}%)'

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
" TODO Change the color of inactive statusline.
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
set showcmd
set nrformats=hex
set shortmess=aI
set switchbuf=useopen,usetab
set textwidth=0
set viminfo='50,h,f1,n$HOME/.viminfo
" }}}
" Autocmd {{{

" colorscheme (on windows, setting colorscheme in .vimrc does not work)
function! s:define_colorscheme() "{{{
    if has('gui_running')
        set background=dark
        colorscheme desert
    else
        set background=dark
        colorscheme koehler
    endif
endfunction "}}}
command! MyColorScheme call s:define_colorscheme()
MyAutocmd VimEnter * MyColorScheme

" open on read-only if swap exists
MyAutocmd SwapExists * let v:swapchoice = 'o'

" autocmd CursorHold,CursorHoldI *   silent! update
MyAutocmd QuickfixCmdPost * QuickFix

" InsertLeave, InsertEnter
MyAutocmd InsertLeave * setlocal nocursorline
MyAutocmd InsertEnter * setlocal cursorline ignorecase

" Disable &modeline when opened template file.
MyAutocmd BufReadPre ~/.vim/template/* setlocal nomodeline


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
MyAutocmd BufNewFile,BufReadPre *.scm,.uim
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
            \ setlocal ft=mkd
MyAutocmd BufNewFile,BufReadPre *.md
            \ setlocal ft=markdown

" aliases
" MyAutocmd FileType mkd
"             \ setlocal ft=markdown
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

function! s:rtp_shift(path) "{{{
    let &rtp = s:join_path(s:split_path(&rtp)[1:])
endfunction "}}}
function! s:rtp_pop(path) "{{{
    let &rtp = s:join_path(s:split_path(&rtp)[:-2])
endfunction "}}}
function! s:rtp_unshift(path) "{{{
    let &rtp = s:join_path(s:glob(path) + s:split_path(&rtp))
endfunction "}}}
function! s:rtp_push(path) "{{{
    let &rtp = s:join_path(s:split_path(&rtp) + s:glob(a:path))
endfunction "}}}
function! s:rtp_clear(path) "{{{
    let &rtp = ''
endfunction "}}}
function! s:rtp_prune(path) "{{{
    let path = expand(a:path)
    " FIXME
    " let path = s:follow_symlink(expand(a:path))
    let filtered = filter(s:split_path(&rtp), 'expand(v:val) !=# path')
    let &rtp = s:join_path(filtered)
endfunction "}}}

command!
\   -bar -nargs=1
\   RtpShift
\   call s:rtp_shift(<f-args>)
command!
\   -bar -nargs=1
\   RtpPop
\   call s:rtp_pop(<f-args>)
command!
\   -bar -nargs=1
\   RtpUnshift
\   call s:rtp_unshift(<f-args>)
command!
\   -bar -nargs=1
\   RtpPush
\   call s:rtp_push(<f-args>)
command!
\   -bar -nargs=1
\   RtpClear
\   call s:rtp_clear(<f-args>)
command!
\   -bar -nargs=1
\   RtpPrune
\   call s:rtp_prune(<f-args>)



if has('win32')
    RtpPush $HOME/.vim
endif

if exists('$VIM_RTP_REPO_DIR')
    RtpPush $VIM_RTP_REPO_DIR/*
    RtpPrune $VIM_RTP_REPO_DIR/pummode.vim
    RtpPrune $VIM_RTP_REPO_DIR/command-buffer.vim
    RtpPrune $VIM_RTP_REPO_DIR/cmdwincomplete.vim
    RtpPrune $VIM_RTP_REPO_DIR/fencview.vim
    if !executable('git')
        RtpPrune $VIM_RTP_REPO_DIR/gist-vim
    endif
    if !has('python')
        RtpPrune $VIM_RTP_REPO_DIR/lingr-vim
    endif
else
    call s:warn('Forgot to set $VIM_RTP_REPO_DIR ?')
endif

" }}}


call emap#load()
call emap#set_sid(s:SID())
" call emap#set_sid_from_sfile(expand('<sfile>'))

let g:arpeggio_timeoutlen = 40
call arpeggio#load()

call altercmd#load()
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
"
" MapCount:
"   " Map [n] -expr <C-n> v:count1 . 'gt'
"   MapCount [n] <C-n> gt



" TODO Do not clear mappings set by plugins.
" mapclear
" mapclear!
" " mapclear!!!!
" lmapclear



" Set up general prefix keys. {{{

" <orig>
call s:map_prefix_key('nvo', 'orig', 'q')
call s:map_prefix_key('ic' , 'orig', '<C-g><C-o>')
call s:map_orig_key('n', 'q')
" <Leader>
call s:map_leader(';')
" <LocalLeader>
call s:map_localleader('\')
" <excmd>
call s:map_prefix_key('nvo', 'excmd', '<Space>')
" <operator>
call s:map_prefix_key('nvo', 'operator', ';')
" <window>
call s:map_prefix_key('n', 'window', '<C-w>')
" }}}

" map {{{
" operator {{{

" Copy to clipboard, primary.
Map [nvo] <operator>y     "+y
Map [nvo] <operator>gy    "*y
Map [nvo] <operator>d     "+d
Map [nvo] <operator>gd    "*d


" Do not destroy noname register.
Map [nvo] x "_x


Map [nvo] <operator>e =


" operator-adjust {{{
call operator#user#define('adjust', 'Op_adjust_window_height')
function! Op_adjust_window_height(motion_wiseness)
  execute (line("']") - line("'[") + 1) 'wincmd' '_'
  normal! `[zt
endfunction

Map [nvo] -remap <operator>adj <Plug>(operator-adjust)
" }}}
" operator-sort {{{
call operator#user#define_ex_command('sort', 'sort')
Map [nvo] -remap <operator>s <Plug>(operator-sort)
" }}}
" operator-retab {{{
call operator#user#define_ex_command('retab', 'retab')
Map [nvo] -remap <operator>t <Plug>(operator-retab)
" }}}
" operator-join {{{
call operator#user#define_ex_command('join', 'join')
Map [nvo] -remap <operator>j <Plug>(operator-join)
" }}}
" operator-uniq {{{
call operator#user#define_ex_command('uniq', 'sort u')
Map [nvo] -remap <operator>u <Plug>(operator-uniq)
" }}}
" operator-narrow {{{
call operator#user#define_ex_command('narrow', 'Narrow')

Map [nvo] -remap <operator>na <Plug>(operator-narrow)
Map [nvo]        <operator>nw :<C-u>Widen<CR>

let g:narrow_allow_overridingp = 1
" }}}
" operator-replace {{{
Map [nvo] -remap <operator>r  <Plug>(operator-replace)
" }}}
" operator-camelize {{{
Map [nvo] -remap <operator>c <Plug>(operator-camelize)
Map [nvo] -remap <operator>C <Plug>(operator-decamelize)
" }}}
" }}}
" motion/textobj {{{
Map [nvo] j gj
Map [nvo] k gk
call s:map_orig_key('nvo', 'j')
call s:map_orig_key('nvo', 'k')

" FIXME: Does not work in visual mode.
Map [nvo] ]k :<C-u>call search('^\S', 'Ws')<CR>
Map [nvo] [k :<C-u>call search('^\S', 'Wsb')<CR>

Map [vo] -remap iF <Plug>(textobj-fold-i)
Map [vo] -remap aF <Plug>(textobj-fold-a)

Map [nvo] gp %

Map [vo] aa a>
Map [vo] ia i>
Map [vo] ar a]
Map [vo] ir i]
" }}}
" }}}
" nmap {{{

call s:map_prefix_key('nvo', 'fold', 'z')

" Open only current line's fold.
Map [n] <fold><Space> zMzvzz

" Folding mappings easy to remember.
Map [n] <fold>l zo
Map [n] <fold>h zc

" Operate on line without newline.
DefMacroMap [n] line-w/o-newline <Space>
Map [n] d<line-w/o-newline> 0d$
Map [n] y<line-w/o-newline> 0y$
Map [n] c<line-w/o-newline> 0c$

" http://vim-users.jp/2009/08/hack57/
Map [n] d<CR> :<C-u>call append(expand('.'), '')<CR>j
Map [n] c<CR> :<C-u>call append(expand('.'), '')<CR>jI

Map [n] <excmd>me :<C-u>messages<CR>
Map [n] <excmd>di :<C-u>display<CR>

Map [n] g; ~

Map [n] + <C-a>
Map [n] -- - <C-x>

Map [n] <excmd>sp :<C-u>Split<CR>

Map [n] <C-g><C-n>    :<C-u>tablast<CR>
Map [n] <C-g><C-p>    :<C-u>tabfirst<CR>

Map [n] R gR

" TODO: Smart 'zd': Delete empty line {{{
" }}}
" TODO: Smart '{', '}': Treat folds as one non-empty line. {{{
" }}}

" Execute most used command quickly {{{
Map [n] <excmd>w      :<C-u>write<CR>
Map [n] <excmd>q      :<C-u>quit<CR>
" }}}
" Edit .vimrc quickly {{{
Map [n] <excmd>ee     :<C-u>edit<CR>
Map [n] <excmd>ev     :<C-u>edit $MYVIMRC<CR>
Map [n] <excmd>e.     :<C-u>edit .<CR>

Map [n] <excmd>tt     :<C-u>tabedit<CR>
Map [n] <excmd>tv     :<C-u>tabedit $MYVIMRC<CR>
Map [n] <excmd>t.     :<C-u>tabedit .<CR>

Map [n] <excmd>sv     :<C-u>source $MYVIMRC<CR>
" }}}
" Cmdwin {{{
set cedit=<C-z>
function! s:cmdwin_enter()
    Map [ni] -force -buffer <C-z>         <C-c>
    Map [n]  -buffer <Esc>         :<C-u>quit<CR>
    Map [n]  -force -buffer :             :<C-u>quit<CR>:
    Map [n]  -force -buffer <window>k        :<C-u>quit<CR>
    Map [n]  -force -buffer <window><C-k>    :<C-u>quit<CR>

    startinsert!
endfunction
MyAutocmd CmdwinEnter * call s:cmdwin_enter()

let loaded_cmdbuf = 1
Map [n] <excmd>: q:
Map [n] <excmd>/ q/
Map [n] <excmd>? q?
" }}}
" Moving tabs {{{
Map [n] <Left>    :<C-u>execute 'tabmove' (tabpagenr() == 1 ? tabpagenr('$') : tabpagenr() - 2)<CR>
Map [n] <Right>   :<C-u>execute 'tabmove' (tabpagenr() == tabpagenr('$') ? 0 : tabpagenr())<CR>
" NOTE: gVim only
Map [n] <S-Left>  :<C-u>execute 'tabmove' 0<CR>
Map [n] <S-Right> :<C-u>execute 'tabmove' tabpagenr('$')<CR>
" }}}
" Walk between windows {{{
" NOTE: gVim only
Map [n] <M-j>     <C-w>j
Map [n] <M-k>     <C-w>k
Map [n] <M-h>     <C-w>h
Map [n] <M-l>     <C-w>l
" }}}
" Toggle options {{{
function! s:toggle_option(option_name) "{{{
    if exists('&' . a:option_name)
        execute 'setlocal' a:option_name . '!'
        execute 'setlocal' a:option_name . '?'
    endif
endfunction "}}}

function! s:advance_state(state, elem) "{{{
    let curidx = s:get_idx(a:state, a:elem, 0)
    return a:state[s:has_idx(a:state, curidx + 1) ? curidx + 1 : 0]
endfunction "}}}

function! s:advance_option_state(state, optname) "{{{
    let varname = '&' . a:optname
    call setbufvar(
    \   '%',
    \   varname,
    \   s:advance_state(
    \       a:state,
    \       getbufvar('%', varname)))
    execute 'setlocal' a:optname . '?'
endfunction "}}}

Map [n] <excmd>oh :<C-u>call <SID>toggle_option('hlsearch')<CR>
Map [n] <excmd>oi :<C-u>call <SID>toggle_option('ignorecase')<CR>
Map [n] <excmd>op :<C-u>call <SID>toggle_option('paste')<CR>
Map [n] <excmd>ow :<C-u>call <SID>toggle_option('wrap')<CR>
Map [n] <excmd>oe :<C-u>call <SID>toggle_option('expandtab')<CR>
Map [n] <excmd>ol :<C-u>call <SID>toggle_option('list')<CR>
Map [n] <excmd>om :<C-u>call <SID>toggle_option('modeline')<CR>
Map [n] <excmd>ofc :<C-u>call <SID>advance_option_state(['', 'all'], 'foldclose')<CR>
Map [n] <excmd>ofm :<C-u>call <SID>advance_option_state(['manual', 'marker', 'indent'], 'foldmethod')<CR>


" FIXME: Bad name :(
command!
\   -bar
\   OptInit
\
\   set hlsearch ignorecase nopaste wrap expandtab list modeline foldclose= foldmethod=manual
\   | echo 'Initialized frequently toggled options.'

Map [n] <excmd>OI :<C-u>OptInit<CR>


silent OptInit
" }}}
" Select coding style. {{{
"
" These settings is only about tab.
" See the followings for the details:
"   http://www.jukie.net/bart/blog/vim-and-linux-coding-style
"   http://yuanjie-huang.blogspot.com/2009/03/vim-in-gnu-coding-style.html
"   http://en.wikipedia.org/wiki/Indent_style
" But wikipedia is dubious, I think :(

let s:coding_styles = {}
let s:coding_styles['My style'] =
\   'set expandtab   tabstop=4 shiftwidth=4 softtabstop&'
let s:coding_styles['Short indent'] =
\   'set expandtab   tabstop=2 shiftwidth=2 softtabstop&'
let s:coding_styles['GNU'] =
\   'set expandtab   tabstop=8 shiftwidth=2 softtabstop=2'
let s:coding_styles['BSD'] =
\   'set noexpandtab tabstop=8 shiftwidth=4 softtabstop&'    " XXX
let s:coding_styles['Linux'] =
\   'set noexpandtab tabstop=8 shiftwidth=8 softtabstop&'

command!
\   -bar -nargs=1 -complete=customlist,s:coding_style_complete
\   CodingStyle
\   execute get(s:coding_styles, <f-args>, '')

function! s:coding_style_complete(...) "{{{
    return keys(s:coding_styles)
endfunction "}}}


Map [n] <excmd>ot :<C-u>call <SID>toggle_tab_options()<CR>

function! s:toggle_tab_options() "{{{
    let choice = prompt#prompt('Which do you prefer?:', {
    \   'one_char': 1,
    \   'menu': keys(s:coding_styles),
    \   'escape': 1,
    \})
    execute get(s:coding_styles, choice, '')
endfunction "}}}
" }}}

" Close help/quickfix window {{{
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


Map [n] <excmd>c: :<C-u>call <SID>close_cmdwin_window()<CR>
Map [n] <excmd>ch :<C-u>call <SID>close_help_window()<CR>
Map [n] <excmd>cQ :<C-u>call <SID>close_quickfix_window()<CR>
Map [n] <excmd>cr :<C-u>call <SID>close_ref_window()<CR>
Map [n] <excmd>cq :<C-u>call <SID>close_quickrun_window()<CR>
Map [n] <excmd>cb :<C-u>call <SID>close_unlisted_window()<CR>

Map [n] <excmd>cc :<C-u>call <SID>close_certain_window()<CR>
" }}}
" Close tab with also prefix <excmd>c. {{{
" tab
Map [n] <excmd>ct :<C-u>tabclose<CR>
" }}}
" Move window into tabpage {{{
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
Map [n] <excmd>st :<C-u>call <SID>move_window_into_tab_page(0)<Cr>
" }}}
" Merge tabpage into a tab {{{
function! s:exists_tab(tabpagenr) "{{{
    return 1 <= a:tabpagenr && a:tabpagenr <= tabpagenr('$')
endfunction "}}}

function! s:merge_tab_into_tab(from_tabpagenr, to_tabpagenr) "{{{
    if !s:exists_tab(a:from_tabpagenr)
    \   || !s:exists_tab(a:to_tabpagenr)
    \   || a:from_tabpagenr == a:to_tabpagenr
        return
    endif

    execute 'tabnext' a:to_tabpagenr
    for bufnr in tabpagebuflist(a:from_tabpagenr)
        split
        execute bufnr 'buffer'
    endfor

    execute 'tabclose' a:from_tabpagenr
endfunction "}}}

Map [n] <Space>mh :<C-u>call <SID>merge_tab_into_tab(tabpagenr(), tabpagenr() - 1)<CR>
Map [n] <Space>ml :<C-u>call <SID>merge_tab_into_tab(tabpagenr(), tabpagenr() + 1)<CR>
Map [n] <Space>m  :<C-u>call <SID>merge_tab_into_tab(tabpagenr(), input('tab number:'))<CR>
" }}}
" Netrw - vimperator-like keymappings {{{
function! s:filetype_netrw() "{{{
    Map [n] -buffer h -
    Map [n] -buffer l <CR>
    Map [n] -buffer e <CR>
endfunction "}}}

MyAutocmd FileType netrw call s:filetype_netrw()
" }}}
" 'Y' to yank till the end of line. {{{
Map [n] Y    y$
Map [n] ;Y   "+y$
Map [n] ,Y   "*y$
" }}}
" Back to col '$' when current col is right of col '$'. {{{
if has('virtualedit') && s:has_one_of(['all', 'onemore'], split(&virtualedit, ','))
    DefMap [n] -expr $-if-right-of-$    col('.') >= col('$') ? '$' : ''
    DefMap [n]       Paste              P
    DefMap [n]       paste              p
    Map [n] -remap P <$-if-right-of-$><Paste>
    Map [n] -remap p <$-if-right-of-$><paste>

    " omake
    Map [n] <excmd>p $p
endif
" }}}
" Move around windows beyond tabs {{{
" http://gist.github.com/358813
" http://gist.github.com/358862

Map [n] -silent <C-n> :<C-u>call <SID>NextWindowOrTab()<CR>
Map [n] -silent <C-p> :<C-u>call <SID>PreviousWindowOrTab()<CR>

function! s:NextWindowOrTab() "{{{
	if winnr() < winnr("$")
		wincmd w
	else
		tabnext
		1wincmd w
	endif
endfunction "}}}

function! s:PreviousWindowOrTab() "{{{
	if winnr() > 1
		wincmd W
	else
		tabprevious
		execute winnr("$") . "wincmd w"
	endif
endfunction "}}}
" }}}
" Open new window and Search current <cword>. {{{
Map [n] <Space>* :<C-u>Split<CR>*
Map [n] <Space># :<C-u>Split<CR>#
" }}}
" Move window position: <C-w>r, <C-w>R, <C-w>x suck! {{{
Map [n] -remap <Space><C-n> <SID>swap_window_next
Map [n] -remap <Space><C-p> <SID>swap_window_prev
Map [n] -remap <Space><C-j> <SID>swap_window_j
Map [n] -remap <Space><C-k> <SID>swap_window_k
Map [n] -remap <Space><C-h> <SID>swap_window_h
Map [n] -remap <Space><C-l> <SID>swap_window_l

Map [n] -silent <SID>swap_window_next :<C-u>call <SID>swap_window_count(v:count1)<CR>
Map [n] -silent <SID>swap_window_prev :<C-u>call <SID>swap_window_count(-v:count1)<CR>
Map [n] -silent <SID>swap_window_j :<C-u>call <SID>swap_window_dir(v:count1, 'j')<CR>
Map [n] -silent <SID>swap_window_k :<C-u>call <SID>swap_window_dir(v:count1, 'k')<CR>
Map [n] -silent <SID>swap_window_h :<C-u>call <SID>swap_window_dir(v:count1, 'h')<CR>
Map [n] -silent <SID>swap_window_l :<C-u>call <SID>swap_window_dir(v:count1, 'l')<CR>
Map [n] -silent <SID>swap_window_t :<C-u>call <SID>swap_window_dir(v:count1, 't')<CR>
Map [n] -silent <SID>swap_window_b :<C-u>call <SID>swap_window_dir(v:count1, 'b')<CR>

function! s:modulo(n, m) "{{{
  let d = a:n * a:m < 0 ? 1 : 0
  return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
endfunction "}}}

function! s:swap_window_count(n) "{{{
  let curwin = winnr()
  let target = s:modulo(curwin + a:n - 1, winnr('$')) + 1
  call s:swap_window(curwin, target)
endfunction "}}}

function! s:swap_window_dir(n, dir) "{{{
  let curwin = winnr()
  execute a:n 'wincmd' a:dir
  let targetwin = winnr()
  wincmd p
  call s:swap_window(curwin, targetwin)
endfunction "}}}

function! s:swap_window(curwin, targetwin) "{{{
  let curbuf = winbufnr(a:curwin)
  let targetbuf = winbufnr(a:targetwin)

  if curbuf == targetbuf
    " TODO: Swap also same buffer!
  else
    execute 'hide' targetbuf . 'buffer'
    execute a:targetwin 'wincmd w'
    execute curbuf 'buffer'
  endif
endfunction "}}}
" }}}
" Count the number of <cword> in this file {{{
" http://d.hatena.ne.jp/miho36/20100621/1277092415

function! s:count_word(word) "{{{
    if a:word == ''
        return
    endif

    redir => output
    silent execute "%s/" . a:word . "/&/gn"
    redir END
    let output = substitute(output, '^\n\+', '', '')

    echomsg printf('"%s" => %s', a:word, output)
endfunction "}}}
Map [n] <Space>n :<C-u>call <SID>count_word(expand('<cword>'))<CR>
" }}}
" Minor mappings to change window layout. {{{

Map [n] -remap <window>j <SID>(merge-curwin-into-j)
Map [n] -remap <window>k <SID>(merge-curwin-into-k)
Map [n] -remap <window>h <SID>(merge-curwin-into-h)
Map [n] -remap <window>l <SID>(merge-curwin-into-l)

Map [n] -silent <SID>(merge-curwin-into-j) :<C-u>call <SID>window_merge('j', 'J', 1)<CR>
Map [n] -silent <SID>(merge-curwin-into-k) :<C-u>call <SID>window_merge('k', 'K', 1)<CR>
Map [n] -silent <SID>(merge-curwin-into-h) :<C-u>call <SID>window_merge('h', 'H', 0)<CR>
Map [n] -silent <SID>(merge-curwin-into-l) :<C-u>call <SID>window_merge('l', 'L', 0)<CR>

function! s:window_merge(jump_cmd, layout_cmd, vertical) "{{{
    let save_ei = &eventignore
    let &l:eventignore = 'all'
    try
        let curbuf = bufnr('%')
        let i = 0
        while i < v:count1
            let curwin = winnr()
            execute 'wincmd' a:jump_cmd
            let nextgroupwin = winnr()

            if curwin ==# nextgroupwin
                " No more next group. Create new group.
                execute 'wincmd' a:layout_cmd
            else
                wincmd p
                " Close `curwin` window.
                hide
                " Back to `nextgroupwin` window.
                wincmd p

                execute (a:vertical ? 'vsplit' : 'split')
            endif

            let i += 1
        endwhile
        let &l:eventignore = save_ei    " to detect `curbuf` buffer filetype.
        silent execute curbuf 'buffer'
    finally
        let &l:eventignore = save_ei
    endtry
endfunction "}}}

" }}}
" Hide default <C-w>[hjkl] mappings for previous mappings. {{{
Map [n] <Space>j <C-w>j
Map [n] <Space>k <C-w>k
Map [n] <Space>h <C-w>h
Map [n] <Space>l <C-w>l
" }}}
" <C-w>s, <C-w>v: I don't want to use them because they depend on 'splitright', 'splitbelow' ! {{{

Map [n] -remap <excmd>sj <SID>(split-to-j)
Map [n] -remap <excmd>sk <SID>(split-to-k)
Map [n] -remap <excmd>sh <SID>(split-to-h)
Map [n] -remap <excmd>sl <SID>(split-to-l)

Map [n] <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
Map [n] <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
Map [n] <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
Map [n] <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>

" }}}
" }}}
" vmap {{{
" TODO: '<C-g>' and 'g<C-g>' in visual mode: Show information about selected area. {{{
" }}}
" }}}
" map! {{{
Map [ic] <C-f> <Right>
Map [ic] <C-b> <Left>
Map [ic] <C-a> <Home>
Map [ic] <C-e> <End>
Map [ic] <C-d> <Del>
Map [ic] <C-l> <Tab>

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
Map [i] <C-r><C-u>  <C-r><C-p>+
Map [i] <C-r><C-i>  <C-r><C-p>*
Map [i] <C-r><C-o>  <C-r><C-p>"
Map [i] <C-r>       <C-r><C-r>

" shift left (indent)
Map [i] <C-q>   <C-d>

" make <C-w> and <C-u> undoable.
Map [i] <C-w> <C-g>u<C-w>
Map [i] <C-u> <C-g>u<C-u>

Map [i] <C-@> <C-a>

Map [i] <S-CR> <C-o>O
Map [i] <C-CR> <C-o>o
" }}}
" cmap {{{
if &wildmenu
    Map [c] -force <C-f> <Space><BS><Right>
    Map [c] -force <C-b> <Space><BS><Left>
endif

" paste register
Map [c] <C-r><C-u>  <C-r>+
Map [c] <C-r><C-i>  <C-r>*
Map [c] <C-r><C-o>  <C-r>"

Map [c] -expr /  getcmdtype() == '/' ? '\/' : '/'
Map [c] -expr ?  getcmdtype() == '?' ? '\?' : '?'
" }}}
" abbr {{{
inoreab <expr> date@      strftime("%Y-%m-%d")
inoreab <expr> time@      strftime("%H:%M")
inoreab <expr> dt@        strftime("%Y-%m-%d %H:%M")

AlterCommand th     tab<Space>help
AlterCommand t      tabedit
AlterCommand sf     setf
AlterCommand hg     helpgrep
AlterCommand ds     diffsplit

" For typo.
AlterCommand qw     wq
AlterCommand amp    map
" }}}

" Mappings with option value. {{{
Map [n] -expr / <SID>expr_with_options('/', {'&hlsearch': 1})
Map [n] -expr ? <SID>expr_with_options('?', {'&hlsearch': 1})

Map [n] -expr * <SID>expr_with_options('*', {'&hlsearch': 1, '&ignorecase': 0})
Map [n] -expr # <SID>expr_with_options('#', {'&hlsearch': 1, '&ignorecase': 0})

Map [nv] -expr : <SID>expr_with_options(':', {'&ignorecase': 1})

Map [n] -expr gd <SID>expr_with_options('gd', {'&hlsearch': 1})
Map [n] -expr gD <SID>expr_with_options('gD', {'&hlsearch': 1})
" }}}
" Emacs like kill-line. {{{
Map [i] -expr <C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
Map [c] <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" }}}
" Make searching directions consistent {{{
  " 'zv' is harmful for Operator-pending mode and it should not be included.
  " For example, 'cn' is expanded into 'cnzv' so 'zv' will be inserted.
Map [nv] -expr n <SID>search_forward_p() ? 'nzv' : 'Nzv'
Map [nv] -expr N <SID>search_forward_p() ? 'Nzv' : 'nzv'
Map [o]  -expr n <SID>search_forward_p() ? 'n' : 'N'
Map [o]  -expr N <SID>search_forward_p() ? 'N' : 'n'

function! s:search_forward_p()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction
" }}}
" Walk between columns at 0, ^, $, window's right edge(virtualedit). {{{

function! s:get_tilde_col(lnum) "{{{
endfunction "}}}

function! s:back_between(zero, tilde, dollar) "{{{
    let curcol = col('.')
    let tilde_col = match(getline('.'), '\S') + 1

    if curcol > col('$')
        return a:dollar
    elseif curcol > tilde_col
        return a:tilde
    else
        return a:zero
    endif
endfunction "}}}
function! s:advance_between(tilde, dollar) "{{{
    let curcol = col('.')
    let tilde_col = match(getline('.'), '\S') + 1

    if curcol < tilde_col
        return a:tilde
    elseif curcol < col('$')
        return a:dollar
    else
        return ''
        " return a:right_edge
    endif
endfunction "}}}

" imap
Map [i] -expr -force <C-a> <SID>back_between("\<Home>", "\<C-o>^", "\<End>")
Map [i] -expr -force <C-e> <SID>advance_between("\<C-o>^", "\<End>")

" motion
Map [nvo] -expr H <SID>back_between('0', '^', '$')
Map [nvo] -expr L <SID>advance_between('^', '$')

" TODO
" Map [nvo] -expr L <SID>advance_between('^', '$', '')    " <comment Go right edge of window.>

" }}}
" Disable unused keys. {{{
Map [n] ZZ <Nop>
Map [n] U  <Nop>
Map [v] K  <Nop>
" }}}
" Expand abbreviation {{{
" http://gist.github.com/347852
" http://gist.github.com/350207

DefMap [i] -expr bs-ctrl-] getline('.')[col('.') - 2]    ==# "\<C-]>" ? "\<BS>" : ''
DefMap [c] -expr bs-ctrl-] getcmdline()[getcmdpos() - 2] ==# "\<C-]>" ? "\<BS>" : ''
Map   [ic] -remap <C-]>     <C-]><bs-ctrl-]>
" }}}
" <Esc> to execute current pending mapping {{{
" Because I don't use `set timeout`,
" I need the key to execute pending mapping.

Map [o] <Esc> <Nop>

" TODO I need the key to execute pending mapping in mapmode-ic...

" }}}

" [compl] {{{
call s:map_prefix_key('i', 'compl', '<Tab>')
" Do <C-n> while pumvisible().
execute 'imap <expr> <Tab> pumvisible() ? "\<C-n>" : ' . string(maparg('<Tab>', 'i'))


Map [i] <compl><Tab> <C-n>

Map [i] <compl>n <C-x><C-n>
Map [i] <compl>p <C-x><C-p>

Map [i] <compl>] <C-x><C-]>
Map [i] <compl>d <C-x><C-d>
Map [i] <compl>f <C-x><C-f>
Map [i] <compl>i <C-x><C-i>
Map [i] <compl>k <C-x><C-k>
Map [i] <compl>l <C-x><C-l>
" Map [i] <compl>s <C-x><C-s>
" Map [i] <compl>t <C-x><C-t>

Map [i] -expr <compl>o <SID>omni_or_user_func()

function! s:omni_or_user_func() "{{{
    if &omnifunc != ''
        return "\<C-x>\<C-o>"
    elseif &completefunc != ''
        return "\<C-x>\<C-u>"
    else
        return "\<C-n>"
    endif
endfunction "}}}


" Map [i] <compl>j <C-n>
" Map [i] <compl>k <C-p>
" TODO
" call submode#enter_with('c', 'i', '', emap#compile_map('<compl>j', 'i'), '<C-n>')
" call submode#enter_with('c', 'i', '', emap#compile_map('<compl>k', 'i'), '<C-p>')
" call submode#leave_with('c', 'i', '', '<CR>')
" call submode#map       ('c', 'i', '', 'j', '<C-n>')
" call submode#map       ('c', 'i', '', 'k', '<C-p>')


" }}}
" }}}
" Encoding {{{
let s:enc = 'utf-8'
let &enc = s:enc
let &fenc = s:enc
let &termencoding = s:enc
let &fileencodings = s:uniq_path(
\   [s:enc]
\   + split(&fileencodings, ',')
\   + ['iso-2022-jp', 'iso-2022-jp-3']
\)
unlet s:enc

set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif

call s:map_prefix_key('nvo', 'encoding', ',')

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

Map [n] <encoding>ta     :call ChangeEncoding()<CR>
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

Map [n] <encoding>ts    :<C-u>call ChangeFileEncoding()<CR>
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

Map [n] <encoding>td    :<C-u>call ChangeNL()<CR>
" }}}
" }}}
" FileType {{{
function! s:each_filetype() "{{{
    return split(&l:filetype, '\.')
endfunction "}}}

function! s:set_dict() "{{{
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
endfunction "}}}
function! s:set_tab_width() "{{{
    if s:has_one_of(['css', 'xml', 'html', 'lisp', 'scheme', 'yaml'], s:each_filetype())
        CodingStyle Short indent
    else
        CodingStyle My style
    endif
endfunction "}}}
function! s:set_compiler() "{{{
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
endfunction "}}}
function! s:load_filetype() "{{{
    if &omnifunc == ""
        setlocal omnifunc=syntaxcomplete#Complete
    endif

    call s:set_dict()
    call s:set_tab_width()
    call s:set_compiler()
endfunction "}}}

MyAutocmd FileType * call s:load_filetype()
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
            try
                silent execute 'helptags' join(a:000) doc
            catch
                echohl WarningMsg
                echom v:exception
                echom v:throwpoint
                echohl None
            endtry
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

AlterCommand ac[k] Ack
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
AlterCommand rtp EchoPath<Space>&rtp


command!
\   -nargs=+ -complete=expression
\   EchoPath
\   call s:cmd_echo_path(<f-args>)

function! s:cmd_echo_path(optname, ...) "{{{
    let delim = a:0 != 0 ? a:1 : ','
    let val = eval(a:optname)
    for i in split(val, delim)
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
" AllMaps {{{
command!
\   -nargs=*
\   AllMaps
\   map <args> | map! <args> | lmap <args>
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
\   -bar -nargs=1 -complete=file
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
" Capture {{{
AlterCommand cap[ture] Capture

command!
\   -nargs=+ -complete=command
\   Capture
\   call s:cmd_capture(<q-args>)

function! s:cmd_capture(q_args) "{{{
    redir => output
    silent execute a:q_args
    redir END
    let output = substitute(output, '^\n\+', '', '')

    " Change as you like. for e.g., :new instead.
    New

    silent file `=printf('[Capture: %s]', a:q_args)`
    setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
    call setline(1, split(output, '\n'))
endfunction "}}}
" }}}

" TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
AlterCommand cd  TabpageCD

Map [n] ,cd       :<C-u>TabpageCD %:p:h<CR>
Map [n] <Space>cd :<C-u>lcd %:p:h<CR>

command! -complete=dir -nargs=? TabpageCD
\   execute 'cd' fnameescape(expand(<q-args>))
\ | let t:cwd = getcwd()

MyAutocmd TabEnter *
\   if exists('t:cwd') && !isdirectory(t:cwd)
\ |     unlet t:cwd
\ | endif
\ | if !exists('t:cwd')
\ |   let t:cwd = getcwd()
\ | endif
\ | execute 'cd' fnameescape(expand(t:cwd))
" }}}
" s:split_nicely_with() {{{
AlterCommand sp[lit]    Split
AlterCommand h[elp]     Help
AlterCommand new        New

command!
\   -bar -bang -nargs=* -complete=file
\   Split
\   call s:split_nicely_with(['split', <f-args>], <bang>0)

command!
\   -bar -bang -nargs=* -complete=file
\   New
\   call s:split_nicely_with(['new', <f-args>], <bang>0)

command!
\   -bar -bang -nargs=* -complete=help
\   Help
\   call s:cmd_Help(['help', <f-args>], <bang>0)

function! s:cmd_Help(f_args, banged) "{{{
    let save = {'splitright': &splitright, 'splitbelow': &splitbelow}
    let [&splitright, &splitbelow] = [1, 0]
    try
        call s:split_nicely_with(a:f_args, a:banged)
    finally
        let [&splitright, &splitbelow] = [save.splitright, save.splitbelow]
    endtry
endfunction "}}}

function! s:vertically() "{{{
    return 80*2 * 15/16 <= winwidth(0)  " FIXME: threshold customization
endfunction "}}}

" Originally from kana's s:split_nicely().
function! s:split_nicely_with(args, banged) "{{{
    if empty(a:args)
        return
    endif

    try
        execute
        \   s:vertically() ? 'vertical' : ''
        \   a:args[0] . (a:banged ? '!' : '')
        \   join(a:args[1:])
    catch
        echohl ErrorMsg
        echomsg substitute(v:exception, '^Vim(\w\+):', '', '')
        echohl None
    endtry
endfunction "}}}
" }}}
" SelectColorScheme {{{
" via http://gist.github.com/314439
" via http://gist.github.com/314597
fun! s:SelectColorScheme()
  30vnew

  let files = split(globpath(&rtp, 'colors/*.vim'), "\n")
  let regex = '\w\+\(\.vim\)\@='
  let files = map(files, 'matchstr(v:val, regex)')
  let files = sort(files)
  let files = s:uniq(files)
  call setline(1, files)

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
\   -nargs=+
\   Grep
\   call s:grep([<f-args>])

function! s:grep(args)
    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
    noautocmd execute 'vimgrep' '/' . a:args[0] . '/j' target
    QuickFix
endfunction
" }}}
" :WhichEdit {{{
AlterCommand we WhichEdit
command!
\   -nargs=1 -complete=customlist,s:complete_bin_programs
\   WhichEdit
\   call s:cmd_which_edit(<f-args>)

function! s:complete_bin_programs(arg_lead, cmd_line, cursor_pos) "{{{
    return []    " TODO
endfunction "}}}

function! s:cmd_which_edit(arg) "{{{
    if !exists('*Which')
        echoerr "You have not installed which.vim yet. (script_id is 139)"
        return
    endif
    execute 'edit' Which(a:arg)
endfunction "}}}

" }}}
" :BacktickEdit {{{
AlterCommand be BacktickEdit
command!
\   -nargs=+
\   BacktickEdit
\   edit `<args>`
" }}}
" }}}
" For Plugins {{{
" CommentAnyWay {{{
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
Map [n] -remap ,n <Plug>(nextfile-next)
Map [n] -remap ,p <Plug>(nextfile-previous)

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
" let g:SD_debug = 1
let g:SD_disable = 1

if !g:SD_disable
    Map [n] -silent <C-l> :SDUpdate<CR><C-l>
endif
" }}}
" DumbBuf {{{
let dumbbuf_hotkey = 'gb'
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
" skk.vim && eskk.vim {{{

if 1
" Map <C-j> to eskk, Map <C-g><C-j> to skk.vim {{{
let skk_control_j_key = '<C-g><C-j>'
" }}}
else
" Map <C-j> to skk.vim, Map <C-g><C-j> to eskk {{{
map! <C-g><C-j> <Plug>(eskk:toggle)
" }}}
endif

" }}}
" skk {{{
let g:skk_disable = 0

let skk_jisyo = '~/.skk-jisyo'
let skk_large_jisyo = '/usr/share/skk/SKK-JISYO'

" let skk_control_j_key = ''
" Arpeggio map! fj    <Plug>(skk-enable-im)

let skk_manual_save_jisyo_keys = ''

let skk_egg_like_newline = 1
let skk_auto_save_jisyo = 1
let skk_imdisable_state = -1
let skk_keep_state = 1
let skk_sticky_key = ';'
let skk_show_candidates_count = 2
let skk_remap_lang_mode = 0
let skk_show_annotation = 0


if 0
" g:skk_enable_hook test {{{
" Do not map `<Plug>(skk-toggle-im)`.
let skk_control_j_key = ''

" `<C-j><C-e>` to enable, `<C-j><C-d>` to disable.
map! <C-j><C-e> <Plug>(skk-enable-im)
map! <C-j><C-d> <Nop>
function! MySkkMap()
    lunmap <buffer> <C-j>
    lmap <buffer> <C-j><C-d> <Plug>(skk-disable-im)
endfunction
function! HelloWorld()
    echomsg 'Hello.'
endfunction
function! Hogera()
    echomsg 'hogera'
endfunction
let skk_enable_hook = 'MySkkMap,HelloWorld,Hogera'
" }}}
endif

" }}}
" eskk {{{
let g:eskk_disable = 0
let g:eskk_debug = 1
let g:eskk_debug_file = '~/eskk-debug.log'

call eskk#load()

if has('vim_starting')
    let g:eskk_dictionary.path = '~/.skk-jisyo'
    let g:eskk_large_dictionary.path = '/usr/share/skk/SKK-JISYO'
endif

let g:eskk_egg_like_newline = 1
let g:eskk_keep_state = 1
let g:eskk_show_candidates_count = 2
let g:eskk_show_annotation = 0
let g:eskk_rom_input_style = 'msime'


" Disable "qkatakana". not ";katakanaq".
EskkMap -type=mode:hira:toggle-kata <Nop>

" NOTE:
" eskk#table#get_definition() calls eskk#util#log(),
" and it will :redraw statusline.
runtime! plugin/skk.vim

let t = eskk#table#get_definition('rom_to_hira')
let t['~'] = ['〜', '']
let t['zc'] = ['©', '']
let t['zr'] = ['®', '']
unlet t


" NOTE: Experimental

" command! EskkDumpBuftable call eskk#get_buftable().dump_print()

" inoremap <C-l> <C-o><C-l>

" EskkMap U <Plug>(eskk:undo-kakutei)

" EskkMap lhs rhs
" EskkMap -silent lhs2 rhs
" EskkMap -unique lhs2 foo
" EskkMap -expr lhs3 {'foo': 'hoge'}.foo
" EskkMap -noremap lhs4 rhs
" }}}
" stickykey {{{

" I use stickykey for emergency use.
" So these mappings are little bit difficult to press, but I don't care.

Map [nvoicl] -remap <C-g><C-s> <Plug>(stickykey-shift-remap)
Map [nvoicl] -remap <C-g><C-c> <Plug>(stickykey-ctrl-remap)
Map [nvoicl] -remap <C-g><C-a> <Plug>(stickykey-alt-remap)
" I don't have Macintosh :(
" Map [nvoicl] -remap <C-g><C-m> <Plug>(stickykey-command-remap)

" }}}
" restart {{{
AlterCommand res[tart] Restart
AlterCommand ers[tart] Restart
AlterCommand rse[tart] Restart
" }}}
" openbrowser {{{
MyAutocmd VimEnter * Map [nv] -remap -force gx <Plug>(openbrowser-open)
" }}}
" AutoDate {{{
let g:autodate_format = "%Y-%m-%d"
" }}}
" FuzzyFinder {{{
call s:map_prefix_key('n', 'anything', 's')

Map [n] <anything>d        :<C-u>FufDir<CR>
Map [n] <anything>f        :<C-u>FufFile<CR>
Map [n] <anything>h        :<C-u>FufMruFile<CR>
Map [n] <anything>r        :<C-u>FufRenewCache<CR>

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
Map [n] <C-h> :<C-u>MRU<CR>
let MRU_Max_Entries   = 500
let MRU_Add_Menu      = 0
let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\|COMMIT_EDITMSG'
" }}}
" changelog {{{
let changelog_username = "tyru"
" }}}
" Gtags {{{
if 0
" <C-]> for gtags. {{{
function! s:JumpTags() "{{{
    if expand('%') == '' | return | endif

    if !exists(':GtagsCursor')
        echo "gtags.vim is not installed. do default <C-]>..."
        sleep 2
        " unmap this function.
        " use plain <C-]> next time.
        Unmap [n] <C-]>
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
Map [n] <C-]>     :<C-u>call <SID>JumpTags()<CR>
" }}}
endif
" }}}
" vimshell {{{
AlterCommand vsh[ell] VimShell

MyAutocmd FileType vimshell call s:vimshell_settings()

function! s:vimshell_settings() "{{{
    " No -bar
    command!
    \   -buffer -nargs=+
    \   VimShellAlterCommand
    \   call vimshell#altercmd#define(
    \       s:parse_one_arg_from_q_args(<q-args>)[0],
    \       s:eat_n_args_from_q_args(<q-args>, 1)
    \   )

    " Alias
    VimShellAlterCommand vi vim
    VimShellAlterCommand df df -h
    VimShellAlterCommand diff diff --unified
    VimShellAlterCommand du du -h
    VimShellAlterCommand free free -m -l -t
    VimShellAlterCommand j jobs -l
    VimShellAlterCommand jobs jobs -l
    " VimShellAlterCommand l. ls -d .*
    " VimShellAlterCommand l ls -lh
    VimShellAlterCommand ll ls -lh
    VimShellAlterCommand la ls -A
    VimShellAlterCommand less less -r
    VimShellAlterCommand sc screen
    VimShellAlterCommand whi which
    VimShellAlterCommand whe where
    VimShellAlterCommand go gopen
    VimShellAlterCommand termtter iexe termtter
    VimShellAlterCommand sudo iexe sudo

    call vimshell#set_alias('l.', 'ls -d .*')

    " Abbrev
    inoreabbrev <buffer> l@ <Bar> less
    inoreabbrev <buffer> g@ <Bar> grep
    inoreabbrev <buffer> p@ <Bar> perl
    inoreabbrev <buffer> s@ <Bar> sort
    inoreabbrev <buffer> u@ <Bar> sort -u
    inoreabbrev <buffer> c@ <Bar> xsel --input --clipboard
    inoreabbrev <buffer> x@ <Bar> xargs --no-run-if-empty
    inoreabbrev <buffer> n@ >/dev/null 2>/dev/null
    inoreabbrev <buffer> e@ 2>&1
    inoreabbrev <buffer> h@ --help 2>&1 <Bar> less
    inoreabbrev <buffer> H@ --help 2>&1

    if executable('perldocjp')
        VimShellAlterCommand perldoc perldocjp
    endif

    let less_sh = s:globpath(&rtp, 'macros/less.sh')
    if !empty(less_sh)
        call vimshell#altercmd#define('vless', less_sh[0])
    endif

    " Hook
    function! s:chpwd_ls(args, context)
        call vimshell#execute('ls')
    endfunction

    call vimshell#hook#set('chpwd', [s:SNR('chpwd_ls')])

    " Add/Remove some mappings.
    Unmap [n] -buffer <C-n>
    Unmap [n] -buffer <C-p>
    Unmap [i] -buffer <C-k>
    Map [i] -buffer -force <C-l> <Space><Bar><Space>
    Unmap [i] -buffer <Tab>
    Map [i] -remap -buffer -force <Tab><Tab> <Plug>(vimshell_command_complete)

    " Misc.
    setlocal backspace-=eol
    setlocal updatetime=0

    NeoComplCacheEnable
    autocmd BufEnter <buffer> NeoComplCacheEnable
    autocmd BufLeave <buffer> NeoComplCacheDisable
endfunction "}}}
" }}}
" quickrun {{{
let g:loaded_quicklaunch = 1

let g:quickrun_no_default_key_mappings = 1
Map [nvo] -remap <Space>r <Plug>(quickrun)

if has('vim_starting')
    let g:quickrun_config = {}
    let g:quickrun_config['*'] = {'split': printf('{%s() ? "vertical" : ""}', s:SNR('vertically'))}
    if executable('pandoc')
        let g:quickrun_config['markdown'] = {'command' : 'pandoc'}
    endif
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
call submode#map       ('guiwinsize', 'n', '', 'j', ':set lines+=1<CR>')
call submode#map       ('guiwinsize', 'n', '', 'k', ':set lines-=1<CR>')
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

" Scroll by j and k.
" TODO Stash &scroll value.
" TODO Make utility function to generate current shortest <SID> map.
call submode#enter_with('s', 'n', '', 'gj', '<C-d>:redraw<CR>')
call submode#enter_with('s', 'n', '', 'gk', '<C-u>:redraw<CR>')
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
AlterCommand pdoc Ref<Space>perldoc
AlterCommand cppref Ref<Space>cppref
AlterCommand cpp    Ref<Space>cppref

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
" vimfiler {{{
" let g:vimfiler_as_default_explorer = 1
let g:vimfiler_split_command = 'Split'
let g:vimfiler_edit_command = 'edit'
" }}}
" prettyprint {{{
AlterCommand pp PP

let g:prettyprint_echo_type = 'buffer'
let g:prettyprint_echomsg_highlight = 'Debug'
let g:prettyprint_echo_buffer_new = 'New'
" }}}
" fencview {{{
let g:fencview_auto_patterns = '*'
let g:fencview_show_progressbar = 0
" }}}
" lingr.vim {{{
" if !exists('g:lingr')
"     " Only when started by the 'lingr' command(alias), lingr.vim is used.
"     "     alias lingr="vim --cmd 'let g:lingr = 1' -c LingrLaunch"
"     let g:loaded_lingr_vim = 1
" endif
" let g:lingr_vim_user = 'tyru'
" augroup vimrc-plugin-lingr
"     autocmd!
"     autocmd User plugin-lingr-* call s:lingr_event(
"     \            matchstr(expand('<amatch>'), 'plugin-lingr-\zs\w*'))
"     autocmd FileType lingr-* call s:init_lingr(expand('<amatch>'))
" augroup END
" function! s:init_lingr(ft) "{{{
"     if exists('s:window')
"         nnoremap <buffer> <silent> <C-l> :<C-u>call <SID>auto_window_name()<CR><C-l>
"         let b:window_name = 'lingr-vim'
"     endif
" endfunction "}}}
" function! s:lingr_event(event) "{{{
"   if a:event ==# 'message' && exists(':WindowName')
"     execute printf('WindowName %s(%d)', 'lingr-vim', lingr#unread_count())
"   endif
" endfunction "}}}
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
" Do not load menu {{{
let did_install_default_menus = 1
" }}}
" About japanese input method {{{
if has('multi_byte_ime') || has('xim')
  " Cursor color when IME is on.
  highlight CursorIM guibg=Purple guifg=NONE
  set iminsert=0 imsearch=0
endif
" }}}
" Do `<C-g>u` when inserted a character. {{{
function! s:is_changed() "{{{
    try
        " When no `b:vimrc_changedtick` variable (first time), not changed.
        return exists('b:vimrc_changedtick') && b:vimrc_changedtick < b:changedtick
    finally
        let b:vimrc_changedtick = b:changedtick
    endtry
endfunction "}}}

" MyAutocmd CursorMovedI * if s:is_changed() | doautocmd User changed-text | endif
" MyAutocmd User changed-text call feedkeys("\<C-g>u", 'n')
" }}}
" :hyde {{{

AlterCommand hyd[e] Hyde

command!
\   -bar -nargs=1 -complete=expression
\   Hyde
\   call s:cmd_hyde(<q-args>)

function! s:hyde2inch(hyde_num) "{{{
    return s:hyde2cm(a:hyde_num) / 2.54
endfunction "}}}
function! s:hyde2cm(hyde_num) "{{{
    return a:hyde_num * 156
endfunction "}}}

function! s:cmd_hyde(hyde_num_str) "{{{
    " Hyde it more accurately
    let hyde_num = str2float(a:hyde_num_str)

    " http://dic.nicovideo.jp/a/156cm
    if v:lang ==# 'C'
        echo s:hyde2inch(hyde_num) 'inch'
    elseif v:lang =~# '^ja_JP'
        echo s:hyde2cm(hyde_num) 'cm'
    else
        echo hyde_num 'hyde'
    endif
endfunction "}}}

" }}}
" GNU Screen, Tmux {{{
" function! s:set_window_name(name) "{{{
"       let esc = "\<ESC>"
"       silent! execute '!echo -n "' . esc . 'k' . escape(a:name, '%#!')
"         \ . esc . '\\"'
"       redraw!
" endfunction "}}}
" command! -nargs=? WindowName call s:set_window_name(<q-args>)
" function! s:auto_window_name() "{{{
"   let varname = 'window_name'
"   for scope in ['w:', 'b:', 't:', 'g:']
"     if exists(scope .varname)
"       call s:set_window_name(eval(scope . varname))
"       return
"     endif
"   endfor
"   if bufname('%') !~ '^\[A-Za-z0-9\]*:/'
"     call s:set_window_name('v:' . expand('%:t'))
"   endif
" endfunction "}}}
" }}}
" }}}
" End. {{{

if filereadable(expand('~/.vimrc.local'))
    source `=expand('~/.vimrc.local')`
endif


if has('vim_starting')
    GarbageCorrect    " first time
endif


set secure
" }}}
