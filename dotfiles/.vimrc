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

function! s:is_win()
    return has('win16') || has('win32') || has('win64')
endfunction
if s:is_win()
    let s:vimdir = expand('~/vimfiles')
else
    let s:vimdir = expand('~/.vim')
endif
" }}}
" Utilities {{{
" Function {{{

function! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction "}}}
function! s:SNR(map) "{{{
    return printf("<SNR>%d_%s", s:SID(), a:map)
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
\   let [hl, msg] = parse_args#parse_one_arg_from_q_args(<q-args>)
\   | execute 'echohl' hl
\   | echomsg eval(msg)
\   | echohl None

" }}}
" }}}
" Options {{{

set all&

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

" fsync() is slow...
if has('unix')
    set nofsync
    set swapsync=
endif

" backup
set backup
let &backupdir = s:vimdir . '/backup'
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif

" title
set title
function! MyTitleString() "{{{
    if exists('t:cwd')
        return t:cwd . ' (tab)'
    elseif haslocaldir()
        return getcwd() . ' (local)'
    else
        return getcwd()
    endif
endfunction "}}}
let &titlestring = '%{MyTitleString()}'

" tab
set showtabline=2

nnoremap <C-t> :<C-u>SetProjectName<CR>
command! -bar -nargs=* SetProjectName call s:cmd_set_project_name(<q-args>)
function! s:cmd_set_project_name(name) "{{{
    if a:name == ''
        let default = exists('t:title') ? t:title : ''
        let t:title = input('Project name?:', default)
    else
        let t:title = a:name
    endif
endfunction "}}}

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
function! MyTabLine() "{{{
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
set tabline=%!MyTabLine()

function! MyGuiTabLabel() "{{{
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
set guitablabel=%!MyGuiTabLabel()

" statusline
set laststatus=2
function! MyStatusLine() "{{{
    let s = '%f%([%M%R%H%W]%)%(, %{&ft}%), %{&fenc}/%{&ff}'
    let s .= '%( ### '

    " eskk, skk.vim
    " let exists_eskk = exists('g:loaded_eskk')
    " let exists_skk  = exists('g:skk_loaded')
    " if exists_eskk
    "     let s .= ' %{eskk#statusline("IM:%s", "IM:off")}'
    " elseif exists_skk
    "     let s .= ' %{SkkGetModeStr()}'
    " endif

    " current-func-info
    let s .= '%{cfi#format("%s()", "none")}'

    let s .= ' ### +:%{b:changedtick}, u:%{changenr()}'
    let s .= '%)'

    return s
endfunction "}}}
set statusline=%!MyStatusLine()

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

" fold
set foldenable
" set foldmethod=marker

" :help undo-persistence
if has('persistent_undo')
    set undofile
    let &undodir = s:vimdir . '/info/undo'
    silent! call mkdir(&undodir, 'p')
endif

if has('&colorcolumn')
    set colorcolumn=+1
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
Lazy colorscheme tyru

" Open on read-only if swap exists
MyAutocmd SwapExists * let v:swapchoice = 'o'

MyAutocmd QuickfixCmdPost * QuickFix

" InsertLeave, InsertEnter
MyAutocmd InsertLeave * setlocal nocursorline
MyAutocmd InsertEnter * setlocal cursorline ignorecase

" Delete filetypedetect.
" mkd
Lazy autocmd! filetypedetect BufNewFile,BufRead *.md
Lazy autocmd filetypedetect BufNewFile,BufRead *.md setf markdown
" kscript
Lazy autocmd! filetypedetect BufNewFile,BufRead *.ks
Lazy autocmd filetypedetect BufNewFile,BufRead *.ks setf kirikiri

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

" Checking typo.
MyAutocmd BufWriteCmd *[,*] call s:write_check_typo(expand('<afile>'))
function! s:write_check_typo(file)
    let prompt = "possible typo: really want to write to '" . a:file . "'?(y/n):"
    if input(prompt) =~? '^y\(es\)\=$'
        execute 'write' a:file
    endif
