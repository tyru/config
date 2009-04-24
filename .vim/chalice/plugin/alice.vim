" vim:set ts=8 sts=2 sw=2 tw=0 nowrap fdm=marker:
"
" alice.vim - A vim script library
"
" Last Change: 24-Jul-2006.
" Written By:  MURAOKA Taro <koron@tka.att.ne.jp>

let s:version_serial = 135
let s:name = 'alice'
if exists('g:plugin_'.s:name.'_disable') || (exists('g:version_'.s:name) && g:version_{s:name} > s:version_serial)
  finish
endif
let g:version_{s:name} = s:version_serial

" Get script directory
let s:scriptdir = expand('<sfile>:p:h')

"------------------------------------------------------------------------------
" ALICE

function! AL_version()
  return s:version_serial
endfunction

function! AL_compareversion(ver1, ver2)
  " Compare version strings a:ver1 and a:ver2.  If a:ver2 indicate more
  " newer version than a:ver1 indicated, return 1.  Equal, return 0.  Older,
  " return -1.
  let mx_ver = '\d\+\%(\.\d\+\)*'
  let v1 = matchstr(a:ver1, mx_ver)
  let v2 = matchstr(a:ver2, mx_ver)
  let mx_num = '^0*\(\d\+\)\%(\.\(.*\)\)\?'
  while v1 != '' && v2 != ''
    let n1 = substitute(v1, mx_num, '\1', '') + 0
    let n2 = substitute(v2, mx_num, '\1', '') + 0
    let v1 = substitute(v1, mx_num, '\2', '')
    let v2 = substitute(v2, mx_num, '\2', '')
    if n1 < n2
      return 1
    elseif n1 > n2
      return -1
    endif
  endwhile
  if (v1 == '' || v1 + 0 == 0) && (v2 == '' || v2 + 0 == 0)
    return 0
  elseif v1 == ''
    return 1
  else
    return -1
  endif
endfunction

function! AL_islastline(...)
  return line('$') == line(a:0 > 0 ? a:1 : '.')
endfunction

function! AL_get_winnum(window)
  " Obtain window number from buffer name or window number.
  let num = bufwinnr(a:window)
  if num < 0 && a:window =~ '^\d\+$'
    let num = a:window + 0
    if winbufnr(num) < 0
      let num = -1
    endif
  endif
  return num
endfunction

function! AL_selectwindow(window)
  " Obtain window number from buffer name or window number.
  let num = AL_get_winnum(a:window)
  " Activate window
  if num >= 0 && num != winnr()
    call AL_execute(num.'wincmd w')
  endif
  return num
endfunction

function! AL_setwinheight(height)
  " Change current window height
  call AL_execute('normal! '.a:height."\<C-W>_")
endfunction

function! AL_hascmd(cmd)
  let cmd = a:cmd
  " Preparing PATH for globpath
  if has('win32')
    let path = substitute(substitute($PATH, '\\', '/', 'g'), ';', ',', 'g')
    let cmd = cmd . '.exe'
  else
    let path = substitute($PATH, ':', ',', 'g')
  endif
  " Save value of 'wildignore' and reset it
  let wildignore = &wildignore
  set wildignore=
  " Search a command from path
  let cmdpath = globpath(path, cmd)
  let retval = ''
  if has('win32') && cmdpath == ''
    let retval = globpath($VIM, cmd)
  elseif cmdpath != ''
    let retval = cmd
  endif
  " Revert 'wildignore'
  let &wildignore = wildignore
  return retval
endfunction

function! AL_del_lastsearch()
  call histdel("search", -1)
endfunction

function! AL_fileread(filename)
  " Read file and return it in multi-line string form.
  if !filereadable(a:filename)
    return ''
  endif
  if has('win32') && &shell =~ '\ccmd'
    let cmd = 'type'
  else
    let cmd = 'cat'
  endif
  return AL_system(cmd . ' ' . AL_quote(a:filename))
endfunction

function! AL_buffer_clear()
  call AL_execute('%delete _')
endfunction

