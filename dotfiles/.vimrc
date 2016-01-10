" Don't set scriptencoding before 'encoding' option is set!
" scriptencoding utf-8

" vim:set et fen fdm=marker:

" See also: ~/.vimrc or ~/_vimrc


let s:is_win = has('win16') || has('win32') || has('win64') || has('win95')
if s:is_win
    let $MYVIMDIR = expand('~/vimfiles')
else
    let $MYVIMDIR = expand('~/.vim')
endif

" Use plain vim when vim was invoked by 'sudo' command.
if exists('$SUDO_USER')
    finish
endif

if !exists('$VIMRC_USE_VIMPROC')
    " 0: vimproc disabled
    " 1: vimproc enabled
    " 2: each plugin default(auto)
    let $VIMRC_USE_VIMPROC = 1
endif
if !exists('$VIMRC_FORCE_LANG_C')
    let $VIMRC_FORCE_LANG_C = 0
endif
if !exists('$VIMRC_LOAD_MENU')
    let $VIMRC_LOAD_MENU = 1
endif


" Basic {{{

" Reset all options
set all&

" Reset auto-commands
augroup vimrc
    autocmd!
augroup END


" TODO Clear mappings mapped only in vimrc, but plugin mappings.
" mapclear
" mapclear!
" " mapclear!!!!
" lmapclear


if $VIMRC_FORCE_LANG_C
    language messages C
    language time C
endif

if $VIMRC_LOAD_MENU
    " Load current locale and &encoding menu.
    set guioptions+=m
else
    set guioptions+=M
    let did_install_default_menus = 1
    let did_install_syntax_menu = 1
endif

filetype plugin indent on

if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
endif

" }}}
" Utilities {{{

" Function {{{

function! s:SID() "{{{
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction "}}}
let s:SNR_PREFIX = '<SNR>' . s:SID() . '_'
function! s:SNR(map) "{{{
    return s:SNR_PREFIX . a:map
endfunction "}}}

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
function! s:error(msg) "{{{
    call s:echomsg('ErrorMsg', a:msg)
endfunction "}}}


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
    return v:version >=# 703
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

" }}}

" Commands {{{

" :autocmd is listed in |:bar|
command! -bang -nargs=* VimrcAutocmd autocmd<bang> vimrc <args>


command!
\   -nargs=+
\   Lazy
\   call s:cmd_lazy(<q-args>)

function! s:cmd_lazy(q_args) "{{{
    if a:q_args == ''
        return
    endif
    if has('vim_starting')
        execute 'VimrcAutocmd VimEnter *' a:q_args
    else
        execute a:q_args
    endif
endfunction "}}}

" }}}

" }}}
" Encoding {{{
let s:enc = 'utf-8'

let &enc = s:enc
let &fenc = s:enc
let &termencoding = s:enc
let s:fencs = [s:enc] + split(&fileencodings, ',') + ['iso-2022-jp', 'iso-2022-jp-3', 'cp932']
let &fileencodings = join(filter(s:fencs, 'count(s:fencs, v:val) == 1'), ',')

unlet s:fencs
unlet s:enc

scriptencoding utf-8

set fileformats=unix,dos,mac
if exists('&ambiwidth')
    set ambiwidth=double
endif

" }}}
" Load Plugins {{{

set rtp+=$MYVIMDIR/bundle/vivacious.vim

" Fetch managed plugins from remote.
call vivacious#fetch_all()

" Add managed plugins to 'runtimepath'.
" (It won't load disabled plugins)
filetype off
call vivacious#load_plugins()
filetype plugin indent on

" Import emap.vim & altercmd.vim commands {{{
" I use those commands also in bundleconfig.
" So define those commands before loading bundleconfig.

" Define :Map commands
call emap#load('noprefix')
" call emap#set_sid_from_vimrc()
" call emap#set_sid(s:SID())
call emap#set_sid_from_sfile(expand('<sfile>'))


" Define :MapAlterCommand commands
call altercmd#load()
command!
\   -bar -nargs=+
\   MapAlterCommand
\   CAlterCommand <args> | AlterCommand <cmdwin> <args>


" Set up general prefix keys. {{{

DefMacroMap [nxo] orig <C-q>
Map [n] <orig><orig> <orig>
DefMacroMap [ic] orig <C-g><C-q>

DefMacroMap [nxo] excmd <Space>
DefMacroMap [nxo] operator ;

let g:mapleader = ';'
Map [n] <Leader> <Nop>

Map [n] ;; ;
Map [n] ,, ,