endfunction

" }}}
" Initializing {{{

call pathogen#runtime_append_all_bundles()
command! -bar HelpTagsAll call pathogen#helptags()
HelpTagsAll


call emap#load()
call emap#set_sid(s:SID())
" call emap#set_sid_from_sfile(expand('<sfile>'))


let g:arpeggio_timeoutlen = 40
call arpeggio#load()


call altercmd#load()
command!
\   -bar -nargs=+
\   MyAlterCommand
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
" <prompt>
call s:map_prefix_key('nvo', 'prompt', ',t')
" <compl>
call s:map_prefix_key('i', 'compl', '<Tab>')
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
Map [nvo] -remap <operator>c <Plug>(operator-camelize)
Map [nvo] -remap <operator>C <Plug>(operator-decamelize)
let g:operator_camelize_all_uppercase_action = 'camelize'
let g:operator_decamelize_all_uppercase_action = 'lowercase'
" }}}
" operator-blank-killer {{{
call operator#user#define_ex_command('blank-killer', 's/\s\+$//')
Map [nvo] -remap <operator>bk <Plug>(operator-blank-killer)
" }}}
" operator-html-escape {{{
Map [nvo] -remap <operator>he <Plug>(operator-html-escape)
Map [nvo] -remap <operator>hu <Plug>(operator-html-unescape)
" }}}
" }}}
" motion {{{
Map [nvo] j gj
Map [nvo] k gk
call s:map_orig_key('nvo', 'j')
call s:map_orig_key('nvo', 'k')

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
Map [n] d<CR> :<C-u>call append(line('.'), '')<CR>j
Map [n] c<CR> :<C-u>call append(line('.'), '')<CR>jI

Map [n] <excmd>me :<C-u>messages<CR>
Map [n] <excmd>di :<C-u>display<CR>

Map [n] g; ~

Map [n] + <C-a>
Map [n] -- - <C-x>

Map [n] <excmd>sp :<C-u>Split<CR>

Map [n] r gR

Map [n] gl :<C-u>cnext<CR>
Map [n] gh :<C-u>cNext<CR>

Map [n] <excmd>ct :<C-u>tabclose<CR>

Map [n] gm :<C-u>make<CR>

" TODO: Smart 'zd': Delete empty line {{{
" }}}
" TODO: Smart '{', '}': Treat folds as one non-empty line. {{{
" }}}

" Execute most used command quickly {{{
Map [n] <excmd>ee     :<C-u>edit<CR>
Map [n] <excmd>w      :<C-u>write<CR>
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
if has('virtualedit') && tyru#util#has_one_of(['all', 'onemore'], split(&virtualedit, ','))
    DefMap [n] -expr $-if-right-of-$    col('.') >= col('$') ? '$' : ''
    DefMap [n]       Paste              P
    DefMap [n]       paste              p
    Map [n] -remap P <$-if-right-of-$><Paste>
    Map [n] -remap p <$-if-right-of-$><paste>

    " omake
    Map [n] <excmd>p $p
endif
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
Map [i] <C-r><C-u>  <C-r><C-o>+
Map [i] <C-r><C-i>  <C-r><C-o>*
Map [i] <C-r><C-o>  <C-r><C-o>"
Map [i] <C-r>       <C-r><C-r>

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
" call submode#enter_with('c', 'i', '', emap#compile_map('<compl>j', 'i'), '<C-n>')
" call submode#enter_with('c', 'i', '', emap#compile_map('<compl>k', 'i'), '<C-p>')
" call submode#leave_with('c', 'i', '', '<CR>')
" call submode#map       ('c', 'i', '', 'j', '<C-n>')
" call submode#map       ('c', 'i', '', 'k', '<C-p>')


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

