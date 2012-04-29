" vim:set fen fdm=marker:
" Basic {{{
scriptencoding utf-8

syntax enable
filetype plugin indent on

language messages C
language time C

if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
endif

let s:is_win = has('win16') || has('win32') || has('win64')
" }}}
" Utilities {{{
" Function {{{

function! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction "}}}
function! s:SNR(map) "{{{
    return printf("<SNR>%d_%s", s:SID(), a:map)
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



command!
\   -nargs=+
\   Lazy
\   call s:cmd_lazy(<q-args>)

function! s:cmd_lazy(q_args) "{{{
    if a:q_args == ''
        return
    endif
    if has('vim_starting')
        execute 'MyAutocmd VimEnter *' a:q_args
    else
        execute a:q_args
    endif
endfunction "}}}



command!
\   -nargs=+
\   Echomsg
\
\   let [hl, msg] = tyru#util#parse_one_arg_from_q_args(<q-args>)
\   | execute 'echohl' hl
\   | echomsg eval(msg)
\   | echohl None

" }}}
" }}}
" Options {{{

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
set tabstop=4

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

" Disable it temporarily...
let g:scrolloff = 0

" Hack for <LeftMouse> not to adjust ('scrolloff') when single-clicking.
" Implement 'scrolloff' by auto-command to control the fire.
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

" shift
set shiftround
set shiftwidth=4

" completion
set complete=.,w,b,u,t,i,d,k,kspell
set wildmenu
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
let &backupdir = $MYVIMDIR . '/backup'
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif

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

" gui
set guioptions=agitrhpF

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

" undo-persistence
if has('persistent_undo')
    set undofile
    let &undodir = $MYVIMDIR . '/info/undo'
    silent! call mkdir(&undodir, 'p')
endif

" http://vim-users.jp/2009/12/hack107/
" Enable mouse support.
set mouse=a

" For screen.
if &term =~ "^screen"
    augroup MyAutoCmd
        autocmd VimLeave * :set mouse=
     augroup END

    " workaround for freeze when using mouse on GNU screen.
    set ttymouse=xterm2
endif

if has('gui_running')
    " Show popup menu if right click.
    set mousemodel=popup

    " Don't focus the window when the mouse pointer is moved.
    set nomousefocus
    " Hide mouse pointer on insert mode.
    set mousehide
endif

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
set viminfo='50,h,f1,n$HOME/.viminfo
set matchpairs+=<:>
set showbreak=↪
" }}}
" Autocmd {{{

" colorscheme
" NOTE: On MS Windows, setting colorscheme in .vimrc does not work.
" Because :Lazy is necessary.
" XXX: `:Lazy colorscheme tyru` does not throw ColorScheme event,
" what the fuck?
Lazy colorscheme tyru | doautocmd ColorScheme

" Open on read-only if swap exists
MyAutocmd SwapExists * let v:swapchoice = 'o'

MyAutocmd QuickfixCmdPost * QuickFix

" InsertLeave, InsertEnter
MyAutocmd InsertEnter * setlocal ignorecase

" Set syntaxes
MyAutocmd BufNewFile,BufRead *.as setlocal syntax=actionscript
MyAutocmd BufNewFile,BufRead _vimperatorrc,.vimperatorrc setlocal syntax=vimperator
MyAutocmd BufNewFile,BufRead *.avs setlocal syntax=avs

" Aliases
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
    let prompt = "possible typo: really want to write to '" . a:file . "'?(y/n):"
    if input(prompt) =~? '^\s*y'
        execute 'write' a:file
    endif
endfunction
" }}}

" Automatic `:!chmod +x %`. {{{
command! -bar AutoChmodDisable let b:disable_auto_chmod = 1
command! -bar AutoChmodEnable  unlet! b:disable_auto_chmod
MyAutocmd BufWritePost * call s:auto_chmod()
function! s:check_auto_chmod() "{{{
    return !exists('b:disable_auto_chmod')
    \   && getfperm(expand('%'))[2] !=# 'x'
    \   && getline(1) =~# '^#!'
    \   && executable('chmod')
endfunction "}}}
function! s:auto_chmod()
    if s:check_auto_chmod()
        !chmod +x %
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
" Initializing {{{

call rtputil#bundle()
command! -bar HelpTagsAll call rtputil#helptags()
HelpTagsAll


call emap#load('noprefix')    " Define :EmMap as :Map
" call emap#set_sid_from_vimrc()
call emap#set_sid(s:SID())
" call emap#set_sid_from_sfile(expand('<sfile>'))


let g:arpeggio_timeoutlen = 40
call arpeggio#load()


call altercmd#load()
command!
\   -bar -nargs=+
\   MapAlterCommand
\   CAlterCommand <args> | AlterCommand <cmdwin> <args>


call dutil#load()
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

DefMacroMap [nvo] orig q
DefMacroMap [ic] orig <C-g><C-o>

Map [n] <orig>q q

DefMacroMap [nvo] excmd <Space>
DefMacroMap [nvo] operator ;
DefMacroMap [n] window <C-w>
DefMacroMap [nvo] prompt ,t

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
" operator-reverse-lines {{{
Map [nvo] -remap <operator>rl <Plug>(operator-reverse-lines)
" }}}
" operator-reverse-text {{{
Map [nvo] -remap <operator>rw <Plug>(operator-reverse-text)
" }}}
" operator-narrow {{{
call operator#user#define_ex_command('narrow', 'Narrow')