let g:maplocalleader = '\'
Map [n] <LocalLeader> <Nop>

" }}}

" }}}

" Load all bundle configs in '~/.vim/bundleconfig/*.vim' (if you prefer).
" This function loads plugin list from 'runtimepath'.
call vivacious#bundleconfig#load()

" TODO: Load only vim-singleton and call it before 'vivacious#load_plugins()'.
call singleton#enable()

" Generate helptags for plugins in 'runtimepath'.
call vivacious#helptags()

" Load vimrc vital. {{{

let s:Vital = vital#of('vimrc')
let s:Prelude = s:Vital.import('Prelude')
let s:List = s:Vital.import('Data.List')
let s:Filepath = s:Vital.import('System.Filepath')
let s:File = s:Vital.import('System.File')
unlet s:Vital

" }}}

" }}}
" Options {{{

" indent
set autoindent
set expandtab
set smarttab
set shiftround
set copyindent
set preserveindent
if exists('+breakindent')
    set breakindent
endif

" Follow 'tabstop' value.
set tabstop=4
" 7.3.629 or later
set shiftwidth=0
" 7.3.693 or later
set softtabstop=-1

" search
set hlsearch
set incsearch
set smartcase

" Aesthetic options
set list
" Assumption: Trailing spaces are already highlighted and noticeable.
" set listchars=tab:>.,extends:>,precedes:<,eol:$
set listchars=tab:>.,extends:>,precedes:<
set display=lastline
set t_Co=256
set cursorline

" scroll
set scroll=5
set scrolloff=0
" set scrolloff=9999

" mouse
set mouse=a
set mousehide
set mousemodel=popup_setpos

" command-line
set cmdheight=1
set wildmenu
set wildmode=longest,list

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

" virtualedit
if has('virtualedit')
    set virtualedit=all
endif

" Swapfile
if 0
    " Use swapfile.
    set swapfile
    " Open a file as read-only if swap exists
    " VimrcAutocmd SwapExists * let v:swapchoice = 'o'
else
    " No swapfile.
    set noswapfile
    set updatecount=0
endif

" backup (:help backup-table)
set backup
set backupcopy=yes
set backupdir=$MYVIMDIR/backup
silent! call mkdir(&backupdir, 'p')

" title
set title
let &titlestring = '%{getcwd()}'

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
    let bufname = ''
    let modified = 0
    if type(buflist) ==# 3
        let bufname = bufname(buflist[tabpagewinnr(a:tabnr) - 1])
        let bufname = fnamemodify(bufname, ':t')
        " let bufname = pathshorten(bufname)
        for bufnr in buflist
            if getbufvar(bufnr, '&modified')
                let modified = 1
                break
            endif
        endfor
    endif

    if bufname == ''
        let label = '[No Name]'
    else
        let label = bufname
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
let &tabline = s:tabline()

let &guitablabel = '%{MyTabLabel(v:lnum)}'

" statusline
set laststatus=2
function! s:statusline() "{{{
    let s = '%f%([%M%R%H%W]%)%(, %{&ft}%), %{&fenc}/%{&ff}'
    let s .= '%('

    " NOTE: calling GetCCharAndHex() destroys also unnamed register. it may be the problem of Vim.
    " let s .= '%( | [%{GetCCharAndHex()}]%)'

    let s .= '%( | %{GetDocumentPosition()}%)'

    let s .= '%)'

    return s
endfunction "}}}
let &statusline = s:statusline()

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

" 'guioptions' flags are set on FocusGained
" because "cmd.exe start /min" doesn't work.
" (always start up as foreground)
augroup vimrc-guioptions
    autocmd!
augroup END
if has('vim_starting')
    command! -nargs=* AutocmdWhenVimStarting    autocmd vimrc-guioptions FocusGained * <args>
    command! -nargs=* AutocmdWhenVimStartingEnd autocmd vimrc-guioptions FocusGained * autocmd! vimrc-guioptions
else
    command! -nargs=* AutocmdWhenVimStarting    <args>
    command! -nargs=* AutocmdWhenVimStartingEnd :
endif

" Must be set in .vimrc
" set guioptions+=p
AutocmdWhenVimStarting set guioptions-=a
AutocmdWhenVimStarting set guioptions+=A
" Include 'e': tabline
" Otherwise  : guitablabel
" AutocmdWhenVimStarting set guioptions-=e
AutocmdWhenVimStarting set guioptions+=h
AutocmdWhenVimStarting set guioptions+=m
AutocmdWhenVimStarting set guioptions-=L
AutocmdWhenVimStarting set guioptions-=T
AutocmdWhenVimStartingEnd