" Make / command comfortable {{{
Map [c] -expr /  getcmdtype() == '/' ? '\/' : '/'
Map [c] -expr ?  getcmdtype() == '?' ? '\?' : '?'
Map [c] -expr .  getcmdtype() =~# '[/?]' ? '\.' : '.'
" }}}

Map [c] <C-n> <Down>
Map [c] <C-p> <Up>
" }}}
" abbr {{{
inoreab <expr> date@      strftime("%Y-%m-%d")
inoreab <expr> time@      strftime("%H:%M")
inoreab <expr> dt@        strftime("%Y-%m-%d %H:%M")

MyAlterCommand th     tab help
MyAlterCommand t      tabedit
MyAlterCommand sf     setf
MyAlterCommand hg     helpgrep
MyAlterCommand ds     diffsplit

" For typo.
MyAlterCommand qw     wq
MyAlterCommand amp    map
" }}}

" Mappings with option value. {{{
function! s:expr_with_options(cmd, opt) "{{{
    for [name, value] in items(a:opt)
        call setbufvar('%', name, value)
    endfor
    return a:cmd
endfunction "}}}

Map [n] -expr / <SID>expr_with_options('/', {'&ignorecase': 1, '&hlsearch': 0})
Map [n] -expr ? <SID>expr_with_options('?', {'&ignorecase': 1, '&hlsearch': 0})

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

" set enc=... {{{
function! s:change_encoding()
    if expand('%') == ''
        call tyru#util#warn("current file is empty.")
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
                \   'execute_if': '<f-value> != ""',
                \   'execute': 'edit ++enc=<value>'})
    if result !=# "\e"
        echomsg printf("re-open with '%s'.", result)
    endif
endfunction

Map [n] <prompt>a     :<C-u>call <SID>change_encoding()<CR>
" }}}
" set fenc=... {{{
function! s:change_fileencoding()
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
                \ 'execute_if': '<f-value> != ""',
                \ 'execute': 'set fenc=<value>'})
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

Map [n] <prompt>s    :<C-u>call <SID>change_fileencoding()<CR>
" }}}
" set ff=... {{{
function! s:change_newline_format()
    let result = prompt#prompt("changing newline format to...", {
                \ 'menu': ['dos', 'unix', 'mac'],
                \ 'one_char': 1,
                \ 'escape': 1,
                \ 'execute_if': '<f-value> != ""',
                \ 'execute': 'set ff=<value>'})
    if result !=# "\e"
        echomsg printf("changing newline format to '%s'.", result)
    endif
endfunction

Map [n] <prompt>d    :<C-u>call <SID>change_newline_format()<CR>
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
            let dict_path = expand(printf(s:vimdir . '/dict/%s.dict', ft))
            if filereadable(dict_path)
                call add(dicts, dict_path)
            endif
        endfor
    endfor

    " FIXME Use pathogen.vim!!
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
" :ListChars {{{
command!
\   -bar
\   ListChars
\   call s:cmd_list_chars()

function! s:cmd_list_chars() "{{{
    let lcs = prompt#prompt('changing &listchars to...', {
    \       'menu': [
    \           'tab:>-,extends:>,precedes:<,eol:.',
    \           'tab:>-',
    \           'tab:\ \ ',
    \       ],
    \       'one_char': 1,
    \       'escape': 1,
    \       'execute_if': '<f-value> != ""',
    \       'execute': 'set listchars=<value>'})
    if lcs !=# "\e"
        echomsg printf("changing &listchars to '%s'.", lcs)
    endif
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
\   -bar -complete=file -nargs=+
\   Delete
\   call s:cmd_del_file(<f-args>)

function! s:cmd_del_file(...) "{{{
    if !a:0
        return
    endif

    for arg in a:000
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
            if bufnr != -1
                if bufnr == bufnr('%')
                    enew
                endif
                execute bufnr 'bwipeout'
            endif
        endfor
    endfor
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

    let success = 0
    if rename(from, to) !=# success
        Echomsg WarningMsg "Can't rename():" from "=>" to
    endif
