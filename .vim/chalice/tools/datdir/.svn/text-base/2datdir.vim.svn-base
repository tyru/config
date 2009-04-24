" vim:set ts=8 sts=2 sw=2 tw=0 fdm=marker:
"
" 2datdir.vim - datdir transition tool 
"
" Last Change: 12-Feb-2003.
" Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

function! s:Rename(fromfile, tofile)
  let basepath = substitute(matchstr(a:tofile, '\m^.*[/\\]'), '\m[/\\]$', '', '')
  if basepath.'X' !=# 'X' && AL_mkdir(basepath) && filewritable(basepath)
    call rename(a:fromfile, a:tofile)
  endif
endfunction

function! s:HandleDat(filenum, filepath, host, board, dat)
  let tofile = {g:chalice_sid}GetPath_Datdir_Dat(a:host, a:board, a:dat)
  "call AL_echokv('dat tofile', tofile)
  call s:Rename(a:filepath, tofile)
endfunction

function! s:HandleKako(filenum, filepath, host, board, dat)
  let tofile = {g:chalice_sid}GetPath_Datdir_Kako(a:host, a:board, a:dat)
  "call AL_echokv('kako tofile', tofile)
  call s:Rename(a:filepath, tofile)
endfunction

function! s:HandleAbone(filenum, filepath, host, board, dat)
  let tofile = {g:chalice_sid}GetPath_Datdir_Abone(a:host, a:board, a:dat)
  "call AL_echokv('abone tofile', tofile)
  call s:Rename(a:filepath, tofile)
endfunction

function! s:HandleSubject(filenum, filepath, host, board)
  let tofile = {g:chalice_sid}GetPath_Datdir_Subject(a:host, a:board)
  "call AL_echokv('subject tofile', tofile)
  call s:Rename(a:filepath, tofile)
endfunction

function! s:HandleFile(filenum, filepath)
  let filename = matchstr(a:filepath, '\m[^/\\]*$')
  if filename.'X' ==# 'X'
    return 0
  endif
  let mx1 = '^subject_\(.\+\)_\([^_]\+\)$'
  let mx2 = '^\(dat\|kako_dat\|abonedat\)_\(.\+\)_\([^_]\+\)_\(\d\+\)$'
  if filename =~# mx1
    let host = AL_sscan(filename, mx1, '\1')
    let board = AL_sscan(filename, mx1, '\2')
    "call AL_echokv('['.a:filenum.']', ' type:subject'.' host:'.host.' board:'.board)
    call s:HandleSubject(a:filenum, a:filepath, host, board)
  elseif filename =~# mx2
    let type = AL_sscan(filename, mx2, '\1')
    let host = AL_sscan(filename, mx2, '\2')
    let board = AL_sscan(filename, mx2, '\3')
    let dat = AL_sscan(filename, mx2, '\4')
    "call AL_echokv('['.a:filenum.']', ' type:'.type.' host:'.host.' board:'.board.' dat:'.dat)
    if type ==# 'dat'
      call s:HandleDat(a:filenum, a:filepath, host, board, dat)
    elseif type ==# 'kako_dat'
      call s:HandleKako(a:filenum, a:filepath, host, board, dat)
    elseif type ==# 'abonedat'
      call s:HandleAbone(a:filenum, a:filepath, host, board, dat)
    endif
  endif
endfunction

function! s:DoTransit()
  let cache_dir = Chalice_GetCacheDir()
  "call AL_echokv('cache_dir', cache_dir)
  call AL_echo('Scanning chalice cache directory... ', 'WarningMsg')
  let filelist = glob(cache_dir.'*')
  call AL_echon('DONE', 'Special')
  let filenum = 0
  let maxnum = AL_countlines(filelist)
  call AL_echo('Now transitting to DATDIR... ', 'WarningMsg')
  while filelist.'X' !=# 'X'
    let curfile = AL_firstline(filelist)
    let filelist = AL_lastlines(filelist)
    call s:HandleFile(filenum, curfile)
    if filenum % 100 == 0
      call AL_echo('    ')
      call AL_echon(filenum.'/'.maxnum, 'Special')
    endif
    let filenum = filenum + 1
  endwhile
endfunction

if exists('g:chalice_sid')
  call s:DoTransit()
endif
