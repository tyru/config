" vim:set fen fdm=marker:
"
" See also: ~/.vimrc
"

" let $VIMRC_DEBUG = 1
" let $VIMRC_DISABLE_MYAUTOCMD = 1
" let $VIMRC_DISABLE_VIMENTER = 1


" Basic {{{
scriptencoding utf-8

syntax enable
filetype plugin indent on

language messages C
language time C

if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
endif

let s:is_win = has('win16') || has('win32') || has('win64') || has('win95')
" }}}
" Utilities {{{
" Function {{{

function! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction "}}}
function! s:SNR(map) "{{{
    return printf("<SNR>%d_%s", s:SID(), a:map)
endfunction "}}}

" e.g.) s:has_plugin('eskk') ? 'yes' : 'no'
function! s:has_plugin(name)
    let nosuffix = a:name =~? '\.vim$' ? a:name[:-5] : a:name
    let suffix   = a:name =~? '\.vim$' ? a:name      : a:name . '.vim'
    return &rtp =~# '\c\<' . nosuffix . '\>'
    \   || globpath(&rtp, suffix, 1) != ''
    \   || globpath(&rtp, nosuffix, 1) != ''
    \   || globpath(&rtp, 'autoload/' . suffix, 1) != ''
    \   || globpath(&rtp, 'autoload/' . tolower(suffix), 1) != ''
endfunction

" e.g.)
" echo s:fill_version('7.3.629')
" echo s:fill_version('7.3')
function! s:fill_version(str)
    let m = matchlist(a:str, '\v'.'^(\d+)\.(\d{1,2})(\.\d+)?$')
    if empty(m)
        throw 'error: s:fill_version(): '
        \   . 'version string format is invalid: '.a:str
    endif
    let ver = printf('%d%02d', m[1], m[2])
    let patch = m[3] ==# '' ? '1' : m[3][1:]
    return v:version ># ver
    \   || (v:version is ver && has('patch'.patch))
endfunction

function! s:echomsg(hl, msg) "{{{
    execute 'echohl' a:hl
    try
        echomsg a:msg
    finally
        echohl None
    endtry
endfunction "}}}
function! s:warn(msg) "{{{
    call s:echomsg('WarningMsg', a:msg)
endfunction "}}}

function! s:splitmapjoin(str, pattern, expr, sep)
    return join(map(split(a:str, a:pattern, 1), a:expr), a:sep)
endfunction
function! s:map_lines(str, expr)
    " return s:splitmapjoin(value, '\n', expr, "\n")
    return join(map(split(a:str, '\n', 1), a:expr), "\n")
endfunction

" Like builtin getchar() but returns string always.
" and do inputsave()/inputrestore() before/after getchar().
function! s:getchar_safe(...)
  let c = s:input_helper('getchar', a:000)
  return type(c) == type("") ? c : nr2char(c)
endfunction
" Like builtin getchar() but
" do inputsave()/inputrestore() before/after input().
function! s:input_safe(...)
    return s:input_helper('input', a:000)
endfunction
" Do inputsave()/inputrestore() before/after calling a:funcname.
function! s:input_helper(funcname, args)
    let success = 0
    if inputsave() !=# success
        throw 'inputsave() failed'
    endif
    try
        return call(a:funcname, a:args)
    finally
        if inputrestore() !=# success
            throw 'inputrestore() failed'
        endif
    endtry
endfunction

" }}}
" Commands {{{
augroup vimrc
    autocmd!
augroup END


command!
\   -bar -nargs=1
\   Nop
\   command! -bar -bang -nargs=* <args> :



" :autocmd is listed in |:bar|
command! -bang -nargs=* MyAutocmd autocmd<bang> vimrc <args>

if exists('$VIMRC_DISABLE_MYAUTOCMD')
    Nop MyAutoCmd
endif



command!
\   -nargs=+
\   Lazy
\   call s:cmd_lazy(<q-args>)

if exists('$VIMRC_DISABLE_VIMENTER')
    Nop Lazy
endif

function! s:cmd_lazy(q_args) "{{{
    if a:q_args == ''
        return
    endif
    if has('vim_starting')
        execute 'MyAutocmd VimEnter *'
        \       join([
        \           'try',
        \               'execute '.string(a:q_args),
        \           'catch',
        \               'call StartDebugMode()',
        \           'endtry',
        \       ], " | ")
    else
        execute a:q_args
    endif
endfunction "}}}

command!
\   -bar -nargs=+
\   Echomsg
\   call s:echomsg(
\       matchstr(<q-args>, '^\s*\zs\S\+'),
\       eval(matchstr(<q-args>, '^\s*\S\+\s\+\zs.*'))
\   )

" }}}
" }}}
" Initializing {{{

if !exists('$VIMRC_DEBUG')
    call rtputil#append('$MYVIMDIR/bundle/vim-singleton')
    call singleton#enable()

    call rtputil#bundle()

    if !executable('git')
        call rtputil#remove('gist-vim')
    endif

    if !has('signs') ||
    \  !has('diff')  ||
    \  (!exists('*mkdir') && !executable('mkdir')) ||
    \  !executable('diff')
        call rtputil#remove('sign-diff')
    endif
    if 1    " disable it temporarily...
        call rtputil#remove('sign-diff')
    endif

    if s:is_win || !has('unix') || has('gui_running')
        call rtputil#remove('vim-fakeclip')
    endif
else
    " TODO: Reduce dependency plugins.

    " Basic plugins
    call rtputil#append($MYVIMDIR.'/bundle/tyru')
    call rtputil#append($MYVIMDIR.'/bundle/emap.vim')
    call rtputil#append($MYVIMDIR.'/bundle/vim-altercmd')
    call rtputil#append($MYVIMDIR.'/bundle/detect-coding-style.vim')

    call rtputil#append($MYVIMDIR.'/bundle/vital.vim')

    " Useful plugins for debug
    call rtputil#append($MYVIMDIR.'/bundle/dutil.vim')
    call rtputil#append($MYVIMDIR.'/bundle/vim-prettyprint')
    call rtputil#append($MYVIMDIR.'/bundle/restart.vim')

    " Load plugins to debug
    call rtputil#append($MYVIMDIR.'/bundle/eskk.vim')
    call rtputil#append($MYVIMDIR.'/bundle/neocomplcache')
endif

let s:Vital = vital#of('vimrc')
call s:Vital.load('Data.List')
call s:Vital.load('System.Filepath')

command! -bar -bang HelpTagsAll call rtputil#helptags(<bang>0)
HelpTagsAll


call emap#load('noprefix')    " Define :EmMap as :Map
" call emap#set_sid_from_vimrc()
call emap#set_sid(s:SID())
" call emap#set_sid_from_sfile(expand('<sfile>'))


call altercmd#load()
command!
\   -bar -nargs=+
\   MapAlterCommand
\   CAlterCommand <args> | AlterCommand <cmdwin> <args>


call dutil#load()
" }}}
" Options {{{

" Reset all options except 'runtimepath'.
let s:tmp = &runtimepath
set all&
let &runtimepath = s:tmp
unlet s:tmp

if exists('&msghistlen')
    set msghistlen=9999
endif

" indent
set autoindent
set smartindent
set expandtab
set smarttab
set shiftround
set preserveindent

" Follow 'tabstop' value.
set tabstop=4
let &shiftwidth = s:fill_version('7.3.629') ? 0 : &ts
let &softtabstop = s:fill_version('7.3.693') ? -1 : &ts

" search
set hlsearch
set incsearch
set smartcase

" listchars
set list
set listchars=tab:>_,extends:>,precedes:<,eol:/

" scroll
set scroll=5
" set scrolloff=15
" set scrolloff=9999
set scrolloff=0
" let g:scrolloff = 15    " see below

let g:scrolloff = 0
if g:scrolloff ># 0
    " Hack for <LeftMouse> not to adjust ('scrolloff') when single-clicking.
    " Implement 'scrolloff' by auto-command to control the fire.
    " cf. http://vim-users.jp/2011/04/hack213/
    MyAutocmd CursorMoved * call s:reinventing_scrolloff()
    let s:last_lnum = -1
    function! s:reinventing_scrolloff()
        if g:scrolloff ==# 0 || s:last_lnum > 0 && line('.') ==# s:last_lnum
            return
        endif
        let s:last_lnum = line('.')
        let winline     = winline()
        let winheight   = winheight(0)
        let middle      = winheight / 2
        let upside      = (winheight / winline) >= 2
        " If upside is true, add winlines to above the cursor.
        " If upside is false, add winlines to under the cursor.
        if upside
            let up_num = g:scrolloff - winline + 1
            let up_num = winline + up_num > middle ? middle - winline : up_num
            if up_num > 0
                execute 'normal!' up_num."\<C-y>"
            endif
        else
            let down_num = g:scrolloff - (winheight - winline)
            let down_num = winline - down_num < middle ? winline - middle : down_num
            if down_num > 0
                execute 'normal!' down_num."\<C-e>"
            endif
        endif
    endfunction

    " Do not adjust current scroll position (do not fire 'scrolloff') on single-click.
    Map -silent [n] <LeftMouse>   <Esc>:set eventignore=all<CR><LeftMouse>:set eventignore=<CR>
endif

" command-line
set cmdheight=1
set wildmenu

" completion
set complete=.,w,b,u,t,i,d,k,kspell
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

" backup
set backup
set backupdir=$MYVIMDIR/backup
silent! call mkdir(&backupdir, 'p')

function! SandboxCallOptionFn(option_name) "{{{
    try
        return s:{a:option_name}()
    catch
        call setbufvar('%', '&' . a:option_name, '')
        return ''
    endtry
endfunction "}}}

" title
set title
function! s:titlestring() "{{{
    if exists('t:cwd')
        return t:cwd . ' (tab)'
    elseif haslocaldir()
        return getcwd() . ' (local)'
    else
        return getcwd()
    endif
endfunction "}}}
let &titlestring = '%{SandboxCallOptionFn("titlestring")}'

" tab
set showtabline=2

function! MyTabLabel(tabnr) "{{{
    if exists('*gettabvar')
        let title = gettabvar(a:tabnr, 'title')
        if title != ''
            return title
        endif
    endif

    let buflist = tabpagebuflist(a:tabnr)
    let bufname = bufname(buflist[tabpagewinnr(a:tabnr) - 1])
    let modified = 0
    for bufnr in buflist
        if getbufvar(bufnr, '&modified')
            let modified = 1
            break
        endif
    endfor

    if bufname == ''
        let label = '[No Name]'
    elseif tabpagenr() != a:tabnr
        let label = fnamemodify(bufname, ':t')
    else
        let label = pathshorten(bufname)
    endif
    return label . (modified ? '[+]' : '')
endfunction "}}}
function! s:tabline() "{{{
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'

        " the label is made by MyTabLabel()
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif

    return s
endfunction "}}}
set tabline=%!SandboxCallOptionFn('tabline')

function! s:guitablabel() "{{{
    let s = '%{tabpagenr()}. [%t]'
    if exists('t:cwd')
        let s .= ' @ [tab: %{t:cwd}]'
    elseif haslocaldir()
        let s .= ' @ [local cwd: %{getcwd()}]'
    else
        let s .= ' @ [cwd: %{getcwd()}]'
    endif
    return s
endfunction "}}}
set guitablabel=%!SandboxCallOptionFn('guitablabel')

" statusline
set laststatus=2
function! s:statusline() "{{{
    let s = '%f%([%M%R%H%W]%)%(, %{&ft}%), %{&fenc}/%{&ff}'
    let s .= '%('

    if exists('g:loaded_eskk')    " eskk.vim
        " postpone the load of autoload/eskk.vim
        if exists('g:loaded_autoload_eskk')
            let s .= ' %{eskk#statusline("IM:%s", "IM:off")}'
        endif
    elseif exists('g:skk_loaded')    " skk.vim
        let s .= ' %{SkkGetModeStr()}'
    endif

    if !get(g:, 'cfi_disable')
    \   && s:has_plugin('current-func-info')
        let s .= '%( | %{cfi#format("%s()", "")}%)'
    endif

    " XXX: calling GetCCharAndHex() destroys also unnamed register. it may be the problem of Vim.
    " let s .= '%( | [%{GetCCharAndHex()}]%)'

    let s .= '%( | %{GetDocumentPosition()}%)'

    let s .= '%)'

    return s
endfunction "}}}
set statusline=%!SandboxCallOptionFn('statusline')

function! GetDocumentPosition()
    return float2nr(str2float(line('.')) / str2float(line('$')) * 100) . "%"
endfunction

function! GetCCharAndHex()
    if mode() !=# 'n'
        return ''
    endif
    if foldclosed(line('.')) isnot -1
        return ''
    endif
    let cchar = s:get_cchar()
    return cchar ==# '' ? '' : cchar . ":" . "0x".char2nr(cchar)
endfunction
function! s:get_cchar()
    let reg     = getreg('z', 1)
    let regtype = getregtype('z')
    try
        if col('.') ==# col('$') || virtcol('.') > virtcol('$')
            return ''
        endif
        normal! "zyl
        return @z
    catch
        return ''
    finally
        call setreg('z', reg, regtype)
    endtry
endfunction

if has('vim_starting')
    " Must be set in .vimrc
    set guioptions+=p
    " These flags are set on FocusGained
    " because "cmd.exe start /min" doesn't work.
    " (always start up as foreground)
    augroup vimrc-guioptions
        autocmd!
        autocmd FocusGained * set guioptions=agitrhF | autocmd! vimrc-guioptions
    augroup END
else
    set guioptions=agitrhpF
endif

" clipboard
"
" TODO: hmm... I want normal "y" operation to use unnamed register also...
" (namely, I want to merge the registers, '"', '+', '*')
" Are there another solutions but overwriting mappings 'y', 'd', 'c', etc.
"
" set clipboard+=unnamed
" if has('unnamedplus')
"     set clipboard+=unnamedplus
" endif

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
Lazy set t_vb=

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
if s:fill_version('7.3.541')
    set formatoptions+=j
endif

" undo-persistence
if has('persistent_undo')
    set undofile
    let &undodir = $MYVIMDIR . '/info/undo'
    silent! call mkdir(&undodir, 'p')
endif

if has('conceal')
    set concealcursor=nvic
endif

" http://vim-users.jp/2009/12/hack107/
" Enable mouse support.
set mouse=a

" For screen.
if &term =~ "^screen"
    MyAutocmd VimLeave * :set mouse=

    " workaround for freeze when using mouse on GNU screen.
    set ttymouse=xterm2
endif

if has('gui_running')
    " Show popup menu if right click.
    "set mousemodel=popup
    " Don't focus the window when the mouse pointer is moved.
    set nomousefocus
    " Hide mouse pointer on insert mode.
    set mousehide
