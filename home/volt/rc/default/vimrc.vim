" Don't set scriptencoding before 'encoding' option is set!
" scriptencoding utf-8

" vim:set et fen fdm=marker:

" See also: ~/.vimrc or ~/_vimrc

let s:is_win = has('win32')
let s:is_wsl = has('unix') && isdirectory('/mnt/c/')

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
" set complete=.,w,b,u,t,i,d,k,kspell
" set complete=.
set concealcursor=nvic
set copyindent
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
set nrformats-=octal
set number
set preserveindent
set pumheight=20
set scrolloff=5
set sessionoptions-=options
set shiftround
set shiftwidth=0
set shortmess+=aI
set shortmess-=S
set smartcase
set softtabstop=-1
set t_Co=256
set tabstop=2
set textwidth=80
set whichwrap=b,s
set wildmenu
set wildmode=longest,list,full

if has('path_extra')
  set tags+=.;
  set tags+=tags;
  set path+=.;
endif

" Assumption: Trailing spaces are already highlighted and noticeable.
" set listchars=tab:>.,extends:>,precedes:<,trail:-,eol:$
set listchars=tab:>.,extends:>,precedes:<,trail:-

" Swapfile
if 1
  " Use swapfile.
  set swapfile
  set directory=$MYVIMDIR/info/swap//
  silent! call mkdir(substitute(&directory, '//$', '', ''), 'p')
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
silent! call mkdir(substitute(&backupdir, '//$', '', ''), 'p')

" Title
set title
let &titlestring = '%{getcwd()}'

" guitablabel {{{

let &guitablabel = '%{MyTabLabel(v:lnum)}'

function! MyTabLabel(tabnr)
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

  if bufname ==# ''
    let label = '[No Name]'
  else
    let label = bufname
  endif
  return label . (modified ? '[+]' : '')
endfunction

" }}}

" statusline {{{

set laststatus=2
let &statusline = 
\    '%f%( [%M%R%H%W]%)%( [%{&ft}]%) %{&fenc}/%{&ff}'
\ .  '%( %{line(".")}/%{line("$")}%)'

" }}}

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
set novisualbell
set t_vb=

" Restore screen
set norestorescreen
set t_ti=
set t_te=

" Undo persistence
if has('persistent_undo')
  set undofile
  set undodir=$MYVIMDIR/info/undo
  silent! call mkdir(&undodir, 'p')
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
  colorscheme spring-night
  " https://github.com/rhysd/vim-color-spring-night/issues/7
  Lazy hi SignColumn term=NONE guibg=#ffffff ctermbg=255
  " for diff
  Lazy hi FoldColumn term=NONE guibg=#ffffff ctermbg=255
catch /E185/
  colorscheme desert
endtry

" too annoying
" highlight ColorColumn ctermfg=12 guifg=Red ctermbg=NONE guibg=NONE

" Mappings, Abbreviations {{{1

" General prefix keys {{{2

BulkMap [nxo] <Space> <Plug>(vimrc:prefix:excmd)
" fallback
BulkMap <noremap> [nxo] <Plug>(vimrc:prefix:excmd) <Space>

let g:mapleader = '\'
let g:maplocalleader = '\'
nnoremap <Leader> <Nop>
nnoremap <LocalLeader> <Nop>

" Operators {{{2

" Do not destroy noname register.
BulkMap <noremap> [nxo] x "_x

" Text-objects {{{2

onoremap gv :<C-u>normal! gv<CR>



" Motions {{{2

" Go to the next/previous line whose first character is not space.
BulkMap [nxo] [k <SID>(go-prev-first-non-blank)
BulkMap [nxo] ]k <SID>(go-next-first-non-blank)
BulkMap <noremap><expr> [nx] <SID>(go-prev-first-non-blank) <SID>first_non_blank('Wbn')
BulkMap <noremap><expr> [o]  <SID>(go-prev-first-non-blank) 'V' . <SID>first_non_blank('Wbn')
BulkMap <noremap><expr> [nx] <SID>(go-next-first-non-blank) <SID>first_non_blank('Wn')
BulkMap <noremap><expr> [o]  <SID>(go-next-first-non-blank) 'V' . <SID>first_non_blank('Wn')

function! s:first_non_blank(flags) abort
  let lnum = search('^\S', a:flags)
  return lnum > 0 ? lnum . 'G' : ''
endfunction

BulkMap <noremap> [nxo] gp %

" }}}