delcommand AutocmdWhenVimStarting
delcommand AutocmdWhenVimStartingEnd

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
set fillchars=stl:\ ,stlnc::,vert:\ ,fold:-,diff:-

" cursor behavior in insertmode
set whichwrap=b,s
set backspace=indent,eol,start
set formatoptions=mMcroqnl2
" 7.3.541 or later
set formatoptions+=j

" undo-persistence
if has('persistent_undo')
    set undofile
    let &undodir = $MYVIMDIR . '/info/undo'
    silent! call mkdir(&undodir, 'p')
endif

if has('conceal')
    set concealcursor=nvic
endif

if version >=# 704
    set regexpengine=2
endif

" For screen.
if &term =~ "^screen"
    VimrcAutocmd VimLeave * :set mouse=

    " workaround for freeze when using mouse on GNU screen.
    set ttymouse=xterm2
endif


set browsedir=current

" Font {{{
if has('gui_running')
    if s:is_win
        if exists('+renderoptions')
            " If 'renderoptions' option exists,
            set renderoptions=type:directx,renmode:5
            " ... and if "Ricty_Diminished" font is installed,
            " enable DirectWrite.
            try
            set gfn=Ricty_Diminished_Discord:h14:cSHIFTJIS
            catch | endtry
        endif
    elseif has('mac')    " Mac
        set guifont=Osaka－等幅:h14
        set printfont=Osaka－等幅:h14
    else    " *nix OS
        try
            set guifont=Monospace\ 12
            set printfont=Monospace\ 12
            set linespace=0
        catch
            set guifont=Monospace\ 12
            set printfont=Monospace\ 12
            set linespace=4
        endtry
    endif
endif
" }}}

" misc.
set diffopt=filler,vertical
set history=50
set keywordprg=
" set lazyredraw
set nojoinspaces
set showcmd
set nrformats=hex
set shortmess=aI
set switchbuf=useopen,usetab
set textwidth=78
set colorcolumn=80
set viminfo='50,h,f1,n$HOME/.viminfo
set matchpairs+=<:>
set number
set showbreak=...
set confirm
set updatetime=500
if has('path_extra')
    set path+=.;
endif
" }}}
" ColorScheme {{{

" NOTE: On MS Windows, setting colorscheme in .vimrc does not work.
" Thus :Lazy is necessary.
" NOTE: `:Lazy colorscheme tyru` does not throw ColorScheme event, what the fxck?
Lazy colorscheme no_quarter | doautocmd ColorScheme

" }}}
" Mappings, Abbreviations {{{

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


" map {{{
" operator {{{

" Copy to clipboard or primary.
Map [nxo] <operator>y     "+y
Map [nxo] <operator>Y     "*y

" Do not destroy noname register.
Map [nxo] x "_x

Map [nxo] <operator>e =

" }}}
" textobj {{{

Map [o] gv :<C-u>normal! gv<CR>

" }}}
" motion {{{
" If [count] was specified, use 'j'.
" Otherwise, use 'gj'.
Map -expr [nxo] j v:count == 0 ? 'gj' : 'j'
Map -expr [nxo] k v:count == 0 ? 'gk' : 'k'
Map [nxo] <orig>j j
Map [nxo] <orig>k k