endif

set browsedir=current

" Font {{{
if has('win32')    " Windows
    " set guifont=M+2VM+IPAG_circle:h13
    " set printfont=M+2VM+IPAG_circle:h13
elseif has('mac')    " Mac
    set guifont=Osaka－等幅:h14
    set printfont=Osaka－等幅:h14
else    " *nix OS
    set guifont=Monospace\ 12
    set printfont=Monospace\ 12
    set linespace=4
endif
" }}}

" misc.
set diffopt=filler,vertical
set helplang=ja,en
set history=50
set keywordprg=
" set lazyredraw
set nojoinspaces
set showcmd
set nrformats=hex
set shortmess=aI
set switchbuf=useopen,usetab
set textwidth=0
set colorcolumn=80
set viminfo='50,h,f1,n$HOME/.viminfo
set matchpairs+=<:>
if has('multibyte')
    set showbreak=↪
endif
" }}}
" Autocmd {{{

" colorscheme
" NOTE: On MS Windows, setting colorscheme in .vimrc does not work.
" Because :Lazy is necessary.
" XXX: `:Lazy colorscheme tyru` does not throw ColorScheme event,
" what the fuck?
Lazy colorscheme tyru | doautocmd ColorScheme

" Open a file as read-only if swap exists
MyAutocmd SwapExists * let v:swapchoice = 'o'

MyAutocmd QuickfixCmdPost * QuickFix


" Set syntaxes
MyAutocmd BufNewFile,BufRead *.as setlocal syntax=actionscript
MyAutocmd BufNewFile,BufRead _vimperatorrc,.vimperatorrc setlocal syntax=vimperator
MyAutocmd BufNewFile,BufRead *.avs setlocal syntax=avs

" Aliases
" http://vim-users.jp/2010/04/hack138/
MyAutocmd FileType mkd setlocal filetype=markdown
MyAutocmd FileType js setlocal filetype=javascript
MyAutocmd FileType c++ setlocal filetype=cpp
MyAutocmd FileType py setlocal filetype=python
MyAutocmd FileType pl setlocal filetype=perl
MyAutocmd FileType rb setlocal filetype=ruby
MyAutocmd FileType scm setlocal filetype=scheme

" Checking typo. {{{
MyAutocmd BufWriteCmd *[,*] call s:write_check_typo(expand('<afile>'))
function! s:write_check_typo(file)
    let writecmd = 'write'.(v:cmdbang ? '!' : '').' '.a:file
    if exists('b:write_check_typo_nocheck')
        execute writecmd
        return
    endif
    let prompt = "possible typo: really want to write to '" . a:file . "'?(y/n):"
    let input = input(prompt)
    if input ==# 'YES'
        execute writecmd
        let b:write_check_typo_nocheck = 1
    elseif input =~? '^y\(es\)\=$'
        execute writecmd
    endif
endfunction
" }}}