function! AL_filename(path)
  return matchstr(a:path, '\m[^/\\]*$')
endfunction

function! AL_basepath(dirpath)
  return substitute(matchstr(a:dirpath, '\m^.*[/\\]'), '\m[/\\]$', '', '')
endfunction

let g:AL_pattern_class_url = '[-!#$%&*+,./0-9:;=?@A-Za-z_~]'

function! s:AL_open_url_win32(url)
  let url = substitute(a:url, '%', '%25', 'g')
  if url =~# ' '
    let url = substitute(url, ' ', '%20', 'g')
    let url = substitute(url, '^file://', 'file:/', '')
  endif
  " If 'url' has % or #, all of those characters are expanded to buffer name
  " by execute().  Below escape() suppress this.  system() does not expand
  " those characters.
  let url = escape(url, '%#')
  " Start system related URL browser
  if !has('win95') && url !~ '[&!]'
    " for Win NT/2K/XP
    call AL_execute('!start /min cmd /c start ' . url)
    " MEMO: "cmd" causes some side effects.  Some strings like "%CD%" is
    " expanded (may be environment variable?) by cmd.
  else
    " It is known this rundll32 method has a problem when opening URL that
    " matches http://*.html.  It is better to use ShellExecute() API for
    " this purpose, open some URL.  Command "cmd" and "start" on NT/2K?XP
    " does this.
    call AL_execute("!start rundll32 url.dll,FileProtocolHandler " . url)
  endif
endfunction

function! AL_open_url(url, cmd)
  " Open given URL by external browser
  "   For Windows, if cmd is empty, system related URL browser is used.  For
  "   all, if cmd include string '%URL%', it is replaced with url.  If not
  "   include just appended.
  let retval = 0
  if a:url == ''
    return retval
  endif
  let url = s:AL_verifyurl(a:url)

  if a:cmd != ''
    let url = AL_quote(url)
    if a:cmd =~ '%URL%'
      " Avoid that '&' is replaced by '%URL%'.
      " Avoid that '~' is replaced by previous replace string.
      let url = escape(url, '&~\\')
      let excmd = substitute(a:cmd, '%URL%', url, 'g')
    else
      let excmd = a:cmd . ' ' . url
    endif
    if excmd !~ '^!'
      call AL_system(excmd)
    else
      let excmd = escape(excmd, '%#')
      call AL_execute(excmd)
    endif
    let retval = 1
  elseif has('win32')
    " You can build minshell.exe or minshell.dll where tools/minshell
    " directory with VisualC.  If you want to get compiled binary, please
    " send a e-mail to author of this script.
    if filereadable(s:scriptdir.'/minshell.dll')
      " Open with minshell.dll
      call libcall(s:scriptdir.'/minshell.dll', 'ExecuteOpen', url)
    else
      let url = AL_urldecode(url)
      " Search minshell.exe
      if filereadable(s:scriptdir.'/minshell.exe')
	let minshell_exe = s:scriptdir.'/minshell.exe'
      else
	let minshell_exe = AL_hascmd('minshell')
      endif
      " Open with minshell.exe or old win32 function.
      if minshell_exe.'X' !=# 'X'
	call AL_system(minshell_exe.' '.url)
      else
	call s:AL_open_url_win32(url)
      endif
    endif
    let retval = 1
  elseif has('mac')
    " Use osascript for MacOS X
    call AL_system("osascript -e 'open location \"" .url. "\"'")
    let retval = 1
  endif
  return retval
endfunction

function! AL_urlencoder_ch2hex(ch)
  let result = ''
  let i = 0
  while i < strlen(a:ch)
    let hex = AL_nr2hex(char2nr(a:ch[i]))
    let result = result.'%'.(strlen(hex) < 2 ? '0' : '').hex
    let i = i + 1
  endwhile
  return result
endfunction

function! s:AL_verifyurl(str)
  let retval = a:str
  let retval = substitute(retval, '[ $~]', '\=AL_urlencoder_ch2hex(submatch(0))', 'g')
  "let retval = substitute(retval, ' ', '+', 'g')
  return retval