" FIXME: Does not work in visual mode.
Map [n] ]k :<C-u>call search('^\S', 'Ws')<CR>
Map [n] [k :<C-u>call search('^\S', 'Wsb')<CR>

Map [nxo] gp %

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

Map [n] <excmd>me :<C-u>messages<CR>
Map [n] <excmd>di :<C-u>display<CR>

Map [n] gl :<C-u>cnext<CR>
Map [n] gh :<C-u>cNext<CR>

Map [n] <excmd>ct :<C-u>tabclose<CR>

Map [n] <excmd>tl :<C-u>tabedit<CR>
Map [n] <excmd>th :<C-u>tabedit<CR>:execute 'tabmove' (tabpagenr() isnot 1 ? tabpagenr() - 2 : '')<CR>

if has('gui_running')
    Map -script [i] <C-s> <SID>(gui-save)<Esc>
    Map -script [n] <C-s> <SID>(gui-save)
    Map -script [i] <SID>(gui-save) <C-o><SID>(gui-save)
    Map         [n] <SID>(gui-save) :<C-u>call <SID>gui_save()<CR>
    function! s:gui_save()
        if bufname('%') ==# ''
            browse confirm saveas
        else
            update
        endif
    endfunction
endif

Map -expr -silent [n] f <SID>search_char('/\V%s'."\<CR>:nohlsearch\<CR>")
Map -expr -silent [n] F <SID>search_char('?\V%s'."\<CR>:nohlsearch\<CR>")
Map -expr -silent [n] t <SID>search_char('/.\ze\V%s'."\<CR>:nohlsearch\<CR>")
Map -expr -silent [n] T <SID>search_char('?\V%s\v\zs.'."\<CR>:nohlsearch\<CR>")

function! s:search_char(cmdfmt)
    let char = s:Prelude.getchar_safe()
    return char ==# "\<Esc>" ? '' : printf(a:cmdfmt, char)
endfunction


Map [nxo] H ^
Map [nxo] L $

" See also rooter.vim settings.
Map [n] ,cd       :<C-u>cd %:p:h<CR>

" 'Y' to yank till the end of line.
Map [n] Y    y$

" Moving tabs
Map -silent [n] <Left>    :<C-u>-tabmove<CR>
Map -silent [n] <Right>   :<C-u>+tabmove<CR>

" Execute most used command quickly {{{
Map [n] <excmd>w      :<C-u>update<CR>
Map -silent [n] <excmd>q      :<C-u>call <SID>vim_never_die_close()<CR>

function! s:vim_never_die_close()
    try
        close
    catch
        if !&modified
            bwipeout!
        endif
    endtry
endfunction
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
    Map -buffer -silent [n]  <Esc>         :<C-u>quit<CR>
    Map -buffer -silent [n]  <C-w>k        :<C-u>quit<CR>
    Map -buffer -silent [n]  <C-w><C-k>    :<C-u>quit<CR>

    startinsert!
endfunction
VimrcAutocmd CmdwinEnter * call s:cmdwin_enter()

Map [n] <excmd>: q:
Map [n] <excmd>/ q/
Map [n] <excmd>? q?
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

function! s:toggle_option_list(state, optname) "{{{
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

Map [n] <excmd>oh  :<C-u>call <SID>toggle_option('hlsearch')<CR>
Map [n] <excmd>oi  :<C-u>call <SID>toggle_option('ignorecase')<CR>
Map [n] <excmd>op  :<C-u>call <SID>toggle_option('paste')<CR>
Map [n] <excmd>ow  :<C-u>call <SID>toggle_option('wrap')<CR>
Map [n] <excmd>oe  :<C-u>call <SID>toggle_option('expandtab')<CR>
Map [n] <excmd>ol  :<C-u>call <SID>toggle_option('list')<CR>
Map [n] <excmd>on  :<C-u>call <SID>toggle_option('number')<CR>
Map [n] <excmd>om  :<C-u>call <SID>toggle_option('modeline')<CR>
Map [n] <excmd>ofc :<C-u>call <SID>toggle_option_list(['', 'all'], 'foldclose')<CR>
Map [n] <excmd>ofm :<C-u>call <SID>toggle_option_list(['manual', 'marker', 'indent'], 'foldmethod')<CR>
Map [n] <excmd>ofw :<C-u>call <SID>toggle_winfix()<CR>

" }}}
" Close help/quickfix window {{{

" s:window {{{
let s:window = {'_group_order': [], '_groups': {}}

function! s:window.register(group_name, functions) "{{{
    call add(s:window._group_order, a:group_name)
    let s:window._groups[a:group_name] = a:functions
endfunction "}}}

function! s:window.get_all_groups() "{{{
    return map(copy(s:window._group_order),
    \         'deepcopy(s:window._groups[v:val])')
endfunction "}}}


function! s:window.close(winnr) "{{{
    if winbufnr(a:winnr) !=# -1
        execute a:winnr . 'wincmd w'
        execute 'wincmd c'
        return 1
    else
        return 0
    endif
endfunction "}}}


function! s:window.get_winnr_list_like(expr) "{{{
    let ret = []
    for winnr in range(1, winnr('$'))
        if eval(a:expr)
            call add(ret, winnr)
        endif
    endfor
    return ret
endfunction "}}}

function! s:window.close_first_like(expr) "{{{
    let winnr_list = s:window.get_winnr_list_like(a:expr)
    " Close current window if current matches a:expr.
    let winnr_list = s:move_current_winnr_to_head(winnr_list)
    if empty(winnr_list)
        return
    endif

    let prev_winnr = winnr()
    try
        for winnr in winnr_list
            if s:window.close(winnr)
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

function! s:move_current_winnr_to_head(winnr_list) "{{{
    let winnr = winnr()
    if index(a:winnr_list, winnr) is -1
        return a:winnr_list
    endif
    return [winnr] + filter(a:winnr_list, 'v:val isnot winnr')
endfunction "}}}

" }}}

" help {{{
function! s:close_help_window() "{{{
    return s:window.close_first_like('s:is_help_window(winnr)')
endfunction "}}}
function! s:is_help_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'help'
endfunction "}}}

call s:window.register('help', {'close': function('s:close_help_window'), 'detect': function('s:is_help_window')})
" }}}

" quickfix {{{
function! s:close_quickfix_window() "{{{
    " cclose
    return s:window.close_first_like('s:is_quickfix_window(winnr)')
endfunction "}}}
function! s:is_quickfix_window(winnr) "{{{
    return getbufvar(winbufnr(a:winnr), '&buftype') ==# 'quickfix'
endfunction "}}}

call s:window.register('quickfix', {'close': function('s:close_quickfix_window'), 'detect': function('s:is_quickfix_window')})
" }}}

" unlisted {{{
function! s:close_unlisted_window() "{{{
    return s:window.close_first_like('s:is_unlisted_window(winnr)')
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


Map -silent [n] <excmd>ch :<C-u>call <SID>close_help_window()<CR>
Map -silent [n] <excmd>cq :<C-u>call <SID>close_quickfix_window()<CR>
Map -silent [n] <excmd>cu :<C-u>call <SID>close_unlisted_window()<CR>

" Close first matching window in above windows.
Map -silent [n] <excmd>cc :<C-u>call <SID>close_certain_window()<CR>
" }}}
" Back to col '$' when current col is right of col '$'. {{{
"
" 1. move to the last col
" when over the last col ('virtualedit') and getregtype(v:register) ==# 'v'.
" 2. do not insert " " before inserted text
" when characterwise and getregtype(v:register) ==# 'v'.

function! s:paste_characterwise_nicely()
    let reg = '"' . v:register
    let virtualedit_enabled =
    \   has('virtualedit') && &virtualedit =~# '\<all\>\|\<onemore\>'
    let move_to_last_col =
    \   (virtualedit_enabled && col('.') >= col('$'))
    \   ? '$' : ''
    let paste =
    \   reg . (getline('.') ==# '' ? 'P' : 'p')
    return getregtype(v:register) ==# 'v' ?
    \   move_to_last_col . paste :
    \   reg . 'p'
endfunction

Map -expr [n] p <SID>paste_characterwise_nicely()
" }}}
" <Space>[hjkl] for <C-w>[hjkl], <Space><Space>[hjkl] for <C-w>[HJKL] {{{
Map -silent [n] <Space>j <C-w>j
Map -silent [n] <Space>k <C-w>k
Map -silent [n] <Space>h <C-w>h
Map -silent [n] <Space>l <C-w>l
Map -silent [n] <Space>n <C-w>w
Map -silent [n] <Space>p <C-w>W

Map -silent [n] <Space><Space>j <C-w>J
Map -silent [n] <Space><Space>k <C-w>K
Map -silent [n] <Space><Space>h <C-w>H
Map -silent [n] <Space><Space>l <C-w>L
" }}}
" Moving between tabs {{{
Map -silent [n] <C-n> gt
Map -silent [n] <C-p> gT
" }}}
" "Use one tabpage per project" project {{{
" :SetTabName - Set tab's title {{{

Map -silent [n] g<C-t> :<C-u>SetTabName<CR>
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

function! s:map_lines(str, expr)
    return join(map(split(a:str, '\n', 1), a:expr), "\n")
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


" Tab key indent
" NOTE: <S-Tab> is GUI only.
Map [x] <Tab> >gv
Map [x] <S-Tab> <gv

" Space key indent (inspired by sakura editor)
Map [x] <Space><Space> <Esc>:call <SID>space_indent(0)<CR>gv
Map [x] <Space><BS> <Esc>:call <SID>space_indent(1)<CR>gv
Map -remap [x] <Space><S-Space> <Space><BS>

function! s:space_indent(leftward)
    let save = [&l:expandtab, &l:shiftwidth]
    setlocal expandtab shiftwidth=1
    execute 'normal!' (a:leftward ? 'gv<<' : 'gv>>')
    let [&l:expandtab, &l:shiftwidth] = save
endfunction

" }}}
" map! {{{
Map [ic] <C-f> <Right>
Map -expr [i] <C-b> col('.') ==# 1 ? "\<C-o>k\<End>" : "\<Left>"
Map [c] <C-b> <Left>
Map [ic] <C-a> <Home>
Map [ic] <C-e> <End>
Map [i] <C-d> <Del>
Map -expr [c] <C-d> getcmdpos()-1<len(getcmdline()) ? "\<Del>" : ""
" Emacs like kill-line.
Map -expr [i] <C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
Map [c] <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

" }}}
" imap {{{

" shift left (indent)
Map [i] <C-q>   <C-d>

" make <C-w> and <C-u> undoable.
" NOTE: <C-u> may be already mapped by $VIMRUNTIME/vimrc_example.vim
Map [i] <C-w> <C-g>u<C-w>
Map -force [i] <C-u> <C-g>u<C-u>

" completion {{{

DefMacroMap [i] compl <C-l>

Map [i] <compl><C-n> <C-x><C-n>
Map [i] <compl><C-p> <C-x><C-p>
Map [i] <compl><C-]> <C-x><C-]>
Map [i] <compl><C-d> <C-x><C-d>
Map [i] <compl><C-f> <C-x><C-f>
Map [i] <compl><C-i> <C-x><C-i>
Map [i] <compl><C-k> <C-x><C-k>
Map [i] <compl><C-l> <C-x><C-l>
Map [i] <compl><C-s> <C-x><C-s>
Map [i] <compl><C-t> <C-x><C-t>

