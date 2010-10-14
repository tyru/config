" vim:set ts=8 sts=2 sw=2 tw=0 nowrap:
"
" dolib.vim - Authentication library for 2channel
"
" Last Change: 24-May-2004.
" Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

" Require: alice.vim

let s:version_serial = 2
let s:name = 'dolib'
if exists('g:plugin_'.s:name.'_disable') || (exists('g:version_'.s:name) && g:version_{s:name} > s:version_serial)
  finish
endif
let g:version_{s:name} = s:version_serial

"------------------------------------------------------------------------------
" CONSTANTS

let s:debug = 0
let s:curlpath = ''
let s:mininumlife = 3600
let s:loginurl = 'https://2chv.tora3.net/futen.cgi'
let s:mx_result = '^SESSION-ID=\(\([^:]*\):.*\)$'

"------------------------------------------------------------------------------
" DOLIB API

function! DOLIB_version()
  return s:version_serial
endfunction

" Login 2channel with specified 'loginid' and 'password' and 'useragent'.
" Return SID in form of string.  If function is failed empty string is
" returned.  Argument #4 means 'flags'.
" Flags:
"   curlpath=PATH
"   secure		Don't use this on Windows
function! DOLIB_login(loginid, password, useragent, ...)
  let flags = a:0 > 0 ? a:1 : ''
  " Initialize s:curlpath and curlpath.
  let curlpath = AL_getflagparam(flags, 'curlpath')
  if s:curlpath.'X' ==# 'X'
    if curlpath.'X' !=# 'X'
      let s:curlpath = curlpath
    else
      let s:curlpath = AL_hascmd('curl')
      " Can't find cURL.
      if s:curlpath ==# 'X'
	echoerr "DOLIB_login: Can't find cURL command"
	return ''
      endif
    endif
  endif
  if curlpath.'X' ==# 'X'
    let curlpath = s:curlpath
  endif
  " Build cURL's option string
  let opts = ''
  let opts = opts. ' -s'
  let opts = opts. ' -A DOLIB/1.00'
  let opts = opts. ' -H X-2ch-UA:'.a:useragent
  let opts = opts. ' -d '.AL_quote('ID='.a:loginid.'&PW='.a:password)
  if !AL_hasflag(flags, 'secure')
    let opts = opts. ' -k'
  endif
  " Execute command and get result in string variable
  let cmd = curlpath . opts .' '. s:loginurl
  if s:debug
    let @a = cmd
  endif
  let result = AL_firstline(system(cmd))
  " Parse 'result' and make it SID format
  if result !~# s:mx_result
    " Login failed.
    return ''
  endif
  let baseuseragent = AL_sscan(result, s:mx_result, '\2')
  let sessionid = AL_sscan(result, s:mx_result, '\1')
  if baseuseragent ==# 'ERROR'
    " Login failed.
    return ''
  endif
  let sid = ''
  let sid = sid. baseuseragent.' ('.a:useragent.')' ."\<NL>"
  let sid = sid. sessionid ."\<NL>"
  let sid = sid. localtime() ."\<NL>"
  " Login succeeded, so return SID
  return sid
endfunction

function! s:IsValidSid(sid)
  if AL_countlines(a:sid) == 3 && AL_firstline(a:sid) =~# '^Monazilla/'
    return 1
  else
    return 0
  endif
endfunction

" Get sessionid expanded from SID.  If 'sid' is invalid, return empty string.
function! DOLIB_get_sessionid(sid)
  if !s:IsValidSid(a:sid)
    return ''
  else
    return AL_getline(a:sid, 1)
  endif
endfunction

" Get useragent (ex. Monazilla/1.00) expanded from SID.  If 'sid' is invalid,
" return empty string.
function! DOLIB_get_useragent(sid)
  if !s:IsValidSid(a:sid)
    return ''
  else
    return AL_getline(a:sid, 0)
  endif
endfunction

" Get login time expanded from SID.  If 'sid' is invalid, return 0.
function! DOLIB_get_logintime(sid)
  if !s:IsValidSid(a:sid)
    return 0
  else
    return AL_getline(a:sid, 2) + 0
  endif
endfunction

" Evaluate lifetime of SID.  Return 1 if 'sid' was expired, else return 0.
" Argument #4 means 'flags'.
" Flags:
"   lifetime=SECONDS
function! DOLIB_isexpired(sid, ...)
  if !s:IsValidSid(a:sid)
    return 1
  endif
  let flags = a:0 > 0 ? a:1 : ''
  " Calculate lifetime
  let lifetime = AL_getflagparam(flags, 'lifetime') + 0
  if lifetime <= 0
    let lifetime = s:mininumlife
  endif
  " Evaluate lifetime
  if DOLIB_get_logintime(a:sid) + lifetime > localtime()
    return 0
  else
    return 1
  endif
endfunction

if s:debug
  " Self testing function
  function! DOLIB_test(loginid, password)
    let sid = DOLIB_login(a:loginid, a:password, 'Chalice/TEST')
    call AL_echo("Executed command: " . @a, 'Comment')
    if sid.'X' ==# 'X'
      echoerr "DOLIB_test: Login failed."
      return
    endif
    call AL_echo('User-Agent: ', 'PreProc')
    call AL_echon(DOLIB_get_useragent(sid))
    call AL_echo('Sessino-ID: ', 'PreProc')
    call AL_echon(DOLIB_get_sessionid(sid))
    call AL_echo('Login-Time: ', 'PreProc')
    call AL_echon(DOLIB_get_logintime(sid))
  endfunction
endif

"------------------------------------------------------------------------------
" APPENDIX

" SID Format:
"   SID is multiline string.  SID consist from 3 lines.  First line is
"   User-Agent be used to access 2channel.  Second line is Session-ID be used
"   to access 2channel too.  And third line is login time,  SID is expired in
"   a few hours.

" DOLIB Specification:
"   http://kage.monazilla.org/system_DOLIB100.html