endfunction

function! AL_urlencode_with_range(range)
  call AL_execute(a:range . 's/[^- *.0-9A-Za-z]/\=AL_urlencoder_ch2hex(submatch(0))/g')
  call AL_execute(a:range . 's/ /+/g')
endfunction

function! AL_urlencode(str)
  " Return URL encoded string
  let retval = a:str
  let retval = substitute(retval, '[^- *.0-9A-Za-z]', '\=AL_urlencoder_ch2hex(submatch(0))', 'g')
  let retval = substitute(retval, ' ', '+', 'g')
  return retval
endfunction

function! AL_urldecode(str)
  let retval = a:str
  let retval = substitute(retval, '+', ' ', 'g')
  let retval = substitute(retval, '%\(\x\x\)', '\=nr2char("0x".submatch(1))', 'g')
  return retval
endfunction

function! s:Utf_nr2byte(nr)
  if a:nr < 0x80
    return nr2char(a:nr)
  elseif a:nr < 0x800
    return nr2char(a:nr/64+192).nr2char(a:nr%64+128)
  else
    return nr2char(a:nr/4096%16+224).nr2char(a:nr/64%64+128).nr2char(a:nr%64+128)
  endif
endfunction

function! s:Uni_nr2enc_char(charcode)
  if &encoding == 'utf-8'
    return nr2char(a:charcode)
  endif
  let char = s:Utf_nr2byte(a:charcode)
  if has('iconv') && strlen(char) > 1
    let char = strtrans(iconv(char, 'utf-8', &encoding))
  endif
  return char
endfunction

function! AL_decode_entityreference_with_range(range)
  " Decode entity reference for range
  call AL_execute(a:range . 's/&gt;/>/g')
  call AL_execute(a:range . 's/&lt;/</g')
  call AL_execute(a:range . 's/&quot;/"/g')
  call AL_execute(a:range . "s/&apos;/'/g")
  call AL_execute(a:range . 's/&nbsp;/ /g')
  call AL_execute(a:range . 's/&yen;/\&#65509;/g')
  call AL_execute(a:range . 's/&#\(\d\+\);/\=s:Uni_nr2enc_char(submatch(1))/g')
  call AL_execute(a:range . 's/&amp;/\&/g')
endfunction

function! AL_decode_entityreference(str)
  " Decode entity reference for string
  let str = a:str
  let str = substitute(str, '&gt;', '>', 'g')
  let str = substitute(str, '&lt;', '<', 'g')
  let str = substitute(str, '&quot;', '"', 'g')
  let str = substitute(str, '&apos;', "'", 'g')
  let str = substitute(str, '&nbsp;', ' ', 'g')
  let str = substitute(str, '&yen;', '\&#65509;', 'g')
  let str = substitute(str, '&#\(\d\+\);', '\=s:Uni_nr2enc_char(submatch(1))', 'g')
  let str = substitute(str, '&amp;', '\&', 'g')
  return str
endfunction

function! AL_get_quotesymbol()
  " Return quote symbol.
  if &shellxquote == '"'
    return "'"
  else
    return '"'
  endif
endfunction

function! AL_quote(str)
  " Quote filepath by quote symbol.
  let fq = AL_get_quotesymbol()
  retur fq . a:str. fq
endfunction

"------------------------------------------------------------------------------
" FLAG FUNCTIONS {{{

function! s:AL_getflagmx(flag)
  return '\%(^\|,\)'.a:flag.'\%(=\([^,]*\)\)\?\%(,\|$\)'
endfunction

function! AL_delflag(flags, flag)
  let newflags = substitute(a:flags, s:AL_getflagmx(a:flag) , ',', 'g')
  let newflags = substitute(newflags, ',,\+', ',', 'g')
  let newflags = substitute(newflags, '^,', '', 'g')
  let newflags = substitute(newflags, ',$', '', 'g')
  return newflags
endfunction

function! AL_addflag(flags, flag)
  return AL_hasflag(a:flags, a:flag) ? a:flags : (a:flags == '' ? a:flag : a:flags .','. a:flag)