" }}}
" }}}
" cmap {{{
if &wildmenu
    Map -force [c] <C-f> <Space><BS><Right>
    Map -force [c] <C-b> <Space><BS><Left>
endif

Map [c] <C-n> <Down>
Map [c] <C-p> <Up>

" Escape /,?
Map -expr [c] /  getcmdtype() == '/' ? '\/' : '/'
Map -expr [c] ?  getcmdtype() == '?' ? '\?' : '?'
" }}}
" abbr {{{
Map -abbr -expr [i]  date@ strftime('%Y/%m/%d')
Map -abbr -expr [i]  time@ strftime("%H:%M")
Map -abbr -expr [i]  dt@   strftime("%Y/%m/%d %H:%M")
Map -abbr -expr [ic] mb@   [^\x01-\x7e]

MapAlterCommand th     tab help
MapAlterCommand t      tabedit
MapAlterCommand sf     setf
MapAlterCommand hg     helpgrep
MapAlterCommand ds     diffsplit
MapAlterCommand do     diffoff!

MapAlterCommand ba     breakadd
MapAlterCommand baf    breakadd func
MapAlterCommand bah    breakadd here

" For typo.
MapAlterCommand qw     wq
" }}}


Map [nx] <SID>(centering-display) zvzz

" Mappings with option value. {{{