endfunction "}}}

MyAlterCommand mv Rename
MyAlterCommand ren[ame] Rename
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

MyAlterCommand mkd[ir] Mkdir
" }}}
" :Mkcd {{{
command!
\   -bar -nargs=1 -complete=dir
\   Mkcd
\   Mkdir <args> | CD <args>

MyAlterCommand mkc[d] Mkcd
" }}}
" :EchoPath - Show path-like option in a readable way {{{

MyAlterCommand epa EchoPath
MyAlterCommand rtp EchoPath<Space>&rtp


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
\   echo expand(<q-args> != '' ? <q-args> : '%:p')

MyAlterCommand ep Expand
" }}}
" :Has {{{
MyAlterCommand has Has

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

MyAlterCommand gp GlobPath
" }}}
" :QuickFix - Wrapper for favorite quickfix opening command {{{
" Select prefered command from cwindow, copen, and so on.

command!
\   -bar -nargs=?
\   QuickFix
\   if !empty(getqflist()) | cwindow <args> | endif

MyAlterCommand qf QuickFix
" }}}
" :TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
MyAlterCommand cd  TabpageCD

Map [n] ,cd       :<C-u>TabpageCD %:p:h<CR>
Map [n] <Space>cd :<C-u>lcd %:p:h<CR>

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
MyAlterCommand cap[ture] Capture

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
" :Split, :Help, :New - Open window vertically/horizontally {{{
MyAlterCommand sp[lit]    Split
MyAlterCommand h[elp]     Help
MyAlterCommand new        New

command!
\   -bar -bang -nargs=* -complete=file
\   Split
\   call s:split_nicely_with(['split', <f-args>], <bang>0)

command!
\   -bar -bang -nargs=* -complete=file
\   New
\   call s:split_nicely_with(['new', <f-args>], <bang>0)

" No -bar
command!
\   -bang -nargs=* -complete=help
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
        Echomsg ErrorMsg substitute(v:exception, '^Vim(\w\+):', '', '')
    endtry
endfunction "}}}
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
let g:starter_no_default_command = 1
nnoremap <silent> gt :<C-u>call starter#launch()<CR>

function! StarterAfterHookFile(path) "{{{
    if !filereadable(a:path)
        return
    endif

    " Open the file.
    execute 'edit' a:path

    " Set filetype.
    let filetype = fnamemodify(a:path, ':e')
    if filetype != ''
    \   && globpath(&rtp, 'ftplugin/' . filetype . '.vim') != ''
        execute 'setfiletype' filetype
    endif
endfunction "}}}
function! s:system_list(args_list) "{{{
    return system(join(
    \   map(copy(a:args_list), 'shellescape(v:val)')))
endfunction "}}}
function! StarterAfterHookDir(path) "{{{
    if !isdirectory(a:path)
        return
    endif

    if filereadable(a:path . '/setup')
        call s:system_list(a:path . '/setup', [a:path])
        call delete(a:path . '/setup')
    endif
    if filereadable(a:path . '/setup.sh')
        call s:system_list('/bin/sh', [a:path . '/setup.sh', a:path])
        call delete(a:path . '/setup.sh')
    endif
    if filereadable(a:path . '/setup.pl')
        call s:system_list('perl', [a:path . '/setup.pl', a:path])
        call delete(a:path . '/setup.pl')
    endif
    if filereadable(a:path . '/setup.py')
        call s:system_list('python', [a:path . '/setup.py', a:path])
        call delete(a:path . '/setup.py')
    endif
    if filereadable(a:path . '/setup.rb')
        call s:system_list('ruby', [a:path . '/setup.rb', a:path])
        call delete(a:path . '/setup.rb')
    endif
endfunction "}}}
let g:starter#after_hook = [
\   'StarterAfterHookFile',
\   'StarterAfterHookDir',
\]
" }}}
" vimtemplate {{{
let g:loaded_vimtemplate = 1

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

