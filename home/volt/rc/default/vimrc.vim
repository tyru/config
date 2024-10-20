" vim:fdm=marker:fen:
" vint: -ProhibitUnusedVariable

" Don't set scriptencoding before 'encoding' option is set!
" scriptencoding utf-8

" See also: ~/.vimrc or ~/_vimrc

" TODO: Install plugins
" - https://thinca.hatenablog.com/entry/qfhl-vim-released

if v:version < 802
  echomsg 'Stop loading vimrc. Please use 8.2 later'
  set packpath-=$MYVIMDIR
  set packpath-=$MYVIMDIR/after
  finish
endif

let s:is_win = has('win32')
let s:is_wsl = has('unix') && isdirectory('/mnt/c/')

if s:is_win
  let $MYVIMDIR = expand('~/vimfiles')
else
  let $MYVIMDIR = expand('~/.vim')
endif

" Use plain vim when vim was invoked by 'sudo' command.
if exists('$SUDO_USER')
  set packpath-=$MYVIMDIR
  set packpath-=$MYVIMDIR/after
  finish
endif

if !exists('$VIMRC_FORCE_LANG_C')
  let $VIMRC_FORCE_LANG_C = 0
endif
if !exists('$VIMRC_LOAD_MENU')
  let $VIMRC_LOAD_MENU = 0
endif

" Macros {{{1

let s:macros = []

" :BulkMap {{{2

let s:macros += ['BulkMap']
command! -nargs=* BulkMap call s:cmd_map(<q-args>)

function! s:cmd_map(args) abort
  let m = matchlist(a:args, '^\(.*\)\[\([nvxsoiclt]\+\)\]\(.*\)$')
  if empty(m)
    throw 'BulkMap: invalid arguments: ' . a:args
  endif
  let [l, modes, r] = m[1:3]
  let l = substitute(l, '<noremap>', '', 'g')
  let nore = l is# m[1] ? '' : 'nore'
  let l = trim(l, " \t")
  let r = trim(r, " \t")
  for m in split(modes, '\zs')
    let cmd = printf('%s%smap %s %s', m, nore, l, r)
    " echom cmd
    execute cmd
  endfor
endfunction

" :Lazy {{{2

let s:macros += ['Lazy']
if has('vim_starting')
  command! -nargs=* Lazy autocmd vimrc VimEnter * <args>
else
  command! -nargs=* Lazy <args>
endif

" Basic {{{1

" Reset all options
let save_rtp = &rtp
set all&
let &rtp = save_rtp

" Reset auto-commands
augroup vimrc
  autocmd!
augroup END

if $VIMRC_FORCE_LANG_C
  language messages C
  language time C
endif

if !$VIMRC_LOAD_MENU
  set guioptions+=M
  let g:did_install_default_menus = 1
  let g:did_install_syntax_menu = 1
endif

filetype off
filetype plugin indent on

if filereadable(expand('$MYVIMDIR/vimrc.local'))
  execute 'source' expand('$MYVIMDIR/vimrc.local')
endif

" Encoding {{{1
let s:enc = 'utf-8'

let &enc = s:enc
let &fenc = s:enc
let s:fencs = [s:enc] + split(&fileencodings, ',') + ['iso-2022-jp', 'iso-2022-jp-3', 'cp932']
let &fileencodings = join(filter(s:fencs, 'count(s:fencs, v:val) == 1'), ',')

unlet s:fencs
unlet s:enc

scriptencoding utf-8

set fileformats=unix,dos,mac
if exists('&ambiwidth')
  set ambiwidth=double
endif

" Options {{{1

set autoindent
set backspace=indent,eol,start
set browsedir=current
set complete=.,w,t
set completeopt=menu,popup
set concealcursor=nvic
set diffopt+=vertical
set display=lastline
set expandtab
set formatoptions+=j
set formatoptions=mMcroqnl2
set history=1000
set hlsearch
set ignorecase
set incsearch
set keywordprg=
set list
set matchpairs+=<:>
set nofixeol
set noshowcmd
set notimeout
set nrformats-=octal nrformats+=unsigned
set number
set pumheight=20
set scrolloff=5
set sessionoptions=blank,curdir,folds,help,tabpages,terminal,winsize,slash
set shiftround
set shiftwidth=2
set showtabline=2
set smartcase
set softtabstop=-1
set switchbuf=useopen,usetab
set t_Co=256
set tabstop=8
set textwidth=80
set ttimeout
set ttimeoutlen=50
set whichwrap=b,s
set wildmenu
set wildmode=longest,list,full

set shortmess+=aI
if !exists('*searchcount')
  set shortmess-=S
endif

if has('path_extra')
  set tags+=.;
  set tags+=tags;
  set path+=.;
endif

" Assumption: Trailing spaces are already highlighted and noticeable.
" set listchars=tab:>\ ,extends:>,precedes:<,trail:-,eol:$
set listchars=tab:>\ ,extends:>,precedes:<,trail:-

" Swapfile
if 1
  " Use swapfile.
  set swapfile
  set directory=$MYVIMDIR/info/swap//
  call mkdir(substitute(&directory, '//$', '', ''), 'p')
  " Open a file as read-only if swap exists
  " autocmd vimrc SwapExists * let v:swapchoice = 'o'
else
  " No swapfile.
  set noswapfile
  set updatecount=0
endif

" Backup
set backup
set backupdir=$MYVIMDIR/info/backup//
call mkdir(substitute(&backupdir, '//$', '', ''), 'p')