" Do not scroll over the last line
" http://itchyny.hatenablog.com/entry/2016/02/02/210000
BulkMap <noremap><expr> [nxo] <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')

" At the first/last screen row, scroll also lines not screen view
BulkMap <noremap><expr> [nxo] <C-y> line('w0') <= 1         ? 'k' : "\<C-y>"
BulkMap <noremap><expr> [nxo] <C-e> line('w$') >= line('$') ? 'j' : "\<C-e>"

" Fold {{{2

nmap z <Plug>(vimrc:prefix:fold)
xmap z <Plug>(vimrc:prefix:fold)
omap z <Plug>(vimrc:prefix:fold)
" fallback
nnoremap <Plug>(vimrc:prefix:fold) z
xnoremap <Plug>(vimrc:prefix:fold) z
onoremap <Plug>(vimrc:prefix:fold) z

" Open only current line's fold.
nnoremap <Plug>(vimrc:prefix:fold)<Space> zMzvzz

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

" }}}


" Set cwd to current file's directory
nnoremap <Plug>(vimrc:prefix:excmd)cd   :<C-u>lcd %:h<CR>

" 'Y' to yank till the end of line.
nnoremap Y    y$

" Moving tabs
if has('tabsidebar')
  nnoremap <silent> <Up>      :<C-u>call <SID>tabmove(-v:count1)<CR>
  nnoremap <silent> <Down>    :<C-u>call <SID>tabmove(+v:count1)<CR>
else
  nnoremap <silent> <Left>    :<C-u>call <SID>tabmove(-v:count1)<CR>
  nnoremap <silent> <Right>   :<C-u>call <SID>tabmove(+v:count1)<CR>
endif

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

" Terminal {{{2

tnoremap <C-w><Space> <C-w>N

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
      if getbufvar(bufnr, '&buftype') isnot# 'terminal'
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

nnoremap <Plug>(vimrc:prefix:excmd)oh  :<C-u>setlocal hlsearch! hlsearch?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oi  :<C-u>setlocal ignorecase! ignorecase?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)op  :<C-u>setlocal paste! paste?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ow  :<C-u>setlocal wrap! wrap?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oe  :<C-u>setlocal expandtab! expandtab?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ol  :<C-u>setlocal list! list?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)on  :<C-u>setlocal number! number?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)om  :<C-u>setlocal modeline! modeline?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ot  :<C-u>call <SID>toggle_option_list([2, 4, 8], "tabstop")<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofc :<C-u>call <SID>toggle_option_list(['', 'all'], 'foldclose')<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofm :<C-u>call <SID>toggle_option_list(['manual', 'marker', 'indent'], 'foldmethod')<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofw :<C-u>call <SID>toggle_winfix()<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oT  :<C-u>call <SID>toggle_terminal_modes()<CR>
nnoremap <Plug>(vimrc:prefix:excmd)od  :<C-u>call <SID>toggle_diff()<CR>

" <Space>[hjkl] for <C-w>[hjkl] {{{2

nnoremap <silent> <Space>j <C-w>j
nnoremap <silent> <Space>k <C-w>k
nnoremap <silent> <Space>h <C-w>h
nnoremap <silent> <Space>l <C-w>l

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

" Duplicate terminal buffer {{{2

" Duplicate current lines to another plain buffer,
" to see the output without stopping command I/O.
tnoremap <C-w>y <C-w>:<C-u>call <SID>dup_term_buf()<CR>

" TODO dump also scrolled lines
function! s:dup_term_buf() abort
  let file = tempname()
  call term_dumpwrite('', file)
  call term_dumpload(file)
  setlocal nolist
  call delete(file)
endfunction

" Centering display position after certain commands {{{2

nnoremap <SID>(centering-display) zvzz
xnoremap <SID>(centering-display) zvzz