Map [nvo] -remap <operator>na <Plug>(operator-narrow)
Map [nvo]        <operator>nw :<C-u>Widen<CR>

let g:narrow_allow_overridingp = 1
" }}}
" operator-replace {{{
Map [nvo] -remap <operator>p  <Plug>(operator-replace)
" }}}
" operator-camelize {{{
Map [nvo] -remap <operator>c <Plug>(operator-camelize-toggle)
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
" Map [nvo] -remap <operator>c <Plug>(operator-camelize)
" Map [nvo] -remap <operator>C <Plug>(operator-decamelize)


" See "keymappings" branch.
" Map [nvo] -remap <operator>c <Plug>(operator-camelize/camelize)
" Map [nvo] -remap <operator>C <Plug>(operator-decamelize/lowercase)

" }}}
" operator-blank-killer {{{
call operator#user#define_ex_command('blank-killer', 's/\s\+$//')
Map [nvo] -remap <operator>bk <Plug>(operator-blank-killer)
" }}}
" operator-html-escape {{{
Map [nvo] -remap <operator>he <Plug>(operator-html-escape)
Map [nvo] -remap <operator>hu <Plug>(operator-html-unescape)
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

Map [nvo] -remap <operator>zh <Plug>(operator-zen2han)
Map [nvo] -remap <operator>hz <Plug>(operator-han2zen)
" }}}
" }}}
" motion {{{
Map [nvo] j gj
Map [nvo] k gk

Map [nvo] <orig>j j
Map [nvo] <orig>k k

" FIXME: Does not work in visual mode.
Map [nvo] ]k :<C-u>call search('^\S', 'Ws')<CR>
Map [nvo] [k :<C-u>call search('^\S', 'Wsb')<CR>

Map [nvo] gp %
" }}}
" textobj {{{
Map [vo] -remap iF <Plug>(textobj-fold-i)
Map [vo] -remap aF <Plug>(textobj-fold-a)

Map [vo] -remap iF <Plug>(textobj-between-i)
Map [vo] -remap aF <Plug>(textobj-between-a)

Map [vo] -remap if <Plug>(textobj-function-i)
Map [vo] -remap af <Plug>(textobj-function-a)

Map [vo] aa a>
Map [vo] ia i>
Map [vo] ar a]
Map [vo] ir i]

Map [vo] -remap il <Plug>(textobj-lastpat-n)
" }}}
" }}}
" nmap {{{

DefMacroMap [nvo] fold z

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
Map [n] d<CR> :<C-u>call append(line('.'), '')<CR>j
Map [n] c<CR> :<C-u>call append(line('.'), '')<CR>jI

Map [n] <excmd>me :<C-u>messages<CR>
Map [n] <excmd>di :<C-u>display<CR>

Map [n] g; ~

Map [n] r gR

Map [n] gl :<C-u>cnext<CR>
Map [n] gh :<C-u>cNext<CR>

Map [n] <excmd>ct :<C-u>tabclose<CR>

Map [n] gm :<C-u>make<CR>

