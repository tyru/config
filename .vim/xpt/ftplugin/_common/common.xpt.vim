if exists("b:___COMMON_COMMON_XPT_VIM__")
  finish
endif
let b:___COMMON_COMMON_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()


call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$UNDEFINED' : 'undefined'}, "keep")
call extend(s:v, {'$CL': '/*', '$CM' : '*', '$CR' : '*/', '$CS' : '//'}, "keep")

call extend(s:v, {'$author' : 'drdr.xp', '$email' : 'drdr.xp@gmail.com'}, 'keep')


call XPTemplatePriority("all")

" ========================= Function and Varaibles =============================
" current name
fun! s:f.N() "{{{
  if has_key(self._ctx, 'name')
    return self._ctx.name
  else
    return ""
  endif
endfunction "}}}

" current value
fun! s:f.V() "{{{
  if has_key(self._ctx, 'value')
    return self._ctx.value
  else
    return ""
  endif
endfunction "}}}

" equals to expand()
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

" equals to S(C().value, ...)
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

  return ""
endfunction "}}}

" black hole
fun! s:f.VOID(...) "{{{
  return ""
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


" draft increment implementation
fun! s:f.CntD() "{{{
  let ctx = self._ctx
  if !has_key(ctx, '__counter')
    let ctx.__counter = {}
  endif
  return ctx.__counter
endfunction "}}}
fun! s:f.CntStart(name, ...) "{{{
  let d = self.CntD()
  let i = a:0 >= 1 ? 0 + a:1 : 0
  let d[a:name] = 0 + i
  return ""
endfunction "}}}
fun! s:f.Cnt(name) "{{{
  let d = self.CntD()
  return d[a:name]
endfunction "}}}
fun! s:f.CntIncr(name, ...)"{{{
  let i = a:0 >= 1 ? 0 + a:1 : 1
  let d = self.CntD()

  let d[a:name] += i
  return d[a:name]
endfunction"}}}



" ================================= Snippets ===================================
call XPTemplateMark('`', '^')

" shortcuts
call XPTemplate('Author', '`$author^')
call XPTemplate('Email', '`$email^')
call XPTemplate("Date", "`date()^")
call XPTemplate("File", "`file()^")
call XPTemplate("Path", "`path()^")