" Make *, gn command consistent
" https://github.com/vim-jp/issues/issues/1094
function! s:star_smartcase(forward) abort
  let search = (a:forward ? '/' : '?')
  let cw = expand('<cword>')
  let case = (&smartcase && cw =~# '[A-Z]' ? '\C' : '')
  return search . case . '\<' . cw . '\>' . "\<CR>"
endfunction

nnoremap <expr> <SID>(smart-*) <SID>star_smartcase(1)
nnoremap <expr> <SID>(smart-#) <SID>star_smartcase(0)

nmap * <SID>(smart-*)<SID>(centering-display)
nmap # <SID>(smart-#)<SID>(centering-display)

nnoremap <script> gd gd<SID>(centering-display)
nnoremap <script> gD gD<SID>(centering-display)

nmap n n<SID>(centering-display)
xmap n n<SID>(centering-display)
nmap N N<SID>(centering-display)
xmap N N<SID>(centering-display)

" Use gF (search line number after filename) {{{2

nnoremap gf gF
nnoremap <C-w>f <C-w>F

" FileType & Syntax {{{1

" Must be after 'runtimepath' setting!
syntax enable

autocmd vimrc FileType * call s:on_filetype()

function! s:on_filetype()
  if &omnifunc ==# ''
    setlocal omnifunc=syntaxcomplete#Complete
  endif
  set formatoptions+=j
endfunction

autocmd vimrc Syntax * call s:on_syntax()

function! s:on_syntax() abort
  call matchadd('TODO', '\<TODO\|FIXME\|XXX\|NOTE\>')
endfunction

" Commands {{{1

command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis

command! -bar -nargs=? Expand call vimrc#cmd_expand#call(<q-args>)

command! -bar -nargs=+ -complete=file Glob echo glob(<q-args>, 1)
command! -bar -nargs=+ -complete=file GlobPath echo globpath(&rtp, <q-args>, 1)

command! -bar SynNames call vimrc#cmd_synnames#call()

command! -bar -nargs=* Ctags call vimrc#cmd_ctags#call(<q-args>)

command! -bar -bang -nargs=1 -complete=event WatchAutocmd
\   call vimrc#cmd_watch_autocmd#call(<q-args>, <bang>0)

" http://nanasi.jp/articles/vim/kwbd_vim.html
command! -bar Kwbd execute 'enew | bw' bufnr("%")

" Enable/Disable 'scrollbind', 'cursorbind' options.
command! -bar ScrollbindEnable  call vimrc#cmd_scrollbind#enable()
command! -bar ScrollbindDisable call vimrc#cmd_scrollbind#disable()
command! -bar ScrollbindToggle  call vimrc#cmd_scrollbind#toggle()

command! -bar ResetHelpBuffer
\   setlocal noro modifiable buftype= list noet

command! -nargs=+ GitGrep call vimrc#cmd_git_grep#call(<q-args>, 0)
command! -nargs=+ LGitGrep call vimrc#cmd_git_grep#call(<q-args>, 1)

" Add current line to quickfix (Use quickfix as bookmark list)
command! -bar -range QFAddLine <line1>,<line2>call vimrc#cmd_qfaddline#add()

if s:is_wsl
  command! -bar -range=% Clip <line1>,<line2>call s:cmd_clip()

  function! s:cmd_clip() range abort
    let windir = s:windir()
    if windir is# ''
      echoerr 'windows directory not found'
      return
    endif
    let clip = join([windir, 'System32', 'clip.exe'], '/')
    let str = join(getline(a:firstline, a:lastline), "\n")
    call system(clip, str)
  endfunction

  function! s:windir() abort
    return get(filter([
    \ '/mnt/c/Windows',
    \ '/mnt/c/WINDOWS',
    \], {_,p -> isdirectory(p)}), 0, '')
  endfunction
endif

command! -bar EmojiTest tabedit https://unicode.org/Public/emoji/12.0/emoji-test.txt

" Quickfix {{{1
autocmd vimrc QuickfixCmdPost [l]*  call vimrc#quickfix_cmdpost#call(1)
autocmd vimrc QuickfixCmdPost [^l]* call vimrc#quickfix_cmdpost#call(0)


" Terminal {{{1
autocmd vimrc TerminalOpen *  call s:setup_terminal()

function! s:setup_terminal() abort
  setlocal nowrap
endfunction


" Configurations for Vim runtime plugins {{{1

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

" Exit diff mode automatically {{{1
" https://hail2u.net/blog/software/vim-turn-off-diff-mode-automatically.html

" Turn off diff mode automatically
autocmd vimrc WinEnter *
\ if (winnr('$') == 1) &&
\    (getbufvar(winbufnr(0), '&diff')) == 1 |
\     diffoff                               |
\ endif

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
  " BulkMap <expr> [nxo] [3;3R <SID>EnableVsplitMode()
  set t_F9=[3;3R
  BulkMap <expr><noremap> [nxo] <t_F9> <SID>EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

" When editing a file, always jump to the last known cursor position {{{1
"
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).

" From defaults.vim (:help defaults.vim)

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

if has('vim_starting')
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
  for name in keys(s:)
    unlet s:[name]
  endfor
endfunction
call s:clean()

set secure