Map [n] <Space>tl :<C-u>tabedit<CR>
Map [n] <Space>th :<C-u>tabedit<CR>:execute 'tabmove' (tabpagenr() isnot 1 ? tabpagenr() - 2 : '')<CR>

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
Map [n] <excmd>sv     :<C-u>source $MYVIMRC<CR>
" }}}
" Cmdwin {{{
set cedit=<C-z>
function! s:cmdwin_enter()
    Map [ni] -force -buffer <C-z>         <C-c>
    Map [n]  -buffer <Esc>         :<C-u>quit<CR>
    Map [n]  -force -buffer <window>k        :<C-u>quit<CR>
    Map [n]  -force -buffer <window><C-k>    :<C-u>quit<CR>
    Map [i]  -force -buffer -expr <BS>       col('.') == 1 ? "\<Esc>:quit\<CR>" : "\<BS>"

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
" NOTE: gVim only
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
    let curidx = tyru#util#get_idx(a:state, a:elem, 0)
    return a:state[tyru#util#has_idx(a:state, curidx + 1) ? curidx + 1 : 0]
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
Map [n] <excmd>on :<C-u>call <SID>toggle_option('number')<CR>
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
    while tyru#util#has_idx(winnr_list, counter)
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
" 'Y' to yank till the end of line. {{{
Map [n] Y    y$
Map [n] ;Y   "+y$
Map [n] ,Y   "*y$
" }}}
" Back to col '$' when current col is right of col '$'. {{{
"
" 1. move to the last col
" when over the last col ('virtualedit').
" 2. do not insert " " before inserted text
" when characterwise.

if has('virtualedit') && &virtualedit =~# '\<all\>'
    DefMap [n] -expr $-if-right-of-$    (col('.') >= col('$') ? '$' : '')
else
    DefMap [n]       $-if-right-of-$    <Nop>
endif
DefMap [n] -expr paste-nicely       getline('.') == '' ? 'p0"_x' : 'p'
Map [n] -remap -expr p getregtype(v:register) ==# 'v' ? emap#compile_map('n', '<$-if-right-of-$><paste-nicely>') : (v:register !=# '' ? '"'.v:register : '').'<paste-nicely>'
" }}}
" <Space>[hjkl] for <C-w>[hjkl] {{{
Map [n] -silent <Space>j <C-w>j
Map [n] -silent <Space>k <C-w>k
Map [n] -silent <Space>h <C-w>h
Map [n] -silent <Space>l <C-w>l
Map [n] -silent <Space>n <C-w>w
Map [n] -silent <Space>p <C-w>W
" }}}
" Moving between tabs {{{
Map [n] -silent <C-n> gt
Map [n] -silent <C-p> gT
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

command!
\   -bar -nargs=?
\   CountWord
\   call s:count_word(expand(empty([<f-args>]) ? '<cword>' : <q-args>))
" }}}
" Move all windows of current group beyond next group. {{{
" TODO
" }}}
" Set tab's title {{{
Map [n] -silent <C-t> :<C-u>SetProjectName<CR>
command! -bar -nargs=* SetProjectName call s:cmd_set_project_name(<q-args>)
function! s:cmd_set_project_name(name) "{{{
    if a:name == ''
        let default = exists('t:title') ? t:title : ''
        let t:title = input('Project name?:', default)
    else
        let t:title = a:name
    endif
endfunction "}}}
" }}}
" }}}
" vmap {{{
Map [v] <C-g> g<C-g>
" }}}
" map! {{{
Map [ic] <C-f> <Right>
Map [ic] <C-b> <Left>
Map [ic] <C-a> <Home>
Map [ic] <C-e> <End>
Map [ic] <C-d> <Del>

if 1

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

else

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
" call submode#enter_with('c', 'i', '', emap#compile_map('i', '<compl>j'), '<C-n>')
" call submode#enter_with('c', 'i', '', emap#compile_map('i', '<compl>k'), '<C-p>')
" call submode#leave_with('c', 'i', '', '<CR>')
" call submode#map       ('c', 'i', '', 'j', '<C-n>')
" call submode#map       ('c', 'i', '', 'k', '<C-p>')


Map [i] -expr <C-y> neocomplcache#close_popup()
Map [i] -expr <CR>  pumvisible() ? neocomplcache#close_popup() . "\<CR>" : "\<CR>"
Map [is] -remap <C-t> <Plug>(neocomplcache_snippets_expand)

" }}}
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

Map [c] <C-n> <Down>
Map [c] <C-p> <Up>

Map [c] <C-l> <C-d>

" Make / command comfortable {{{
function! s:cmdline_slash()
    let cmdtype = getcmdtype()
    if cmdtype ==# '/'
        return '\/'
    elseif cmdtype ==# ':'
        " When `wildmode=longest:full,full`,
        " escape 2nd "full" mode.
        " TODO: See the files in the directory.
        if getcmdline()[getcmdpos()-2] ==# '/'
            return "\<Space>\<BS>"
        endif
    endif
    return '/'
endfunction

" Map [c] -expr /  <SID>cmdline_slash()
Map [c] -expr ?  getcmdtype() == '?' ? '\?' : '?'
Map [c] -expr .  getcmdtype() =~# '[/?]' ? '\.' : '.'
" }}}
" }}}
" abbr {{{
Map [i] -expr -abbr  date@ strftime('%Y-%m-%d')
Map [i] -expr -abbr  time@ strftime("%H:%M")
Map [i] -expr -abbr  dt@   strftime("%Y-%m-%d %H:%M")
Map [ic] -expr -abbr mb@   [^\x01-\x7e]

MapAlterCommand th     tab help
MapAlterCommand t      tabedit
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

Map [n] -expr / <SID>expr_with_options('/', {'&ignorecase': 1, '&hlsearch': 1})
Map [n] -expr ? <SID>expr_with_options('?', {'&ignorecase': 1, '&hlsearch': 1})

Map [n] -expr * <SID>expr_with_options('*', {'&ignorecase': 0, '&hlsearch': 1})
Map [n] -expr # <SID>expr_with_options('#', {'&ignorecase': 0, '&hlsearch': 1})

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
Map [n] <F1> <Nop>
Map [n] ZZ <Nop>
Map [n] ZQ <Nop>
Map [n] U  <Nop>
" }}}
" Expand abbreviation {{{
" http://gist.github.com/347852
" http://gist.github.com/350207

DefMap [i] -expr bs-ctrl-] getline('.')[col('.') - 2]    ==# "\<C-]>" ? "\<BS>" : ''
DefMap [c] -expr bs-ctrl-] getcmdline()[getcmdpos() - 2] ==# "\<C-]>" ? "\<BS>" : ''
Map   [ic] -remap <C-]>     <C-]><bs-ctrl-]>
" }}}

" Mouse {{{

" TODO: Add frequently-used-commands to the top level of the menu.
" like MS Windows Office 2007 Ribborn interface.

" Do not adjust current scroll position (do not fire 'scrolloff') on single-click.
Map [n] -silent <LeftMouse>   <Esc>:set eventignore=all<CR><LeftMouse>:set eventignore=<CR>
" Double-click for searching the word under the cursor.
Map [n]         <2-LeftMouse> g*
" Single-click for searching the word selected in visual-mode.
Map [v] -remap  <LeftMouse> <Plug>(visualstar-g*)
" Select lines with <S-LeftMouse>
Map [n]         <S-LeftMouse> V

" }}}
" }}}
" Encoding {{{
let s:enc = 'utf-8'
let &enc = s:enc
let &fenc = s:enc
let &termencoding = s:enc
let &fileencodings = tyru#util#uniq_path(
\   [s:enc]
\   + split(&fileencodings, ',')
\   + ['iso-2022-jp', 'iso-2022-jp-3', 'cp932']
\)
unlet s:enc

