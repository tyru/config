if exists("b:__COMMON_XPT_VIM__")
  finish
endif
let b:__COMMON_XPT_VIM__ = 1


let s:f = g:XPTfuncs()
let s:v = g:XPTvars()


fun! s:f.N() "{{{
  if has_key(self._ctx, 'name')
    return self._ctx.name
  else
    return ""
  endif
endfunction "}}}

fun! s:f.V() "{{{
  if has_key(self._ctx, 'value')
    return self._ctx.value
  else
    return ""
  endif
endfunction "}}}

fun! s:f.E(s) "{{{
  return expand(a:s)
endfunction "}}}

" return the context
fun! s:f.C() "{{{
  return self._ctx
endfunction "}}}

" post filter	substitute
fun! s:f.S(str, ptn, rep, ...) "{{{
  let flg = a:0 >= 1 ? a:1 : 'g'
  return substitute(a:str, a:ptn, a:rep, flg)
endfunction "}}}

fun! s:f.SV(ptn, rep, ...) "{{{
  let flg = a:0 >= 1 ? a:1 : 'g'
  return substitute(self.V(), a:ptn, a:rep, flg)
endfunction "}}}


" reference to another finished item value
fun! s:f.R(name) "{{{
  let ctx = self._ctx
  if has_key(ctx.namedStep, a:name)
    return ctx.namedStep[a:name]
  endif

  return a:ctx.name
endfunction "}}}

fun! s:f.headerSymbol(...) "{{{
  let h = expand('%:t')
  let h = substitute(h, '\.', '_', 'g') " replace . with _
  let h = substitute(h, '.', '\U\0', 'g') " make all characters upper case

  return '__'.h.'__'
endfunction
 "}}}
 "
fun! s:f.date(...) "{{{
  return strftime("%Y %b %d")
endfunction "}}}

fun! s:f.datetime(...) "{{{
  return strftime("%c")
endfunction "}}}

fun! s:f.time(...) "{{{
  return strftime("%H:%M:%S")
endfunction "}}}

fun! s:f.file(...) "{{{
  return expand("%:t")
endfunction "}}}

fun! s:f.fileRoot(...) "{{{
  return expand("%:t:r")
endfunction "}}}

fun! s:f.fileExt(...) "{{{
  return expand("%:t:e")
endfunction "}}}

fun! s:f.path(...) "{{{
  return expand("%:p")
endfunction "}}}


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