Map [n] / :<C-u>setlocal ignorecase hlsearch<CR>/
Map [n] ? :<C-u>setlocal ignorecase hlsearch<CR>?

Map -script [n] * :<C-u>setlocal noignorecase hlsearch<CR>*<SID>(centering-display)
Map -script [n] # :<C-u>setlocal noignorecase hlsearch<CR>#<SID>(centering-display)

Map [n] : :<C-u>setlocal hlsearch<CR>:
Map [x] : :<C-u>setlocal hlsearch<CR>gv:

Map -script [n] gd :<C-u>setlocal hlsearch<CR>gd<SID>(centering-display)
Map -script [n] gD :<C-u>setlocal hlsearch<CR>gD<SID>(centering-display)

" }}}
" Make searching directions consistent {{{
" 'zv' is harmful for Operator-pending mode and it should not be included.
" For example, 'cn' is expanded into 'cnzv' so 'zv' will be inserted.

Map -expr [nx] <SID>(always-forward-n) (<SID>search_forward_p() ? 'n' : 'N')
Map -expr [nx] <SID>(always-backward-N) (<SID>search_forward_p() ? 'N' : 'n')
Map -expr [o]  <SID>(always-forward-n) <SID>search_forward_p() ? 'n' : 'N'
Map -expr [o]  <SID>(always-backward-N) <SID>search_forward_p() ? 'N' : 'n'

function! s:search_forward_p()
    return exists('v:searchforward') ? v:searchforward : 1
endfunction

" Mapping -> plugin specific mapping, misc. hacks
Map -remap [nx] n <SID>(always-forward-n)<SID>(centering-display)
Map -remap [nx] N <SID>(always-backward-N)<SID>(centering-display)
Map -remap [o] n <SID>(always-forward-n)
Map -remap [o] N <SID>(always-backward-N)