set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif

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
            let dict_path = $MYVIMDIR . '/dict/' . ft . '.dict'
            if filereadable(dict_path)
                call add(dicts, dict_path)
            endif
        endfor
    endfor

    for d in dicts
        let &l:dictionary = join(tyru#util#uniq(dicts), ',')
    endfor
endfunction "}}}
function! s:set_tab_width() "{{{
    if tyru#util#has_one_of(['css', 'xml', 'html', 'lisp', 'scheme', 'yaml'], s:each_filetype())
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
" :DiffOrig {{{
" from vimrc_example.vim
"
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
" }}}
" :MTest {{{
"   convert Perl's regex to Vim's regex
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
" :Open {{{
command!
\   -nargs=? -complete=dir
\   Open
\   call s:Open(<f-args>)

function! s:Open(...) "{{{
    let dir =   a:0 == 1 ? a:1 : '.'

    if !isdirectory(dir)
        call tyru#util#warn(dir .': No such a directory')
        return
    endif

    if has('win32')
        " if dir =~ '[&()\[\]{}\^=;!+,`~ '. "']" && dir !~ '^".*"$'
        "     let dir = '"'. dir .'"'
        " endif
        call tyru#util#system('explorer', dir)
    else
        call tyru#util#system('gnome-open', dir)
    endif
endfunction "}}}
" }}}
" :Delete {{{

command!
\   -bar -bang -complete=file -nargs=+
\   Delete
\   call s:cmd_del_file([<f-args>], <bang>0)

function! s:cmd_del_file(args, delete_buffer) "{{{
    if empty(a:args)
        return
    endif

    for arg in a:args
        for file in split(expand(arg), '\n')
            let file = resolve(file)
            let bufnr = bufnr(file)

            " Delete the file.
            let type = getftype(file)
            if type ==# 'file'
                let success = 0
                if delete(file) !=# success
                    call tyru#util#warn("Can't delete '" . file . "'")
                    continue
                endif
            elseif type ==# 'dir'
                " TODO
            else
                redraw
                call tyru#util#warn(file . ": Unknown file type '" . type . "'.")
            endif

            " Delete the buffer.
            if a:delete_buffer && bufnr != -1
                if bufnr == bufnr('%')
                    enew
                endif
                execute bufnr 'bwipeout'
            endif
        endfor
    endfor

    checktime
endfunction "}}}
" }}}
" :Rename {{{
command!
\   -nargs=+ -complete=file
\   Rename
\   call s:cmd_rename(<f-args>)

function! s:cmd_rename(...) "{{{
    if a:0 == 1
        let [from, to] = [expand('%'), expand(a:1)]
    elseif a:0 == 2
        let [from, to] = [expand(a:1), expand(a:2)]
    else
        return
    endif
    if isdirectory(to)
        let to = to . '/' . fnamemodify(from, ':t')
    endif

    try
        call rename(from, to)
        if from !=# expand('%') && filereadable(to)
            execute 'edit' to
        endif
    catch
        Echomsg WarningMsg "Can't rename():" from "=>" to
    endtry
endfunction "}}}

MapAlterCommand mv Rename
MapAlterCommand ren[ame] Rename
" }}}
" :Mkdir {{{
function! s:mkdir_p(...)
    for i in a:000
        call mkdir(expand(i), 'p')
    endfor
endfunction

command! -bar -nargs=+ -complete=dir
\   Mkdir
\   call s:mkdir_p(<f-args>)

MapAlterCommand mkd[ir] Mkdir
" }}}
" :Mkcd {{{
command!
\   -bar -nargs=1 -complete=dir
\   Mkcd
\   silent! Mkdir <args> | CD <args>

MapAlterCommand mkc[d] Mkcd
" }}}
" :EchoPath - Show path-like option in a readable way {{{

MapAlterCommand epa EchoPath
MapAlterCommand rtp EchoPath<Space>&rtp


" TODO Add -complete=option
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
" :AllMaps - Do show/map in all modes. {{{
command!
\   -nargs=* -complete=mapping
\   AllMaps
\   map <args> | map! <args> | lmap <args>
" }}}
" :Expand {{{
command!
\   -nargs=?
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
\   echo globpath(&rtp, <q-args>)

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
" :TabpageLookupCD - Set t:cwd to root directory of project working tree {{{
Map [n] <Space>cd :<C-u>TabpageLookupCD %:p:h<CR>

command!
\   -bar -complete=dir -nargs=?
\   TabpageLookupCD
\   call s:cmd_tabpage_lookup_cd(<q-args>)

function! s:cmd_tabpage_lookup_cd(args) "{{{
    " Expand :cd like notation.
    let dir = expand(a:args != '' ? a:args : '.')
    " Get fullpath.
    let dir = fnamemodify(dir, ':p')
    if !isdirectory(dir)
        Echomsg WarningMsg "No such directory: " . dir
        return
    endif
    return s:lookup_repo(dir)
endfunction "}}}
function! s:is_root_project_dir(dir) "{{{
    return isdirectory(tyru#util#catfile(a:dir, '.git'))
endfunction "}}}
function! s:lookup_repo(dir) "{{{
    " Assert isdirectory(a:dir)

    let parent = tyru#util#dirname(a:dir)
    if a:dir ==# parent    " root
        Echomsg WarningMsg 'Not found project directory.'
        return
    elseif s:is_root_project_dir(a:dir)
        execute 'TabpageCD' a:dir
    else
        return s:lookup_repo(parent)
    endif
endfunction "}}}

" }}}
" :TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
MapAlterCommand cd  TabpageCD

Map [n] ,cd       :<C-u>TabpageCD %:p:h<CR>

command!
\   -bar -complete=dir -nargs=?
\   CD
\   TabpageCD <args>
command!
\   -bar -complete=dir -nargs=?
\   TabpageCD
\   execute 'cd' fnameescape(expand(<q-args>))
\   | let t:cwd = getcwd()

MyAutocmd TabEnter *
\   if exists('t:cwd') && !isdirectory(t:cwd)
\ |     unlet t:cwd
\ | endif
\ | if !exists('t:cwd')
\ |   let t:cwd = getcwd()
\ | endif
\ | execute 'cd' fnameescape(expand(t:cwd))
" }}}
" :Capture {{{
MapAlterCommand cap[ture] Capture

command!
\   -nargs=+ -complete=command
\   Capture
\   call s:cmd_capture(<q-args>)

function! s:cmd_capture(q_args) "{{{
    redir => output
    silent execute a:q_args
    redir END
    let output = substitute(output, '^\n\+', '', '')

    belowright new

    silent file `=printf('[Capture: %s]', a:q_args)`
    setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
    call setline(1, split(output, '\n'))
endfunction "}}}
" }}}
" :SynNames {{{
" :help synstack()

command!
\   -bar
\   SynNames
\
\     for id in synstack(line("."), col("."))
\   |     echo synIDattr(id, "name")
\   | endfor
\   | unlet! id
" }}}
" :Help {{{
MapAlterCommand h[elp]     Help

" No -bar
command!
\   -bang -nargs=* -complete=help
\   Help
\   vertical rightbelow help<bang> <args>
" }}}
" :SplitToLeft, :SplitToRight, :SplitToUp, :SplitToDown {{{
" Assumption: <args> does not contain :vertical,
" and does not change 'splitright', 'splitbelow'.

Map [n] -silent <SID>(split:to-down)
\   :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
Map [n] -silent <SID>(split:to-up)
\   :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
Map [n] -silent <SID>(split:to-left)
\   :<C-u>execute 'aboveleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
Map [n] -silent <SID>(split:to-right)
\   :<C-u>execute 'belowright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>

Map [n] -silent <SID>(new:to-down)
\   :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'new'<CR>
Map [n] -silent <SID>(new:to-up)
\   :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'new'<CR>
Map [n] -silent <SID>(new:to-left)
\   :<C-u>execute 'aboveleft'    (v:count == 0 ? '' : v:count) 'vnew'<CR>
Map [n] -silent <SID>(new:to-right)
\   :<C-u>execute 'belowright'   (v:count == 0 ? '' : v:count) 'vnew'<CR>


Map [n] -remap <excmd>sj <SID>(split:to-down)
Map [n] -remap <excmd>sk <SID>(split:to-up)
Map [n] -remap <excmd>sh <SID>(split:to-left)
Map [n] -remap <excmd>sl <SID>(split:to-right)

Map [n] -remap <excmd>ej <SID>(new:to-down)
Map [n] -remap <excmd>ek <SID>(new:to-up)
Map [n] -remap <excmd>eh <SID>(new:to-left)
Map [n] -remap <excmd>el <SID>(new:to-right)
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
\   -bar
\   Ctags
\   call s:cmd_ctags()

function! s:cmd_ctags() "{{{
    if !executable('ctags')
        return
    endif
    execute '!ctags' (filereadable('.ctags') ? '' : '-R')
endfunction "}}}
" }}}
" }}}
" For Plugins {{{
" nextfile {{{
let g:nf_map_next     = ''
let g:nf_map_previous = ''
Map [n] -remap ,n <Plug>(nextfile-next)
Map [n] -remap ,p <Plug>(nextfile-previous)

let g:nf_include_dotfiles = 1    " don't skip dotfiles
let g:nf_loop_files = 1    " loop at the end of file
let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']
" }}}
" starter {{{

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

" }}}
" vimtemplate {{{
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
let prompt_debug = 0
" }}}
" skk && eskk {{{

let s:skk_user_dict = '~/.skk/user-dict'
let s:skk_user_dict_encoding = 'utf-8'
let s:skk_system_dict = '~/.skk/system-dict'
let s:skk_system_dict_encoding = 'euc-jp'

if 1
" Map <C-j> to eskk, Map <C-g><C-j> to skk.vim {{{
let skk_control_j_key = '<C-g><C-j>'
" }}}
else
" Map <C-j> to skk.vim, Map <C-g><C-j> to eskk {{{
Map [ic] -remap <C-g><C-j> <Plug>(eskk:toggle)
" }}}
endif

" }}}
" skk {{{
let skk_jisyo = s:skk_user_dict
let skk_jisyo_encoding = s:skk_user_dict_encoding
let skk_large_jisyo = s:skk_system_dict
let skk_large_jisyo_encoding = s:skk_system_dict_encoding

" let skk_control_j_key = ''
" Arpeggio map! fj    <Plug>(skk-enable-im)

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
Map [ic] -remap <C-j><C-e> <Plug>(skk-enable-im)
Map [ic] -remap <C-j><C-d> <Nop>
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
if has('vim_starting')
    let g:eskk#dictionary = {
    \   'path': s:skk_user_dict,
    \   'encoding': s:skk_user_dict_encoding,
    \}
    let g:eskk#large_dictionary = {
    \   'path': s:skk_system_dict,
    \   'encoding': s:skk_system_dict_encoding,
    \}