" Automatic mkdir when :edit nonexistent-file {{{
" http://vim-users.jp/2011/02/hack202/
augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir)
        \   && (a:force
        \       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END " }}}

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
"   " Map [nxo] lhs rhs
"   MapOp lhs rhs
"
" MapMotion:
"   " Map [nxo] lhs rhs
"   MapMotion lhs rhs
"
" MapObject:
"   " Map [xo] lhs rhs
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
"   " Map -expr [n] <C-n> v:count1 . 'gt'
"   MapCount [n] <C-n> gt



" TODO Do not clear mappings set by plugins.
" mapclear
" mapclear!
" " mapclear!!!!
" lmapclear



" Set up general prefix keys. {{{

DefMacroMap [nxo] orig q
DefMacroMap [ic] orig <C-g><C-o>

Map [n] <orig>q q

DefMacroMap [nxo] excmd <Space>
DefMacroMap [nxo] operator ;
DefMacroMap [n] window <C-w>
DefMacroMap [nxo] prompt ,t

let g:mapleader = ';'
Map [n] <Leader> <Nop>

Map [n] ;; ;
Map [n] ,, ,

let g:maplocalleader = '\'
Map [n] <LocalLeader> <Nop>

DefMacroMap [i] compl <Tab>
" }}}

" map {{{
" operator {{{

" Copy to clipboard, primary.
Map [nxo] <operator>y     "+y
Map [nxo] <operator>gy    "*y
Map [nxo] <operator>d     "+d
Map [nxo] <operator>gd    "*d


" Do not destroy noname register.
Map [nxo] x "_x


Map [nxo] <operator>e =


if s:has_plugin('operator-user')

    " operator-adjust {{{
    call operator#user#define('adjust', 'Op_adjust_window_height')
    function! Op_adjust_window_height(motion_wiseness)
        execute (line("']") - line("'[") + 1) 'wincmd' '_'
        normal! `[zt
    endfunction

    Map -remap [nxo] <operator>adj <Plug>(operator-adjust)
    " }}}
    " operator-sort {{{
    call operator#user#define_ex_command('sort', 'sort')
    Map -remap [nxo] <operator>s <Plug>(operator-sort)
    " }}}
    " operator-retab {{{
    call operator#user#define_ex_command('retab', 'retab')
    Map -remap [nxo] <operator>t <Plug>(operator-retab)
    " }}}
    " operator-join {{{
    call operator#user#define_ex_command('join', 'join')
    Map -remap [nxo] <operator>j <Plug>(operator-join)
    " }}}
    " operator-uniq {{{
    call operator#user#define_ex_command('uniq', 'sort u')
    Map -remap [nxo] <operator>u <Plug>(operator-uniq)
    " }}}
    " operator-reverse-lines {{{
    Map -remap [nxo] <operator>rl <Plug>(operator-reverse-lines)
    " }}}
    " operator-reverse-text {{{
    Map -remap [nxo] <operator>rw <Plug>(operator-reverse-text)
    " }}}
    " operator-narrow {{{
    call operator#user#define_ex_command('narrow', 'Narrow')

    Map -remap [nxo] <operator>na <Plug>(operator-narrow)
    Map [nxo]        <operator>nw :<C-u>Widen<CR>

    let g:narrow_allow_overridingp = 1
    " }}}
    " operator-replace {{{
    Map -remap [nxo] <operator>p  <Plug>(operator-replace)
    " Map -remap [xo] p <Plug>(operator-replace)
    " }}}
    " operator-camelize {{{
    Map -remap [nxo] <operator>c <Plug>(operator-camelize-toggle)
    let g:operator_camelize_all_uppercase_action = 'camelize'
    let g:operator_decamelize_all_uppercase_action = 'lowercase'


    " Test: g:operator_camelize_detect_function
    " function! Camelized(word)
    "     return 0
    " endfunction
    " let g:operator_camelize_detect_function = 'Camelized'
    " E704: Funcref variable name must start with a capital: g:operator_camelize_detect_function
    " let g:operator_camelize_detect_function = function('Camelized')

    " Test: mappings
    " Map -remap [nxo] <operator>c <Plug>(operator-camelize)
    " Map -remap [nxo] <operator>C <Plug>(operator-decamelize)


    " See "keymappings" branch.
    " Map -remap [nxo] <operator>c <Plug>(operator-camelize/camelize)
    " Map -remap [nxo] <operator>C <Plug>(operator-decamelize/lowercase)

    " }}}
    " operator-blank-killer {{{
    call operator#user#define_ex_command('blank-killer', 's/\s\+$//')
    Map -remap [nxo] <operator>bk <Plug>(operator-blank-killer)
    " }}}
    " operator-html-escape {{{
    Map -remap [nxo] <operator>he <Plug>(operator-html-escape)
    Map -remap [nxo] <operator>hu <Plug>(operator-html-unescape)
    " }}}
    " operator-zen2han, operator-han2zen {{{
    call operator#user#define('zen2han', 'Op_zen2han')
    function! Op_zen2han(motion_wiseness)
        " TODO
    endfunction

    call operator#user#define('han2zen', 'Op_han2zen')
    function! Op_han2zen(motion_wiseness)
        " TODO
    endfunction

    Map -remap [nxo] <operator>zh <Plug>(operator-zen2han)
    Map -remap [nxo] <operator>hz <Plug>(operator-han2zen)
    " }}}
    " operator-fillblank {{{
    " from daisuzu .vimrc:
    "   http://vim-jp.org/reading-vimrc/archive/023.html
    "   http://lingr.com/room/vim/archives/2012/12/08#message-13176343
    "   https://raw.github.com/daisuzu/dotvim/master/.vimrc

    function! OperatorFillBlank(motion_wise)
        let v = operator#user#visual_command_from_wise_name(a:motion_wise)
        execute 'normal! `['.v.'`]"xy'
        let text = getreg('x', 1)
        let text = s:map_lines(text,
        \   'substitute(v:val, ".", "\\=s:charwidthwise_r(submatch(0))", "g")')
        call setreg('x', text, v)
        normal! gv"xp
    endfunction
    function! s:charwidthwise_r(char)
        return repeat(' ', exists('*strwidth') ? strwidth(a:char) : 1)
    endfunction
    call operator#user#define('fillblank', 'OperatorFillBlank')
    Map -remap [nxo] <operator><Space> <Plug>(operator-fillblank)
    " }}}

endif
" }}}
" motion {{{
Map -expr [nxo] j v:count == 0 ? 'gj' : 'j'
Map -expr [nxo] k v:count == 0 ? 'gk' : 'k'

Map [nxo] <orig>j j
Map [nxo] <orig>k k

" FIXME: Does not work in visual mode.
Map [n] ]k :<C-u>call search('^\S', 'Ws')<CR>
Map [n] [k :<C-u>call search('^\S', 'Wsb')<CR>

Map [nxo] gp %
" }}}
" textobj {{{
let g:textobj_between_no_default_key_mappings = 1
Map -remap [xo] ib <Plug>(textobj-between-i)
Map -remap [xo] ab <Plug>(textobj-between-a)

let g:textobj_entire_no_default_key_mappings = 1
Map -remap [xo] i@ <Plug>(textobj-entire-i)
Map -remap [xo] a@ <Plug>(textobj-entire-a)

Map [xo] aa a>
Map [xo] ia i>
Map [xo] ar a]
Map [xo] ir i]
" }}}
" }}}
" nmap {{{

DefMacroMap [nxo] fold z

" Open only current line's fold.
Map [n] <fold><Space> zMzvzz

" Folding mappings easy to remember.
Map [n] <fold>l zo
Map [n] <fold>h zc

" +virtualedit
if has('virtualedit')
    Map -expr [n] i col('$') is col('.') ? 'A' : 'i'
    Map -expr [n] a col('$') is col('.') ? 'A' : 'a'
    Map       [n] <orig>i i
    Map       [n] <orig>a a
endif

" Operate on line without newline.
Map [n] d<Space> 0d$
Map [n] y<Space> 0y$
Map [n] c<Space> 0c$

" http://vim-users.jp/2009/08/hack57/
Map [n] d<CR> :<C-u>call append(line('.'), '')<CR>j
Map [n] c<CR> :<C-u>call append(line('.'), '')<CR>jI

Map [n] <excmd>me :<C-u>messages<CR>
Map [n] <excmd>di :<C-u>display<CR>

Map [n] g; ~

Map [n] gl :<C-u>cnext<CR>
Map [n] gh :<C-u>cNext<CR>

Map [n] <excmd>ct :<C-u>tabclose<CR>

Map [n] gm :<C-u>make<CR>

Map [n] <excmd>tl :<C-u>tabedit<CR>
Map [n] <excmd>th :<C-u>tabedit<CR>:execute 'tabmove' (tabpagenr() isnot 1 ? tabpagenr() - 2 : '')<CR>

Map [n] <C-s> :<C-u>browse saveas<CR>

Map -expr -silent [n] f '/\V'.<SID>getchar_safe()."\<CR>:nohlsearch\<CR>"
Map -expr -silent [n] F '?\V'.<SID>getchar_safe()."\<CR>:nohlsearch\<CR>"
Map -expr -silent [n] t '/.\ze\V'.<SID>getchar_safe()."\<CR>:nohlsearch\<CR>"
Map -expr -silent [n] T '?\V'.<SID>getchar_safe().'\v\zs.'."\<CR>:nohlsearch\<CR>"


" Map [n] <C-h> b
" Map [n] <C-l> w
" Map [n] <S-h> ge
" Map [n] <S-l> e

Map [n] <C-j> *
Map [n] <C-k> #

" NOTE: <S-Tab> is GUI only.
Map [x] <Tab> >gv
Map [x] <S-Tab> <gv

Map [o] gv :<C-u>normal! gv<CR>


Map [n] ,cd       :<C-u>cd %:p:h<CR>
" :LookupCD - chdir to root directory of project working tree {{{
Map [n] cd :<C-u>LookupCD %:p:h<CR>

command!
\   -bar -complete=dir -nargs=?
\   LookupCD
\   call s:cmd_lookup_cd(<q-args>)

function! s:cmd_lookup_cd(args) "{{{
    " Expand :cd like notation.
    let dir = expand(a:args != '' ? a:args : '.')
    " Get fullpath.
    let dir = fnamemodify(dir, ':p')
    if !isdirectory(dir)
        call s:warn("No such directory: " . dir)
        return
    endif
    let dir = s:lookup_repo(dir)
    if dir !=# ''
        cd `=dir`
    endif
endfunction "}}}
function! s:is_root_project_dir(dir) "{{{
    let FP = s:Vital.System.Filepath
    " .git may be a file when its repository is a submodule.
    return isdirectory(FP.join(a:dir, '.git'))
    \   || filereadable(FP.join(a:dir, '.git'))
    \   || isdirectory(FP.join(a:dir, '.hg'))
endfunction "}}}
function! s:lookup_repo(dir) "{{{
    " Assert isdirectory(a:dir)

    let parent = s:Vital.System.Filepath.dirname(a:dir)
    if a:dir ==# parent    " root
        call s:warn('Not found project directory.')
        return ''
    elseif s:is_root_project_dir(a:dir)
        return a:dir
    else
        return s:lookup_repo(parent)
    endif
endfunction "}}}

" }}}

" TODO: Smart 'zd': Delete empty line {{{
" }}}
" TODO: Smart '{', '}': Treat folds as one non-empty line. {{{
" }}}

" Execute most used command quickly {{{
Map [n] <excmd>ee     :<C-u>edit<CR>
Map [n] <excmd>w      :<C-u>update<CR>
Map [n] <excmd>q      :<C-u>quit<CR>
" }}}
" Edit/Apply .vimrc quickly {{{
Map [n] <excmd>ev     :<C-u>edit $MYVIMRC<CR>
if has('gui_running')
    Map [n] <excmd>sv     :<C-u>source $MYVIMRC<CR>:source $MYGVIMRC<CR>
else
    Map [n] <excmd>sv     :<C-u>source $MYVIMRC<CR>
endif
" }}}
" Cmdwin {{{
set cedit=<C-z>
function! s:cmdwin_enter()
    Map -buffer -force       [ni] <C-z>         <C-c>
    Map -buffer              [n]  <Esc> :<C-u>quit<CR>
    Map -buffer -force       [n]  <window>k        :<C-u>quit<CR>
    Map -buffer -force       [n]  <window><C-k>    :<C-u>quit<CR>
    Map -buffer -force -expr [i]  <BS>       col('.') == 1 ? "\<Esc>:quit\<CR>" : "\<BS>"

    startinsert!
endfunction
MyAutocmd CmdwinEnter * call s:cmdwin_enter()

Map [n] <excmd>: q:
Map [n] <excmd>/ q/
Map [n] <excmd>? q?
" }}}
" Moving tabs {{{
Map [n] <Left>    :<C-u>execute 'tabmove' (tabpagenr() == 1 ? tabpagenr('$') : tabpagenr() - 2)<CR>
Map [n] <Right>   :<C-u>execute 'tabmove' (tabpagenr() == tabpagenr('$') ? 0 : tabpagenr())<CR>
" NOTE: Mappings <S-Left>, <S-Right> work only in gVim
Map [n] <S-Left>  :<C-u>execute 'tabmove' 0<CR>
Map [n] <S-Right> :<C-u>execute 'tabmove' tabpagenr('$')<CR>
" }}}
" Toggle options {{{
function! s:toggle_option(option_name) "{{{
    if exists('&' . a:option_name)
        execute 'setlocal' a:option_name . '!'
        execute 'setlocal' a:option_name . '?'
    endif
endfunction "}}}

function! s:advance_state(state, elem) "{{{
    let curidx = index(a:state, a:elem)
    let curidx = curidx is -1 ? 0 : curidx
    return a:state[index(a:state, curidx + 1) isnot -1 ? curidx + 1 : 0]
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

function! s:toggle_winfix()
    if &winfixheight || &winfixwidth
        setlocal nowinfixheight nowinfixwidth
        echo 'released.'
    else
        setlocal winfixheight winfixwidth
        echo 'fixed!'
    endif
endfunction

Map [n] <excmd>oh :<C-u>call <SID>toggle_option('hlsearch')<CR>
Map [n] <excmd>oi :<C-u>call <SID>toggle_option('ignorecase')<CR>
Map [n] <excmd>op :<C-u>call <SID>toggle_option('paste')<CR>
Map [n] <excmd>ow :<C-u>call <SID>toggle_option('wrap')<CR>
Map [n] <excmd>oe :<C-u>call <SID>toggle_option('expandtab')<CR>
Map [n] <excmd>ol :<C-u>call <SID>toggle_option('list')<CR>
Map [n] <excmd>on :<C-u>call <SID>toggle_option('number')<CR>
Map [n] <excmd>om :<C-u>call <SID>toggle_option('modeline')<CR>
Map [n] <excmd>ofc :<C-u>call <SID>advance_option_state(['', 'all'], 'foldclose')<CR>
Map [n] <excmd>ofm :<C-u>call <SID>advance_option_state(['manual', 'marker', 'indent'], 'foldmethod')<CR>
Map [n] <excmd>ofw :<C-u>call <SID>toggle_winfix()<CR>


command!
\   -bar
\   OptInit
\
\   set hlsearch ignorecase nopaste wrap expandtab list modeline foldclose= foldmethod=manual
\   | echo 'Initialized frequently toggled options.'

Map [n] <excmd>OI :<C-u>OptInit<CR>


silent OptInit
" }}}
" Close help/quickfix window {{{

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


function! s:winutil.get_winnr_list_like(expr) "{{{
    let ret = []
    for winnr in range(1, winnr('$'))
        if eval(a:expr)
            call add(ret, winnr)
        endif
    endfor
    return ret
endfunction "}}}

function! s:winutil.has_window_like(expr) "{{{
    return !empty(s:winutil.get_winnr_list_like(a:expr))
endfunction "}}}

function! s:winutil.close_first_like(expr) "{{{
    let winnr_list = s:winutil.get_winnr_list_like(a:expr)
    " Close current window if current matches a:expr.
    let winnr_list = s:move_current_winnr_to_head(winnr_list)
    if empty(winnr_list)
        return
    endif

    let prev_winnr = winnr()
    try
        for winnr in winnr_list
            if s:winutil.close(winnr)
                return 1    " closed.
            endif
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
    let winnr = winnr()
    if index(a:winnr_list, winnr) is -1
        return a:winnr_list
    endif
    return [winnr] + filter(a:winnr_list, 'v:val isnot winnr')
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

call s:window.register('cmdwin', {'close': function('s:close_cmdwin_window'), 'detect': function('s:is_cmdwin_window')})
" }}}

" help {{{
function! s:close_help_window() "{{{
    return s:winutil.close_first_like('s:is_help_window(winnr)')
endfunction "}}}
function! s:has_help_window() "{{{
    return s:winutil.has_window_like('s:is_help_window(winnr)')
endfunction "}}}
function! s:is_help_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'help'
endfunction "}}}

call s:window.register('help', {'close': function('s:close_help_window'), 'detect': function('s:is_help_window')})
" }}}

" quickfix {{{
function! s:close_quickfix_window() "{{{
    " cclose
    return s:winutil.close_first_like('s:is_quickfix_window(winnr)')
endfunction "}}}
function! s:is_quickfix_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'quickfix'
endfunction "}}}

call s:window.register('quickfix', {'close': function('s:close_quickfix_window'), 'detect': function('s:is_quickfix_window')})
" }}}

" ref {{{
function! s:close_ref_window() "{{{
    return s:winutil.close_first_like('s:is_ref_window(winnr)')
endfunction "}}}
function! s:is_ref_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&filetype') ==# 'ref'
endfunction "}}}

call s:window.register('ref', {'close': function('s:close_ref_window'), 'detect': function('s:is_ref_window')})
" }}}

" quickrun {{{
function! s:close_quickrun_window() "{{{
    return s:winutil.close_first_like('s:is_quickrun_window(winnr)')
endfunction "}}}
function! s:is_quickrun_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&filetype') ==# 'quickrun'
endfunction "}}}

call s:window.register('quickrun', {'close': function('s:close_quickrun_window'), 'detect': function('s:is_quickrun_window')})
" }}}

" unlisted {{{
function! s:close_unlisted_window() "{{{
    return s:winutil.close_first_like('s:is_unlisted_window(winnr)')
endfunction "}}}
function! s:is_unlisted_window(winnr) "{{{
    return !getbufvar(winbufnr(a:winnr), '&buflisted')
endfunction "}}}

call s:window.register('unlisted', {'close': function('s:close_unlisted_window'), 'detect': function('s:is_unlisted_window')})
" }}}


function! s:close_certain_window() "{{{
    let curwinnr = winnr()
    let groups = s:window.get_all_groups()

    " Close current.
    for group in groups
        if group.detect(curwinnr)
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


Map -silent [n] <excmd>c: :<C-u>call <SID>close_cmdwin_window()<CR>
Map -silent [n] <excmd>ch :<C-u>call <SID>close_help_window()<CR>
Map -silent [n] <excmd>cQ :<C-u>call <SID>close_quickfix_window()<CR>
Map -silent [n] <excmd>cr :<C-u>call <SID>close_ref_window()<CR>
Map -silent [n] <excmd>cq :<C-u>call <SID>close_quickrun_window()<CR>
Map -silent [n] <excmd>cb :<C-u>call <SID>close_unlisted_window()<CR>

Map -silent [n] <excmd>cc :<C-u>call <SID>close_certain_window()<CR>
" }}}
" 'Y' to yank till the end of line. {{{
Map [n] Y    y$
Map [n] ;Y   "+y$
Map [n] ,Y   "*y$
" }}}
" Back to col '$' when current col is right of col '$'. {{{
"
" 1. move to the last col
" when over the last col ('virtualedit') and getregtype(v:register) ==# 'v'.
" 2. do not insert " " before inserted text
" when characterwise and getregtype(v:register) ==# 'v'.

function! s:virtualedit_enabled()
    return has('virtualedit')
    \   && &virtualedit =~# '\<all\>\|\<onemore\>'
endfunction

if s:virtualedit_enabled()
    function! s:paste_characterwise_nicely()
        let reg = '"' . v:register
        let move_to_last_col =
        \   (s:virtualedit_enabled()
        \       && col('.') >= col('$'))
        \   ? '$' : ''
        let paste =
        \   reg . (getline('.') ==# '' ? 'P' : 'p')
        return getregtype(v:register) ==# 'v' ?
        \   move_to_last_col . paste :
        \   reg . 'p'
    endfunction

    Map -expr [n] p <SID>paste_characterwise_nicely()
endif
" }}}
" <Space>[hjkl] for <C-w>[hjkl] {{{
Map -silent [n] <Space>j <C-w>j
Map -silent [n] <Space>k <C-w>k
Map -silent [n] <Space>h <C-w>h
Map -silent [n] <Space>l <C-w>l
Map -silent [n] <Space>n <C-w>w
Map -silent [n] <Space>p <C-w>W
" }}}
" Moving between tabs {{{
Map -silent [n] <C-n> gt
Map -silent [n] <C-p> gT
" }}}
" Move all windows of current group beyond next group. {{{
" TODO
" }}}
" quickfix buffer-local mappings {{{
MyAutocmd FileType qf call s:quickfix_settings()
function! s:quickfix_settings()
    " Map -buffer -force [n] j j<CR>:silent! normal! zo<CR><C-w><C-w>
    " Map -buffer -force [n] k k<CR>:silent! normal! zo<CR><C-w><C-w>
endfunction
" }}}
" "Use one tabpage per project" project {{{
" :SetTabName - Set tab's title {{{
Map -silent [n] <C-t> :<C-u>SetTabName<CR>
command! -bar -nargs=* SetTabName call s:cmd_set_tab_name(<q-args>)
function! s:cmd_set_tab_name(name) "{{{
    let old_title = exists('t:title') ? t:title : ''
    if a:name == ''
        " Hitting <Esc> returns empty string.
        let title = input('tab name?:', old_title)
        let t:title = title != '' ? title : old_title
    else
        let t:title = a:name
    endif
    if t:title !=# old_title
        " :redraw does not update tabline.
        redraw!
    endif
endfunction "}}}
" }}}
" }}}
" }}}
" vmap {{{

" Map [x] <C-g> g<C-g>1gs

Map -silent [x] y y:<C-u>call <SID>remove_trailing_spaces_blockwise()<CR>
function! s:remove_trailing_spaces_blockwise()
    let regname = v:register
    if getregtype(regname)[0] !=# "\<C-v>"
        return ''
    endif
    let value = getreg(regname, 1)
    let expr = 'substitute(v:val, '.string('\v\s+$').', "", "")'
    let value = s:map_lines(value, expr)
    call setreg(regname, value, "\<C-v>")
endfunction


" http://labs.timedia.co.jp/2012/10/vim-more-useful-blockwise-insertion.html
Map -expr [x] I <SID>force_blockwise_visual(<q-lhs>)
Map -expr [x] A <SID>force_blockwise_visual(<q-lhs>)

function! s:force_blockwise_visual(next_key)
    if mode() ==# 'v'
        return "\<C-v>" . a:next_key
    elseif mode() ==# 'V'
        return "\<C-v>0o$" . a:next_key
    else  " mode() ==# "\<C-v>"
        return a:next_key
    endif
endfunction
" }}}
" map! {{{
Map [ic] <C-f> <Right>
Map [ic] <C-b> <Left>
Map [ic] <C-a> <Home>
Map [ic] <C-e> <End>
Map [ic] <C-d> <Del>

if 0

    function! s:eclipse_like_autoclose(quote)
        if mode() !~# '^\(i\|R\|Rv\|c\|cv\|ce\)$'
            return a:quote
        endif
        return
        \   col('.') <=# 1 || col('.') >=# col('$') ?
        \       a:quote.a:quote."\<Left>" :
        \   getline('.')[col('.') - 1] ==# a:quote ?
        \       "\<Right>" :
        \   getline('.')[col('.') - 2] ==# a:quote ?
        \       a:quote.a:quote."\<Left>" :
        \       a:quote
    endfunction

    noremap! <expr> " <SID>eclipse_like_autoclose('"')
    noremap! <expr> ' <SID>eclipse_like_autoclose("'")

endif

" }}}
" imap {{{

Map [i] <C-l> <Tab>

" shift left (indent)
Map [i] <C-q>   <C-d>

" make <C-w> and <C-u> undoable.
Map [i] <C-w> <C-g>u<C-w>
Map [i] <C-u> <C-g>u<C-u>

Map [i] <C-@> <C-a>

Map [i] <S-CR> <C-o>O
Map [i] <C-CR> <C-o>o

" completion {{{

Map [i] <compl><Tab> <C-n>

" Map [i] <compl>n <C-x><C-n>
" Map [i] <compl>p <C-x><C-p>
Map [i] <compl>n <C-n>
Map [i] <compl>p <C-p>

Map [i] <compl>] <C-x><C-]>
Map [i] <compl>d <C-x><C-d>
Map [i] <compl>f <C-x><C-f>
Map [i] <compl>i <C-x><C-i>
Map [i] <compl>k <C-x><C-k>
Map [i] <compl>l <C-x><C-l>
" Map [i] <compl>s <C-x><C-s>
" Map [i] <compl>t <C-x><C-t>

Map -expr [i] <compl>o <SID>omni_or_user_func()

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
" call submode#enter_with('c', 'i', '', emap#compile_map('i', '<compl>j'), '<C-n>')
" call submode#enter_with('c', 'i', '', emap#compile_map('i', '<compl>k'), '<C-p>')
" call submode#leave_with('c', 'i', '', '<CR>')
" call submode#map       ('c', 'i', '', 'j', '<C-n>')
" call submode#map       ('c', 'i', '', 'k', '<C-p>')


Map -expr [i] <C-y> neocomplcache#close_popup()
Map -expr [i] <CR>  pumvisible() ? neocomplcache#close_popup() . "\<CR>" : "\<CR>"
Map -remap [is] <C-t> <Plug>(neocomplcache_snippets_expand)

" }}}
" }}}
" cmap {{{
if &wildmenu
    Map -force [c] <C-f> <Space><BS><Right>
    Map -force [c] <C-b> <Space><BS><Left>
endif

" paste register
Map [c] <C-r><C-u>  <C-r>+
Map [c] <C-r><C-i>  <C-r>*
Map [c] <C-r><C-o>  <C-r>"

Map [c] <C-n> <Down>
Map [c] <C-p> <Up>

Map [c] <C-l> <C-d>

" Escape /,? {{{
Map -expr [c] /  getcmdtype() == '/' ? '\/' : '/'
Map -expr [c] ?  getcmdtype() == '?' ? '\?' : '?'
" }}}
" }}}
" abbr {{{
Map -abbr -expr [i]  date@ strftime('%Y-%m-%d')
Map -abbr -expr [i]  time@ strftime("%H:%M")
Map -abbr -expr [i]  dt@   strftime("%Y-%m-%d %H:%M")
Map -abbr -expr [ic] mb@   [^\x01-\x7e]

MapAlterCommand th     tab help
MapAlterCommand t      tabedit
MapAlterCommand s      setlocal
MapAlterCommand sf     setf
MapAlterCommand hg     helpgrep
MapAlterCommand ds     diffsplit
MapAlterCommand do     diffoff!

" For typo.
MapAlterCommand qw     wq
MapAlterCommand amp    map
" }}}

" Mappings with option value. {{{
function! s:expr_with_options(cmd, opt) "{{{
    for [name, value] in items(a:opt)
        call setbufvar('%', name, value)
    endfor
    return a:cmd
endfunction "}}}

Map -expr [n] / <SID>expr_with_options('/', {'&ignorecase': 1, '&hlsearch': 1})
Map -expr [n] ? <SID>expr_with_options('?', {'&ignorecase': 1, '&hlsearch': 1})

Map -expr [n] * <SID>expr_with_options('*', {'&ignorecase': 0, '&hlsearch': 1})
Map -expr [n] # <SID>expr_with_options('#', {'&ignorecase': 0, '&hlsearch': 1})

Map -expr [nx] : <SID>expr_with_options(':', {'&ignorecase': 1})

Map -expr [n] gd <SID>expr_with_options('gd', {'&hlsearch': 1})
Map -expr [n] gD <SID>expr_with_options('gD', {'&hlsearch': 1})
" }}}
" Emacs like kill-line. {{{
Map -expr [i] <C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
Map [c] <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" }}}
" Make searching directions consistent {{{
" 'zv' is harmful for Operator-pending mode and it should not be included.
" For example, 'cn' is expanded into 'cnzv' so 'zv' will be inserted.

Map -expr [nx] <SID>(always_forward_n) (<SID>search_forward_p() ? 'n' : 'Nzv').'zvzz'
Map -expr [nx] <SID>(always_forward_N) (<SID>search_forward_p() ? 'N' : 'n').'zvzz'
Map -expr [o]  <SID>(always_forward_n) <SID>search_forward_p() ? 'n' : 'N'
Map -expr [o]  <SID>(always_forward_N) <SID>search_forward_p() ? 'N' : 'n'

function! s:search_forward_p()
    return exists('v:searchforward') ? v:searchforward : 1
endfunction
" }}}
" Walk between columns at 0, ^, $, window's right edge(virtualedit). {{{

function! s:back_between(zero, tilde, dollar) "{{{
    let curcol = col('.')
    let tilde_col = match(getline('.'), '\S') + 1

    if curcol > col('$')        " $ ~
        return a:dollar
    elseif curcol > tilde_col   " ^ ~ $
        return a:tilde
    else                        " 0 ~ ^
        return a:zero
    endif
endfunction "}}}
function! s:advance_between(tilde, dollar) "{{{
    let curcol = col('.')
    let tilde_col = match(getline('.'), '\S') + 1

    if curcol < tilde_col      " 0 ~ ^
        return a:tilde
    elseif curcol < col('$')   " ^ ~ $
        return a:dollar
    else                       " $ ~
        return a:dollar    " back
    endif
endfunction "}}}

" imap
Map -force -expr [i] <C-a> <SID>back_between("\<Home>", "\<C-o>^", "\<End>")
Map -force -expr [i] <C-e> <SID>advance_between("\<C-o>^", "\<End>")

" motion
Map -expr [nxo] H <SID>back_between('0', '^', '$')
Map -expr [nxo] L <SID>advance_between('^', '$')

" TODO
" Map -expr [nxo] L <SID>advance_between('^', '$', '')    " <comment Go right edge of window.>

" }}}
" Disable unused keys. {{{
Map [n] <F1> <Nop>
Map [n] <C-F1> <Nop>
Map [n] <S-F1> <Nop>
Map [n] ZZ <Nop>
Map [n] ZQ <Nop>
Map [n] U  <Nop>
" }}}
" Expand abbreviation {{{
" http://gist.github.com/347852
" http://gist.github.com/350207

DefMap [i] -expr bs-ctrl-] getline('.')[col('.') - 2]    ==# "\<C-]>" ? "\<BS>" : ''
DefMap [c] -expr bs-ctrl-] getcmdline()[getcmdpos() - 2] ==# "\<C-]>" ? "\<BS>" : ''
Map -remap   [ic] <C-]>     <C-]><bs-ctrl-]>
" }}}
" Add current line to quickfix. {{{
command! -bar -range QFAddLine <line1>,<line2>call s:quickfix_add_range()


function! s:quickfix_add_range() range
    for lnum in range(a:firstline, a:lastline)
        call s:quickfix_add_line(lnum)
    endfor
endfunction

function! s:quickfix_add_line(lnum)
    let lnum = a:lnum =~# '^\d\+$' ? a:lnum : line(a:lnum)
    let qf = {
    \   'bufnr': bufnr('%'),
    \   'lnum': lnum,
    \   'text': getline(lnum),
    \}
    if s:quickfix_supported_quickfix_title()
        " Set 'qf.col' and 'qf.vcol'.
        call s:quickfix_add_line_set_col(lnum, qf)
    endif
    call setqflist([qf], 'a')
endfunction
function! s:quickfix_add_line_set_col(lnum, qf)
    let lnum = a:lnum
    let qf = a:qf

    let search_word = s:quickfix_get_search_word()
    if search_word !=# ''
        let idx = match(getline(lnum), search_word[1:])
        if idx isnot -1
            let qf.col = idx + 1
            let qf.vcol = 0
        endif
    endif
endfunction
" }}}
" :QFSearchAgain {{{
command! -bar QFSearchAgain call s:qf_search_again()
function! s:qf_search_again()
    let qf_winnr = s:quickfix_get_winnr()
    if !qf_winnr
        copen
    endif
    let search_word = s:quickfix_get_search_word()
    if search_word !=# ''
        let @/ = search_word[1:]
        setlocal hlsearch
        try
            execute 'normal!' "/\<CR>"
        catch
            call s:echomsg('ErrorMsg', v:exception)
        endtry
    endif
endfunction
" }}}

" Quickfix utility functions {{{
function! s:quickfix_get_winnr()
    " quickfix window is usually at bottom,
    " thus reverse-lookup.
    for winnr in reverse(range(1, winnr('$')))
        if getwinvar(winnr, '&buftype') ==# 'quickfix'
            return winnr
        endif
    endfor
    return 0
endfunction
function! s:quickfix_exists_window()
    return !!s:quickfix_get_winnr()
endfunction
function! s:quickfix_supported_quickfix_title()
    return s:fill_version('7.3')
endfunction
function! s:quickfix_get_search_word()
    " NOTE: This function returns a string starting with "/"
    " if previous search word is found.
    " This function can't use an empty string
    " as a failure return value, because ":vimgrep /" also returns an empty string.

    " w:quickfix_title only works 7.3 or later.
    if !s:quickfix_supported_quickfix_title()
        return ''
    endif

    let qf_winnr = s:quickfix_get_winnr()
    if !qf_winnr
        copen
    endif

    try
        let qf_title = getwinvar(qf_winnr, 'quickfix_title')
        if qf_title ==# ''
            return ''
        endif

        " NOTE: Supported only :vim[grep] command.
        let rx = '^:\s*\<vim\%[grep]\>\s*\(/.*\)'
        let m = matchlist(qf_title, rx)
        if empty(m)
            return ''
        endif

        return m[1]
    finally
        if !qf_winnr
            cclose
        endif
    endtry
endfunction
" }}}

" Mouse {{{

" TODO: Add frequently-used-commands to the top level of the menu.
" like MS Windows Office 2007 Ribborn interface.
" Back to normal mode if insert mode.

Map -silent [i] <LeftMouse>   <Esc><LeftMouse>
" Double-click for selecting the word under the cursor
" as same as most editors.
set selectmode=mouse
" Single-click for searching the word selected in visual-mode.
Map -remap [x]  <LeftMouse> <Plug>(visualstar-g*)
" Select lines with <S-LeftMouse>
Map [n]         <S-LeftMouse> V

" }}}
" }}}
" Encoding {{{
let s:enc = 'utf-8'
let &enc = s:enc
let &fenc = s:enc
let &termencoding = s:enc
let &fileencodings = join(s:Vital.Data.List.uniq(
\   [s:enc]
\   + split(&fileencodings, ',')
\   + ['iso-2022-jp', 'iso-2022-jp-3', 'cp932']
\), ',')
unlet s:enc

set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif

" }}}
" FileType {{{
function! s:current_filetypes() "{{{
    return split(&l:filetype, '\.')
endfunction "}}}

function! s:set_dict() "{{{
    let filetype_vs_dictionary = {
    \   'c': ['c', 'cpp'],
    \   'cpp': ['c', 'cpp'],
    \   'html': ['html', 'css', 'javascript', 'smarty', 'htmldjango'],
    \   'scala': ['scala', 'java'],
    \}

    let dicts = []
    for ft in s:current_filetypes()
        for ft in get(filetype_vs_dictionary, ft, [ft])
            let dict_path = $MYVIMDIR . '/dict/' . ft . '.dict'
            if filereadable(dict_path)
                call add(dicts, dict_path)
            endif
        endfor
    endfor

    let &l:dictionary = join(s:Vital.Data.List.uniq(dicts), ',')
endfunction "}}}
function! s:is_current_filetype(filetypes)
    if type(a:filetypes) isnot type([])
        return s:is_current_filetype([a:filetypes])
    endif
    let filetypes = copy(a:filetypes)
    for ft in s:current_filetypes()
        if !empty(filter(filetypes, 'v:val ==# ft'))
            return 1
        endif
    endfor
    return 0
endfunction
function! s:set_tab_width() "{{{
    if s:is_current_filetype(
    \   ['css', 'xml', 'html', 'smarty', 'htmldjango',
    \    'lisp', 'scheme', 'yaml', 'python', 'markdown']
    \)
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
        for ft in s:current_filetypes()
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
" :DiffOrig {{{
" from vimrc_example.vim
"
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
command! -bar DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
\ | wincmd p | diffthis
" }}}
" :MTest {{{
" convert Perl's regex to Vim's regex

" No -bar
command!
\   -nargs=+
\   MTest
\   call s:MTest(<q-args>)

function! s:MTest(args) "{{{
    let org_search = @/
    let org_hlsearch = &hlsearch

    try
        silent execute "M" . a:args
        let @" = @/
    catch
        return
    finally
        let @/ = org_search
        let &hlsearch = org_hlsearch
    endtry

    echo @"
endfunction "}}}
" }}}
" :EchoPath - Show path-like option in a readable way {{{

MapAlterCommand epa EchoPath
MapAlterCommand rtp EchoPath<Space>&rtp


" TODO Add -complete=option
command!
\   -bar -nargs=+ -complete=expression
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
" :AllMaps - Do show/map in all modes. {{{
command!
\   -nargs=* -complete=mapping
\   AllMaps
\   Capture map <args> | map! <args> | lmap <args>
" }}}
" :Expand {{{
command!
\   -bar -nargs=?
\   Expand
\   call s:cmd_expand(<q-args>)

function! s:cmd_expand(args) "{{{
    if a:args != ''
        echo expand(a:args)
    else
        if getbufvar('%', '&buftype') == ''
            echo expand('%:p')
        else
            echo expand('%')
        endif
    endif
endfunction "}}}

MapAlterCommand ep Expand
" }}}
" :Has {{{
MapAlterCommand has Has

command!
\   -bar -nargs=1 -complete=customlist,feature_list_excomplete#complete
\   Has
\   echo has(<q-args>)
" }}}
" :GlobPath {{{
command!
\   -bar -nargs=1 -complete=file
\   GlobPath
\   echo globpath(&rtp, <q-args>, 1)

MapAlterCommand gp GlobPath
" }}}
" :QuickFix - Wrapper for favorite quickfix opening command {{{
" Select prefered command from cwindow, copen, and so on.

command!
\   -bar -nargs=?
\   QuickFix
\   if !empty(getqflist()) | cwindow <args> | endif

MapAlterCommand qf QuickFix
" }}}
" :SynNames {{{
" :help synstack()

command!
\   -bar
\   SynNames
\
\     for s:id in synstack(line("."), col("."))
\   |     echo printf('%s (%s)', synIDattr(s:id, "name"), synIDattr(synIDtrans(s:id), "name"))
\   | endfor
\   | unlet! s:id
" }}}
" :SplitNicely {{{
" originally from kana's .vimrc
" https://github.com/kana/config

command! -bar -nargs=* SplitNicely
\   call s:cmd_split_nicely(<q-args>)

function! s:cmd_split_nicely(q_args)
    let winnum = winnr('$')
    " FIXME: If already opened a window, it gets smaller!
    let save_winwidth = winwidth(0)
    let cmd = a:q_args != '' ?
    \           'belowright vertical '.a:q_args :
    \           'belowright vsplit'
    execute cmd
    if winnr('$') is winnum
        " if no new window is opened
        return
    endif
    " Adjust split window.
    if !&l:winfixwidth
        execute save_winwidth / 3 'wincmd |'
    endif
    setlocal winfixwidth winfixheight
endfunction

" }}}
" :Help {{{
MapAlterCommand h[elp]     Help

" No -bar
command!
\   -bang -nargs=* -complete=help
\   Help
\   SplitNicely help<bang> <args>
" }}}
" :NonSortUniq {{{
"
" http://lingr.com/room/vim/archives/2010/11/18#message-1023619
" > :let d={}|g/./let l=getline('.')|if has_key(d,l)|d|else|let d[l]=1

command!
\   -bar
\   NonSortUniq
\   let d={}|g/./let l=getline('.')|if has_key(d,l)|d|el|let d[l]=1

" E147: Cannot do :global recursive
" command!
" \   -bar
" \   NonSortUniq
" \   g/./let l=getline('.')|g/./if l==getline('.')|d

" }}}
" :Ctags {{{
MapAlterCommand ctags Ctags

command!
\   -bar -nargs=*
\   Ctags
\   call s:cmd_ctags(<q-args>)

function! s:cmd_ctags(q_args) "{{{
    if !executable('ctags')
        return
    endif
    execute '!ctags' (filereadable('.ctags') ? '' : '-R') a:q_args
endfunction "}}}
" }}}
" :WatchAutocmd {{{

" Create watch-autocmd augroup.
augroup watch-autocmd
    autocmd!
augroup END

command! -bar -nargs=1 -complete=event WatchAutocmd
\   call s:cmd_{<bang>0 ? "un" : ""}watch_autocmd(<q-args>)


let s:watching_events = {}

function! s:cmd_unwatch_autocmd(event)
    if !exists('#'.a:event)
        Echomsg ErrorMsg "Invalid event name: ".a:event
        return
    endif
    if !has_key(s:watching_events, a:event)
        Echomsg ErrorMsg "Not watching ".a:event." event yet..."
        return
    endif

    unlet s:watching_events[a:event]
    echomsg 'Removed watch for '.a:event.' event.'
endfunction
function! s:cmd_watch_autocmd(event)
    if !exists('#'.a:event)
        Echomsg ErrorMsg "Invalid event name: ".a:event
        return
    endif
    if has_key(s:watching_events, a:event)
        echomsg "Already watching ".a:event." event."
        return
    endif

    execute 'autocmd watch-autocmd' a:event
    \       '* Echomsg Debug "Executing '.string(a:event).' event..."'
    let s:watching_events[a:event] = 1
    echomsg 'Added watch for '.a:event.' event.'
endfunction
" }}}
" :Alias {{{
command!
\   -nargs=+ -bar
\   Alias
\   call s:cmd_alias('<bang>', [<f-args>], <q-args>)

function! s:cmd_alias(bang, args, q_args)
    if len(a:args) is 1 && a:args[0] =~# '^[A-Z][A-Za-z0-9]*$'
        execute 'command '.a:args[0]
    elseif len(a:args) is 2
        execute 'command! -bang -nargs=* '.a:args[0].' '.a:args[1].a:bang.' '.a:q_args
    endif
endfunction
" }}}
" :Kwbd {{{
" http://nanasi.jp/articles/vim/kwbd_vim.html
command! Kwbd let s:kwbd_bn= bufnr("%")|enew|exe "bdel ".s:kwbd_bn|unlet s:kwbd_bn
MapAlterCommand bd[elete] Kwbd
" }}}
" :KeepView {{{
command! -nargs=+ -complete=command KeepView call s:cmd_keepview(<q-args>)

function! s:cmd_keepview(excmd)
    let sessionoptions = &l:sessionoptions
    setlocal sessionoptions=
    setlocal sessionoptions+=blank
    setlocal sessionoptions+=buffers
    setlocal sessionoptions+=curdir
    setlocal sessionoptions+=folds
    setlocal sessionoptions+=help
    setlocal sessionoptions+=localoptions
    setlocal sessionoptions+=options
    setlocal sessionoptions+=resize
    setlocal sessionoptions+=tabpages
    setlocal sessionoptions+=winpos
    setlocal sessionoptions+=winsize

    let tmpfile = tempname()
    mksession `=tmpfile`

    try
        execute a:excmd
    finally
        source `=tmpfile`
        call delete(tmpfile)
        let &l:sessionoptions = sessionoptions
    endtry
endfunction
" }}}
" :ScrollbindEnable, :ScrollbindDisable, :ScrollbindToggle {{{

" Enable/Disable 'scrollbind', 'cursorbind' options.
command! -bar ScrollbindEnable  call s:cmd_scrollbind(1)
command! -bar ScrollbindDisable call s:cmd_scrollbind(0)
command! -bar ScrollbindToggle  call s:cmd_scrollbind_toggle()

function! s:cmd_scrollbind_toggle()
    if get(t:, 'vimrc_scrollbind', 0)
        ScrollbindDisable
    else
        ScrollbindEnable
    endif
endfunction

function! s:cmd_scrollbind(enable)
    let winnr = winnr()
    try
        call s:scrollbind_specific_mappings(a:enable)
        windo let &l:scrollbind = a:enable
        if exists('+cursorbind')
            windo let &l:cursorbind = a:enable
        endif
        let t:vimrc_scrollbind = a:enable
    finally
        execute winnr . 'wincmd w'
    endtry
endfunction

function! s:scrollbind_specific_mappings(enable)
    if a:enable
        " Check either buffer-local those mappings are mapped already or not.
        if get(maparg('<C-e>', 'n', 0, 1), 'buffer', 0)
            nnoremap <buffer> <C-e> :<C-u>call <SID>no_scrollbind('<C-e>')<CR>
        endif
        if get(maparg('<C-y>', 'n', 0, 1), 'buffer', 0)
            nnoremap <buffer> <C-y> :<C-u>call <SID>no_scrollbind('<C-y>')<CR>
        endif
    else
        " Check either those mappings are above one or not.
        let map = maparg('<C-e>', 'n', 0, 1)
        if get(map, 'buffer', 0)
        \   || get(map, 'rhs', '') =~# 'no_scrollbind('
            nunmap <buffer> <C-e>
        endif
        let map = maparg('<C-y>', 'n', 0, 1)
        if get(map, 'buffer', 0)
        \   || get(map, 'rhs', '') =~# 'no_scrollbind('
            nunmap <buffer> <C-y>
        endif
    endif
endfunction

function! s:no_scrollbind(key)
    let scrollbind = &l:scrollbind
    try
        execute 'normal!' a:key
    finally
        let &l:scrollbind = scrollbind
    endtry
endfunction

" }}}
" }}}
" For Plugins {{{
if s:has_plugin('nextfile') " {{{
    let g:nf_map_next     = ''
    let g:nf_map_previous = ''
    Map -remap [n] ,n <Plug>(nextfile-next)
    Map -remap [n] ,p <Plug>(nextfile-previous)

    let g:nf_include_dotfiles = 1    " don't skip dotfiles
    let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']


    function! NFLoopMsg(file_to_open)
        redraw
        call s:echomsg('WarningMsg', 'open a file from the start...')
        " Always open a next/previous file...
        return 1
    endfunction
    function! NFLoopPrompt(file_to_open)
        return input('open a file from the start? [y/n]:') =~? 'y\%[es]'
    endfunction

    " g:nf_loop_hook_fn only works when g:nf_loop_files is true.
    let g:nf_loop_files = 1
    " Call this function when wrap around.
    " let g:nf_loop_hook_fn = 'NFLoopPrompt'
    let g:nf_loop_hook_fn = 'NFLoopMsg'
    " To avoid |hit-enter| for NFLoopMsg().
    let g:nf_open_command = 'silent edit'

endif " }}}
if s:has_plugin('starter') " {{{

    " TODO
    let g:loaded_starter = 1

    " let g:starter_no_default_command = 1
    " nnoremap <silent> gt :<C-u>call starter#launch()<CR>

    " function! StarterAfterHookFile(path) "{{{
    "     if !filereadable(a:path)
    "         return
    "     endif

    "     " Open the file.
    "     execute 'edit' a:path

    "     " Set filetype.
    "     let filetype = fnamemodify(a:path, ':e')
    "     if filetype != ''
    "     \   && globpath(&rtp, 'ftplugin/' . filetype . '.vim') != ''
    "         execute 'setfiletype' filetype
    "     endif
    " endfunction "}}}
    " function! s:system_list(args_list) "{{{
    "     return system(join(
    "     \   map(copy(a:args_list), 'shellescape(v:val)')))
    " endfunction "}}}
    " function! StarterAfterHookDir(path) "{{{
    "     if !isdirectory(a:path)
    "         return
    "     endif

    "     if filereadable(a:path . '/setup')
    "         call s:system_list(a:path . '/setup', [a:path])
    "         call delete(a:path . '/setup')
    "     endif
    "     if filereadable(a:path . '/setup.sh')
    "         call s:system_list('/bin/sh', [a:path . '/setup.sh', a:path])
    "         call delete(a:path . '/setup.sh')
    "     endif
    "     if filereadable(a:path . '/setup.pl')
    "         call s:system_list('perl', [a:path . '/setup.pl', a:path])
    "         call delete(a:path . '/setup.pl')
    "     endif
    "     if filereadable(a:path . '/setup.py')
    "         call s:system_list('python', [a:path . '/setup.py', a:path])
    "         call delete(a:path . '/setup.py')
    "     endif
    "     if filereadable(a:path . '/setup.rb')
    "         call s:system_list('ruby', [a:path . '/setup.rb', a:path])
    "         call delete(a:path . '/setup.rb')
    "     endif
    " endfunction "}}}
    " let g:starter#after_hook = [
    " \   'StarterAfterHookFile',
    " \   'StarterAfterHookDir',
    " \]

endif " }}}
if s:has_plugin('vimtemplate') " {{{
    " TODO: starter.vim
    " let g:loaded_vimtemplate = 1

    let g:vt_author = "tyru"
    let g:vt_email = "tyru.exe@gmail.com"
    let g:vt_files_metainfo = {
    \   'cppsrc-scratch.cpp': {'filetype': "cpp"},
    \   'cppsrc.cpp'    : {'filetype': "cpp"},
    \   'csharp.cs'     : {'filetype': "cs"},
    \   'csrc.c'        : {'filetype': "c"},
    \   'header.h'      : {'filetype': "c"},
    \   'hina.html'     : {'filetype': "html"},
    \   'javasrc.java'  : {'filetype': "java"},
    \   'perl.pl'       : {'filetype': "perl"},
    \   'perlmodule.pm' : {'filetype': "perl"},
    \   'python.py'     : {'filetype': "python"},
    \   'scala.scala'   : {'filetype': "scala"},
    \   'scheme.scm'    : {'filetype': "scheme"},
    \   'vimscript.vim' : {'filetype': "vim"}
    \}

    let g:vt_open_command = 'botright 7new'
    " Disable &modeline when opened template file.
    execute
    \   'MyAutocmd BufReadPre'
    \   $MYVIMDIR . '/template/*'
    \   'setlocal nomodeline'
endif " }}}
if s:has_plugin('winmove') " {{{
    let g:wm_move_down  = '<C-M-j>'
    let g:wm_move_up    = '<C-M-k>'
    let g:wm_move_left  = '<C-M-h>'
    let g:wm_move_right = '<C-M-l>'
endif " }}}
if s:has_plugin('sign-diff') " {{{
    " let g:SD_debug = 1
    let g:SD_disable = 1

    if !g:SD_disable
        Map -silent [n] <C-l> :SDUpdate<CR><C-l>
    endif
endif " }}}
if s:has_plugin('DumbBuf') " {{{
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
endif " }}}
if s:has_plugin('prompt') " {{{
    let prompt_debug = 0
endif " }}}
if s:has_plugin('skk') || s:has_plugin('eskk') " {{{

    " Switch SKK plugin.
    let [s:skk_plugin_skk, s:skk_plugin_eskk] = ['skk.vim', 'eskk']
    let s:skk_plugin = s:skk_plugin_eskk

    " skkdict
    call rtputil#append($MYVIMDIR.'/bundle/skkdict.vim')
    let s:skk_user_dict = '~/.skkdict/user-dict'
    let s:skk_user_dict_encoding = 'utf-8'
    let s:skk_system_dict = '~/.skkdict/system-dict'
    let s:skk_system_dict_encoding = 'euc-jp'

    " Disable this settings because now I do not use skk.vim and eskk together.
    " if 1
    "     " Map <C-j> to eskk, Map <C-g><C-j> to skk.vim
    "     let skk_control_j_key = '<C-g><C-j>'
    " else
    "     " Map <C-j> to skk.vim, Map <C-g><C-j> to eskk
    "     Map -remap [ic] <C-g><C-j> <Plug>(eskk:toggle)
    " endif

endif " }}}
if s:has_plugin('skk') && s:skk_plugin is s:skk_plugin_skk " {{{
    let s:skk_plugin_loaded = 1

    " disable eskk
    call rtputil#remove('\<eskk.vim\>')

    " skkdict
    let skk_jisyo = s:skk_user_dict
    let skk_jisyo_encoding = s:skk_user_dict_encoding
    let skk_large_jisyo = s:skk_system_dict
    let skk_large_jisyo_encoding = s:skk_system_dict_encoding

    " let skk_control_j_key = ''
    " Map -remap [lic] <C-j> <Plug>(skk-enable-im)

    let skk_manual_save_jisyo_keys = ''

    let skk_egg_like_newline = 1
    let skk_auto_save_jisyo = 1
    let skk_imdisable_state = -1
    let skk_keep_state = 1
    let skk_show_candidates_count = 2
    let skk_show_annotation = 0
    let skk_sticky_key = ';'
    let skk_use_color_cursor = 1
    let skk_remap_lang_mode = 0


    if 0
        " g:skk_enable_hook test {{{
        " Do not map `<Plug>(skk-toggle-im)`.
        let skk_control_j_key = ''

        " `<C-j><C-e>` to enable, `<C-j><C-d>` to disable.
        Map -remap [ic] <C-j><C-e> <Plug>(skk-enable-im)
        Map -remap [ic] <C-j><C-d> <Nop>
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

endif " }}}
if s:has_plugin('eskk') && s:skk_plugin is s:skk_plugin_eskk " {{{
    let s:skk_plugin_loaded = 1

    " disable skk.vim
    call rtputil#remove('\<skk.vim\>')

    " skkdict
    if !exists('g:eskk#dictionary')
        let g:eskk#dictionary = {
        \   'path': s:skk_user_dict,
        \   'encoding': s:skk_user_dict_encoding,
        \}
    endif
    if !exists('g:eskk#large_dictionary')
        let g:eskk#large_dictionary = {
        \   'path': s:skk_system_dict,
        \   'encoding': s:skk_system_dict_encoding,
        \}
    endif

    let g:eskk#debug = 1
    if 1    " for debugging default behavior.
        let g:eskk#egg_like_newline = 1
        let g:eskk#egg_like_newline_completion = 1
        let g:eskk#show_candidates_count = 2
        let g:eskk#show_annotation = 1
        let g:eskk#rom_input_style = 'msime'
        let g:eskk#keep_state = 1
        let g:eskk#keep_state_beyond_buffer = 1
        let g:eskk#marker_henkan = '$'
        let g:eskk#marker_okuri = '*'
        let g:eskk#marker_henkan_select = '@'
        let g:eskk#marker_jisyo_touroku = '?'
        let g:eskk#dictionary_save_count = 5
        let g:eskk#start_completion_length = 1

        if has('vim_starting')
            MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
            function! s:eskk_initial_pre() "{{{
                " User can be allowed to modify
                " eskk global variables (`g:eskk#...`)
                " until `User eskk-initialize-pre` event.
                " So user can do something heavy process here.
                " (I'm a paranoia, eskk#table#new() is not so heavy.
                " But it loads autoload/vice.vim recursively)

                " rom_to_hira
                let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
                call t.add_map('~', '〜')
                call t.add_map('vc', '©')
                call t.add_map('vr', '®')
                call t.add_map('vh', '☜')
                call t.add_map('vj', '☟')
                call t.add_map('vk', '☝')
                call t.add_map('vl', '☞')
                call t.add_map('jva', 'ゔぁ')
                call t.add_map('jvi', 'ゔぃ')
                call t.add_map('jvu', 'ゔ')
                call t.add_map('jve', 'ゔぇ')
                call t.add_map('jvo', 'ゔぉ')
                call t.add_map('z ', '　')
                " Input hankaku characters.
                call t.add_map('(', '(')
                call t.add_map(')', ')')
                " It is better to register the word "Exposé" than to register this map :)
                call t.add_map('qe', 'é')
                if g:eskk#rom_input_style ==# 'skk'
                    call t.add_map('zw', 'w', 'z')
                endif
                call t.add_map('wyi', 'ゐ', '')
                call t.add_map('wye', 'ゑ', '')

                call eskk#register_mode_table('hira', t)


                " rom_to_kata
                let t = eskk#table#new('rom_to_kata*', 'rom_to_kata')
                call t.add_map('~', '〜')
                call t.add_map('vc', '©')
                call t.add_map('vr', '®')
                call t.add_map('vh', '☜')
                call t.add_map('vj', '☟')
                call t.add_map('vk', '☝')
                call t.add_map('vl', '☞')
                call t.add_map('jva', 'ゔぁ')
                call t.add_map('jvi', 'ゔぃ')
                call t.add_map('jvu', 'ゔ')
                call t.add_map('jve', 'ゔぇ')
                call t.add_map('jvo', 'ゔぉ')
                call t.add_map('z ', '　')
                " Input hankaku characters.
                call t.add_map('(', '(')
                call t.add_map(')', ')')
                " It is better to register the word "Exposé" than to register this map :)
                call t.add_map('qe', 'é')
                if g:eskk#rom_input_style ==# 'skk'
                    call t.add_map('zw', 'w', 'z')
                endif
                call t.add_map('wyi', 'ヰ', '')
                call t.add_map('wye', 'ヱ', '')

                call eskk#register_mode_table('kata', t)
            endfunction "}}}
        endif

        " Debug
        command! -bar          EskkDumpBuftable PP! eskk#get_buftable().dump()
        command! -bar -nargs=1 EskkDumpTable    PP! eskk#table#<args>#load()
        " EskkMap lhs rhs
        " EskkMap -silent lhs2 rhs
        " EskkMap lhs2 foo
        " EskkMap -expr lhs3 {'foo': 'hoge'}.foo
        " EskkMap -noremap lhs4 rhs

        " by @_atton
        " Map -remap [icl] <C-j> <Plug>(eskk:enable)

        " by @hinagishi
        " MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
        " function! s:eskk_initial_pre() "{{{
        "     let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
        "     call t.add_map(',', ', ')
        "     call t.add_map('.', '.')
        "     call eskk#register_mode_table('hira', t)
        "     let t = eskk#table#new('rom_to_kata*', 'rom_to_kata')
        "     call t.add_map(',', ', ')
        "     call t.add_map('.', '.')
        "     call eskk#register_mode_table('kata', t)
        " endfunction "}}}

        " MyAutocmd User eskk-initialize-post call s:eskk_initial_post()
        function! s:eskk_initial_post() "{{{
            " Disable "qkatakana", but ";katakanaq" works.
            " NOTE: This makes some eskk tests fail!
            " EskkMap -type=mode:hira:toggle-kata <Nop>

            map! <C-j> <Plug>(eskk:enable)
            EskkMap <C-j> <Nop>

            EskkMap U <Plug>(eskk:undo-kakutei)

            EskkMap jj <Esc>
            EskkMap -force jj hoge
        endfunction "}}}

    endif
endif " }}}
" SKK plugin finalization "{{{
if !exists('s:skk_plugin_loaded')
    call s:warn("warning: Could not load '".s:skk_plugin."'.")
endif
" }}}
if s:has_plugin('restart') " {{{
    command!
    \   -bar
    \   RestartWithSession
    \   let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
    \   | Restart

    MapAlterCommand res[tart] Restart
    MapAlterCommand ers[tart] Restart
    MapAlterCommand rse[tart] Restart
endif " }}}
if s:has_plugin('openbrowser') " {{{
    let g:netrw_nogx = 1
    Map -remap [nx] gx <Plug>(openbrowser-smart-search)
    MapAlterCommand o[pen] OpenBrowserSmartSearch
    MapAlterCommand alc OpenBrowserSmartSearch -alc

    " let g:openbrowser_open_commands = ['xdg-open', 'x-www-browser', 'firefox', 'w3m']
    " let g:openbrowser_open_rules = {
    " \   'xdg-open':      '{browser} {shellescape(uri)} &',
    " \   'x-www-browser': '{browser} {shellescape(uri)} &',
    " \   'firefox':       '{browser} {shellescape(uri)} &',
    " \   'w3m':           '{browser} {shellescape(uri)} &',
    " \}
    " let g:openbrowser_open_commands = ['firefox']
    " let g:openbrowser_open_rules = {
    " \   'firefox':       '{browser} {shellescape(uri)} &',
    " \   'irefox':       '{browser} {shellescape(uri)} &',
    " \}

    " let g:openbrowser_github_always_used_branch = 'master'
endif " }}}
if s:has_plugin('AutoDate') " {{{
    " let g:autodate_format = "%Y-%m-%d"
endif " }}}
" anything (ku,fuf,unite,etc.) {{{
DefMacroMap [n] anything s

" Which anything do you like?
let [s:anything_fuf, s:anything_ku, s:anything_unite] = range(3)
let s:anything = s:anything_unite

if s:anything == s:anything_fuf && s:has_plugin('fuf')
    Map [n] <anything>d        :<C-u>FufDir<CR>
    Map [n] <anything>f        :<C-u>FufFile<CR>
    Map [n] <anything>h        :<C-u>FufMruFile<CR>
    Map [n] <anything>r        :<C-u>FufRenewCache<CR>
elseif s:anything == s:anything_ku && s:has_plugin('ku')
    Map [n] <anything>f        :<C-u>Ku file<CR>
    Map [n] <anything>h        :<C-u>Ku file/mru<CR>
    Map [n] <anything>H        :<C-u>Ku history<CR>
    Map [n] <anything>:        :<C-u>Ku cmd_mru/cmd<CR>
    Map [n] <anything>/        :<C-u>Ku cmd_mru/search<CR>
elseif s:has_plugin('unite') " fallback, or you select this :)
    command! -bar -nargs=* UniteKawaii Unite -prompt='-')/\  -no-split -create <args>
    Map [n] <anything>f        :<C-u>UniteKawaii -buffer-name=files file buffer file_mru<CR>
    Map [n] <anything>F        :<C-u>UniteKawaii -buffer-name=files file_rec<CR>
    Map [n] <anything>p        :<C-u>UniteKawaii -buffer-name=files buffer_tab<CR>
    Map [n] <anything>h        :<C-u>UniteKawaii -buffer-name=files file_mru<CR>
    Map [n] <anything>t        :<C-u>UniteKawaii -immediately tab:no-current<CR>
    Map [n] <anything>w        :<C-u>UniteKawaii -immediately window:no-current<CR>
    Map [n] <anything>T        :<C-u>UniteKawaii tag<CR>
    Map [n] <anything>H        :<C-u>UniteKawaii help<CR>
    Map [n] <anything>b        :<C-u>UniteKawaii buffer<CR>
    Map [n] <anything>o        :<C-u>UniteKawaii outline<CR>
    Map [n] <anything>r        :<C-u>UniteKawaii -input=ref/ source<CR>
    Map [n] <anything>s        :<C-u>UniteKawaii source<CR>
    Map [n] <anything>g        :<C-u>UniteKawaii grep<CR>
    Map [n] <anything>/        :<C-u>UniteKawaii line<CR>
    Map [n] <anything>:        :<C-u>UniteKawaii history/command<CR>
else
    let s:anything_not_found = 1
endif


" abbrev
function! s:register_anything_abbrev() "{{{
    let abbrev = {
    \   '^r@': [$VIMRUNTIME . '/'],
    \   '^p@': map(split(&runtimepath, ','), 'v:val . "/plugin/"'),
    \   '^h@': ['~/'],
    \   '^v@': [$MYVIMDIR . '/'],
    \   '^g@': ['~/git/'],
    \   '^d@': ['~/git/dotfiles/'],
    \   '^m@': ['~/Dropbox/memo/'],
    \   '^s@': ['~/scratch/'],
    \}

    if has('win16') || has('win32') || has('win64') || has('win95')
        call extend(abbrev, {
        \   '^m@' : ['~/My Dropbox/memo/'],
        \   '^de@' : ['C:' . substitute($HOMEPATH, '\', '/', 'g') . '/デスクトップ/'],
        \   '^cy@' : [exists('$CYGHOME') ? $CYGHOME . '/' : 'C:/cygwin/home/'. $USERNAME .'/'],
        \   '^ms@' : [exists('$MSYSHOME') ? $MSYSHOME . '/' : 'C:/msys/home/'. $USERNAME .'/'],
        \})
    endif

    " fuf
    if s:has_plugin('fuf')
        let g:fuf_abbrevMap = abbrev
    endif
    " unite
    if s:has_plugin('unite')
        for [pat, subst_list] in items(abbrev)
            call unite#set_substitute_pattern('files', pat, subst_list)
        endfor
    endif
endfunction "}}}
if !exists('s:anything_not_found')
    Lazy call s:register_anything_abbrev()
endif

if s:has_plugin('ku') " {{{
    MapAlterCommand ku Ku
endif " }}}
if s:has_plugin('fuf') " {{{
    let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']

    let fuf_keyOpenTabpage = '<C-t>'
    let fuf_keyNextMode    = '<C-l>'
    let fuf_keyPrevMode    = '<C-h>'
    let fuf_keyOpenSplit   = '<C-s>'
    let fuf_keyOpenVsplit  = '<C-v>'
    let fuf_enumeratingLimit = 20
    let fuf_previewHeight = 0
endif " }}}
if s:has_plugin('unite') " {{{
    let g:unite_enable_start_insert = 1
    let g:unite_enable_ignore_case = 1
    let g:unite_enable_smart_case = 1
    let g:unite_enable_split_vertically = 0
    let g:unite_split_rule =
    \   g:unite_enable_split_vertically ?
    \       'topleft' : 'rightbelow'
    let g:unite_update_time = 50
    let g:unite_source_file_mru_ignore_pattern =
    \   '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\|COMMIT_EDITMSG'

    " unite-source-menu {{{

    let g:unite_source_menu_menus = {}

    function! UniteSourceMenuMenusMap(key, value)
        return {
        \   'word' : a:key,
        \   'kind' : 'command',
        \   'action__command' : a:value,
        \}
    endfunction


    " set enc=... {{{
    let g:unite_source_menu_menus.enc = {
    \   'description' : 'set enc=...',
    \   'candidates'  : {},
    \   'map': function('UniteSourceMenuMenusMap'),
    \}
    for s:tmp in [
    \           'latin1',
    \           'cp932',
    \           'shift-jis',
    \           'iso-2022-jp',
    \           'euc-jp',
    \           'utf-8',
    \           'ucs-bom'
    \       ]
        call extend(g:unite_source_menu_menus.enc.candidates,
        \           {s:tmp : 'edit ++enc='.s:tmp},
        \           'error')
    endfor
    unlet s:tmp

    Map -silent [n] <prompt>a  :<C-u>Unite menu:enc<CR>
    " }}}
    " set fenc=... {{{
    let g:unite_source_menu_menus.fenc = {
    \   'description' : 'set fenc=...',
    \   'candidates'  : {},
    \   'map': function('UniteSourceMenuMenusMap'),
    \}
    for s:tmp in [
    \           'latin1',
    \           'cp932',
    \           'shift-jis',
    \           'iso-2022-jp',
    \           'euc-jp',
    \           'utf-8',
    \           'ucs-bom'
    \       ]
        call extend(g:unite_source_menu_menus.fenc.candidates,
        \           {s:tmp : 'set fenc='.s:tmp},
        \           'error')
    endfor
    unlet s:tmp

    Map -silent [n] <prompt>s  :<C-u>Unite menu:fenc<CR>
    " }}}
    " set ff=... {{{
    let g:unite_source_menu_menus.ff = {
    \   'description' : 'set ff=...',
    \   'candidates'  : {},
    \   'map': function('UniteSourceMenuMenusMap'),
    \}
    for s:tmp in ['dos', 'unix', 'mac']
        call extend(g:unite_source_menu_menus.ff.candidates,
        \           {s:tmp : 'set ff='.s:tmp},
        \           'error')
    endfor
    unlet s:tmp

    Map -silent [n] <prompt>d  :<C-u>Unite menu:ff<CR>
    " }}}

    " }}}



    MyAutocmd FileType unite call s:unite_settings()

    let g:unite_winheight = 5    " default winheight.
    let g:unite_winwidth  = 10    " default winwidth.
    function! s:unite_settings() "{{{
        Map -remap -buffer -force [i] <BS> <Plug>(unite_delete_backward_path)
        Map -remap -buffer -force [n] <Space><Space> <Plug>(unite_toggle_mark_current_candidate)

        " Map -remap -buffer -force [i] <C-n> <SID>(expand_unite_window)<Plug>(unite_select_next_line)
        " Map -remap -buffer -force [i] <C-p> <SID>(expand_unite_window)<Plug>(unite_select_previous_line)
    endfunction "}}}

    " Expand current unite window width/height 2/3
    Map -remap [i] <SID>(expand_unite_window) <Plug>(unite_insert_leave)<SID>(expand_unite_window_fn)<Plug>(unite_insert_enter)

    Map -silent [n] <SID>(expand_unite_window_fn) :<C-u>call <SID>unite_resize_window(&columns / 3 * 2, &lines / 3 * 2)<CR>
    function! s:unite_resize_window(width, height)
        if winnr('$') is 1
            return
        elseif g:unite_enable_split_vertically
            execute 'vertical resize' a:width
        else
            execute 'resize' a:height
        endif

        Map -remap -buffer [i] <C-n> <Plug>(unite_select_next_line)
        Map -remap -buffer [i] <C-p> <Plug>(unite_select_previous_line)
    endfunction
endif " }}}
" }}}
if s:has_plugin('Gtags') " {{{
    " <C-]> for gtags.
    function! s:JumpTags() "{{{
        if expand('%') == '' | return | endif

        if !exists(':GtagsCursor')
            echo "gtags.vim is not installed. do default <C-]>..."
            sleep 2
            " unmap this function.
            " use plain <C-]> next time.
            Map! [n] <C-]>
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
endif " }}}
if s:has_plugin('vimshell') " {{{
    MapAlterCommand sh[ell] VimShell

    let g:vimshell_user_prompt = '"(" . getcwd() . ") --- (" . $USER . "@" . hostname() . ")"'
    let g:vimshell_prompt = '$ '
    let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
    let g:vimshell_ignore_case = 1
    let g:vimshell_smart_case = 1

    MyAutocmd FileType vimshell call s:vimshell_settings()
    function! s:vimshell_settings() "{{{
        call s:build_env_path()

        " No -bar
        command!
        \   -buffer -nargs=+
        \   VimShellAlterCommand
        \   call vimshell#altercmd#define(
        \       tyru#util#parse_one_arg_from_q_args(<q-args>)[0],
        \       tyru#util#eat_n_args_from_q_args(<q-args>, 1)
        \   )

        " Alias
        VimShellAlterCommand vi vim
        VimShellAlterCommand df df -h
        VimShellAlterCommand diff diff --unified
        VimShellAlterCommand du du -h
        VimShellAlterCommand free free -m -l -t
        VimShellAlterCommand j jobs -l
        VimShellAlterCommand jobs jobs -l
        VimShellAlterCommand ll ls -lh
        VimShellAlterCommand l ll
        VimShellAlterCommand la ls -A
        " VimShellAlterCommand less less -r
        VimShellAlterCommand sc screen
        VimShellAlterCommand whi which
        VimShellAlterCommand whe where
        VimShellAlterCommand go gopen

        " VimShellAlterCommand l. ls -d .*
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

        let less_sh = s:Vital.globpath(&rtp, 'macros/less.sh')
        if !empty(less_sh)
            call vimshell#altercmd#define('vless', less_sh[0])
        endif

        " Hook
        call vimshell#hook#set('chpwd', [s:SNR('vimshell_chpwd_ls')])
        call vimshell#hook#set('preexec', [s:SNR('vimshell_preexec')])
        " call vimshell#hook#set('preexec', [s:SNR('vimshell_preexec_less')])

        " Add/Remove some mappings.
        Map! -buffer [n] <C-n>
        Map! -buffer [n] <C-p>
        Map! -buffer [i] <Tab>
        Map -buffer -remap -force [i] <Tab><Tab> <Plug>(vimshell_command_complete)
        Map -buffer -remap -force [n] <C-z> <Plug>(vimshell_switch)
        Map -buffer -remap -force [i] <compl>r <Plug>(vimshell_history_complete_whole)

        if s:has_plugin('concealedyank.vim') && has('conceal')
            Map -buffer -remap [nxo] y <Plug>(operator-concealedyank)
        endif

        " Misc.
        setlocal backspace-=eol
        setlocal updatetime=1000
        setlocal nowrap

        if 0
            if !exists(':NeoComplCacheDisable')
                NeoComplCacheEnable
            endif
            NeoComplCacheAutoCompletionLength 1
            NeoComplCacheUnlock
            augroup vimrc-vimshell-settings
                autocmd!
                autocmd TabEnter <buffer> NeoComplCacheUnlock
                autocmd TabLeave <buffer> NeoComplCacheLock
            augroup END
        endif
    endfunction "}}}

    function! s:vimshell_chpwd_ls(args, context) "{{{
        call vimshell#execute('ls')
    endfunction "}}}

    let s:PREEXEC_IEXE = [
    \   'termtter',
    \   'sudo',
    \   ['git', 'add', '-p'],
    \   ['git', 'log'],
    \   ['git', 'lp'],
    \   ['git', 'view'],
    \   ['git', 'blame'],
    \   ['git', 'help'],
    \   'earthquake',
    \]
    let s:PREEXEC_LESS = [
    \   ['git', 'log'],
    \   ['git', 'view'],
    \]
    function! s:vimshell_preexec(cmdline, context) "{{{
        let args = vimproc#parser#split_args(a:cmdline)
        if empty(args)
            return a:cmdline
        endif

        " Prepend "iexe".
        if args[0] ==# 'iexe'
            return a:cmdline
        elseif s:vimshell_preexec_match(args, s:PREEXEC_IEXE)
            return 'iexe '.a:cmdline
        endif

        " Prepend "less".
        if args[0] ==# 'less'
            return a:cmdline
        elseif s:vimshell_preexec_match(args, s:PREEXEC_LESS)
            return 'less '.a:cmdline
        endif

        " TODO: Detect args[1] is correct git command.
        " Avoid error like "git ls ..."
        " This also avoids "git git ..." :-)
        " if len(args) >= 2 &&
        " \   args[0] ==# 'git' && executable(args[1])
        "     return join(args[1:], ' ')
        " endif

        " TODO: Implement a feature like zsh correct

        " No rewrite.
        return a:cmdline
    endfunction "}}}
    function! s:vimshell_preexec_match(args, patlist)
        if empty(a:args)
            return 0
        endif
        for i in a:patlist
            let list_match = type(i) == type([]) && i ==# a:args[:len(i)-1]
            let string_match = type(i) == type("") && a:args[0] ==# i
            if list_match || string_match
                return 1
            endif
            unlet i
        endfor
        return 0
    endfunction

    let s:has_built_path = 0
    function! s:build_env_path() "{{{
        if s:has_built_path
            return
        endif
        let s:has_built_path = 1

        " build $PATH if vim started w/o shell.
        " XXX: :gui
        let $PATH = system(s:is_win ? 'echo %path%' : 'echo $PATH')
    endfunction "}}}
endif " }}}
if s:has_plugin('quickrun') " {{{
    let g:loaded_quicklaunch = 1

    let g:quickrun_no_default_key_mappings = 1
    Map -remap [nx] <Space>r <Plug>(quickrun)

    if has('vim_starting')
        let g:quickrun_config = {}

        let g:quickrun_config['_'] = {'outputter/buffer/split': 'SplitNicely'}

        if executable('pandoc')
            let g:quickrun_config['markdown'] = {'command' : 'pandoc'}
        endif

        let g:quickrun_config['lisp'] = {
        \   'command': 'clisp',
        \   'eval': 1,
        \   'eval_template': '(print %s)',
        \}

        " http://d.hatena.ne.jp/osyo-manga/20121125/1353826182
        let g:quickrun_config["cpp0x"] = {
        \   "command" : "g++",
        \   "cmdopt" : "--std=c++0x",
        \   "type" : "cpp/g++",
        \}
    endif
endif " }}}
if s:has_plugin('submode') "{{{

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
    call submode#enter_with('winsize', 'n', '', 'mws', ':<C-u>call VimrcSubmodeResizeWindow()<CR>')
    call submode#leave_with('winsize', 'n', '', '<Esc>')

    " TODO or FIXME: submode#leave_with() can't do that.
    " call submode#leave_with('winsize', 'n', '', '<Esc>', ':<C-u>call VimrcSubmodeResizeWindowRestore()<CR>')

    function! VimrcSubmodeResizeWindow()
        let curwin = winnr()
        wincmd j | let target1 = winnr() | exe curwin "wincmd w"
        wincmd l | let target2 = winnr() | exe curwin "wincmd w"

        execute printf("call submode#map ('winsize', 'n', 'r', 'j', '<C-w>%s')", curwin == target1 ? "-" : "+")
        execute printf("call submode#map ('winsize', 'n', 'r', 'k', '<C-w>%s')", curwin == target1 ? "+" : "-")
        execute printf("call submode#map ('winsize', 'n', 'r', 'h', '<C-w>%s')", curwin == target2 ? ">" : "<")
        execute printf("call submode#map ('winsize', 'n', 'r', 'l', '<C-w>%s')", curwin == target2 ? "<" : ">")
    endfunction
    " function! VimrcSubmodeResizeWindowRestore()
    "     if exists('s:submode_save_lazyredraw')
    "         let &l:lazyredraw = s:submode_save_lazyredraw
    "         unlet s:submode_save_lazyredraw
    "     endif
    " endfunction

    " undo/redo
    call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
    call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
    call submode#leave_with('undo/redo', 'n', '', '<Esc>')
    call submode#map       ('undo/redo', 'n', '', '-', 'g-')
    call submode#map       ('undo/redo', 'n', '', '+', 'g+')

    " Tab walker.
    call submode#enter_with('tabwalker', 'n', '', 'mt', '<Nop>')
    call submode#leave_with('tabwalker', 'n', '', '<Esc>')
    call submode#map       ('tabwalker', 'n', '', 'h', 'gT')
    call submode#map       ('tabwalker', 'n', '', 'l', 'gt')
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
    call submode#enter_with('scroll', 'n', '', 'gj', '<C-d>')
    call submode#enter_with('scroll', 'n', '', 'gk', '<C-u>')
    call submode#leave_with('scroll', 'n', '', '<Esc>')
    call submode#map       ('scroll', 'n', '', 'j', '<C-d>')
    call submode#map       ('scroll', 'n', '', 'k', '<C-u>')
    call submode#map       ('scroll', 'n', '', 'a', ':let &l:scroll -= 3<CR>')
    call submode#map       ('scroll', 'n', '', 's', ':let &l:scroll += 3<CR>')
endif "}}}
if s:has_plugin('vim-ref') " {{{
    " 'K' for ':Ref'.
    MapAlterCommand ref         Ref
    " MapAlterCommand alc         Ref alc    " See openbrowser.vim config
    MapAlterCommand rfc         Ref rfc
    MapAlterCommand man         Ref man
    MapAlterCommand pdoc        Ref perldoc
    MapAlterCommand cppref      Ref cppref
    MapAlterCommand cpp         Ref cppref
    MapAlterCommand py[doc]     Ref pydoc

    Map [n] <orig>K K
    Map -remap [n] K <SID>(open-help-window)<Plug>(ref-keyword)

    Map [n] <SID>(open-help-window) :<C-u>call <SID>open_help_window()<CR>
    function! s:open_help_window()
        if !s:has_help_window()
            Help
        endif
    endfunction

    let g:ref_use_vimproc = 0
    let g:ref_open = 'SplitNicely'
    if executable('perldocjp')
        let g:ref_perldoc_cmd = 'perldocjp'
    endif
endif " }}}
if s:has_plugin('vimfiler') " {{{
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_safe_mode_by_default = 0
    let g:vimfiler_split_command = 'aboveleft split'

    MyAutocmd FileType vimfiler call s:vimfiler_settings()
    function! s:vimfiler_settings() "{{{
        Map -buffer -remap -force [n] L <Plug>(vimfiler_move_to_history_forward)
        Map -buffer -remap -force [n] H <Plug>(vimfiler_move_to_history_back)
        Map -buffer -remap -force [n] <C-o> <Plug>(vimfiler_move_to_history_back)
        Map -buffer -remap -force [n] <C-i> <Plug>(vimfiler_move_to_history_forward)

        " TODO
        " Map! -buffer [n] N j k
        Map! -buffer [n] N
        Map! -buffer [n] j
        Map! -buffer [n] k
        Map! -buffer [n] ?

        " dd as <Plug>(vimfiler_force_delete_file)
        " because I want to use trash-put.
        Map! -buffer [n] d
        Map -remap -buffer -force [n] dd <Plug>(vimfiler_force_delete_file)

        Map -remap -buffer -force [n] <Space><Space> <Plug>(vimfiler_toggle_mark_current_line)
    endfunction "}}}
endif " }}}
if s:has_plugin('prettyprint') " {{{
    MapAlterCommand pp PP

    let g:prettyprint_show_expression = 1
endif " }}}
if s:has_plugin('lingr') " {{{

    " from thinca's .vimrc {{{
    " http://soralabo.net/s/vrcb/s/thinca

    if !exists('g:lingr')
        call rtputil#remove('\<lingr-vim\>')
    endif

    if 0
        " Update GNU screen tab name.

        augroup vimrc-plugin-lingr
            autocmd!
            autocmd User plugin-lingr-* call s:lingr_event(
            \     matchstr(expand('<amatch>'), 'plugin-lingr-\zs\w*'))
            autocmd FileType lingr-* call s:init_lingr(expand('<amatch>'))
        augroup END

        function! s:lingr_ctrl_l() "{{{
            call lingr#mark_as_read_current_room()
            call s:screen_auto_window_name()
            redraw!
        endfunction "}}}
        function! s:init_lingr(ft) "{{{
            if exists('s:screen_is_running')
                Map -silent -buffer [n] <C-l> :<C-u>call <SID>lingr_ctrl_l()<CR>
                let b:window_name = 'lingr'
            endif
        endfunction "}}}
        function! s:lingr_event(event) "{{{
            if a:event ==# 'message' && s:screen_is_running
                execute printf('WindowName %s(%d)', 'lingr', lingr#unread_count())
            endif
        endfunction "}}}

    endif    " Update GNU screen tab name.
    " }}}



    MyAutocmd FileType lingr-messages
    \   call s:lingr_messages_mappings()
    function! s:lingr_messages_mappings() "{{{
        Map -remap -buffer [n] o <Plug>(lingr-messages-show-say-buffer)
        Map -buffer [n] <C-g><C-n> gt
        Map -buffer [n] <C-g><C-p> gT
    endfunction "}}}

    MyAutocmd FileType lingr-say
    \   call s:lingr_say_mappings()
    function! s:lingr_say_mappings() "{{{
        Map -remap -buffer [n] <CR> <SID>(lingr-say-say)
    endfunction "}}}

    Map -silent [n] <SID>(lingr-say-say) :<C-u>call <SID>lingr_say_say()<CR>
    function! s:lingr_say_say() "{{{
        let all_lines = getline(1, '$')
        let blank_line = '^\s*$'
        call filter(all_lines, 'v:val =~# blank_line')
        if empty(all_lines)    " has blank line(s).
            let doit = 1
        else
            let doit = input('lingr-say buffer has one or more blank lines. say it?[y/n]:') =~? '^y\%[es]'
        endif
        if doit
            execute "normal \<Plug>(lingr-say-say)"
        endif
    endfunction "}}}



    let g:lingr_vim_user = 'tyru'

    let g:lingr_vim_additional_rooms = [
    \   'tyru',
    \   'vim',
    \   'emacs',
    \   'editor',
    \   'vim_users_en',
    \   'vimperator',
    \   'filer',
    \   'completion',
    \   'shell',
    \   'git',
    \   'termtter',
    \   'lingr',
    \   'ruby',
    \   'few',
    \   'gc',
    \   'scala',
    \   'lowlevel',
    \   'lingr_vim',
    \   'vimjolts',
    \   'gentoo',
    \   'LinuxKernel',
    \]
    let g:lingr_vim_rooms_buffer_height = len(g:lingr_vim_additional_rooms) + 3
    let g:lingr_vim_count_unread_at_current_room = 1
endif " }}}
if s:has_plugin('chalice') " {{{
    if !exists('g:chalice')
        call rtputil#remove('\<chalice\>')
    endif
endif " }}}
if s:has_plugin('github') " {{{
    MapAlterCommand gh Github
    MapAlterCommand ghi Github issues
endif " }}}
if s:has_plugin('neocomplcache') "{{{
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_disable_caching_file_path_pattern = '.*'
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_enable_underbar_completion = 1
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_auto_completion_start_length = 3

    Map [n] <Leader>neo :<C-u>NeoComplCacheToggle<CR>
endif "}}}
if s:has_plugin('EasyGrep') " {{{
    let g:EasyGrepCommand = 2
    let g:EasyGrepInvertWholeWord = 1
endif " }}}
if s:has_plugin('gist-vim') "{{{
    let g:gist_detect_filetype = 1
    let g:gist_open_browser_after_post = 1
    let g:gist_browser_command = ":OpenBrowser %URL%"
    let g:gist_update_on_write = 2
endif "}}}
if s:has_plugin('ohmygrep') " {{{
    MapAlterCommand gr[ep] OMGrep
    MapAlterCommand re[place] OMReplace

    Map -remap [n] <Space>gw <Plug>(omg-grep-cword)
    Map -remap [n] <Space>gW <Plug>(omg-grep-cWORD)
endif " }}}
if s:has_plugin('detect-coding-style') " {{{

    MyAutocmd User dcs-initialized-styles call s:dcs_register_own_styles()
    function! s:dcs_register_own_styles()
        " let shiftwidth = 'shiftwidth='.(s:fill_version('7.3.629') ? 0 : &sw)
        " let softtabstop = 'softtabstop='.(s:fill_version('7.3.693') ? -1 : &sts)
        call dcs#register_style('My style', {'hook_excmd': 'setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4'})
        call dcs#register_style('Short indent', {'hook_excmd': 'setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2'})
    endfunction

endif " }}}
if s:has_plugin('autocmd-tabclose') " {{{
    " :tabprevious on vimrc-tabclose
    function! s:tabclose_post()
        if tabpagenr() != 1
            " XXX: Doing :tabprevious here cause Vim behavior strange
            " Decho ':tabprevious'
        endif
    endfunction
    MyAutocmd User tabclose-post call s:tabclose_post()
endif " }}}
if s:has_plugin('simpletap') " {{{
    let g:simpletap#open_command = 'botright vnew'
endif " }}}
if s:has_plugin('ftplugin/vim_fold.vim') " {{{
    augroup foldmethod-expr
        autocmd!
        autocmd InsertEnter * if &l:foldmethod ==# 'expr'
        \                   |   let b:foldinfo = [&l:foldmethod, &l:foldexpr]
        \                   |   setlocal foldmethod=manual foldexpr=0
        \                   | endif
        autocmd InsertLeave * if exists('b:foldmethod')
        \                   |   let [&l:foldmethod, &l:foldexpr] = b:foldinfo
        \                   | endif
    augroup END
endif " }}}
if s:has_plugin('GraVit') " {{{

    " XXX: 2012-09-17 19:48: syntax/vim.vim wrong highlight...
    " Map -remap [nxo] g/ <Plug>gravit->forward
    " Map -remap [nxo] g? <Plug>gravit->backward

    " highlight GraVitCurrentMatch term=underline cterm=underline gui=underline ctermfg=4 guifg=Purple

endif " }}}
if s:has_plugin('hatena.vim') " {{{
    let g:hatena_no_default_keymappings = 1
    let g:hatena_user = 'tyru'
    let g:hatena_entry_file = '~/Dropbox/memo/blogentry.txt'
    " must type :w! to upload.
    let g:hatena_upload_on_write = 0
    let g:hatena_upload_on_write_bang = 1
endif " }}}
if s:has_plugin('fileutils') " {{{
    call fileutils#load('noprefix')

    MapAlterCommand rm Delete
    MapAlterCommand del[ete] Delete

    MapAlterCommand mv Rename
    MapAlterCommand ren[ame] Rename

    MapAlterCommand mkd[ir] Mkdir

    MapAlterCommand mkc[d] Mkcd
endif "}}}
if s:has_plugin('watchdogs') " {{{
    if has('vim_starting')
        call watchdogs#setup(g:quickrun_config)
    endif
    let g:watchdogs_check_BufWritePost_enable = 1

    command! WatchdogsStart
    \     let g:watchdogs_check_BufWritePost_enable = 1
    \   | let g:watchdogs_check_CursorHold_enable   = 1
    \   | echo 'enabled watchdogs auto-commands.'
    command! WatchdogsStop
    \     let g:watchdogs_check_BufWritePost_enable = 0
    \   | let g:watchdogs_check_CursorHold_enable   = 0
    \   | echo 'disabled watchdogs auto-commands.'
endif "}}}
if s:has_plugin('vim-hier') " {{{
    function! s:quickfix_is_target()
        " let buftype = getbufvar(expand('<abuf>'), '&buftype')
        let winnr = bufwinnr(expand('<abuf>'))
        let buftype = getwinvar(winnr, '&buftype')
        " Dump [winnr, buftype]
        return buftype ==# 'quickfix'
    endfunction
    function! s:stop_hier_on_quickfix_close()
        if !exists(':HierStop')
            return
        endif
        if s:quickfix_is_target() || !s:quickfix_exists_window()
            HierStop
        endif
    endfunction
    function! s:start_hier_on_quickfix_open()
        if !exists(':HierStart')
            return
        endif
        if s:quickfix_is_target() || s:quickfix_exists_window()
            HierStart
        endif
    endfunction
    MyAutocmd BufWinLeave,BufDelete,BufUnload,BufWipeout *
    \   call s:stop_hier_on_quickfix_close()
    MyAutocmd QuickFixCmdPost *
    \   call s:start_hier_on_quickfix_open()


    function! s:check_auto_commands(evname)
        " disable
        if 1 | return | endif

        echom a:evname.': <afile> = '.expand('<afile>').', <abuf> = '.expand('<abuf>').', <amatch> = '.expand('<amatch>')
        Dump bufexists(expand('<abuf>'))
        let winnr = s:quickfix_get_winnr()
        Dump [getbufvar(expand('<abuf>'), '&buftype'), winnr, getwinvar(winnr, '&buftype')]
        let quickfix_is_target = s:quickfix_is_target()
        let quickfix_exists_window = s:quickfix_exists_window()
        Dump [quickfix_is_target, quickfix_exists_window]
    endfunction

    for s:tmp in [
    \   'BufWinLeave',
    \   'BufUnload',
    \   'BufDelete',
    \   'BufWipeout',
    \]
        execute 'MyAutocmd '.s:tmp.' * call s:check_auto_commands('.string(s:tmp).')'
    endfor
    unlet s:tmp
endif "}}}
if s:has_plugin('accelerated-jk') " {{{
    Map -remap [n] j <Plug>(accelerated_jk_gj)
    Map -remap [n] k <Plug>(accelerated_jk_gk)
    let g:accelerated_jk_deceleration_table = [
    \   [200, 10],
    \   [300, 15],
    \   [500, 30],
    \   [600, 40],
    \   [700, 50],
    \   [800, 60],
    \   [900, 70],
    \   [1000, 9999],
    \]
endif "}}}
if s:has_plugin('capture') "{{{
    MapAlterCommand c[apture] Capture
endif "}}}
if s:has_plugin('instant-markdown-vim') "{{{
    " MyAutocmd FileType hatena let b:instant_markdown_path = '/html?type=hatena'
    " MyAutocmd FileType hatena InstantMarkdownStart
endif "}}}
if s:has_plugin('concealedyank.vim') && has('conceal') "{{{
    Map -remap [x] <operator>cy <Plug>(operator-concealedyank)
endif "}}}
if s:has_plugin('syntax/vim.vim') "{{{
    " augroup: a
    " function: f
    " lua: l
    " perl: p
    " ruby: r
    " python: P
    " tcl: t
    " mzscheme: m
    let g:vimsyn_folding = 'af'
endif "}}}
if s:has_plugin('indent-guides') "{{{
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0
    MyAutocmd ColorScheme * hi IndentGuidesOdd ctermbg=233
    MyAutocmd ColorScheme * hi IndentGuidesEven ctermbg=235
    let g:indent_guides_color_change_percent = 30
endif "}}}
if s:has_plugin('foldCC') "{{{
    set foldtext=FoldCCtext()
endif "}}}
if s:has_plugin('vim-anzu') "{{{
    Map -remap [nxo] n <SID>(always_forward_n)<Plug>(anzu-update-search-status-with-echo)
    Map -remap [nxo] N <SID>(always_forward_N)<Plug>(anzu-update-search-status-with-echo)
else
    " FIXME: <SID>(always_forward_n) is not related to vim-anzu plugin.
    "
    " Mapping -> plugin specific mapping, misc. hacks
    Map -remap [nxo] n <SID>(always_forward_n)
    Map -remap [nxo] N <SID>(always_forward_N)
endif "}}}
if s:has_plugin('vim-fakeclip') "{{{
    " vim-fakeclip plugin is loaded only on the platform where
    " 1. the X server exists
    " 2. starting Vim of non-GUI version
    set clipboard+=exclude:.*
    let g:fakeclip_always_provide_clipboard_mappings = 1
endif "}}}

" test
let g:loaded_tyru_event_test = 1

" runtime
if s:has_plugin('netrw') " {{{
    function! s:filetype_netrw() "{{{
        Map -remap -buffer [n] h -
        Map -remap -buffer [n] l <CR>
        Map -remap -buffer [n] e <CR>
    endfunction "}}}

    MyAutocmd FileType netrw call s:filetype_netrw()
endif " }}}
if s:has_plugin('indent/vim.vim') " {{{
    let g:vim_indent_cont = 0
endif " }}}
if s:has_plugin('changelog') " {{{
    let changelog_username = "tyru"
endif " }}}
if s:has_plugin('syntax/sh.vim') " {{{
    let g:is_bash = 1
endif " }}}
if s:has_plugin('syntax/scheme.vim') " {{{
    let g:is_gauche = 1
endif " }}}
if s:has_plugin('syntax/perl.vim') " {{{

    " POD highlighting
    let g:perl_include_pod = 1
    " Fold only sub, __END__, <<HEREDOC
    let g:perl_fold = 1
    let g:perl_nofold_packages = 1

endif " }}}

" }}}
" Backup {{{
" TODO Rotate backup files like writebackupversioncontrol.vim
" (I didn't use it, though)

" Delete old files in &backupdir {{{
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
        let stamp_file = expand('~/.vimbackup_deleted')
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
" GNU Screen, Tmux {{{
"
" from thinca's .vimrc
" http://soralabo.net/s/vrcb/s/thinca

if $WINDOW != '' || $TMUX != ''
    let s:screen_is_running = 1

    " Use a mouse in screen.
    if has('mouse')
        set ttymouse=xterm2
    endif

    function! s:screen_set_window_name(name)
        let esc = "\<ESC>"
        silent! execute '!echo -n "' . esc . 'k' . escape(a:name, '%#!')
        \ . esc . '\\"'
        redraw!
    endfunction
    command! -bar -nargs=? WindowName call s:screen_set_window_name(<q-args>)

    function! s:screen_auto_window_name()
        let varname = 'window_name'
        for scope in [w:, b:, t:, g:]
            if has_key(scope, varname)
                call s:screen_set_window_name(scope[varname])
                return
            endif
        endfor
        if bufname('%') !~ '^\[A-Za-z0-9\]*:/'
            call s:screen_set_window_name('vim:' . expand('%:t'))
        endif
    endfunction
    if 0
        augroup vimrc-screen
            autocmd!
            autocmd VimEnter * call s:screen_set_window_name(0 < argc() ?
            \ 'vim:' . fnamemodify(argv(0), ':t') : 'vim')
            autocmd BufEnter,BufFilePost * call s:screen_auto_window_name()
            autocmd VimLeave * call s:screen_set_window_name(len($SHELL) ?
            \ fnamemodify($SHELL, ':t') : 'shell')
        augroup END
    endif
endif
" }}}
" own-highlight {{{
" TODO: Plugin-ize

augroup own-highlight
    autocmd!
augroup END

function! s:register_highlight(hi, hiarg, pat)
    execute 'highlight' a:hiarg
    call s:add_pattern(a:hi, a:pat)
endfunction
function! s:add_pattern(hi, pat)
    " matchadd() will throw an error
    " when a:hi is not defined.
    if !hlexists(a:hi)
        return
    endif
    if !exists('w:did_pattern')
        let w:did_pattern = {}
    endif
    if !has_key(w:did_pattern, a:hi)
        call matchadd(a:hi, a:pat)
        let w:did_pattern[a:hi] = 1
    endif
endfunction

function! s:register_own_highlight()
    " I found that I'm very nervous about whitespaces.
    " so I'd better think about this.
    " This settings just notice its presence.
    for [hi, hiarg, pat] in [
    \   ['IdeographicSpace',
    \    'IdeographicSpace term=underline cterm=underline gui=underline ctermfg=4 guifg=Cyan',
    \    '　'],
    \   ['WhitespaceEOL',
    \    'WhitespaceEOL term=underline cterm=underline gui=underline ctermfg=4 guifg=Cyan',
    \    ' \+$'],
    \]
        " TODO: filetype
        execute
        \   'autocmd own-highlight Colorscheme *'
        \   'call s:register_highlight('
        \       string(hi) ',' string(hiarg) ',' string(pat)
        \   ')'
        execute
        \   'autocmd own-highlight VimEnter,WinEnter *'
        \   'call s:add_pattern('
        \       string(hi) ',' string(pat)
        \   ')'
    endfor
endfunction
call s:register_own_highlight()
" }}}
" Change cursor color on xterm {{{
" :help termcap-cursor-color
if !has('gui_running')
    if &term =~? 'xterm'
        " blue in insert-mode
        let &t_SI = "\<Esc>]12blue\x7"
        " white in normal-mode
        " NOTE: Vim doesn't have option to
        " restore cursor color on VimLeave.
        let &t_EI = "\<Esc>]12;white\x7"
    elseif &term =~? 'screen'
        " TODO
        " let &t_SI = ...
        " let &t_EI = ...
    endif
endif
" }}}
" Make <M-Space> same as ordinal applications on MS Windows {{{
if has('gui_running') && s:is_win
    nnoremap <M-Space> :<C-u>simalt ~<CR>
endif
" }}}
" }}}
" End. {{{


set secure
" }}}
