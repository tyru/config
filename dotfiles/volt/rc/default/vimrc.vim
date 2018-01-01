" Don't set scriptencoding before 'encoding' option is set!
" scriptencoding utf-8

" vim:set et fen fdm=marker:

" See also: ~/.vimrc or ~/_vimrc

let s:is_win = has('win16') || has('win32') || has('win64') || has('win95')
let s:is_msys = has('win32unix') && !has('gui_running')
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


" Basic {{{

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

" }}}
" Encoding {{{
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

" }}}
" Options {{{

" indent
set tabstop=2
set shiftwidth=2
set softtabstop=-1
set autoindent
set expandtab
set shiftround
set copyindent
set preserveindent
if exists('+breakindent')
  set breakindent
  set breakindentopt=sbr
  set showbreak=<
endif

" search
set hlsearch
set incsearch
set smartcase
set ignorecase

" Aesthetic options
set list
" Assumption: Trailing spaces are already highlighted and noticeable.
" set listchars=tab:>.,extends:>,precedes:<,trail:-,eol:$
set listchars=tab:>.,extends:>,precedes:<,trail:-
set display=lastline
set t_Co=256
set nonumber
set showcmd

" command-line
set cmdheight=1
set wildmenu
set wildmode=longest,list,full

" completion
set complete=.,w,b,u,t,i,d,k,kspell
set pumheight=20

" tags
if has('path_extra')
  set tags+=.;
  set tags+=tags;
  set path+=.;
endif

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

" title
set title
let &titlestring = '%{getcwd()}'

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

let &guitablabel = '%{MyTabLabel(v:lnum)}'

" statusline
set laststatus=2
function! s:statusline() "{{{
  let s = '[%f]%( [%M%R%H%W]%)%( [%{&ft}]%) %{&fenc}/%{&ff}'
  let s .= '%('

  let s .= '%( %{line(".")}/%{line("$")}%)'

  let s .= '%)'

  return s
endfunction "}}}
let &statusline = s:statusline()

" 'guioptions' flags are set on FocusGained
" because "cmd.exe start /min" doesn't work.
" (always start up as foreground)
augroup vimrc-guioptions
  autocmd!
augroup END
if has('vim_starting')
  command! -nargs=* AutocmdWhenVimStarting    autocmd FocusGained vimrc-guioptions * <args>
  command! -nargs=* AutocmdWhenVimStartingEnd autocmd FocusGained vimrc-guioptions * autocmd! vimrc-guioptions
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
AutocmdWhenVimStarting set guioptions-=e
AutocmdWhenVimStarting set guioptions+=h
AutocmdWhenVimStarting set guioptions+=m
AutocmdWhenVimStarting set guioptions-=L
AutocmdWhenVimStarting set guioptions-=T
AutocmdWhenVimStartingEnd

delcommand AutocmdWhenVimStarting
delcommand AutocmdWhenVimStartingEnd

" convert "\\" to "/" on win32 like environment
if exists('+shellslash')
  set shellslash
endif

" visual bell
set novisualbell
autocmd vimrc VimEnter * set t_vb=

" restore screen
set norestorescreen
set t_ti=
set t_te=

" timeout
set notimeout

" cursor behavior in insertmode
set whichwrap=b,s
set backspace=indent,eol,start
set formatoptions=mMcroqnl2
" 7.3.541 or later
set formatoptions+=j

" undo-persistence
if has('persistent_undo')
  set undofile
  set undodir=$MYVIMDIR/info/undo
  silent! call mkdir(&undodir, 'p')
endif

if has('conceal')
  set concealcursor=nvic
endif

" jvgrep
if executable('jvgrep')
  set grepprg=jvgrep
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
set keywordprg=
set diffopt+=vertical
set history=1000
set nrformats-=octal
set shortmess+=aI
" set switchbuf=useopen,usetab
set textwidth=80
set matchpairs+=<:>

" }}}
" ColorScheme {{{