endif


let g:eskk#egg_like_newline = 1
let g:eskk#egg_like_newline_completion = 1
let g:eskk#show_candidates_count = 2
let g:eskk#show_annotation = 1
let g:eskk#rom_input_style = 1 ? 'msime' : 'skk'
let g:eskk#keep_state = 1
let g:eskk#keep_state_beyond_buffer = 1

let g:eskk#marker_henkan = '$'
let g:eskk#marker_okuri = '*'
let g:eskk#marker_henkan_select = '@'
let g:eskk#marker_jisyo_touroku = '?'
let g:eskk#marker_popup = '#'

let g:eskk#dictionary_save_count = 5


" Disable "qkatakana". not ";katakanaq".
" EskkMap -type=mode:hira:toggle-kata <Nop>


if has('vim_starting')
    MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
    function! s:eskk_initial_pre() "{{{
        " User can be allowed to modify
        " eskk global variables (`g:eskk#...`)
        " until `User eskk-initialize-pre` event.
        " So user can do something heavy process here.
        " (I'm a paranoia, eskk#table#new() is not so heavy.
        " But it loads autoload/vice.vim recursively)
        let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
        call t.add_map('~', '〜')
        call t.add_map('zc', '©')
        call t.add_map('zr', '®')
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
        " call t.add_map('qe', 'é')
        call eskk#register_mode_table('hira', t)
    endfunction "}}}
