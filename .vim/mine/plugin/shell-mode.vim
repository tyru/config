"==================================================
" Name: 
" Version: 0.0.0
" Author:  tyru <tyru.exe+vim@gmail.com>
" Last Change: 2009-04-09.
"
" Usage:
"   COMMANDS:
"       :VimShell
"           Open shell buffer.
"
"   GLOBAL VARIABLES:
"       g:shell_mode_window_height(default:10)
"       g:shell_mode_eol_char(default:'$')
"         if not empty, do 'set listchar=eol:...'
"
"       g:shell_mode_ps1(default:'$ ')
"
"       g:shell_mode_ps2(default:'> ')
"           NOTE: NOT IMPLEMENTED YET.
"
"   TODO:
"       * syntax highlight for filetype shell
"       * when process requires user input, pipe it between real shell and Vim's buffer(difficult)
"
"==================================================

scriptencoding euc-jp

" LOAD ONCE {{{1
if exists('g:loaded_shell_mode') && g:loaded_shell_mode != 0
  finish
endif
let g:loaded_shell_mode = 1
" }}}1

" SAVING CPO {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" SCOPED VARIABLES {{{1
let s:opened_bufnr   = -1
let s:renamed        = 0
let s:history        = []
let s:hist_pos       = 0
let s:shell_cur_line = 0

" }}}1

" GLOBAL VARIABLES {{{1
if !exists( 'g:shell_mode_window_height' ) | let g:shell_mode_window_height = 10 | endif
if !exists( 'g:shell_mode_eol_char' ) | let g:shell_mode_eol_char = '$' | endif
if !exists( 'g:shell_mode_ps1' ) | let g:shell_mode_ps1 = '$ ' | endif
if !exists( 'g:shell_mode_ps2' ) | let g:shell_mode_ps2 = '> ' | endif
" }}}1



" FUNCTION DEFINITIONS {{{1

" -------------------- INITIALIZE BUFFER --------------------

" s:Shell() {{{2
func! s:Shell()
  if s:opened_bufnr != -1 | return | endif

  " create or move to __shell__ buffer
  call s:OpenBuffer()
  " prompt user
  call s:Prompt()
endfunc
" }}}2

" s:OpenBuffer() {{{2
func! s:OpenBuffer()
  if s:opened_bufnr != -1
    call s:MoveToShellBuffer()
  else
    " Open new buffer
    call s:CreateNewBuffer()
    " Set buffer information
    call s:SetBufferSettings()
    " readline-like key map
    call s:MapKeyReadLine()
    " Get buffer number
    let s:opened_bufnr = bufnr( '.' )
  endif
endfunc
" }}}2

" s:CreateNewBuffer() {{{2
func! s:CreateNewBuffer()
  execute g:shell_mode_window_height . 'new'
  file __shell__
endfunc
" }}}2

" s:SetBufferSettings() {{{2
func! s:SetBufferSettings()

  " set eol(listchars)
  if !empty( g:shell_mode_eol_char )
    let listchars = {}
    for i in split( s:orig_listchars, ',' )
      let pair = split( i, ':' )
      let listchars[ pair[0] ] = pair[1]
    endfor
    let listchars['eol'] = g:shell_mode_eol_char

    let str = ''
    for key in keys( listchars )
      let str .= str == '' ?
            \     key .':'. listchars[key] : ','. key .':'. listchars[key]
    endfor
    
    setlocal list
    execute 'setlocal listchars='. str
  endif

  setlocal filetype=shell
"   setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modifiable
endfunc
" }}}2

" TODO: s:MapKeyReadLine() {{{2
func! s:MapKeyReadLine()
  nnoremap <buffer><silent> <CR>      :call <SID>ShellExec()<CR>
  inoremap <buffer><silent> <CR>      <Esc>:call <SID>ShellExec()<CR>
  nnoremap <buffer><silent> j         :call <SID>JumpHistory( 'j' )<CR>
  nnoremap <buffer><silent> k         :call <SID>JumpHistory( 'k' )<CR>
  nnoremap <buffer><silent> <C-n>     :call <SID>JumpHistory( 'j' )<CR>
  nnoremap <buffer><silent> <C-p>     :call <SID>JumpHistory( 'k' )<CR>
  " nnoremap <buffer><silent> <C-r>   :call IncrementalSearch()<CR>

  " 
  nnoremap <buffer><silent> <Down>    <Nop>
  nnoremap <buffer><silent> <Up>      <Nop>
  nnoremap <buffer><silent> <Left>    <Nop>
  nnoremap <buffer><silent> <Right>   <Nop>
  nnoremap <buffer><silent> u         <Nop>
  nnoremap <buffer><silent> U         <Nop>
  nnoremap <buffer><silent> <Plug>o   o
  nnoremap <buffer><silent> <Plug>O   O
  nnoremap <buffer><silent> o         <Nop>
  nnoremap <buffer><silent> O         <Nop>
  nnoremap <buffer><silent> <Plug>h   h
  nnoremap <buffer><silent> h         <Esc>:call <SID>MoveByPromptStr()<CR>
endfunc
" }}}2

func! <SID>MoveByPromptStr()
  " Don't step over the prompt string
  if strlen( g:shell_mode_ps1 ) < col( '.' )
      call feedkeys( "\<Plug>h" )
  endif
endfunc

" -------------------- MANIPULATE WINDOW --------------------

" s:MoveToShellBuffer() {{{2
"     move to __shell__ buffer.
func! s:MoveToShellBuffer()
  if s:opened_bufnr == -1
    echoerr 'No Buffer Found...'
    return
  endif
  execute s:opened_bufnr .'buffer'
endfunc
" }}}2

" s:IsShellBuffer() {{{2
"     return true if current buffer is __shell__ buffer.
func! s:IsShellBuffer()
  if s:opened_bufnr == -1
    return 0
  elseif s:opened_bufnr == bufnr( '.' )
    return 1
  else
    return 0
  endif
endfunc
" }}}2

" -------------------- CALLED IN BUFFER --------------------

" TODO: s:Prompt() {{{2
func! s:Prompt()

  " suspend autocomplpop.vim
  if exists(':AutoComplPopLock')
    :AutoComplPopLock
  endif

  " prompt
  execute 'normal i'. g:shell_mode_ps1

  " resume autocomplpop.vim
  if exists(':AutoComplPopUnlock')
    :AutoComplPopUnlock
  endif


  " enter insert mode
  call feedkeys( "A \<Esc>i", 'n' )
endfunc
" }}}2

" s:ReplaceCurrentLine( line ) {{{2
func! s:ReplaceCurrentLine( line )
endfunc
" }}}2

" <SID>ShellExec() {{{2
func! <SID>ShellExec()

  " get command
  let cmd = substitute( getline( '.' ), '^'. g:shell_mode_ps1, '', '' )  " XXX
  " XXX
  if cmd =~ '^\s\+$' | return | endif  " blank line
  if cmd =~ '^\s*#'  | return | endif  " comment

  " save history
  let s:history += [ cmd ]
  let s:hist_pos = s:hist_pos + 1

  " execute
  let result = system( cmd )

  " paste result
  let save_z = @z
  let @z = result

  " XXX
  let last_ch = strpart( @z, strlen( @z ) - 1 )
  if last_ch == "\n"
    " e.g. echo
    normal "zgp
    execute "normal \<Plug>o"
    execute "normal \<Plug>o"
  else
    execute "normal \<Plug>o"
    normal "zgp
    execute "normal \<Plug>o"
  endif

  call s:Prompt()
  let @z = save_z
endfunc
" }}}2

" s:DestroyBuffer() {{{2
"     close buffer and delete it.
func! s:DestroyBuffer()
  if !s:IsShellBuffer() | return | endif

  call s:MoveToShellBuffer()
  bdelete
  let s:opened_bufnr = -1
endfunc
" }}}2

" TODO: <SID>JumpHistory( key ) {{{2
func! <SID>JumpHistory( key )
  if empty( s:history )
    call s:Warn( 'No history.' )
    return
  endif

  if a:key == 'j'
    let hist_line = get( s:history, s:hist_pos + 1, '#' )
  elseif a:key == 'k'
    let hist_line = get( s:history, s:hist_pos - 1, '#' )
  endif

  if hist_line == '#'
    call s:Warn( 'No history.' )
    return
  endif

  echomsg 'hist_line:['. hist_line .']'
  call s:ReplaceCurrentLine( s:history[s:hist_pos] )
endfunc
" }}}2

" s:PreventRename() {{{2
"     this may be called by autocmd.
func! s:PreventRename( when )
  if !s:IsShellBuffer() | return | endif

  if a:when == 'Pre'
    call s:Warn( "Don't rename __shell__ buffer!!" )
    let s:renamed = 1
  elseif a:when == 'Post'
    if s:renamed
      file __shell__
      let s:renamed = 0
    endif
  endif
endfunc
" }}}2

" -------------------- OTHERS --------------------

" s:RangeOK( lis, pos ) {{{2
func! s:RangeOK( lis, pos )
  return 0 < a:pos && a:pos < len( lis )
endfunc
" }}}2

" -------------------- DEBUGGING --------------------

" s:Warn( msg ) {{{3
func! s:Warn( msg )
  echohl WarningMsg
  echo a:msg
  echohl None
endfunc
" }}}3

" }}}2

" }}}1

" INITIALIZE {{{1
let s:orig_listchars = &listchars
" }}}1

" COMMANDS {{{1
command!  VimShell        call s:Shell()
" }}}1

" AUTOCOMMANDS {{{1
autocmd  BufUnload   __shell__  call s:DestroyBuffer()
autocmd  BufFilePre  __shell__  call s:PreventRename( 'Pre' )
autocmd  BufFilePost *          call s:PreventRename( 'Post' )
" }}}1


" RESTORE CPO {{{1
let &cpo = s:save_cpo
" }}}1

" vim: foldmethod=marker : fen :