endfunction

function! AL_hasflag(flags, flag)
  " Return 1 (not 0) if a:flags has word a:flag.  a:flags is supposed a list
  " of words separated by camma as CSV.
  return a:flags =~ s:AL_getflagmx(a:flag)
endfunction

function! AL_getflagparam(flags, flag)
  let mx = s:AL_getflagmx(a:flag)
  let retval = AL_sscan(a:flags, mx, '\1')
  return retval
endfunction

"}}}

"------------------------------------------------------------------------------
" STRING FUNCTIONS {{{

function! AL_chomp(str)
  " Like perl chomp() function.  (But did't change argument)
  return substitute(a:str, '\s\+$', '', '')
endfunction

function! AL_chompex(str)
  " Remove leading and trailing white-spaces.
  return substitute(a:str, '^\s\+\|\s\+$', '', 'g')
endfunction

function! AL_nr2hex(nr)
  " see :help eval-examples
  let n = a:nr
  let r = ""
  while 1
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
    if n == 0
      break
    endif
  endwhile
  return r
endfunction

function! AL_sscan(string, pattern, select)
  return substitute(matchstr(a:string, a:pattern), a:pattern, a:select, '')
endfunction

function! AL_sscan_decimal(string)
  return AL_sscan(a:string, '\m[1-9]\d*', '&') + 0
endfunction

function! AL_string_formatnum(value, ncolumns, ...)
  let flags = a:0 > 0 ? a:1 : ''
  let len = strlen(a:value)
  if len < a:ncolumns
    if AL_hasflag(flags, '0')
      let padding = AL_string_multiplication('0', a:ncolumns - len)
    else
      let padding = AL_string_multiplication(' ', a:ncolumns - len)
    endif
    return padding.a:value
  else
    return a:value
  endif
endfunction

function! AL_string_multiplication(base, scalar)
  " Like perl's 'x' operator
  let retval = ''
  let base = a:base
  let scalar = a:scalar
  while scalar
    if scalar % 2
      let retval = retval . base
    endif
    let scalar = scalar / 2
    let base = base . base
  endwhile
  return retval
endfunction

" matchstr() for around the cursor
function! AL_matchstr_cursor(mx)
  let str = AL_matchstr_undercursor(a:mx)
  if str.'X' != 'X'
    return str
  endif
  let str = AL_matchstr_aftercursor(a:mx)
  if str.'X' != 'X'
    return str
  endif
  let str = AL_matchstr_beforecursor(a:mx)
  if str.'X' != 'X'
    return str
  endif
  return ''
endfunction

" matchstr() for before the cursor
function! AL_matchstr_beforecursor(mx)
  let column = col('.')
  let mx = "\\m^.*\\(".a:mx."\\)\\%<".(column + 1).'c.*$'
  return AL_sscan(getline('.'), mx, '\1')
endfunction

" matchstr() for after the cursor
function! AL_matchstr_aftercursor(mx)
  let column = col('.')
  let mx = '\m\%>'.column.'c'.a:mx
  return matchstr(getline('.'), mx)
endfunction

" matchstr() for under the cursor
function! AL_matchstr_undercursor(mx)
  let column = col('.')
  let mx = '\m\%<'.(column + 1).'c'.a:mx.'\%>'.column.'c'
  return matchstr(getline('.'), mx)
endfunction

"}}}

"------------------------------------------------------------------------------
" TIME FUNCTIONS {{{

if exists('s:tz_offset')
  " Time zone offset
  unlet s:tz_offset
endif

function! s:GetEpochtime(year, month, day, hour, minute, second)
  return AL_epochday(a:year, a:month, a:day) * 86400 + a:hour * 3600 + a:minute * 60 + a:second
endfunction