endif

" MyAutocmd User eskk-initialize-post call s:eskk_initial_post()
" function! s:eskk_initial_post() "{{{
"     EskkMap -remap jj <Plug>(eskk:disable)<Esc>
" endfunction "}}}


" Experimental

" map! <C-j> <Plug>(eskk:enable)
" EskkMap <C-j> <Nop>
"
" EskkMap U <Plug>(eskk:undo-kakutei)



" Debug

command! -bar EskkDumpBuftable PP! eskk#get_buftable().dump()
command! -bar EskkDumpTable    PP! eskk#table#<args>#load()

" let g:eskk#cache_table_map = 0
"
" inoremap <C-g> hoge
"
" inoremap <C-l> <C-o><C-l>
"
" EskkMap lhs rhs
" EskkMap -silent lhs2 rhs
" EskkMap -unique lhs2 foo
" EskkMap -expr lhs3 {'foo': 'hoge'}.foo
" EskkMap -noremap lhs4 rhs

" }}}
" restart {{{
command!
\   -bar
\   RestartWithSession
\   let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
\   | Restart

MapAlterCommand res[tart] Restart
MapAlterCommand ers[tart] Restart
MapAlterCommand rse[tart] Restart
" }}}
" openbrowser {{{
let g:netrw_nogx = 1
Map [nv] -remap gx <Plug>(openbrowser-smart-search)
MapAlterCommand o[pen] OpenBrowserSmartSearch
" }}}
" AutoDate {{{
let g:autodate_format = "%Y-%m-%d"
" }}}
" anything (ku,fuf,unite,etc.) {{{
DefMacroMap [n] anything s

" Which anything do you like?
let [s:anything_fuf, s:anything_ku, s:anything_unite] = range(3)
let s:anything = s:anything_unite

if s:anything == s:anything_fuf
    Map [n] <anything>d        :<C-u>FufDir<CR>
    Map [n] <anything>f        :<C-u>FufFile<CR>
    Map [n] <anything>h        :<C-u>FufMruFile<CR>
    Map [n] <anything>r        :<C-u>FufRenewCache<CR>
elseif s:anything == s:anything_ku
    Map [n] <anything>f        :<C-u>Ku file<CR>
    Map [n] <anything>h        :<C-u>Ku file/mru<CR>
    Map [n] <anything>H        :<C-u>Ku history<CR>
    Map [n] <anything>:        :<C-u>Ku cmd_mru/cmd<CR>
    Map [n] <anything>/        :<C-u>Ku cmd_mru/search<CR>
elseif s:anything == s:anything_unite
    command! -nargs=* UniteKawaii Unite -prompt='-')/\  -no-split <args>
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
    let g:fuf_abbrevMap = abbrev
    " unite
    for [pat, subst_list] in items(abbrev)
        call unite#set_substitute_pattern('files', pat, subst_list)
    endfor
endfunction "}}}
Lazy call s:register_anything_abbrev()

" ku {{{
MapAlterCommand ku Ku
" }}}
" fuf {{{
let g:fuf_modesDisable = ['mrucmd', 'bookmark', 'givenfile', 'givendir', 'givencmd', 'callbackfile', 'callbackitem', 'buffer', 'tag', 'taggedfile']

let fuf_keyOpenTabpage = '<C-t>'
let fuf_keyNextMode    = '<C-l>'
let fuf_keyPrevMode    = '<C-h>'
let fuf_keyOpenSplit   = '<C-s>'
let fuf_keyOpenVsplit  = '<C-v>'
let fuf_enumeratingLimit = 20
let fuf_previewHeight = 0

" }}}
" unite {{{
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_enable_split_vertically = 1
let g:unite_update_time = 50
let g:unite_source_file_mru_ignore_pattern =
\   '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\|COMMIT_EDITMSG'

" unite-source-menu {{{

let s:Vital = vital#of('vital')
call s:Vital.load('Data.List')

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

Map [n] -silent <prompt>a  :<C-u>Unite menu:enc<CR>
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

Map [n] -silent <prompt>s  :<C-u>Unite menu:fenc<CR>
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

Map [n] -silent <prompt>d  :<C-u>Unite menu:ff<CR>
" }}}

" }}}



MyAutocmd FileType unite call s:unite_settings()

