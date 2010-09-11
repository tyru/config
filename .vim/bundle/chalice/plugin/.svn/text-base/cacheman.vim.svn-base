" vim:set ts=8 sts=2 sw=2 tw=0 nowrap:
"
" cacheman.vim - Cache directory manager
"
" Last Change: 02-Aug-2003.
" Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

" Require: alice.vim

let s:version_serial = 1
let s:name = 'cacheman'
if exists('g:plugin_'.s:name.'_disable') || (exists('g:version_'.s:name) && g:version_{s:name} > s:version_serial)
  finish
endif
let g:version_{s:name} = s:version_serial

"------------------------------------------------------------------------------
" CACHE MANAGER API

function! CACHEMAN_version()
  return s:version_serial
endfunction

" Get a cached file path.
function! CACHEMAN_getpath(directory, filename)
  let filelist = glob(s:RemoveLastPathSeparator(a:directory).'/*/'.a:filename)
  let maxdaydir = -1
  let latest = ''
  while filelist.'X' !=# 'X'
    let target = AL_firstline(filelist)
    let filelist = AL_lastlines(filelist)
    let daydir = s:IsDaydir(AL_filename(AL_basepath(target)))
    if daydir >= 0 && daydir > maxdaydir
      let maxdaydir = daydir
      let latest = target
    endif
  endwhile
  return latest
endfunction

" Update a cached file.  Return cached file path.
function! CACHEMAN_update(directory, filename)
  let todaydir = s:RemoveLastPathSeparator(a:directory).'/'.strftime('%Y%m%d')
  let todayfile = todaydir.'/'.a:filename
  if !AL_mkdir(todaydir)
    return ''
  endif
  " Get latest cached file.
  let latest = CACHEMAN_getpath(a:directory, a:filename)
  if latest.'X' !=# 'X'
    " Move latest file to today directory
    if todayfile != latest
      call rename(latest, todayfile)
    endif
  endif
  return todayfile
endfunction

" Clear a cached file.
function! CACHEMAN_clear(directory, filename)
  let filelist = glob(s:RemoveLastPathSeparator(a:directory).'/*/'.a:filename)
  while filelist.'X' !=# 'X'
    let target = AL_firstline(filelist)
    let filelist = AL_lastlines(filelist)
    call delete(target)
    "call AL_echokv('Deleting', target)
  endwhile
endfunction

" Clear old cache files.
function! CACHEMAN_flush(directory, thresholdday)
  let filelist = glob(s:RemoveLastPathSeparator(a:directory).'/*')
  let limit = AL_todayepoch() - (a:thresholdday - 1) * 86400
  while filelist.'X' !=# 'X'
    let target = AL_firstline(filelist)
    let filelist = AL_lastlines(filelist)
    let daydir = s:IsDaydir(AL_filename(target))
    if daydir < 0 || daydir < limit
      call s:RemoveDirectory(target)
    endif
  endwhile
endfunction

"------------------------------------------------------------------------------
" SCRIPT LOCAL FUNCTIONS

function! s:RemoveLastPathSeparator(directory)
  return substitute(a:directory, '\m[/\\]$', '', '')
endfunction

function! s:RemoveDirectory(directory)
  "call AL_echokv('Remove', a:directory)
  return AL_delete(a:directory)
endfunction

let s:mx_daydir = '\m^\(\d\d\d\d\)\(\d\d\)\(\d\d\)$'

function! s:IsDaydir(daydir)
  " Evaluate given string is DAYDIR format.  Return minus value when it's
  " not DAYDIR,  else return epoch time of that day.
  if a:daydir !~# s:mx_daydir
    return -1
  endif
  let year  = AL_sscan(a:daydir, s:mx_daydir, '\1')
  let month = substitute(AL_sscan(a:daydir, s:mx_daydir, '\2'), '^0', '', '')
  let day   = substitute(AL_sscan(a:daydir, s:mx_daydir, '\3'), '^0', '', '')
  let epoch = AL_epochtime(year, month, day)
  if epoch < 0 || epoch > localtime()
    return -1
  else
    return epoch
  endif
endfunction