colorscheme desert
" colorscheme evening
" colorscheme molokai

" too annoying
highlight ColorColumn ctermfg=12 guifg=Red ctermbg=NONE guibg=NONE

" }}}
" Mappings, Abbreviations {{{

" Set up general prefix keys. {{{

nmap <Space> <Plug>(vimrc:prefix:excmd)
xmap <Space> <Plug>(vimrc:prefix:excmd)
omap <Space> <Plug>(vimrc:prefix:excmd)
" fallback
nnoremap <Plug>(vimrc:prefix:excmd) <Space>
xnoremap <Plug>(vimrc:prefix:excmd) <Space>
onoremap <Plug>(vimrc:prefix:excmd) <Space>

nmap ; <Plug>(vimrc:prefix:operator)
xmap ; <Plug>(vimrc:prefix:operator)
omap ; <Plug>(vimrc:prefix:operator)
" fallback
nnoremap <Plug>(vimrc:prefix:operator) ;
xnoremap <Plug>(vimrc:prefix:operator) ;
onoremap <Plug>(vimrc:prefix:operator) ;

let g:mapleader = ';'
nnoremap <Leader> <Nop>

nnoremap ;; ;
nnoremap ,, ,

let g:maplocalleader = '\'
nnoremap <LocalLeader> <Nop>

" }}}

" map {{{
" operator {{{

" Copy to clipboard or primary.
nnoremap <Plug>(vimrc:prefix:operator)y "+y
xnoremap <Plug>(vimrc:prefix:operator)y "+y
onoremap <Plug>(vimrc:prefix:operator)y "+y
nnoremap <Plug>(vimrc:prefix:operator)Y "*y
xnoremap <Plug>(vimrc:prefix:operator)Y "*y
onoremap <Plug>(vimrc:prefix:operator)Y "*y

" Do not destroy noname register.
nnoremap x "_x
xnoremap x "_x
onoremap x "_x

nnoremap <Plug>(vimrc:prefix:operator)e =
xnoremap <Plug>(vimrc:prefix:operator)e =
onoremap <Plug>(vimrc:prefix:operator)e =

" }}}
" textobj {{{

onoremap gv :<C-u>normal! gv<CR>

" }}}
" motion {{{