" Disable &modeline when opened template file.
execute
\   'MyAutocmd BufReadPre'
\   s:vimdir . '/template/*'
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
let loaded_dumbbuf = 1    " Use unite-buffer instead.

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

let s:skk_user_dict = '~/.skk/skk-user-dict'
let s:skk_system_dict = '~/.skk/skk-system-dict'

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

let skk_jisyo = s:skk_user_dict
let skk_large_jisyo = s:skk_system_dict

" let skk_control_j_key = ''
" Arpeggio map! fj    <Plug>(skk-enable-im)

let skk_manual_save_jisyo_keys = ''

let skk_egg_like_newline = 1
let skk_auto_save_jisyo = 1
let skk_imdisable_state = -1
let skk_keep_state = 1
let skk_show_candidates_count = 2
let skk_show_annotation = 0

" krogue++'s patch
let skk_sticky_key = ';'
let skk_use_color_cursor = 1

" My hacks
let skk_remap_lang_mode = 0


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
if has('vim_starting')
    let g:eskk#dictionary = {'path': s:skk_user_dict}
    let g:eskk#large_dictionary = {'path': s:skk_system_dict}

    let g:eskk#egg_like_newline = 1
    let g:eskk#show_candidates_count = 2
    let g:eskk#show_annotation = 1
    let g:eskk#rom_input_style = 'msime'
    let g:eskk#keep_state = 1
    let g:eskk#keep_state_beyond_buffer = 1

    let g:eskk#marker_henkan = '$'
    let g:eskk#marker_okuri = '*'
    let g:eskk#marker_henkan_select = '@'
    let g:eskk#marker_jisyo_touroku = '?'
    let g:eskk#marker_popup = '#'

    let g:eskk#convert_at_exact_match = 0


    " Disable "qkatakana". not ";katakanaq".
    " EskkMap -type=mode:hira:toggle-kata <Nop>


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
        call eskk#register_mode_table('hira', t)
    endfunction "}}}

    MyAutocmd User eskk-initialize-post call s:eskk_initial_post()
    function! s:eskk_initial_post() "{{{
        EskkMap -remap jj <Plug>(eskk:disable)<Esc>
    endfunction "}}}


    " Experimental.

    " map! <C-j> <Plug>(eskk:enable)
    " EskkMap <C-j> <Nop>
    "
    " inoremap <C-g> hoge
    "
    " inoremap <C-l> <C-o><C-l>
    "
    " EskkMap U <Plug>(eskk:undo-kakutei)

    " for test.
    "
    " EskkMap lhs rhs
    " EskkMap -silent lhs2 rhs
    " EskkMap -unique lhs2 foo
    " EskkMap -expr lhs3 {'foo': 'hoge'}.foo
    " EskkMap -noremap lhs4 rhs
endif
" }}}
" restart {{{
let g:restart_sessionoptions = 'blank,curdir,folds,help,localoptions,tabpages'
MyAlterCommand res[tart] Restart
MyAlterCommand ers[tart] Restart
MyAlterCommand rse[tart] Restart
" }}}
" openbrowser {{{
let g:netrw_nogx = 1
Map [nv] -remap gx <Plug>(openbrowser-open)
MyAlterCommand o[pen] OpenBrowser
" }}}
" AutoDate {{{
let g:autodate_format = "%Y-%m-%d"
" }}}
" anything (ku,fuf,unite,etc.) {{{
call s:map_prefix_key('n', 'anything', 's')

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
    Map [n] <anything>f        :<C-u>Unite -prompt='-')/\  -buffer-name=files file file_mru<CR>
    Map [n] <anything>F        :<C-u>Unite -prompt='-')/\  -buffer-name=files file_rec<CR>
    Map [n] <anything>t        :<C-u>Unite -prompt='-')/\  tab<CR>
    Map [n] <anything>T        :<C-u>Unite -prompt='-')/\  tags<CR>
    Map [n] <anything>h        :<C-u>Unite -prompt='-')/\  help<CR>
    Map [n] <anything>p        :<C-u>Unite -prompt='-')/\  -buffer-name=files buffer_tab<CR>
    Map [n] <anything>b        :<C-u>Unite -prompt='-')/\  buffer<CR>