function! s:unite_settings() "{{{
    Map [i] -buffer -remap <BS> <Plug>(unite_delete_backward_path)
    Map [n] -buffer -remap <Space><Space> <Plug>(unite_toggle_mark_current_candidate)
    " Map <Plug>(unite_exit) to <Esc> with a small tweak.
    Map [n] -buffer -remap -expr <Esc> input('Exit unite?[y/N]:') =~? '^y\%[es]$' ? "\<Plug>(unite_exit)" : ''
endfunction "}}}
" }}}
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
" }}}
endif
" }}}
" vimshell {{{
MapAlterCommand sh[ell] VimShell

let g:vimshell_user_prompt = '"(" . getcwd() . ") --- (" . $USER . "@" . hostname() . ")"'
let g:vimshell_prompt = '$ '
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
let g:vimshell_ignore_case = 1
let g:vimshell_smart_case = 1
let g:vimshell_cd_command = 'CD'

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
    VimShellAlterCommand less less -r
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

    let less_sh = tyru#util#globpath(&rtp, 'macros/less.sh')
    if !empty(less_sh)
        call vimshell#altercmd#define('vless', less_sh[0])
    endif

    " Hook
    call vimshell#hook#set('chpwd', [s:SNR('vimshell_chpwd_ls')])
    call vimshell#hook#set('preexec', [s:SNR('vimshell_preexec_iexe')])
    " call vimshell#hook#set('preexec', [s:SNR('vimshell_preexec_less')])

    " Add/Remove some mappings.
    Map! [n] -buffer <C-n>
    Map! [n] -buffer <C-p>
    Map! [i] -buffer <Tab>
    Map [i] -remap -buffer -force <Tab><Tab> <Plug>(vimshell_command_complete)
    Map [n] -remap -buffer <C-z> <Plug>(vimshell_switch)
    Map [i] -remap -buffer <compl>r <Plug>(vimshell_history_complete_whole)

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
function! s:vimshell_preexec_iexe(cmdline, context) "{{{
    return s:vimshell_preexec_command(
    \   'iexe',
    \   [
    \       'termtter',
    \       'sudo',
    \       ['git', 'add', '-p'],
    \       ['git', 'log'],
    \       ['git', 'view'],
    \       'earthquake',
    \   ],
    \   a:cmdline,
    \   a:context,
    \)
endfunction "}}}
function! s:vimshell_preexec_less(cmdline, context) "{{{
    return s:vimshell_preexec_command(
    \   'less',
    \   [
    \       ['git', 'log'],
    \       ['git', 'view'],
    \   ],
    \   a:cmdline,
    \   a:context,
    \)
endfunction "}}}
function! s:vimshell_preexec_command(command, patlist, cmdline, context)
    let args = vimproc#parser#split_args(a:cmdline)
    if empty(args)
        return a:cmdline
    endif
    if args[0] ==# a:command
        return a:cmdline
    endif

    for i in a:patlist
        let list_match = type(i) == type([]) && i ==# args[:len(i)-1]
        let string_match = type(i) == type("") && args[0] ==# i
        if list_match || string_match
            return a:command . ' ' . a:cmdline
        endif
        unlet i
    endfor
    return a:cmdline
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
" }}}
" quickrun {{{
let g:loaded_quicklaunch = 1

let g:quickrun_no_default_key_mappings = 1
Map [nvo] -remap <Space>r <Plug>(quickrun)