" FIXME: Does not work in visual mode.
nnoremap ]k :<C-u>call search('^\S', 'Ws')<CR>
nnoremap [k :<C-u>call search('^\S', 'Wsb')<CR>

nnoremap gp %
xnoremap gp %
onoremap gp %

" }}}

nnoremap H ^
xnoremap H ^
onoremap H ^
nnoremap L $
xnoremap L $
onoremap L $

" http://itchyny.hatenablog.com/entry/2016/02/02/210000
nnoremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
xnoremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
onoremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')

nnoremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
xnoremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
onoremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')

nnoremap <expr> <C-y> (line('w0') <= 1         ? 'k' : "\<C-y>")
xnoremap <expr> <C-y> (line('w0') <= 1         ? 'k' : "\<C-y>")
onoremap <expr> <C-y> (line('w0') <= 1         ? 'k' : "\<C-y>")

nnoremap <expr> <C-e> (line('w$') >= line('$') ? 'j' : "\<C-e>")
xnoremap <expr> <C-e> (line('w$') >= line('$') ? 'j' : "\<C-e>")
onoremap <expr> <C-e> (line('w$') >= line('$') ? 'j' : "\<C-e>")

" }}}
" nmap {{{

nmap z <Plug>(vimrc:prefix:fold)
xmap z <Plug>(vimrc:prefix:fold)
omap z <Plug>(vimrc:prefix:fold)
" fallback
nnoremap <Plug>(vimrc:prefix:fold) z
xnoremap <Plug>(vimrc:prefix:fold) z
onoremap <Plug>(vimrc:prefix:fold) z

" Open only current line's fold.
nnoremap <Plug>(vimrc:prefix:fold)<Space> zMzvzz

" Folding mappings easy to remember.
nnoremap <Plug>(vimrc:prefix:fold)l zo
nnoremap <Plug>(vimrc:prefix:fold)h zc

" +virtualedit
if has('virtualedit')
  nnoremap <expr> i col('$') is col('.') ? 'A' : 'i'
  nnoremap <expr> a col('$') is col('.') ? 'A' : 'a'

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

  nnoremap <expr> p <SID>paste_characterwise_nicely()
  " }}}
endif

nnoremap <Plug>(vimrc:prefix:excmd)me :<C-u>messages<CR>
nnoremap <Plug>(vimrc:prefix:excmd)di :<C-u>display<CR>

nnoremap gl :<C-u>cnext<CR>
nnoremap gh :<C-u>cNext<CR>

nnoremap <Plug>(vimrc:prefix:excmd)ct :<C-u>tabclose<CR>

nnoremap <Plug>(vimrc:prefix:excmd)tl :<C-u>tabedit<CR>
nnoremap <Plug>(vimrc:prefix:excmd)th :<C-u>tabedit<CR>:execute 'tabmove' (tabpagenr() isnot 1 ? tabpagenr() - 2 : '')<CR>

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


" See also rooter.vim settings.
nnoremap ,cd       :<C-u>cd %:p:h<CR>

" 'Y' to yank till the end of line.
nnoremap Y    y$

" Moving tabs
nnoremap <silent> <Left>    :<C-u>-tabmove<CR>
nnoremap <silent> <Right>   :<C-u>+tabmove<CR>

" Execute most used command quickly {{{
nnoremap <Plug>(vimrc:prefix:excmd)w      :<C-u>update<CR>
nnoremap <silent> <Plug>(vimrc:prefix:excmd)q      :<C-u>call <SID>vim_never_die_close()<CR>

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

" Edit/Apply .vimrc quickly
nnoremap <Plug>(vimrc:prefix:excmd)ev     :<C-u>call <SID>edit_vimrc()<CR>

function! s:edit_vimrc() abort
  if filereadable(expand('~/volt/rc/default/vimrc.vim'))
    edit ~/volt/rc/default/vimrc.vim
  elseif $MYVIMRC != ''
    edit $MYVIMRC
  endif
endfunction

nnoremap <C-]> :<C-u>call <SID>tagjump()<CR>

function! s:tagjump() abort
  try
    execute "normal! \<C-]>"
  catch
    Ctags
    execute "normal! \<C-]>"
  endtry
endfunction

" Cmdwin {{{
set cedit=<C-l>
function! s:cmdwin_enter()
  startinsert!
  setlocal nonumber
endfunction
autocmd vimrc CmdwinEnter * call s:cmdwin_enter()

" }}}
" Toggle options {{{
function! s:advance_state(states, elem) "{{{
  let curidx = index(a:states, a:elem)
  let curidx = (curidx is -1 ? 0 : curidx)
  let curidx = (curidx + 1 >=# len(a:states) ? 0 : curidx + 1)
  return a:states[curidx]
endfunction "}}}

function! s:toggle_option_list(states, optname) "{{{
  let varname = '&' . a:optname
  call setbufvar(
  \   '%',
  \   varname,
  \   s:advance_state(
  \       a:states,
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

nnoremap <Plug>(vimrc:prefix:excmd)oh  :<C-u>setlocal hlsearch! hlsearch?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oi  :<C-u>setlocal ignorecase! ignorecase?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)op  :<C-u>setlocal paste! paste?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ow  :<C-u>setlocal wrap! wrap?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)oe  :<C-u>setlocal expandtab! expandtab?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ol  :<C-u>setlocal list! list?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)on  :<C-u>setlocal number! number?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)om  :<C-u>setlocal modeline! modeline?<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ot  :<C-u>execute 'silent call <SID>toggle_option_list([2, 4, 8], "tabstop")' <Bar>
\                       let &l:shiftwidth = &l:tabstop <Bar>
\                       redraw <Bar>
\                       echo 'tabstop=' . &tabstop . ' shiftwidth=' . &shiftwidth<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofc :<C-u>call <SID>toggle_option_list(['', 'all'], 'foldclose')<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofm :<C-u>call <SID>toggle_option_list(['manual', 'marker', 'indent'], 'foldmethod')<CR>
nnoremap <Plug>(vimrc:prefix:excmd)ofw :<C-u>call <SID>toggle_winfix()<CR>