" Don't change inode when writing a file
autocmd vimrc BufRead */log/*,*.log setfiletype largefile
autocmd vimrc FileType largefile setlocal noundofile noswapfile shortmess-=S nowrap noincsearch

" Title
set title
let &titlestring = '%{getcwd()}'

" guitablabel {{{

nnoremap <C-w>t :<C-u>TabTitle<CR>
tnoremap <C-w>t <C-w>:<C-u>TabTitle<CR>

command! -nargs=* TabTitle call s:tab_title(<q-args>)
function! s:tab_title(new_title) abort
  let title = trim(a:new_title)
  if title ==# ''
    let title = s:prompt_tab_title()
  endif
  if title ==# ''
    unlet! t:title
  else
    let t:title = title
  endif
  redrawtabline
endfunction

function! s:prompt_tab_title() abort
  let with_tabnr = v:false
  let initial_title = gettabvar(tabpagenr(), 'title', '')
  call inputsave()
  try
    return input('set tab title (blank to clear): ', initial_title)
  finally
    call inputrestore()
  endtry
endfunction

let &guitablabel = '%{MyTabLabel(v:lnum)}'
let &tabline = '%!MyTabLine()'

function MyTabLine()
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
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(tabnr, ...)
  let with_tabnr = get(a:000, 0, v:true)
  let title = gettabvar(a:tabnr, 'title', '')
  let buflist = tabpagebuflist(a:tabnr)
  let fname = title ==# '' ? MyTabFname(a:tabnr, buflist) : title
  let modified = MyTabModified(buflist)
  return join([
  \ (with_tabnr ? a:tabnr . ':' : ''),
  \ fname,
  \ modified
  \], '')
endfunction

" TODO: separate filetype-specific code
let s:webFt = ['javascript', 'typescript', 'stylus']
function! MyTabFname(tabnr, buflist) abort
  let bufname = ''
  let ft = getbufvar(winbufnr(win_getid(tabpagewinnr(a:tabnr), a:tabnr)), '&filetype')
  if index(s:webFt, ft) !=# -1
    let bufname = bufname(a:buflist[tabpagewinnr(a:tabnr) - 1])
    echom bufname
    let paths = bufname->split('/')
    if bufname =~# '/index\.\w\+$' && len(paths) >= 2
      let bufname = paths[-2]
    else
      let bufname = paths->get(-1, '')
    endif
  elseif type(a:buflist) ==# 3
    let bufname = bufname(a:buflist[tabpagewinnr(a:tabnr) - 1])
    let bufname = fnamemodify(bufname, ':t')
    " let bufname = pathshorten(bufname)
  endif
  let fname = bufname ==# '' ? '[No Name]' : bufname
  return fname
endfunction

function! MyTabModified(buflist) abort
  let modified = 0
  for bufnr in a:buflist
    " check only <empty> and acwrite
    if getbufvar(bufnr, '&buftype', 'NONE') =~# '\v^(acwrite)?$' && getbufvar(bufnr, '&modified', 0)
      let modified = 1
      break
    endif
  endfor
  return (modified ? '[+]' : '')
endfunction

" }}}

" statusline {{{

set laststatus=2
let &statusline = 
\    '%f%( [%M%R%H%W]%)%( [%{&ft}]%) %{&fenc}/%{&ff}'
\ .  '%( %{line(".")}/%{line("$")}%)'

if exists('*searchcount')
  function! LastSearchCount() abort
    if !v:hlsearch
      return ''
    endif
    try
      let result = searchcount(#{recompute: 0})
    catch
      return ''
    endtry
    if empty(result)
      return ''
    endif
    if result.incomplete ==# 1     " timed out
      return printf(' /%s [?/??]', @/)
    elseif result.incomplete ==# 2 " max count exceeded
      if result.total > result.maxcount && result.current > result.maxcount
	return printf(' /%s [>%d/>%d]', @/, result.current, result.total)
      elseif result.total > result.maxcount
	return printf(' /%s [%d/>%d]', @/, result.current, result.total)
      endif
    endif
    return printf(' /%s [%d/%d]', @/, result.current, result.total)
  endfunction
  let &statusline .= '%{LastSearchCount()}'

  " debounce
  autocmd CursorMoved * let s:searchcount_timer =
  \   timer_start(200, function('s:update_searchcount'))
  function! s:update_searchcount(timer) abort
    if a:timer ==# s:searchcount_timer
      try
        call searchcount(#{recompute: 1, maxcount: 0, timeout: 100})
        redrawstatus
      catch
      endtry
    endif
  endfunction
endif

" Unofficial patches {{{

" https://rbtnn.github.io/vim/
" disable when running as git commit editor
if has('tabsidebar') && !exists('$GIT_EXEC_PATH')
  set showtabline=0
  set showtabsidebar=2
  set tabsidebarcolumns=20
  set tabsidebarwrap
endif

" http://h-east.github.io/vim/
if has('clpum')
  set wildmode=longest,popup
  set wildmenu
  set clpumheight=40
  set clcompleteopt-=noinsert
endif

" }}}

" 'guioptions' flags are set on FocusGained
" because "cmd.exe start /min" doesn't work.
" (always start up as foreground)
augroup vimrc-guioptions
  autocmd!
augroup END
if has('vim_starting')
  command! -nargs=* FocusGained    autocmd FocusGained vimrc-guioptions * <args>
  command! -nargs=* FocusGainedEnd autocmd FocusGained vimrc-guioptions * autocmd! vimrc-guioptions
else
  command! -nargs=* FocusGained    <args>
  command! -nargs=* FocusGainedEnd :
endif

" Must be set in .vimrc
" set guioptions+=p
FocusGained set guioptions-=a
FocusGained set guioptions+=A
" Include 'e': tabline
" Otherwise  : guitablabel
FocusGained set guioptions-=e
FocusGained set guioptions+=h
FocusGained set guioptions+=m
FocusGained set guioptions-=L
FocusGained set guioptions-=T
FocusGainedEnd

delcommand FocusGained
delcommand FocusGainedEnd

" convert "\\" to "/" on win32 like environment
if exists('+shellslash')
  set shellslash
endif

" Visual bell
set visualbell
set t_vb=

" Restore screen
set norestorescreen
set t_ti=
set t_te=

" Undo persistence
if has('persistent_undo')
  set undofile
  set undodir=$MYVIMDIR/info/undo
  call mkdir(&undodir, 'p')
endif

" jvgrep
if executable('jvgrep')
  set grepprg=jvgrep
endif

" Font {{{2
if has('gui_running')
  if s:is_win
    if exists('+renderoptions')
      " If 'renderoptions' option exists,
      set renderoptions=type:directx,renmode:5
      " ... and if "Ricty_Diminished" font is installed,
      " enable DirectWrite.
      try
        set guifont=Ricty_Diminished_Discord:h14:cSHIFTJIS
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

" ColorScheme {{{1

try
  if 0
    colorscheme spring-night
    " https://github.com/rhysd/vim-color-spring-night/issues/7
    if has('tabsidebar')
      Lazy hi SignColumn term=NONE guibg=#ffffff ctermbg=255
      " for diff
      Lazy hi FoldColumn term=NONE guibg=#ffffff ctermbg=255
    endif
  else
    colorscheme seoul256
    " https://qiita.com/Bakudankun/items/649aa6d8b9eccc1712b5
    if exists('&wincolor')
      autocmd ColorScheme * highlight NormalNC ctermbg=232 guibg=Black
      autocmd WinEnter,BufWinEnter * setlocal wincolor=
      autocmd WinLeave * setlocal wincolor=NormalNC
    endif
  endif
catch /E185/
  colorscheme evening
endtry

" too annoying
" highlight ColorColumn ctermfg=12 guifg=Red ctermbg=NONE guibg=NONE

" Mappings, Abbreviations {{{1

" General prefix keys {{{2

BulkMap [nxo] <Space> <Plug>(vimrc:prefix:excmd)
" fallback
BulkMap <noremap> [nxo] <Plug>(vimrc:prefix:excmd) <Space>

let g:mapleader = ';'
let g:maplocalleader = ';'
nnoremap <Leader> <Nop>
nnoremap <LocalLeader> <Nop>

" Operators {{{2

" Do not destroy noname register.
BulkMap <noremap> [nxo] x "_x

" Text-objects {{{2

onoremap gv :<C-u>normal! gv<CR>

" }}}

" Do not scroll over the last line
" http://itchyny.hatenablog.com/entry/2016/02/02/210000
BulkMap <noremap><expr> [nxo] <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')

" At the first/last screen row, scroll also lines not screen view
BulkMap <noremap><expr> [nxo] <C-y> line('w0') <= 1         ? 'k' : "\<C-y>"
BulkMap <noremap><expr> [nxo] <C-e> line('w$') >= line('$') ? 'j' : "\<C-e>"

" Open only current line's fold.
nnoremap z<Space> zMzvzz


" Set cwd to current file's directory
nnoremap <Plug>(vimrc:prefix:excmd)cd   :<C-u>tcd %:h<CR>

" 'Y' to yank till the end of line.
nnoremap Y    y$

" Jumping tabs
tnoremap <silent> <C-w><C-n> <C-w>:<C-u>call <SID>tabjump(v:count1)<CR>
tnoremap <silent> <C-w><C-p> <C-w>:<C-u>call <SID>tabjump(-v:count1)<CR>
nnoremap <silent> <C-w><C-n> :<C-u>call <SID>tabjump(v:count1)<CR>
nnoremap <silent> <C-w><C-p> :<C-u>call <SID>tabjump(-v:count1)<CR>
nnoremap <silent> <C-n>      :<C-u>call <SID>tabjump(v:count1)<CR>
nnoremap <silent> <C-p>      :<C-u>call <SID>tabjump(-v:count1)<CR>

function! s:tabjump(n) abort
  let dest = (tabpagenr() + a:n) % tabpagenr('$')
  if a:n > 0
    execute 'tabnext' (dest == 0 ? tabpagenr('$') : dest)
  elseif a:n < 0
    execute 'tabnext' (dest <= 0 ? tabpagenr('$') + dest : dest)
  endif
endfunction

" Moving tabs
nnoremap <silent> <C-w><Left>    :<C-u>call <SID>tabmove(-v:count1)<CR>
nnoremap <silent> <C-w><Right>   :<C-u>call <SID>tabmove(+v:count1)<CR>
" for +tabsidebar
nnoremap <silent> <C-w><Up>      :<C-u>call <SID>tabmove(-v:count1)<CR>
nnoremap <silent> <C-w><Down>    :<C-u>call <SID>tabmove(+v:count1)<CR>

function! s:tabmove(n) abort
  let last = tabpagenr('$')
  let i = (tabpagenr() - 1 + a:n) % last
  let i = i < 0 ? last + i : i
  let tabnr = i ==# 0 || i + 2 ==# tabpagenr() ? i : i + 1
  execute 'tabmove' tabnr
endfunction

" :update / :close
nnoremap <Plug>(vimrc:prefix:excmd)w      :<C-u>update<CR>
nnoremap <silent> <Plug>(vimrc:prefix:excmd)q      :<C-u>close<CR>

" Edit .vimrc
nnoremap <Plug>(vimrc:prefix:excmd)ev     :<C-u>edit $MYVIMRC<CR>

" Mark current window ID {{{2
let s:marked_winids = {}

nnoremap <silent> <C-w>m     :<C-u>call <SID>mark_current_winid()<CR>
nnoremap <silent> <C-w><C-m> :<C-u>call <SID>mark_current_winid()<CR>
tnoremap <silent> <C-w>m     <C-w>:<C-u>call <SID>mark_current_winid()<CR>
tnoremap <silent> <C-w><C-m> <C-w>:<C-u>call <SID>mark_current_winid()<CR>

nnoremap <silent> <C-w><C-e> :<C-u>call <SID>jump_to_marked_winid()<CR>
nmap              <C-w>e     <C-w><C-e>
tnoremap <silent> <C-w><C-e> <C-w>:<C-u>call <SID>jump_to_marked_winid()<CR>
tmap              <C-w>e     <C-w><C-e>

let s:VALID_MARK_CHARACTER = '^[a-zA-Z]$'

function! s:getchar(...) abort
  let c = call('getchar', a:000)
  return type(c) ==# v:t_string ? c : nr2char(c)
endfunction

function! s:errormsg(msg, redraw) abort
  if a:redraw
    redraw
  endif
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction

function! s:mark_current_winid() abort
  echon 'Mark window ID as:'
  let c = s:getchar()
  if c ==# "\<CR>"
    return
  endif
  if c !~# s:VALID_MARK_CHARACTER
    call s:errormsg('Please input valid character to mark', v:true)
    return
  endif
  echon c
  " TODO: save pos with text property
  let s:marked_winids[c] = win_getid()
endfunction

" TODO: Popup UI
" TODO: Add ex-command to select & jump to marked window (ex-command version of popup UI)
" TODO: Add feature to search by bufname (like :buffer) if input was not digit
" (this feature conflicts with jumping to marked window,
" mark feature should be deprecate because it's enough to jump to tabpage by tabnr)
function! s:jump_to_marked_winid() abort
  echon 'Jump to:'
  let c = s:getchar()
  if c ==# "\<CR>" || c ==# "\<Esc>"
    redraw
    echo 'Canceled.'
    return
  endif
  " jump by tab number
  if c =~# '[0-9]'
    " 3 digits tab number is not supported :p
    let re = '^' . c
    let found_tabs = range(1, tabpagenr('$'))->filter('v:val =~# re')
    if len(found_tabs) ==# 1
      execute 'normal! ' . c . 'gt'
    elseif len(found_tabs) >=# 2
      redraw
      echon 'which tab? ' . found_tabs->map('MyTabLabel(v:val)')->join(' ') . ': ' . c
      let c2 = s:getchar()
      if c2 ==# "\<Esc>"
        redraw
        echo 'Canceled.'
        return
      endif
      if c2 =~# '[0-9]' || c2 ==# "\<CR>"
        let tabnr = c . (c2 == "\<CR>" ? '' : c2)
        if 1 <=# tabnr && tabnr <=# tabpagenr('$')
          execute 'normal! ' . tabnr . 'gt'
        else
          echo tabnr . ': no such tab.'
        endif
      endif
    else
      echo c . ': no such tab.'
    endif
    redraw
    echo ''
    return
  endif
  " jump by mark
  if c !~# s:VALID_MARK_CHARACTER
    call s:errormsg('Please input valid character to mark', v:true)
    return
  endif
  if !has_key(s:marked_winids, c) || type(s:marked_winids[c]) !=# v:t_number
    call s:errormsg(printf("'%s' is not marked yet", c), v:true)
    return
  endif
  echon c
  call win_gotoid(s:marked_winids[c])
endfunction

" Move to the previous tab {{{2
nnoremap <silent> <C-w><C-w> :<C-u>call <SID>move_to_previous_tab()<CR>
tnoremap <silent> <C-w><C-w> <C-w>:<C-u>call <SID>move_to_previous_tab()<CR>

let s:prev_winid = -1
function! s:move_to_previous_tab() abort
  if s:prev_winid >= 0
    let winid = win_getid()
    call win_gotoid(s:prev_winid)
    let s:prev_winid = winid
  endif
endfunction

autocmd vimrc TabLeave * let s:prev_winid = win_getid()

" Move tabpage {{{2

nnoremap <Left>  :<C-u>tabmove -1<CR>
nnoremap <Right> :<C-u>tabmove +1<CR>

" Move window size {{{2
" https://lambdalisue.hatenablog.com/entry/2015/12/25/000046

nnoremap <S-Left>  <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <S-Up>    <C-w>-
nnoremap <S-Down>  <C-w>+

" GUI: Save current file with <C-s> {{{2

if has('gui_running')
  inoremap <script> <C-s> <SID>(gui-save)<Esc>
  nnoremap <script> <C-s> <SID>(gui-save)
  inoremap <script> <SID>(gui-save) <C-o><SID>(gui-save)
  nnoremap          <SID>(gui-save) :<C-u>call <SID>gui_save()<CR>

  function! s:gui_save()
    if bufname('%') ==# ''
      browse confirm saveas
    else
      update
    endif
  endfunction
endif

" Terminal {{{2

" I don't use <C-w><C-t> mapping in normal mode
tnoremap <C-w><C-t> <C-w>N
nnoremap <expr> <C-w><C-t> term_getstatus(bufnr('')) =~# 'normal' ? 'a' : ''

" Cmdwin {{{2
set cedit=<C-l>
function! s:cmdwin_enter()
  startinsert!
  setlocal nonumber
endfunction
autocmd vimrc CmdwinEnter * call s:cmdwin_enter()

" Toggle options {{{2

function! s:advance_state(states, elem)
  let curidx = index(a:states, a:elem)
  let curidx = (curidx is -1 ? 0 : curidx)
  let curidx = (curidx + 1 >=# len(a:states) ? 0 : curidx + 1)
  return a:states[curidx]
endfunction

function! s:toggle_option_list(states, optname)
  let varname = '&' . a:optname
  call setbufvar(
  \   '%',
  \   varname,
  \   s:advance_state(
  \       a:states,
  \       getbufvar('%', varname)))
  execute 'setlocal' a:optname . '?'
endfunction

function! s:toggle_winfix()
  if &winfixheight || &winfixwidth
    setlocal nowinfixheight nowinfixwidth
    echo 'released.'
  else
    setlocal winfixheight winfixwidth
    echo 'fixed!'
  endif
endfunction

function! s:toggle_terminal_modes()
  let prevwinnr = winnr()
  " -1: undefined, 0: terminal normal mode, 1: terminal job mode
  " Change all terminal window's modes to this mode.
  " It is determined by the first terminal window's mode.
  let dest_mode = -1
  try
    for bufnr in tabpagebuflist()
      if getbufvar(bufnr, '&buftype', 'NONE') isnot# 'terminal'
        continue
      endif
      let is_normal = term_getstatus(bufnr) =~# '\<normal\>'
      if dest_mode is# -1
        let dest_mode = is_normal
      endif
      if is_normal && dest_mode is# 1
        call win_gotoid(win_getid(bufwinnr(bufnr)))
        normal! GA
      elseif !is_normal && dest_mode is# 0
        " XXX: `exe "normal! \<C-w>N"` cannot work in terminal window
        call feedkeys("\<C-w>" . bufwinnr(bufnr) . "\<C-w>\<C-w>N", 'n')
      endif
    endfor
  finally
    call feedkeys("\<C-w>" . prevwinnr . "\<C-w>", 'n')
  endtry
endfunction

function! s:toggle_diff() abort
  if &diff
    diffoff!
  else
    diffthis
  endif
endfunction

function! s:toggle_tabsidebar() abort
  if &showtabsidebar ==# 2
    setlocal showtabline=2
    setlocal showtabsidebar=0
  else
    setlocal showtabline=0
    setlocal showtabsidebar=2
  endif
endfunction

nnoremap <Plug>(vimrc:prefix:excmd)oh  :<C-u>setlocal hlsearch! hlsearch?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oi  :<C-u>setlocal ignorecase! ignorecase?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)op  :<C-u>setlocal paste! paste?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ow  :<C-u>setlocal wrap! wrap?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oe  :<C-u>setlocal expandtab! expandtab?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ol  :<C-u>setlocal list! list?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)on  :<C-u>setlocal number! number?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)om  :<C-u>setlocal modeline! modeline?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ot  :<C-u>call <SID>toggle_option_list([2, 4, 8], &l:shiftwidth ==# 0 ? 'tabstop' : 'shiftwidth')<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofc :<C-u>call <SID>toggle_option_list(['', 'all'], 'foldclose')<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofm :<C-u>call <SID>toggle_option_list(['manual', 'marker', 'indent'], 'foldmethod')<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofw :<C-u>call <SID>toggle_winfix()<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oT  :<C-u>call <SID>toggle_terminal_modes()<CR>
nnoremap <Plug>(vimrc:prefix:excmd)od  :<C-u>call <SID>toggle_diff()<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ost :<C-u>call <SID>toggle_tabsidebar()<CR>

" Make <M-Space> same as ordinal applications on MS Windows {{{2
if has('gui_running') && s:is_win
  nnoremap <M-Space> :<C-u>simalt ~<CR>
endif

" Remove trailing after blockwise yank {{{2

xnoremap <silent> y y:<C-u>call <SID>remove_trailing_spaces_blockwise()<CR>

function! s:remove_trailing_spaces_blockwise()
  let regname = v:register
  if getregtype(regname)[0] !=# "\<C-v>"
    return ''
  endif
  let value = getreg(regname, 1)
  let value = s:map_lines(value, {-> substitute(v:val, '\v\s+$', '', '')})
  call setreg(regname, value, "\<C-v>")
endfunction

function! s:map_lines(str, expr)
  return join(map(split(a:str, '\n', 1), a:expr), "\n")
endfunction

" Emacs like keybindings in i/c modes {{{2

if &wildmenu
  cnoremap <C-f> <Space><BS><Right>
  cnoremap <C-b> <Space><BS><Left>
else
  cnoremap <C-f> <Right>
  cnoremap <C-b> <Left>
endif

inoremap <expr> <C-f> col('.') is# col('$') ? "\<C-o>j\<Home>" : "\<Right>"
inoremap <expr> <C-b> col('.') is# 1        ? "\<C-o>k\<End>" : "\<Left>"
inoremap        <C-a> <Home>
cnoremap        <C-a> <Home>
inoremap        <C-e> <End>
cnoremap        <C-e> <End>
inoremap        <C-d> <Del>
cnoremap <expr> <C-d> getcmdpos() - 1 < len(getcmdline()) ? "\<Del>" : ""

inoremap <expr> <C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
cnoremap        <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

" Make <C-w> and <C-u> undoable {{{2

inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Insert-mode completion {{{2

imap <C-l> <Plug>(vimrc:prefix:compl)
" fallback
inoremap <Plug>(vimrc:prefix:compl) <C-l>

inoremap <Plug>(vimrc:prefix:compl)<C-n> <C-x><C-n>
inoremap <Plug>(vimrc:prefix:compl)<C-p> <C-x><C-p>
inoremap <Plug>(vimrc:prefix:compl)<C-]> <C-x><C-]>
inoremap <Plug>(vimrc:prefix:compl)<C-d> <C-x><C-d>
inoremap <Plug>(vimrc:prefix:compl)<C-f> <C-x><C-f>
inoremap <Plug>(vimrc:prefix:compl)<C-i> <C-x><C-i>
inoremap <Plug>(vimrc:prefix:compl)<C-k> <C-x><C-k>
inoremap <Plug>(vimrc:prefix:compl)<C-l> <C-x><C-l>
inoremap <Plug>(vimrc:prefix:compl)<C-s> <C-x><C-s>
inoremap <Plug>(vimrc:prefix:compl)<C-t> <C-x><C-t>


" Search command-line histories which have the same prefixes {{{2

cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" Centering display position after certain commands {{{2

nnoremap <SID>(centering-display) zvzz
xnoremap <SID>(centering-display) zvzz

nnoremap <script> gd gd<SID>(centering-display)
nnoremap <script> gD gD<SID>(centering-display)

nmap <script> n n<SID>(centering-display)
nmap <script> N N<SID>(centering-display)
xmap <script> n n<SID>(centering-display)
xmap <script> N N<SID>(centering-display)

" gF series {{{2
" * Search line number after filename (Behave like gF series, not gf series)
" * Jump to buffer across tabpages if the buffer was already opened

nnoremap <silent> gf :<C-u>call <SID>open_and_go_lnum('edit')<CR>
vnoremap <silent> gf :<C-u>call <SID>v_open_and_go_lnum('edit')<CR>

nmap     <C-w>f     <C-w><C-f>
vmap     <C-w>f     <C-w><C-f>
nnoremap <silent> <C-w><C-f> :<C-u>call <SID>open_and_go_lnum('split')<CR>
vnoremap <silent> <C-w><C-f> :<C-u>call <SID>v_open_and_go_lnum('split')<CR>

function! s:v_open_and_go_lnum(opencmd) abort
  let [prev_reg, prev_regtype] = [getreg('z', 1), getregtype('z')]
  try
    normal! gv"zy
    let [cfile, clnum] = s:parse_file_and_lnum(@z)
    call s:open_and_go_lnum(a:opencmd, cfile, clnum)
  finally
    call setreg('z', prev_reg, prev_regtype)
  endtry
endfunction

function! s:parse_file_and_lnum(str) abort
  let r = split(a:str, ':')
  let file = get(r, 0, '')
  let lnum = get(r, 1, '')
  return [file, lnum]
endfunction

function! s:open_and_go_lnum(opencmd, ...) abort
  let cfile = a:0 >=# 1 ? a:1 : expand('<cfile>')
  if cfile ==# ''
    return
  endif
  let file = findfile(cfile)
  if file ==# ''
    echohl ErrorMsg
    echomsg 'No such file in path:' cfile
    echohl None
    return
  endif
  let clnum = a:0 >=# 2 ? a:2 : matchstr(getline('.'), '\V' . cfile . '\v:\zs\d+')
  let winid = s:get_winid_by_fname(file)
  if win_gotoid(winid)
    echo 'Already opened.'
  else
    try
      execute a:opencmd file
    catch
      echohl ErrorMsg
      echomsg v:exception
      echohl None
      return
    endtry
  endif
  if clnum !=# ''
    execute clnum
  endif
endfunction

function! s:get_winid_by_fname(expr) abort
  " XXX: why this won't work?
  " return bufwinid(a:expr)
  let bufnr = bufnr(a:expr)
  let buflist = win_findbuf(bufnr)
  return empty(buflist) ? -1 : buflist[0]
endfunction

" Default settings for each filetype {{{1

" Must be after 'runtimepath' setting!
syntax enable

autocmd vimrc FileType * call s:on_filetype()

function! s:on_filetype()
  if &omnifunc ==# ''
    setlocal omnifunc=syntaxcomplete#Complete
  endif
  set formatoptions+=j
endfunction

" Highlight TODO/FIXME/XXX/NOTE comments {{{1

autocmd vimrc BufNew * call matchadd('Todo', '\<TODO\|FIXME\|XXX\|NOTE\>')

" Commands {{{1

command! -bar DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
\ | wincmd p | diffthis

command! -bar DiffAlgoDefault call s:cmd_set_diffalgo('myers')
command! -bar DiffAlgoToggle
\ call s:cmd_diff_algo_toggle(['myers', 'minimal', 'patience', 'histogram'])

function! s:cmd_set_diffalgo(algo) abort
  let opts = split(&diffopt, ',')
  let &diffopt = filter(opts, 'v:val !~# "^algorithm:"')->add('algorithm:' . a:algo)->join(',')
  redraw
  set diffopt?
  diffupdate
endfunction

" algo_list[0] is vim default algorithm
function! s:cmd_diff_algo_toggle(algo_list) abort
  let opts = split(&diffopt, ',')
  let current_algo = match(opts, '^algorithm:')
  let idx = current_algo ==# -1 ? 0 : index(a:algo_list, strpart(opts[current_algo], len('algorithm:')))
  let next_algo = a:algo_list[idx+1 >= len(a:algo_list) ? 0 : idx+1]
  call s:cmd_set_diffalgo(next_algo)
endfunction

command! -bar -nargs=+ -complete=file Glob echo glob(<q-args>, 1)
command! -bar -nargs=+ -complete=file GlobPath echo globpath(&rtp, <q-args>, 1)

command! -bar -nargs=* Ctags call s:cmd_ctags(<q-args>)
function! s:cmd_ctags(q_args)
  if !executable('ctags')
    echohl ErrorMsg
    echomsg "Ctags: No 'ctags' command in PATH"
    echohl None
    return
  endif
  if a:q_args !=# ''
    execute '!ctags' a:q_args
  else
    execute '!ctags' (filereadable('.ctags') ? '' : '-R')
  endif
endfunction

command! -bar -bang -nargs=1 -complete=event WatchAutocmd
\ call <SID>cmd_watch_autocmd(<q-args>, <bang>0)

function! s:cmd_watch_autocmd(event, bang) abort
  if a:event ==# '*'
    for event in getcompletion('*', 'event')
      call s:cmd_watch_autocmd(event, a:bang)
    endfor
    return
  endif
  if a:bang
    call s:unwatch_autocmd(a:event)
  else
    call s:watch_autocmd(a:event)
  endif
endfunction

augroup vimrc-watch-autocmd
  autocmd!
augroup END

let s:watching_events = {}

function! s:unwatch_autocmd(event)
  let event = tolower(a:event)
  if !exists('##'.event)
    echohl ErrorMsg
    echomsg 'Invalid event name: '.a:event
    echohl None
    return
  endif
  if !has_key(s:watching_events, event)
    echohl ErrorMsg
    echomsg 'Not watching '.a:event.' event yet...'
    echohl None
    return
  endif

  execute 'autocmd! vimrc-watch-autocmd' event
  unlet s:watching_events[event]
  echomsg 'Removed watch for '.a:event.' event.'
endfunction

function! s:watch_autocmd(event)
  let event = tolower(a:event)
  if !exists('##'.event)
    echohl ErrorMsg
    echomsg 'Invalid event name: '.a:event
    echohl None
    return
  endif
  if has_key(s:watching_events, event)
    echomsg 'Already watching '.a:event.' event.'
    return
  endif

  execute 'autocmd vimrc-watch-autocmd' event '*'
  \       'echohl MoreMsg |'
  \       'echomsg "Executing '''.a:event.''' event..." |'
  \       'echohl None'
  let s:watching_events[event] = 1
  echomsg 'Added watch for' a:event 'event.'
endfunction

" http://nanasi.jp/articles/vim/kwbd_vim.html
command! -bar Kwbd execute 'enew | bw' bufnr("%")

" Enable/Disable 'scrollbind', 'cursorbind' options.
command! -bar ScrollbindEnable  windo setlocal scrollbind cursorbind
command! -bar ScrollbindDisable windo setlocal noscrollbind nocursorbind

command! -bar ResetHelpBuffer
\   setlocal noro modifiable buftype= list noet

function! s:cmd_git_grep(args, local) abort
  setlocal grepprg=git\ grep
  try
    execute (a:local ? 'l' : '') . 'grep' a:args
  finally
    setlocal grepprg<
  endtry
endfunction
command! -complete=file -nargs=+ GitGrep call s:cmd_git_grep(<q-args>, 0)
command! -complete=file -nargs=+ LGitGrep call s:cmd_git_grep(<q-args>, 1)

command! -bar Todo /\v<(TODO|FIXME|XXX)>
command! -complete=file -nargs=* GrepTodo call s:cmd_greptodo(<q-args>)
function! s:cmd_greptodo(args) abort
  let files = a:args ==# '' ? '%' : a:args
  execute 'vimgrep /\v<(TODO|FIXME|XXX)>/' files
endfunction

function! s:cmd_cexprfile(lines, location) abort
  if type(a:lines) ==# v:t_list
    let lines = a:lines
  elseif type(a:lines) ==# v:t_string
    let lines = split(a:lines, '\n')
  else
    throw 'Invalid value type: expected = list or string, got = ' .. string(a:lines)
  endif
  let list = lines->map({-> trim(v:val)})->filter({-> !empty(v:val)})->map({-> #{filename: v:val, lnum: 1}})->setqflist()
  if a:location
    call setloclist(winnr(), list)
  else
    call setqflist(list)
  endif
endfunction
command! -nargs=+ -complete=expression CExprFile call s:cmd_cexprfile(<args>, v:false)
command! -nargs=+ -complete=expression LExprFile call s:cmd_cexprfile(<args>, v:true)
command! -nargs=+ -complete=expression CExprSystem cexpr system(<q-args>)
command! -nargs=+ -complete=expression LExprSystem lexpr system(<q-args>)

command! -bar EmojiTest OpenBrowser https://unicode.org/Public/emoji/12.0/emoji-test.txt

if has('sound')
  command! -nargs=1 -complete=file PlayFile call sound_playfile(<q-args>)
endif

command! -range=% SQLFmt <line1>,<line2>!sqlformat -r -k upper -
command! -range=% HTMLFmt <line1>,<line2>!tidy -indent --tidy-mark no --show-errors 0 --show-warnings no -quiet

command! -nargs=1 -complete=file Tailf terminal ++kill=term ++close tail -f <args>
command! TermTop terminal ++kill=term ++close top

" FIXME: currently volt does not recognize tyru/project-guide.vim plugconf...
if 0
  command! -nargs=* -complete=dir Gof execute 'terminal ++close gof -t' .. (<q-args> !=# '' ? ' ' .. <q-args> : '')

  function! s:volt_plugconf() abort
    let root_dir = exists('$VOLTPATH') ? '$VOLTPATH' : '$HOME/volt'
    return expand(root_dir .. '/plugconf')
  endfunction
  execute 'command! VoltPlugConf Gof -d' s:volt_plugconf()

  function! s:volt_repos_dirs_pattern() abort
    let root_dir = exists('$VOLTPATH') ? expand('$VOLTPATH') : expand('$HOME/volt')
    let dirs_pattern = root_dir .. '/repos/*/*/*'
    return dirs_pattern
  endfunction

  function! s:gopath_dirs_pattern() abort
    let root_dir = exists('$GOPATH') ? expand('$GOPATH') : expand('$HOME/go')
    let dirs_pattern = root_dir .. '/src/*/*/*'
    return dirs_pattern
  endfunction

  function! s:pj_options() abort
    return #{
      \ peco_args: ['--select-1'],
      "\ gof_args: ['-f'],
      \}
  endfunction


  augroup vimrc-setup-project-guide
    autocmd!
    autocmd VimEnter * call project_guide#define_command('VoltRepos', function('s:volt_repos_dirs_pattern'), s:pj_options())
    autocmd VimEnter * call project_guide#define_command('Gopath', function('s:gopath_dirs_pattern'), s:pj_options())

    autocmd User project-guide-post-tcd let t:vimrc_update_session_constantly = getcwd() . '/Session.vim'
    autocmd User project-guide-post-file-open execute 'mksession!' t:vimrc_update_session_constantly
    " Execute :mksession! in all tabpages which have t:vimrc_update_session_constantly
    function! s:update_session(timer) abort
      for tabnr in range(1, tabpagenr('$'))
        let tabval = gettabvar(tabnr, 'vimrc_update_session_constantly')
        if tabval !=# ''
          call win_execute(win_getid(1, tabnr), 'mksession! ' .. tabval)
        endif
      endfor
    endfunction
    " Call above function every 30 seconds
    function! s:register_update_session() abort
      let sec = 1000
      call timer_start(30 * sec, function('s:update_session'), #{repeat: -1})
    endfunction
    call s:register_update_session()
  augroup END
endif

command! -register CopyPathLnum
\ call setreg(<q-reg>, @% . ':' . line('.')) |
\ echo @% . ':' . line('.')

" Duplicate tab also in terminal
tnoremap <C-w>s <C-w>:<C-u>call <SID>duplicate_tab_term()<CR>

function! s:duplicate_tab_term() abort
  let fname = tempname()
  try
    call term_dumpwrite(bufnr(''), fname)
    call term_dumpload(fname)
    setlocal nolist nowrap
  catch
  finally
    " XXX: this might fail on Windows when opening fname
    silent! call delete(fname)
  endtry
endfunction

" Quickfix {{{1

" Terminal {{{1
autocmd vimrc TerminalOpen *  call s:setup_terminal()

function! s:setup_terminal() abort
  setlocal nowrap
endfunction

" Configurations for Vim runtime plugins {{{1

" Disable unnecessary runtime plugins {{{2
" cf. https://lambdalisue.hatenablog.com/entry/2015/12/25/000046
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_logiPat           = 1
" use https://github.com/itchyny/vim-parenmatch instead
let g:loaded_matchparen        = 1

" Don't inspect *.log file content (because it's large) {{{2
" :help filetype-ignore
let g:ft_ignore_pat .= '\|\.log$'

" syntax/vim.vim {{{2
" augroup: a
" function: f
" lua: l
" perl: p
" ruby: r
" python: P
" tcl: t
" mzscheme: m
let g:vimsyn_folding = 'af'

" indent/vim.vim {{{2
let g:vim_indent_cont = 0

" syntax/sh.vim {{{2
let g:is_bash = 1

" syntax/prolog.vim {{{2
let g:prolog_highlighting_no_keyword = 1

" add prologKeyword highlights for my own
" syn keyword prologKeyword asserta
" syn keyword prologKeyword assertz

" About japanese input method {{{1

" From kaoriya's vimrc

if has('multi_byte_ime') || has('xim')
  " Cursor color when IME is on.
  highlight CursorIM guibg=Purple guifg=NONE
  set iminsert=0 imsearch=0
endif

" Use vsplit mode {{{1
" http://qiita.com/kefir_/items/c725731d33de4d8fb096

if has('vim_starting') && !has('gui_running') && has('vertsplit')
  function! s:EnableVsplitMode()
    " enable origin mode and left/right margins
    let &t_CS = 'y'
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l\e[999H" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6;69h" ], '/dev/tty', 'a')
  endfunction

  " old vim does not ignore CPR
  BulkMap <special> [nxo] <Esc>[3;9R <Nop>

  " new vim can't handle CPR with direct mapping
  BulkMap <expr> [nxo] [3;3R <SID>EnableVsplitMode()
  " set t_F9=[3;3R
  " BulkMap <expr><noremap> [nxo] <t_F9> <SID>EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

" When editing a file, always jump to the last known cursor position {{{1
"
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).

" From $VIMRUNTIME/defaults.vim

autocmd vimrc BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" Do not load menu("m"), toolbar("T") when "M" option was specified {{{1

" From kaoriya's vimrc

if &guioptions =~# 'M'
  let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif

" Change cursor shape in terminal {{{1
" https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34
" https://ttssh2.osdn.jp/manual/ja/usage/tips/vim.html

if has('vim_starting') && !s:is_win
  " insert mode (bar)
  let &t_SI .= "\e[5 q"
  " replace mode (underline)
  let &t_SR .= "\e[3 q"
  " normal mode (block)
  let &t_EI .= "\e[1 q"
endif

" End. {{{1

function! s:clean() abort
  for cmd in s:macros
    execute 'delcommand' cmd
  endfor
  unlet s:macros
endfunction
call s:clean()

set secure