if has('vim_starting')
    let g:quickrun_config = {}
    let g:quickrun_config['*'] = {'split': 'vertical rightbelow'}
    if executable('pandoc')
        let g:quickrun_config['markdown'] = {'command' : 'pandoc'}
    endif
    let g:quickrun_config['lisp'] = {
    \   'command': 'clisp',
    \   'eval': 1,
    \   'eval_template': '(print %s)',
    \}

    function! s:build_quickrun_config_cpp0x()
        if !executable('g++')
            return
        endif
        let g:quickrun_config['cpp0x'] = deepcopy(g:quickrun#default_config['cpp'])
        let g:quickrun_config['cpp0x'].command = 'g++ --std=c++0x'
    endfunction
    Lazy call s:build_quickrun_config_cpp0x()
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
" }}}
" ref {{{
" 'K' for ':Ref'.
MapAlterCommand ref         Ref
MapAlterCommand alc         Ref -new alc
MapAlterCommand rfc         Ref -new rfc
MapAlterCommand man         Ref -new man
MapAlterCommand pdoc        Ref -new perldoc
MapAlterCommand cppref      Ref -new cppref
MapAlterCommand cpp         Ref -new cppref
MapAlterCommand py[doc]     Ref -new pydoc

Map [n] <orig>K K

let g:ref_use_vimproc = 0
let g:ref_open = 'belowright vsplit'
if executable('perldocjp')
    let g:ref_perldoc_cmd = 'perldocjp'
endif
" }}}
" vimfiler {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_split_command = 'aboveleft split'
if executable('trash-put')
    let g:vimfiler_external_delete_command = 'trash-put $srcs'
endif

MyAutocmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings() "{{{
    Map [n] -remap -buffer L <Plug>(vimfiler_move_to_history_forward)
    Map [n] -remap -buffer H <Plug>(vimfiler_move_to_history_back)
    Map [n] -remap -buffer <C-o> <Plug>(vimfiler_move_to_history_back)
    Map [n] -remap -buffer <C-i> <Plug>(vimfiler_move_to_history_forward)

    " TODO
    " Map! [n] -buffer N j k
    Map! [n] -buffer N
    Map! [n] -buffer j
    Map! [n] -buffer k
    Map! [n] -buffer ?

    " dd as <Plug>(vimfiler_force_delete_file)
    " because I want to use trash-put.
    Map! [n] -buffer d
    Map [n] -buffer -remap dd <Plug>(vimfiler_force_delete_file)

    Map [n] -buffer -remap <Space><Space> <Plug>(vimfiler_toggle_mark_current_line)
endfunction "}}}
" }}}
" prettyprint {{{
MapAlterCommand pp PP

let g:prettyprint_show_expression = 1
" }}}
" fencview {{{
let g:fencview_auto_patterns = '*'
let g:fencview_show_progressbar = 0
" }}}
" lingr.vim {{{

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
        Map [n] -buffer -silent <C-l> :<C-u>call <SID>lingr_ctrl_l()<CR>
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
    Map [n] -buffer -remap o <Plug>(lingr-messages-show-say-buffer)
    Map [n] -buffer <C-g><C-n> gt
    Map [n] -buffer <C-g><C-p> gT
endfunction "}}}

MyAutocmd FileType lingr-say
\   call s:lingr_say_mappings()
function! s:lingr_say_mappings() "{{{
    Map [n] -buffer -remap <CR> <SID>(lingr-say-say)
endfunction "}}}

Map [n] -silent <SID>(lingr-say-say) :<C-u>call <SID>lingr_say_say()<CR>
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
" }}}
" chalice {{{
if !exists('g:chalice')
    call rtputil#remove('\<chalice\>')
endif
" }}}
" github {{{
MapAlterCommand gh Github
MapAlterCommand ghi Github issues
" }}}
" neocomplcache {{{
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_disable_caching_file_path_pattern = '.*'
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_auto_completion_start_length = 3

Map [n] <Leader>neo :<C-u>NeoComplCacheToggle<CR>

" http://d.hatena.ne.jp/basyura/20120318/p1
MyAutocmd InsertEnter * call s:neco_pre_cache()
function! s:neco_pre_cache()
    if exists('b:neco_pre_cache')
        return
    endif
    let b:neco_pre_cache = 1
    if bufname('%') =~ g:neocomplcache_lock_buffer_name_pattern
        return
    endif
    NeoComplCacheCachingBuffer
    NeoComplCacheCachingDictionary
endfunction
" }}}
" EasyGrep {{{
let g:EasyGrepCommand = 2
let g:EasyGrepInvertWholeWord = 1
" }}}
" gist {{{
let g:gist_detect_filetype = 1
" }}}
" quickey {{{
let g:quickey_merge_window_hide_vim_window_move_cursor = 1
let g:quickey_no_default_split_nicely_keymappings = 1
" }}}
" ohmygrep {{{
MapAlterCommand gr[ep] OMGrep
MapAlterCommand re[place] OMReplace

Map [n] -remap <Space>gw <Plug>(omg-grep-cword)
Map [n] -remap <Space>gW <Plug>(omg-grep-cWORD)
" }}}
" detect-coding-style {{{

MyAutocmd User dcs-initialized-styles call s:dcs_register_own_styles()
function! s:dcs_register_own_styles()
    call dcs#register_style('My style', {'hook_excmd': 'setlocal expandtab   tabstop=4 shiftwidth=4 softtabstop&'})
    call dcs#register_style('Short indent', {'hook_excmd': 'setlocal expandtab   tabstop=2 shiftwidth=2 softtabstop&'})
endfunction

" }}}
" autocmd-tabclose {{{
" :tabprevious on vimrc-tabclose
function! s:tabclose_post()
    if tabpagenr() != 1
        " XXX: Doing :tabprevious here cause Vim behavior strange
        " Decho ':tabprevious'
    endif
endfunction
MyAutocmd User tabclose-post call s:tabclose_post()
" }}}
" simpletap {{{
let g:simpletap#open_command = 'botright vnew'
" }}}
" fontzoom {{{
let loaded_fontzoom = 1
" }}}
" ftplugin/vim_fold.vim {{{
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
" }}}
" GraVit {{{
Map [nvo] -remap g/ <Plug>gravit->forward
Map [nvo] -remap g? <Plug>gravit->backward
" highlight GraVitCurrentMatch term=underline cterm=underline gui=underline ctermfg=4 guifg=Purple
" }}}
" hatena.vim {{{
let g:hatena_user = 'tyru'
let g:hatena_upload_on_write = 0
" }}}

" test
let g:loaded_tyru_event_test = 1

" runtime
" netrw {{{
function! s:filetype_netrw() "{{{
    Map [n] -buffer -remap h -
    Map [n] -buffer -remap l <CR>
    Map [n] -buffer -remap e <CR>
endfunction "}}}

MyAutocmd FileType netrw call s:filetype_netrw()
" }}}
" indent/vim.vim {{{
let g:vim_indent_cont = 0
" }}}
" changelog {{{
let changelog_username = "tyru"
" }}}
" syntax/sh.vim {{{
let g:is_bash = 1
" }}}
" syntax/scheme.vim {{{
let g:is_gauche = 1
" }}}
" syntax/perl.vim {{{

" POD highlighting
let g:perl_include_pod = 1
" Fold only sub, __END__, <<HEREDOC
let g:perl_fold = 1
let g:perl_nofold_packages = 1

" }}}

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
                call tyru#util#warn("can't delete " . i)
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
    command! -nargs=? WindowName call s:screen_set_window_name(<q-args>)

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
" }}}
" End. {{{


set secure
" }}}