" }}}
" <Space>[hjkl] for <C-w>[hjkl] {{{
nnoremap <silent> <Space>j <C-w>j
nnoremap <silent> <Space>k <C-w>k
nnoremap <silent> <Space>h <C-w>h
nnoremap <silent> <Space>l <C-w>l
" }}}
" Moving between tabs {{{
nnoremap <silent> <C-n> gt
nnoremap <silent> <C-p> gT
" }}}
" "Use one tabpage per project" project {{{
" :SetTabName - Set tab's title {{{

nnoremap <silent> g<C-t> :<C-u>SetTabName<CR>
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
    " Adding ! will update tabline too.
    redraw!
  endif
endfunction "}}}
" }}}
" }}}
" Make <M-Space> same as ordinal applications on MS Windows {{{
if has('gui_running') && s:is_win
  nnoremap <M-Space> :<C-u>simalt ~<CR>
endif
" }}}
" }}}
" vmap {{{

xnoremap <silent> y y:<C-u>call <SID>remove_trailing_spaces_blockwise()<CR>

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


" Tab key indent
" NOTE: <S-Tab> is GUI only.
xnoremap <Tab> >gv
xnoremap <S-Tab> <gv

" Space key indent (inspired by sakura editor)
xnoremap <Space><Space> <Esc>:call <SID>space_indent(0)<CR>gv
xnoremap <Space><BS> <Esc>:call <SID>space_indent(1)<CR>gv
xmap <Space><S-Space> <Space><BS>

function! s:space_indent(leftward)
  let save = [&l:expandtab, &l:shiftwidth]
  setlocal expandtab shiftwidth=1
  execute 'normal!' (a:leftward ? 'gv<<' : 'gv>>')
  let [&l:expandtab, &l:shiftwidth] = save
endfunction

" }}}
" map! {{{
inoremap <C-f> <Right>
cnoremap <C-f> <Right>
inoremap <expr> <C-b> col('.') ==# 1 ? "\<C-o>k\<End>" : "\<Left>"
cnoremap <C-b> <Left>
inoremap <C-a> <Home>
cnoremap <C-a> <Home>
inoremap <C-e> <End>
cnoremap <C-e> <End>
inoremap <C-d> <Del>
cnoremap <expr> <C-d> getcmdpos()-1<len(getcmdline()) ? "\<Del>" : ""
" Emacs like kill-line.
inoremap <expr> <C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
cnoremap        <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

" }}}
" imap {{{

" make <C-w> and <C-u> undoable.
" NOTE: <C-u> may be already mapped by $VIMRUNTIME/vimrc_example.vim
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" completion {{{

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

" }}}
" }}}
" cmap {{{
if &wildmenu
  cnoremap <C-f> <Space><BS><Right>
  cnoremap <C-b> <Space><BS><Left>
endif

cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" }}}


" Centering display position after certain commands {{{

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

" }}}

" }}}
" FileType & Syntax {{{

" Must be after 'runtimepath' setting!
syntax enable

" FileType {{{

function! s:load_filetype() "{{{
  if &omnifunc == ""
    setlocal omnifunc=syntaxcomplete#Complete
  endif
  if &formatoptions !~# 'j'
    " 7.3.541 or later
    set formatoptions+=j
  endif
endfunction "}}}

autocmd vimrc FileType * call s:load_filetype()

" }}}

" }}}
" Commands {{{

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

if s:is_win && executable('bash')
  command! -bar Bash terminal C:/Windows/system32/bash.exe ~ -l
