if exists("b:__COMMON_XPT_VIM__")
  finish
endif
let b:__COMMON_XPT_VIM__ = 1


let s:f = g:XPTfuncs()
let s:v = g:XPTvars()


fun! s:f.headerSymbol(...) 
  let h = expand('%:t')
  let h = substitute(h, '\.', '_', 'g') " replace . with _
  let h = substitute(h, '.', '\U\0', 'g') " make all characters upper case

  return '__'.h.'__'
endfunction

fun! s:f.date(...) 
  return strftime("%Y %b %d")
endfunction

fun! s:f.datetime(...) 
  return strftime("%c")
endfunction

fun! s:f.time(...) 
  return strftime("%H:%M:%S")
endfunction

fun! s:f.file(...) 
  return expand("%:t")
endfunction

fun! s:f.fileRoot(...) 
  return expand("%:t:r")
endfunction

fun! s:f.fileExt(...) 
  return expand("%:t:e")
endfunction

fun! s:f.path(...) 
  return expand("%:p")
endfunction


" variables
let s:v['$author'] = "drdr.xp"
let s:v['$email'] = "drdr.xp@gmail.com"


call XPTemplateMark('`', '^')

" shortcuts
call XPTemplate('ath', '`$author^')
call XPTemplate('em', '`$email^')
call XPTemplate("dt", "`date()^")
call XPTemplate("f", "`file()^")
call XPTemplate("p", "`path()^")


" call XPTemplate("test", '`$author^, `$email^, `date()^, `datetime()^, `time()^, `file()^, `path()^')