endif


" abbrev
function! s:register_anything_abbrev() "{{{
    let abbrev = {
    \   '^r@': [$VIMRUNTIME . '/'],
    \   '^p@': map(split(&runtimepath, ','), 'v:val . "/plugin/"'),
    \   '^h@': ['~/'],
    \   '^v@' : [s:vimdir],
    \   '^g@' : ['~/git/'],
    \   '^d@' : ['~/git/dotfiles/'],
    \}

    if hostname() ==# 'server'
        call extend(abbrev, {
        \   '^m@' : ['~/Dropbox/memo/'],
        \   '^s@' : ['~/scratch/'],
        \})
    elseif hostname() ==# 'laptop'
        call extend(abbrev, {
        \   '^m@' : ['~/Dropbox/memo/'],
        \})
    elseif hostname() ==? 'takuya-win'
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
        if len(subst_list) == 1
            call unite#set_substitute_pattern('files', pat, subst_list[0])
        endif
    endfor
endfunction "}}}
Lazy call s:register_anything_abbrev()

" ku {{{
MyAlterCommand ku Ku
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
let g:unite_cd_command = 'TabpageCD'
let g:unite_lcd_command = 'TabpageCD'
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_enable_split_vertically = 1
let g:unite_update_time = 50
let g:unite_source_file_mru_ignore_pattern =
\   '^/tmp/.*\|^/var/tmp/.*\|\.tmp$\|COMMIT_EDITMSG'

MyAutocmd FileType unite call s:unite_settings()

function! s:unite_settings() "{{{
    Map [i] -remap -buffer <BS> <Plug>(unite_delete_backward_path)
    Map [n] -remap -buffer <Space><Space> <Plug>(unite_toggle_mark_current_candidate)
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
MyAlterCommand vsh[ell] VimShell

let g:vimshell_user_prompt = '"(" . getcwd() . ") --- (" . $USER . "@" . hostname() . ")"'
let g:vimshell_prompt = '$ '
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
let g:vimshell_ignore_case = 1
let g:vimshell_smart_case = 1

MyAutocmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings() "{{{
    " No -bar
    command!
    \   -buffer -nargs=+
    \   VimShellAlterCommand
    \   call vimshell#altercmd#define(
    \       parse_args#parse_one_arg_from_q_args(<q-args>)[0],
    \       parse_args#eat_n_args_from_q_args(<q-args>, 1)
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
    VimShellAlterCommand la ls -A
    VimShellAlterCommand less less -r
    VimShellAlterCommand sc screen
    VimShellAlterCommand whi which
    VimShellAlterCommand whe where
    VimShellAlterCommand go gopen
    VimShellAlterCommand termtter iexe termtter
    VimShellAlterCommand sudo iexe sudo

    " VimShellAlterCommand l. ls -d .*
    " VimShellAlterCommand l ls -lh
    call vimshell#set_alias('l.', 'ls -d .*')
    call vimshell#set_alias('l', 'ls -lh')

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
    function! s:chpwd_ls(args, context)
        call vimshell#execute('ls')
    endfunction
    call vimshell#hook#set('chpwd', [s:SNR('chpwd_ls')])

    " Add/Remove some mappings.
    Unmap [n] -buffer <C-n>
    Unmap [n] -buffer <C-p>
    Map [i] -buffer -force <C-p> <Space><Bar><Space>
    Unmap [i] -buffer <Tab>
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
    if executable('perl6')
        let g:quickrun_config['perl6'] = {
        \   'eval_template': join(['{%s}().perl.print'], ';')
        \}
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
MyAlterCommand ref Ref
MyAlterCommand alc Ref alc
MyAlterCommand man Ref man
MyAlterCommand pdoc Ref perldoc
MyAlterCommand cppref Ref cppref
MyAlterCommand cpp    Ref cppref
MyAlterCommand py[doc] Ref pydoc