else
  command! -bar Bash echoerr 'Cannot invoke bash.exe'
endif

if executable('/mnt/c/WINDOWS/System32/clip.exe')
  command! -bar Clip !cat "%" | /mnt/c/WINDOWS/System32/clip.exe
else
  command! -bar Clip echoerr 'Cannot invoke clip.exe'
endif

" }}}
" Quickfix {{{
autocmd vimrc QuickfixCmdPost [l]*  call vimrc#quickfix_cmdpost#call(1)
autocmd vimrc QuickfixCmdPost [^l]* call vimrc#quickfix_cmdpost#call(0)

" }}}
" Configurations for Vim runtime plugins {{{

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
" syntax/sh.vim {{{
let g:is_bash = 1
" }}}

" }}}
" Misc. {{{

" About japanese input method {{{

" From kaoriya's vimrc

if has('multi_byte_ime') || has('xim')
  " Cursor color when IME is on.
  highlight CursorIM guibg=Purple guifg=NONE
  set iminsert=0 imsearch=0
endif
" }}}

" Exit diff mode automatically {{{
" https://hail2u.net/blog/software/vim-turn-off-diff-mode-automatically.html

augroup vimrc-diff-autocommands
  autocmd!

  " Turn off diff mode automatically
  autocmd vimrc WinEnter *
  \ if (winnr('$') == 1) &&
  \    (getbufvar(winbufnr(0), '&diff')) == 1 |
  \     diffoff                               |
  \ endif
augroup END
" }}}

" Block cursor in MSYS2 console {{{
if s:is_msys
  let &t_ti.="\e[1 q"
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
  let &t_te.="\e[0 q"
endif
" }}}

" Use vsplit mode {{{
" http://qiita.com/kefir_/items/c725731d33de4d8fb096

if has("vim_starting") && !has('gui_running') && has('vertsplit')
  function! EnableVsplitMode()
    " enable origin mode and left/right margins
    let &t_CS = "y"
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l\e[999H" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6;69h" ], "/dev/tty", "a")
  endfunction

  " old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>

  " new vim can't handle CPR with direct mapping
  " map <expr> [3;3R EnableVsplitMode()
  set t_F9=[3;3R
  map <expr> <t_F9> EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

" }}}

" Enter Terminal-Job/Terminal-Normal mode on WinLeave/WinEnter {{{

" Enter Terminal-Job mode when leaving terminal window
function! s:term_winleave() abort
  if &buftype ==# 'terminal' &&
  \   term_getstatus(bufnr('')) =~# 'normal'
    set eventignore=all
    call feedkeys("\<C-w>\<C-p>GA\<C-w>\<C-p>\<C-w>:set ei=\<CR>\<C-l>", 'n')
  endif
endfunction

" Enter Terminal-Normal mode when entering terminal window
"
" NOTE: segfault problem was fixed by 8.0.0968
" https://github.com/vim/vim/issues/1989
function! s:term_winenter() abort
  if &buftype ==# 'terminal' &&
  \   term_getstatus(bufnr('')) !~# 'normal'
    call feedkeys("\<C-w>N", 'n')
  endif
endfunction

augroup vimrc-force-terminal-job-mode
  autocmd!
  " autocmd WinLeave * call s:term_winleave()
  " autocmd WinEnter * call s:term_winenter()
augroup END

" }}}

" When editing a file, always jump to the last known cursor position. {{{
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).

" From defaults.vim (:help defaults.vim)

autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
" }}}

" Do not load menu("m"), toolbar("T") when "M" option was specified {{{

" From kaoriya's vimrc

if &guioptions =~# 'M'
  let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif
" }}}

" Change cursor shape in terminal {{{
" https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34
if has('vim_starting')
    let &t_SI .= "\e[6 q"
    let &t_EI .= "\e[2 q"
    let &t_SR .= "\e[4 q"
endif
" }}}

" }}}
" End. {{{

set secure
" }}}