function! s:EnsureTimezoneOffset()
  if !exists('s:tz_offset')
    let curtime = localtime()
    let calctime = s:GetEpochtime(AL_sscan_decimal(strftime('%Y', curtime)), AL_sscan_decimal(strftime('%m', curtime)), AL_sscan_decimal(strftime('%d', curtime)), AL_sscan_decimal(strftime('%H', curtime)), AL_sscan_decimal(strftime('%M', curtime)), AL_sscan_decimal(strftime('%S', curtime)))
    let s:tz_offset = curtime - calctime
  endif
endfunction

function! AL_epochday(year, month, day)
  " Return elapsed days from 01-Jan-1970.
  if a:month < 3
    let year  = a:year - 1
    let month = a:month + 9
  else
    let year  = a:year
    let month = a:month - 3
  endif
  return year * 1461 / 4 - year / 100 + year / 400 + (month * 153 + 2) / 5 + a:day - 719469
endfunction

function! AL_epochtime(year, month, day, ...)
  " Inverse function of strftime('%Y %m %d %H %M %S', time)
  call s:EnsureTimezoneOffset()
  let hour = 0
  let minute = 0
  let second = 0
  if a:0 > 0
    let hour = a:1
  endif
  if a:0 > 1
    let minute = a:2
  endif
  if a:0 > 2
    let second = a:3
  endif
  "call AL_echokv('s:tz_offset', s:tz_offset)
  return s:GetEpochtime(a:year, a:month, a:day, hour, minute, second) + s:tz_offset
endfunction

function! AL_todayepoch()
  let curtime = localtime()
  return AL_epochtime(AL_sscan_decimal(strftime('%Y', curtime)), AL_sscan_decimal(strftime('%m', curtime)), AL_sscan_decimal(strftime('%d', curtime)))
endfunction

"}}}

"------------------------------------------------------------------------------
" DIRECTORY FUNCTIONS {{{

function! s:MakeDirectory(dirpath)
  " Make directory and its parents if needed.
  let dirpath = AL_quote(substitute(a:dirpath, '\m[/\\]$', '', ''))
  if has('win32') && &shell !~ '\m\csh'
    call AL_system('mkdir ' . substitute(dirpath, '\m/', '\\', 'g'))
  else
    call AL_system('mkdir ' . dirpath)
  endif
endfunction

function! s:EnsureDirectory(dirpath)
  if !isdirectory(a:dirpath)
    call s:MakeDirectory(a:dirpath)
    if !isdirectory(a:dirpath)
      return 0
    endif
  endif
  return 1
endfunction

function! AL_mkdir(dirpath)
  if isdirectory(a:dirpath)
    return 1
  endif
  let basepath = AL_basepath(a:dirpath)
  "call AL_echokv('basepath', basepath)
  if basepath.'X' !=# 'X' && !(has('win32') && basepath =~# '\m^\a:$')
    if !AL_mkdir(basepath)
      return 0
    endif
  endif
  return s:EnsureDirectory(a:dirpath)
endfunction

function! AL_delete(path)
  let path = AL_quote(substitute(a:path, '\m[/\\]$', '', ''))
  if has('win95') && &shell =~# '\m\ccommand\.com'
    call AL_system('deltree /Y '.path)
  elseif has('win32') && &shell =~# '\m\ccmd\.exe'
    let path = substitute(path, '\m/', '\\', 'g')
    if isdirectory(a:path)
      call AL_system('rmdir /S /Q '.path)
    else
      call AL_system('del /F '.path)
    endif
  else
    call AL_system('rm -fr '.path)
  endif
  return glob(a:path).'X' ==# 'X' ? 1 : 0
endfunction

function! AL_copy(from, to)
  if isdirectory(a:from) 
    " Copy a directory.
    if has('win95') && &shell =~# '\m\ccommand\.com'
      call AL_system('xcopy ' . a:from . ' ' . a:to . ' /S /E /C /Q /R /X /Y ')
    elseif has('win32') && &shell =~# '\m\ccmd\.exe'
      call AL_system('xcopy ' . a:from . ' ' . a:to . ' /S /E /C /Q /R /X /Y ')
    else
      call AL_system('cp -Rp ' . a:from . ' ' . a:to)
    endif
    return 1
  elseif filereadable(a:from)
    " Copy a file.
    if has('win95') && &shell =~# '\m\ccommand\.com'
      call AL_system('copy /Y ' . a:from . ' ' . a:to)
    elseif has('win32') && &shell =~# '\m\ccmd\.exe'
      call AL_system('copy /Y ' . a:from . ' ' . a:to)
    else
      call AL_system('cp ' . a:from . ' ' . a:to)
    endif
    return 1
  else
    return 0
  endif