call s:map_orig_key('n', 'K')

let g:ref_use_vimproc = 0
let g:ref_open = 'Split'
if executable('perldocjp')
    let g:ref_perldoc_cmd = 'perldocjp'
endif
" }}}
" vimfiler {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_split_command = 'Split'
let g:vimfiler_edit_command = 'edit'
let g:vimfiler_change_vim_cwd = 0

MyAutocmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings() "{{{
    Map [n] -remap -buffer L <Plug>(vimfiler_move_to_history_forward)
    Map [n] -remap -buffer H <Plug>(vimfiler_move_to_history_back)
    Unmap [n] -buffer N
    Map [n] -remap -buffer <C-o> <Plug>(vimfiler_move_to_history_back)
    Map [n] -remap -buffer <C-i> <Plug>(vimfiler_move_to_history_forward)
endfunction "}}}
" }}}
" prettyprint {{{
MyAlterCommand pp PP

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
    " deactivate lingr.vim if there was not g:lingr variable.
    " this is set in .zshrc/.bashrc like the following:
    "   alias lingr="vim --cmd 'let g:lingr = 1' -c LingrLaunch"
    let g:loaded_lingr_vim = 1
endif

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
" }}}


MyAutocmd FileType lingr-messages
\   Map [n] -buffer -remap o <Plug>(lingr-messages-show-say-buffer)


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
\]

let g:lingr_vim_rooms_buffer_height = len(g:lingr_vim_additional_rooms) + 3

let g:lingr_vim_count_unread_at_current_room = 1
" }}}
" github {{{
MyAlterCommand gh Github
let g:github#use_vimproc = 0
" }}}
" neocomplcache {{{
let g:neocomplcache_enable_at_startup = 0
let g:neocomplcache_disable_caching_buffer_name_pattern = '.*'
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_quick_match = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_plugin_disable = {}
for s:source in map(tyru#util#globpath(&rtp, 'autoload/neocomplcache/sources/*'), 'fnamemodify(v:val, ":t:r")')
    let g:neocomplcache_plugin_disable[s:source] = 1
endfor
unlet! s:source

Map [n] <Leader>neo :<C-u>NeoComplCacheToggle<CR>
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
" }}}
" ohmygrep {{{
MyAlterCommand gr[ep] OMGrep

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
" whichedit {{{
MyAlterCommand we WhichEdit
" }}}
" autocmd-tabclose {{{
" :tabprevious on vimrc-tabclose
function! s:tabclose_post()
    if tabpagenr() != 1
        Decho ':tabprevious'
        " tabprevious
    endif
endfunction
MyAutocmd User tabclose-post call s:tabclose_post()
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

    function! s:screen_set_window_name(name) "{{{2
        let esc = "\<ESC>"
        silent! execute '!echo -n "' . esc . 'k' . escape(a:name, '%#!')
        \ . esc . '\\"'
        redraw!
    endfunction
    command! -nargs=? WindowName call s:screen_set_window_name(<q-args>)

    function! s:screen_auto_window_name()  " {{{2
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
    augroup vimrc-screen
        autocmd!
        autocmd VimEnter * call s:screen_set_window_name(0 < argc() ?
        \ 'vim:' . fnamemodify(argv(0), ':t') : 'vim')
        autocmd BufEnter,BufFilePost * call s:screen_auto_window_name()
        autocmd VimLeave * call s:screen_set_window_name(len($SHELL) ?
        \ fnamemodify($SHELL, ':t') : 'shell')
    augroup END
endif
" }}}
" }}}
" End. {{{


set secure
" }}}