" }}}
" Disable unused keys. {{{
Map [n] <F1> <Nop>
Map [n] <C-F1> <Nop>
Map [n] <S-F1> <Nop>
Map [n] ZZ <Nop>
Map [n] ZQ <Nop>
Map [n] U  <Nop>
" }}}
" Add current line to quickfix. {{{
" quickfix as bookmark list.
command! -bar -range QFAddLine <line1>,<line2>call s:quickfix_add_range()

" ... {{{

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

" }}}
" Map CUA-like keybindings to Alt key {{{
" I like MacVim's command key :)
Map [x] <M-x> "+d
Map [x] <M-c> "+y
Map [nx] <M-v> "+p
Map [n] <M-a> ggVG
Map [n] <M-t> :<C-u>tabedit<CR>
Map [n] <M-w> :<C-u>tabclose<CR>
" }}}

" Mouse {{{

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
" Menus {{{

nnoremenu          PopUp.-VimrcSep- :
nmenu     <silent> PopUp.最近開いたファイル sf
nnoremenu <silent> PopUp.すぐやることリスト :tab drop ~/Dropbox/memo/todo/すぐやること.txt<CR>
nnoremenu <silent> PopUp.ファイルパスをコピー :let [@", @+, @*] = repeat([expand('%:p')], 3)<CR>

" }}}
" FileType & Syntax {{{

" Must be after 'runtimepath' setting!
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
syntax enable

" FileType {{{

function! s:current_filetypes() "{{{
    return split(&l:filetype, '\.')
endfunction "}}}
function! s:set_dict() "{{{
    let filetype_vs_dictionary = {
    \   'c': ['c', 'cpp'],
    \   'cpp': ['c', 'cpp'],
    \   'html': ['html', 'css', 'scss', 'javascript', 'smarty', 'htmldjango'],
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

    let &l:dictionary = join(s:List.uniq(dicts), ',')
endfunction "}}}
function! s:is_current_filetype(filetypes) "{{{
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
endfunction "}}}
function! s:set_tab_width() "{{{
    if s:is_current_filetype(
    \   ['css', 'xml', 'html', 'smarty', 'htmldjango',
    \    'lisp', 'scheme', 'yaml', 'python', 'markdown']
    \)
        setlocal tabstop=2
    else
        setlocal tabstop=4
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
    if &formatoptions !~# 'j'
        " 7.3.541 or later
        set formatoptions+=j
    endif

    call s:set_dict()
    call s:set_tab_width()
    call s:set_compiler()
endfunction "}}}

VimrcAutocmd FileType * call s:load_filetype()

" }}}

" Syntax {{{
VimrcAutocmd BufNewFile,BufRead *.as setlocal syntax=actionscript
VimrcAutocmd BufNewFile,BufRead _vimperatorrc,.vimperatorrc setlocal syntax=vimperator
VimrcAutocmd BufNewFile,BufRead *.avs setlocal syntax=avs
" }}}

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
" :EchoPath - Show path-like option in a readable way {{{

MapAlterCommand epa EchoPath
MapAlterCommand rtp EchoPath<Space>&rtp


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
" :Expand {{{
command!
\   -bar -nargs=?
\   Expand
\   call s:cmd_expand(<q-args>)

function! s:cmd_expand(args) "{{{
    if a:args != ''
        let str = expand(a:args)
    else
        if getbufvar('%', '&buftype') == ''
            let str = expand('%:p')
        else
            let str = expand('%')
        endif
    endif
    if s:is_win
        let str = tr(str, '/', '\')
    endif
    echo str
    let [@", @+, @*] = [str, str, str]
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
" :Glob, :GlobPath {{{
command!
\   -bar -nargs=+ -complete=file
\   Glob
\   echo glob(<q-args>, 1)

MapAlterCommand gl[ob] Glob

command!
\   -bar -nargs=+ -complete=file
\   GlobPath
\   echo globpath(&rtp, <q-args>, 1)

MapAlterCommand gp GlobPath
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
" originally from kana's .vimrc, but now outragely different one :)
" https://github.com/kana/config

command! -bar -bang -nargs=+ SplitNicely
\   call s:cmd_split_nicely(<q-args>, <bang>0)

function! s:cmd_split_nicely(q_args, bang)
    let vertical = 1
    let winnum = winnr('$')
    let save_winwidth = winwidth(0)
    let save_winheight = winheight(0)
    execute 'belowright' (vertical ? 'vertical' : '') a:q_args
    if winnr('$') is winnum
        " if no new window is opened
        return
    endif
    " Adjust split window.
    if vertical && !&l:winfixwidth
        execute save_winwidth / 3 'wincmd |'
    endif
    if !vertical && !&l:winfixheight
        execute save_winheight / 2 'wincmd _'
    endif
    " Fix width and height.
    if a:bang
        setlocal winfixwidth winfixheight
    endif
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

Map -script [n] <C-]> <SID>(gen-tags-if-not-present)<C-]>
Map [n] <SID>(gen-tags-if-not-present) :<C-u>if empty(tagfiles()) | Ctags | endif<CR>

command!
\   -bar -nargs=*
\   Ctags
\   call s:cmd_ctags(<q-args>)

function! s:cmd_ctags(q_args) "{{{
    if !executable('ctags')
        call s:error("Ctags: No 'ctags' command in PATH")
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
        call s:error("Invalid event name: ".a:event)
        return
    endif
    if !has_key(s:watching_events, a:event)
        call s:error("Not watching ".a:event." event yet...")
        return
    endif

    unlet s:watching_events[a:event]
    echomsg 'Removed watch for '.a:event.' event.'
endfunction
function! s:cmd_watch_autocmd(event)
    if !exists('#'.a:event)
        call s:error("Invalid event name: ".a:event)
        return
    endif
    if has_key(s:watching_events, a:event)
        echomsg "Already watching ".a:event." event."
        return
    endif

    execute 'autocmd watch-autocmd' a:event
    \       '* call s:echomsg("Executing '.string(a:event).' event...")'
    let s:watching_events[a:event] = 1
    echomsg 'Added watch for '.a:event.' event.'
endfunction
" }}}
" :Kwbd {{{
" http://nanasi.jp/articles/vim/kwbd_vim.html
command! -bar Kwbd execute "enew | bw ".bufnr("%")
MapAlterCommand clo[se] Kwbd
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
" Quickfix {{{
VimrcAutocmd QuickfixCmdPost [l]*  lopen
VimrcAutocmd QuickfixCmdPost [^l]* copen
" }}}
" Runtime plugin config {{{
" Configuration for plugins in default runtime dir.

" syntax/vim.vim {{{
    " augroup: a
    " function: f
    " lua: l
    " perl: p
    " ruby: r
    " python: P
    " tcl: t
    " mzscheme: m
    let g:vimsyn_folding = 'af'
"}}}
" indent/vim.vim {{{
    let g:vim_indent_cont = 0
" }}}
" changelog.vim {{{
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
" (I have not ever used it, though)

" Delete old files in &backupdir
function! s:delete_backup()
    let stamp_file = expand('$MYVIMDIR/info/backup_deleted_ts.txt')
    if !filereadable(stamp_file)
        call writefile([localtime()], stamp_file)
        return
    endif

    " Delete old files older than 30 days.
    let [line] = readfile(stamp_file)
    let thirty_days_sec = 60 * 60 * 24 * 30
    if localtime() - str2nr(line) > thirty_days_sec
        let backup_files = split(expand(&backupdir . '/*'), "\n")
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
" Misc. (bundled with kaoriya vim's .vimrc & etc.) {{{

" Checking typo. {{{
VimrcAutocmd BufWriteCmd *[,*] call s:write_check_typo(expand('<afile>'))
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

" Jump to the last known cursor position {{{
" This setting was from $VIM/vimrc_example.vim

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
VimrcAutocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif
" }}}

" About japanese input method {{{
if has('multi_byte_ime') || has('xim')
    " Cursor color when IME is on.
    highlight CursorIM guibg=Purple guifg=NONE
    set iminsert=0 imsearch=0
endif
" }}}

" Make <M-Space> same as ordinal applications on MS Windows {{{
if has('gui_running') && s:is_win
    nnoremap <M-Space> :<C-u>simalt ~<CR>
endif
" }}}

" Use meta keys in console {{{
if has('unix') && !has('gui_running')
  " Use meta keys in console.
  function! s:use_meta_keys()  " {{{
    for i in map(
    \   range(char2nr('a'), char2nr('z'))
    \ + range(char2nr('A'), char2nr('Z'))
    \ + range(char2nr('0'), char2nr('9'))
    \ , 'nr2char(v:val)')
      " <ESC>O do not map because used by arrow keys.
      if i != 'O'
        execute 'nmap <ESC>' . i '<M-' . i . '>'
      endif
    endfor
  endfunction  " }}}

  call s:use_meta_keys()
  map <NUL> <C-Space>
  map! <NUL> <C-Space>
endif
" }}}

" }}}
" End. {{{

set secure
" }}}