endfunction

"}}}

"------------------------------------------------------------------------------
" ECHO FUNCTIONS {{{

function! AL_echokv(key, value)
  call AL_echo(a:key.'=', 'PreProc')
  call AL_echon(a:value)
endfunction

function! AL_echon(msgstr, ...)
  let hlname = a:0 > 0 ? a:1 : 'None'
  execute "echohl " . (hlname != '' ? hlname : 'None')
  echon a:msgstr
  echohl None
endfunction

function! AL_echo(msgstr, ...)
  let hlname = a:0 > 0 ? a:1 : 'None'
  execute "echohl " . (hlname != '' ? hlname : 'None')
  echo a:msgstr
  echohl None
endfunction

"}}}

"------------------------------------------------------------------------------
" MULTILINE STRING FUNCTIONS {{{

function! AL_append_multilines(contents)
  let name = 'a'
  let value = getreg(name)
  let type = getregtype(name)
  call setreg(name, a:contents, "c")
  execute 'normal! "'.name.'p'
  call setreg(name, value, type)
endfunction

function! AL_addline(multistr, str)
  if a:multistr.'X' == 'X'
    return a:str
  else
    return a:multistr . "\<NL>" . a:str
  endif
endfunction

function! AL_getline(multistr, linenum)
  if a:linenum == 0
    return AL_firstline(a:multistr)
  else
    return substitute(a:multistr, "^\\%([^\<NL>]*\<NL>\\)\\{" . a:linenum . "}\\([^\<NL>]*\\).*", '\1', '')
  endif
endfunction

function! AL_countlines(multistr)
  if a:multistr == ''
    return 0
  else
    return strlen(substitute(a:multistr, "[^\<NL>]*\<NL>\\?", 'a', 'g'))
  endif
endfunction

function! AL_lastlines(multistr)
  let nextline = matchend(a:multistr, "^[^\<NL>]*\<NL>\\?")
  return strpart(a:multistr, nextline)
endfunction

function! AL_firstline(multistr)
  return matchstr(a:multistr, "^[^\<NL>]*")
endfunction

function! AL_lastline(multistr)
  return substitute(matchstr(a:multistr, "\\m[^\<NL>]*\<NL>\\?$"), "\<NL>$", '', '')
endfunction

"}}}

"------------------------------------------------------------------------------
" WRAPPER FUNCTIONS {{{

function! AL_write(...)
  " Write current buffer to a file without backup.
  let filename = a:0 > 0 ? a:1 : ''
  let append = a:0 > 1 ? a:2 : 0
  let save_backup = &backup
  let save_buftype = &buftype
  set nobackup buftype=
  if filename.'X' == 'X'
    call AL_execute('write!')
  else
    if append != 0
      call AL_execute('write! >> '.escape(filename, ' '))
    else
      call AL_execute('write! '.escape(filename, ' '))
    endif
  endif
  let &backup = save_backup
  let &buftype = save_buftype
  return 1
endfunction

function! AL_execute(cmd)
  if 0 && exists('g:AL_option_nosilent') && g:AL_option_nosilent != 0
    execute a:cmd
  else
    silent! execute a:cmd
  endif
endfunction
command! -nargs=1 ALexecute		call AL_execute(<args>)

function! AL_system(cmd)
  " system() wrapper function
  let cmdstr = a:cmd
  if has('win32') && &shell =~ '\ccmd'
    let cmdstr = '"' . cmdstr . '"'
  endif
  return system(cmdstr)
endfunction
command! -nargs=1 ALsystem		call AL_system(<args>)

"}}}
