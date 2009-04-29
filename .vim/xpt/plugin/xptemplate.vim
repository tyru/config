" XPTEMPLATE ENGIE:
"   code template engine
" VERSION: 0.3.5.2
" BY: drdr.xp | drdr.xp@gmail.com
"
" MARK USED:
"   <, >  visual marks
" REGISTER USED:
"   9
"
" USAGE: "{{{
"   1) vim test.js
"   2) to type:
"     for<C-\>
"     generating a for-loop template. using <TAB> navigate through
"     template
" "}}}
"
" TODOLIST: "{{{
" TODO ordered item
" TODO ontime filter
" TODO lock key variables
" TODO as function call template
" TODO popup if multi keys with same prefix 
" TODO popup hint
" TODO foldmethod=indent problem.
" TODO map stack
" TODO when popup display, map <cr> to trigger template start 
" TODO undo
" TODO wrapping on different visual mode
" TODO store original map for each buffer
" TODO multi cursor
"
" "}}}
"
"

if exists("g:__XPTEMPLATE_VIM__")
  finish
endif
let g:__XPTEMPLATE_VIM__ = 1



runtime plugin/mapstack.vim
runtime plugin/xptemplate.conf.vim


let s:ep =   '\%(' . '\%(\[^\\]\|\^\)' . '\%(\\\\\)\*' . '\)' . '\@<='

let s:stripPtn     = '\V\^\s\*\zs\.\*'
let s:cursorName   = "cursor"
let s:wrappedName  = "wrapped"
let s:repeatPtn    = '...\d\*'
let s:emptyctx     = {
      \'tmpl' : {}, 
      \'evalCtx' : {}, 
      \'name' : '', 
      \'step': [], 
      \'namedStep':{}, 
      \'processing' : 0, 
      \'pos' : {'tmplpos' : {}, 'curpos' : {} }, 
      \'vals' : {}, 
      \'inplist' : [],  
      \'lastcont' : '', 
      \'lastBefore' : '', 
      \'lastAfter' : '', 
      \'unnameInx' : 0}
let s:vrangeClosed = "\\%>'<\\%<'>"
let s:vrange       = '\V' . '\%(' . '\%(' . s:vrangeClosed .'\)' .  '\|' . "\\%'<\\|\\%'>" . '\)'

let s:plugins = {}
let s:plugins.beforeRender = []
let s:plugins.afterRender = []

let s:plugins.beforeFinish = []
let s:plugins.afterFinish = []

let s:plugins.beforeApplyPredefined = []
let s:plugins.afterApplyPredefined = []

let s:plugins.beforeInitItem = []
let s:plugins.afterInitItem = []

let s:plugins.beforeNextItem = []
let s:plugins.afterNextItem = []

let s:plugins.beforeUpdate = []
let s:plugins.afterUpdate = []

let s:priorities = {'all' : 64, 'spec' : 48, 'like' : 32, 'lang' : 16, 'sub' : 0}
let s:priPtn = 'all\|spec\|like\|lang\|sub\|\d\+'

let s:f = {}
let g:XPT = s:f


fun! XPTinclude(...) "{{{
  if a:0 < 1 
    return
  endif

  let x = s:Data()
  let prio = x.bufsetting.priority


  let list = a:000
  
  for v in list
    if type(v) == type([])
      for s in v
        call XPTinclude(s)
      endfor
    elseif type(v) == type('')
      let cmd =  'runtime ftplugin/'.v.'.xpt.vim'
      exe cmd
    endif
  endfor

  let x.bufsetting.priority = prio

endfunction "}}}

com! -nargs=+ XPTinclude call XPTinclude(<f-args>)


fun! XPTcontainer() "{{{
  return [s:Data().vars, s:Data().vars]
endfunction "}}}

" deprecated
fun! g:XPTvars() "{{{
  return s:Data().vars
endfunction "}}}

" deprecated
fun! g:XPTfuncs() "{{{
  return s:Data().funcs
endfunction "}}}

fun! XPTemplatePriority(...) "{{{
  let x = s:Data()
  let p = a:0 == 0 ? 'lang' : a:1

  let x.bufsetting.priority = s:ParsePriority(p)
endfunction "}}}

fun! XPTemplateMark(sl, sr) "{{{
  let x = s:Data().bufsetting.ptn
  let x.l = a:sl
  let x.r = a:sr
  call s:RedefinePattern()
endfunction "}}}

fun! XPTemplateIndent(p) "{{{
  let x = s:Data().bufsetting.indent
  call s:ParseIndent(x, a:p)
endfunction "}}}

fun! s:ParseIndent(x, p) "{{{
  let x = a:x

  if a:p ==# "auto"
    let x.type = 'auto'
  elseif a:p =~ '/\d\+\*\d\+'
    let x.type = 'rate'

    let str = matchstr(a:p, '/\d\+\*\d\+')

    let x.rate =split(str, '/\|\*')
  else
    " a:p == 'keep'
    let x.type = 'keep'
  endif

endfunction "}}}



" @param String name	 		tempalte name
" @param String context			[optional] context syntax name
" @param String|List|FunCRef str	template string
fun! XPTemplate(name, str_or_ctx, ...) " {{{

  let x = s:Data()
  let xt = s:Data().tmpls
  let xp = s:Data().bufsetting.ptn

  let ctx = {}

  if a:0 == 0          " no syntax context
    let T_str = a:str_or_ctx
  elseif a:0 == 1      " with syntax context
    let ctx = deepcopy(a:str_or_ctx)
    let T_str = a:1
  endif


  if type(T_str) == type([])
    let Str = join(T_str, "\n")
  elseif type(T_str) == type(function("tr"))
    let Str = T_str
  else 
    let Str = T_str
  endif


  let name = a:name

  let istr = matchstr(name, '=[^!=]*')
  let name = substitute(name, '=[^!=]*', '', 'g')

  let idt = deepcopy(x.bufsetting.indent)
  if istr != ""
    call s:ParseIndent(idt, istr)
  elseif has_key(ctx, 'indent')
    call s:ParseIndent(idt, ctx.indent)
  endif

  

  " priority 9999 is the lowest 
  let pstr = matchstr(name, '\V!\zs\.\+\$')

  if pstr != ""
    let override_priority = s:ParsePriority(pstr)
  elseif has_key(ctx, 'priority')
    let override_priority = s:ParsePriority(ctx.priority)
  else
    let override_priority = s:ParsePriority("")
  endif

  let name = pstr == "" ? name : matchstr(name, '[^!]*\ze!')


  let hint = s:GetHint(ctx, Str)



  if !has_key(xt, name) || xt[name].priority > override_priority
    let xt[name] = {
          \ 'name' : name, 
          \ 'hint' : hint, 
          \ 'tmpl' : Str, 
          \ 'priority' : override_priority, 
          \ 'ctx' : ctx,
          \ 'ptn' : deepcopy(s:Data().bufsetting.ptn),
          \ 'indent' : idt, 
          \ 'wrapped' : type(Str) != type(function("tr")) && Str =~ '\V' . xp.lft . s:wrappedName . xp.rt}

  endif
endfunction " }}}


fun! s:XPTemplateParse(lines)
  let lines = a:lines

  let p = split(lines[0], '\V'.s:ep.'\s\+')
  let name = p[1]

  let p = p[2:]

  let ctx = {}
  for v in p
    let nv = split(v, '=')
    if len(nv) > 1
      let ctx[nv[0]] = substitute(join(nv[1:],'='), '\\\(.\)', '\1', 'g')
    endif
  endfor


  let tmpl = lines[1:]

  call XPTemplate(name, ctx, tmpl)

endfunction

fun! s:XPTemplate_def(fn)
  let lines = readfile(a:fn)


  " find the line where XPTemplateDef called
  let [i, len] = [0, len(lines)]
  while i < len
    if lines[i] =~# '^XPTemplateDef'
      break
    endif

    let i += 1
  endwhile


  " parse all lines
  let [s, e] = [0, 0]
  while i < len-1 | let i += 1

    let v = lines[i]

    if v =~ '^"' 
      continue
    endif

    if v =~# '^XPT '
      let s = i
    endif

    if v =~# '^\.\.XPT'
      let e = i - 1
      call s:XPTemplateParse(lines[s : e])
      let [s, e] = [0, 0]
    endif

  endwhile

endfunction

com! XPTemplateDef call s:XPTemplate_def(expand("<sfile>")) | finish
 



fun s:GetHint(ctx, str)
  let xp = s:Data().bufsetting.ptn
  let hint = a:str

  if has_key(a:ctx, 'hint')
    let hint = s:Eval(a:ctx.hint)
  else
    let hint = ""
  endif

  return hint
endfunction

fun! s:ParsePriority(s) "{{{
  let x = s:Data()

  let pstr = a:s
  let prio = 0

  if pstr == ""
    let prio = x.bufsetting.priority
  else 

    let p = matchlist(pstr, '\V\^\(' . s:priPtn . '\)\%(\(\[+-]\)\(\d\+\)\?\)\?\$')

    let base   = 0
    let r      = 1
    let offset = 0

    if p[1] != "" 
      if has_key(s:priorities, p[1]) 
        let base = s:priorities[p[1]]
      elseif p[1] =~ '^\d\+$'
        let base = 0 + p[1]
      else
        let base = 0
      endif
    else
      let base = 0
    endif

    let r = p[2] == '+' ? 1 : (p[2] == '-' ? -1 : 0)

    if p[3] != ""
      let offset = 0 + p[3]
    else
      let offset = 1
    endif

    let prio = base + offset * r

  endif

  return prio
endfunction "}}}

fun! XPTemplatePreWrap(wrap) "{{{
  let x = s:Data()
  let x.wrap = a:wrap

  if x.wrap[-1:-1] == "\n"
    let x.wrap = x.wrap[0:-2]
    let @0 = "\n"
    normal! "0P
  endif

  let x.wrapStartPos = col(".")

  if g:xptemplate_strip_left 
    let x.wrap = substitute(x.wrap, '^\s*', '', '')
  endif

  return s:Popup("", x.wrapStartPos)
endfunction "}}}

fun! XPTemplateStart(pos) " {{{
  let x = s:Data()



  let col0 = col(".")

  if x.wrapStartPos

    let lnn = line(".")
    let coln = x.wrapStartPos

  else 

    let [lnn, coln] = searchpos('\<\w\{-}\%#', "bn")

    if lnn == 0 || coln == 0
      let [lnn, coln] = [line("."), col(".")]
    endif

  endif




  let tmplname = strpart(getline(lnn), coln-1, col0-coln)

  if !has_key(x.tmpls, tmplname)
    let ppr = s:Popup(tmplname, coln)
    return ppr
  endif


  if s:Ctx().processing 
    call s:PushCtx()
  endif



  " new context
  let ctx = s:Ctx()

  let ctx.tmpl = x.tmpls[tmplname]


  " leave 1 char at last to avoid the bug when 'virtualedit' is not set with
  " 'onemore'
  call cursor(lnn, coln)
  let len = col0 - coln - 1 " leave the last
  if len >= 1
    exe "normal! " . len . 'x'
  endif

  call s:RenderTemplate(lnn, coln, ctx.tmpl.tmpl)

  let ctx.processing = 1

  " remove the last
  call cursor(s:BR(x))
  normal! x 

  call s:TopTmplRange()
  silent! normal! gvzO

  let x.curctx.pos.tmplpos.r += 1

  if empty(x.stack)
    call s:ApplyMap()
  endif

  let x.wrap = ''
  let x.wrapStartPos = 0

  return s:SelectNextItem(lnn, coln)



endfunction " }}}

fun! s:XPTemplateFinish(...) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn

  " call Log("XPTemplateFinish...........")

  match none

  let l = line(".")
  let toEnd = col(".") - len(getline("."))

  " unescape
  exe "silent! %snomagic/\\V" .s:f.TmplRange() . xp.lft_e . '/' . xp.l . '/g'
  exe "silent! %snomagic/\\V" .s:f.TmplRange() . xp.rt_e . '/' . xp.r . '/g'

  " format template text
  call s:Format(1)

  call cursor(l, toEnd + len(getline(l)))


  if empty(x.stack)
    " call Log("empty, finish all")
    let ctx.processing = 0
    call s:ClearMap()
  else
    " call Log("pop up")
    call s:PopCtx()
  endif

  return s:StartAppend()
endfunction "}}}

fun! s:Popup(pref, coln) "{{{

  let x = s:Data()
  let cmpl=[]
  let cmpl2 = []
  let dic = x.tmpls

  let ctxs = s:SynNameStack(line("."), a:coln)

  for [key, val] in items(dic)

    if a:pref != "" && key !~ "^".a:pref                              | continue | endif
    if val.wrapped && empty(x.wrap) || !val.wrapped && !empty(x.wrap) | continue | endif
    if has_key(val.ctx, "syn") && val.ctx.syn != '' && match(ctxs, '\c'.val.ctx.syn) == -1        | continue | endif

    " buildins come last
    if key =~# "^[A-Z]"
      call add(cmpl2, {'word' : key, 'menu' : val.hint})
    else
      call add(cmpl, {'word' : key, 'menu' : val.hint})
    endif
  endfor

  call sort(cmpl)
  call sort(cmpl2)
  let cmpl = cmpl + cmpl2

  call complete(a:coln, cmpl)
  if a:pref == ""

    " return "\<C-p>"
    return ""
  else
    return ""
  endif
endfunction "}}}

fun! s:RenderTemplate(l, c, tmpl) " {{{

  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn
  let xpos = s:Ctx().pos

  let op = [a:l, a:c]

  if type(a:tmpl) == type(function("tr"))
    let tmpl = a:tmpl()
  else
    let tmpl = a:tmpl
  endif
  " call Log("1:::".tmpl)

  " process indent
  " call Log(col("."))
  let preindent = repeat(" ", virtcol(".") - 1)
  if ctx.tmpl.indent.type =~# 'keep\|rate'
    if ctx.tmpl.indent.type ==# "rate"
      let idtptn = repeat(' ', ctx.tmpl.indent.rate[0])
      let idtrep = repeat(' ', ctx.tmpl.indent.rate[1])
      let tmpl = substitute(tmpl, '\(^\|\n\)\zs'.idtptn, idtrep, 'g')
    endif
    let tmpl = substitute(tmpl, '\n', '&'.preindent, 'g')
  endif

  " call Log("2:::".tmpl)

  " process repetition
  "
  let bef = ""
  let rest = ""
  let rp = xp.lft . s:repeatPtn . xp.rt
  let repPtn     = '\V\(' . rp . '\)\_.\{-}' . '\1'
  let repContPtn = '\V\(' . rp . '\)\zs\_.\{-}' . '\1'


  let stack = []
  let start = 0
  while 1
    let smtc = match(tmpl, repPtn, start)
    if smtc == -1
      break
    endif
    let stack += [smtc]
    let start = smtc + 1
  endwhile


  while stack != []

    let hasmatch = stack[-1]
    unlet stack[-1]

    let bef = tmpl[:hasmatch-1]
    let rest = tmpl[hasmatch : ]

    let rpt = matchstr(rest, repContPtn)
    let symbol = matchstr(rest, rp)

    " default value or post filter text must NOT contains item quotation
    " marks
    " make nonescaped to escaped, escaped to nonescaped
    " turned back when expression evaluated
    let rpt = escape(rpt, '\')
    let rpt = substitute(rpt, '\V'.xp.l, '\\'.xp.l, 'g')
    let rpt = substitute(rpt, '\V'.xp.r, '\\'.xp.r, 'g')

    let bef .= symbol . rpt . xp.r .xp.r 
    let rest = substitute(rest, repPtn, '', '')
    let tmpl = bef . rest
    
  endwhile

  " call Log("2:::".tmpl)

  let tmpl = substitute(tmpl, '\V' . xp.lft . s:wrappedName . xp.rt, x.wrap, 'g')


  " call Log("3:::".tmpl)
  let tmpl = tmpl.";"
  " remember the original position
  let p = [line("."), col(".")]




  " relative position of template
  " notice the ';'
  let xpos.tmplpos = { 
        \'t' : line("."),
        \'l' : col("."),
        \'b' : line(".") - line("$"),
        \'r' : col(".") - len(getline("."))
        \}


  let @0 = tmpl
  normal! "0P
  call s:TopTmplRange()
  silent! normal! gvzO



  " the ';'
  call cursor(s:BR(x))
  " fix 've' setting
  call search(";", "cb")
  normal! x 
  call s:TopTmplRange()
  silent! normal! gvzO


  let ctx.vals = {}
  call cursor(p)
  call s:BuildValues(0)



  call cursor(p)

  call s:ApplyPredefined()


  " open all folds
  call s:TopTmplRange()
  silent! normal! gvzO

  call s:Format(2)

  call s:TopTmplRange()
  silent! normal! gvzO

endfunction " }}}

fun! s:BuildValues(isItemRange) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn




  let i = ctx.unnameInx
  while i < 1000
    let rt = a:isItemRange ? s:GetCurrentTypedRange() : s:f.TmplRange()

    let _p = getpos(".")[1:2]
    while  search(rt.s:ItemPattern(i))
      let i = i + 1
    endwhile

    call cursor(_p)



    let rt = a:isItemRange ? s:GetCurrentTypedRange() : s:f.TmplRange()

    let pl = rt . xp.lft
    let pr = rt . xp.rt

    let pleft0 = searchpos(pl, 'cW')
    if pleft0 == [0, 0]
      break
    endif

    let pright0 = searchpos(pr, 'cW')
    if pright0 == [0, 0]
      break
    endif


    let pright1 = searchpos(pr, 'W')
    if pright1 == [0, 0]
      break
    endif

    " post handler
    let pright2 = searchpos(pr, 'W')


    call cursor(pright0)
    let pleft1 = searchpos(pl, 'cW')



    if pleft1 == [0, 0] || pleft1[0] > pright1[0] || pleft1[1] > pright1[1]
      " found alternative value

      let pleft0[1] =pleft0[1]  + len(xp.l)
      let name = s:f.GetContentBetween(pleft0, pright0)
      let val = s:f.GetContentBetween([pright0[0], pright0[1]+len(xp.r)], pright1)



      " delayed value
      let isdel = 0
      if pright2[0] == pright1[0] && pright2[1] == pright1[1] + len(xp.r)
        let isdel = 1
        call cursor(pright2)
        exe "normal! ".len(xp.r)."x"
      endif

      " [default_value, is_delayed]
      if name == ""
        let ctx.vals[i] = [val, isdel]
      else 
        let ctx.vals[name] = [val, isdel]
      endif



      " delete alternative value
      call s:f.GetRangeBetween(pright0, pright1)
      XPToldVisual
      normal! d



      if name == ""
        let @0 = i
        normal! "0P
      endif

    endif

  endwhile

  let ctx.unnameInx = i + 1

endfunction "}}}

fun! s:f.GetStaticRange(p, q) "{{{
  let tl = a:p
  let br = a:q


  let r = ''
  if tl[0] == br[0]
    let r = r . '\%' . tl[0] . 'l'
    if tl[1] > 1
      let r = r . '\%>' . (tl[1]-1) .'c'
    endif

    let r = r . '\%<' . br[1] . 'c'
  else
    let r = r . '\%>' . tl[0] .'l' . '\%<' . br[0] . 'l'
    let r = r
          \. '\|' .'\%('.'\%'.tl[0].'l\%>'.(tl[1]-1) .'c\)'
          \. '\|' .'\%('.'\%'.br[0].'l\%<'.(br[1]+0) .'c\)'
  endif

  let r = '\%(' . r . '\)' 
  return '\V'.r

endfunction "}}}

fun! s:HighLightItem(name, switchon) " {{{
  let xp = s:Ctx().tmpl.ptn
  if a:switchon
    let ptn = substitute(xp.itemContentPattern, "NAME", a:name, "")

    let ptn = xp.itemMarkLPattern
    exe "2match IgnoredMark /". ptn ."/"

    let ptn = xp.itemMarkRPattern
    exe "3match IgnoredMark /". ptn ."/"
  else
    exe "2match none"
    exe "3match none"
  endif
endfunction " }}}

fun! s:ApplyPredefined() " {{{
  let x = s:Data()
  let xp = s:Ctx().tmpl.ptn
  let xvar = s:Data().vars
  let xfunc = s:Data().funcs

  call cursor(s:TL(x))

  let i = 0
  while i < 100
    let i = i + 1

    let p = s:FindNextItem('cW')

    if p[0:1] == [0, 0] || p[2] ==# s:cursorName
      break
    endif

    let name = p[2]


    let v = s:Eval(name)

    if v != name
      call s:ReplaceAllMark(name, escape(v, '\'))
      call cursor(p[0:1])
      continue
    endif

    " to find next
    call cursor(p[0], p[1] + 1)
  endwhile

endfunction " }}}

fun! s:Rng_to_TmplEnd() "{{{
  let x = s:Data()
  call s:f.GetRangeBetween(getpos(".")[1:2], s:BR(x), 1)
  return s:vrange
endfunction "}}}

fun! s:TopTmplRange() "{{{
  let x = s:Data()
  if empty(x.stack)
    return s:f.TmplRange()
  else 
    let old = x.curctx
    let x.curctx = x.stack[0]
    let r = s:f.TmplRange()
    let x.curctx = old
  endif
  return r
endfunction "}}}

fun! s:TmplRange_static() "{{{
  let x = s:Data()

  let tl = s:TL(x)
  let br = s:BR(x)

  let r = ''
  if tl[0] == br[0]
    let r = r . '\%' . tl[0] . 'l'
    if lt[1] > 1
      let r = r . '\%>' . tl[1] .'c'
    endif

    let r = r . '\%<' . br[1] . 'c'
  else
    let r = r . '\%>' . tl[0] .'l' . '\%<' . br[0] . 'l'
    let r = r
          \. '\|' .'\%('.'\%'.tl[0].'l\%>'.(tl[1]-1) .'c\)'
          \. '\|' .'\%('.'\%'.br[0].'l\%<'.(br[1]+1) .'c\)'
    let r = '\%(' . r . '\)' 
  endif

  return '\V'.r

endfunction "}}}

fun! s:f.TmplRange() "{{{
  let x = s:Data()
  let p = [line("."), col(".")]

  call s:f.GetRangeBetween(s:TL(x), s:BR(x))
  " call Log("template range:".string([getpos("'<"), getpos("'>")]))
  " call Log("template range:".string([s:TL(x), s:BR(x)]))

  call cursor(p)
  return s:vrange
endfunction "}}}

fun! s:GetCurrentTypedRange() "{{{
  let x = s:Data()
  let p = [line("."), col(".")]

  call s:f.GetRangeBetween(s:f.CTL(x), s:f.CBR(x))


  call cursor(p)
  return s:vrange
endfunction "}}}

if &selection != 'inclusive'
  com! XPTrmLast normal! x
else
  " noop
  com! XPTrmLast echo
endif
if &selectmode =~ 'cmd'
  com! XPTvisual normal! v\<C-g>
  com! XPToldVisual normal! gv\<C-g>
else
  com! XPTvisual normal! v
  com! XPToldVisual normal! gv
endif

fun! s:f.GetRangeBetween(p1, p2, ...) "{{{
  let pre = a:0 == 1 && a:1 

  if pre
    let p = getpos(".")[1:2]
  endif

  if a:p1[0]*1000+a:p1[1] <= a:p2[0]*1000+a:p2[1]
    let [p1, p2] = [a:p1, a:p2]
  else
    let [p1, p2] = [a:p2, a:p1]
  endif
    
  " TODO &selection == 'old'
  if &selection == "inclusive"
    let p2 = s:f.LeftPos(p2)
  endif

  call cursor(p1)
  XPTvisual
  call cursor(p2)
  normal! v


  if pre
    call cursor(p)
  endif

  return s:vrange

endfunction "}}}

fun! s:NextItem() " {{{
  let x = s:Data()
  let ctx = s:Ctx()

  let p0 = s:f.CTL(x)

  let p = [line("."), col(".")]
  let name = ctx.name

  call s:HighLightItem(name, 0)

  let post = s:ApplyDelayed()

  let ctx.step += [{'name' : ctx.name, 'value' : post}]
  if ctx.name != ''
    let ctx.namedStep[ctx.name] = post
  endif


  " TODO ???
  if ctx.name =~ "^\."
    return s:SelectNextItem(p0[0], p0[1])
  else
    return s:SelectNextItem(p[0], p[1])
  endif

endfunction " }}}


fun! s:ApplyDelayed() "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let vals = s:Ctx().vals

  let typed = s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x))

  if has_key(vals, ctx.name) && vals[ctx.name][1]

    if ctx.name =~ '^\.\.\.\d*$' || ctx.name =~ '^\V\w\+...\$'
      let post = vals[ctx.name][0]
      let post = s:Unescape(post)
    else
      let post = s:Eval(vals[ctx.name][0], {'typed' : typed})

    endif


    let [isdel, isapp] = [0, 0]


    if ctx.name =~ '^\.\.\.\d*$' || ctx.name =~ '^\V\w\+...\$'
      let isdel = typed == ctx.name
      let isapp = typed == ctx.name
    else
      let [isdel, isapp] = [1, 1]
    endif

    if isdel && isapp

      call s:Replace(s:f.CTL(x), typed, post)
      call cursor(s:f.CTL(x))
      call s:BuildValues(1)

    endif

    call s:XPTupdate()

    if isdel && isapp
      return post
    endif
  endif

  return typed

endfunction "}}}


fun! s:SelectNextItem(fromln, fromcol) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn

  let ln  = a:fromln
  let cur = a:fromcol

  call cursor(ln, cur)

  let p = s:FindNextItem('c')
  " call Log("found next:".string(p))
  if p[0:1] == [0, 0]
    call cursor(s:BR(x))

    return s:XPTemplateFinish(1)

  endif

  let ctx.name = p[2]

  if ctx.name ==# s:cursorName
    call cursor(p[0:1])
    exe "normal! " . (len(s:cursorName) + len(xp.l) + len(xp.r)) .'x'
    return s:XPTemplateFinish()
  endif

  call cursor(p[0:1])
  
  if s:InitItem()
    return "\<esc>gv\<C-g>"
  else
    call cursor(s:f.CBR(x))
    return ""
  endif

endfunction "}}}


fun! s:Format(range) "{{{
  let x = s:Data()
  let ctx = x.curctx

  if ctx.tmpl.indent.type !=# "auto"
    return
  endif

  let p = getpos(".")[1:2]
  let p[1] = p[1] - len(getline(p[0]))

  let pt = s:TL()
  let pt[1] = pt[1] - len(getline(pt[0]))



  " call Log("processing=".ctx.processing)
  " call Log(string(ctx.pos.curpos))

  if ctx.processing && ctx.pos.curpos != {}
    let pc = s:f.CTL()
    let pc[1] = pc[1] - len(getline(pc[0]))
    let bf = matchstr(x.curctx.lastBefore, s:stripPtn)
  endif

  if a:range == 1
    call s:f.TmplRange()
    normal! gv=
  elseif a:range == 2
    call s:TopTmplRange()
    normal! gv=
  else
    normal! ==
  endif

  let x.curctx.pos.tmplpos.l = max([pt[1] + len(getline(pt[0])), 1])
  if ctx.processing && ctx.pos.curpos != {}
    let x.curctx.pos.curpos.l = max([pc[1] + len(getline(pc[0])), 1])
    let x.curctx.lastBefore = matchstr(getline(p[0]), '\V\^\s\*'.escape(bf, '\'))
  endif


  call cursor(p[0], p[1] + len(getline(".")))

endfunction "}}}




fun! s:BuildItemPosList(val) "{{{

  let x = s:Data()
  let xcp = s:Ctx().pos.curpos
  let ctx = s:Ctx()

  let xp = s:Ctx().tmpl.ptn



  let nlen = len(ctx.name)
  let vlen = len(a:val)
  let llen = len(xp.l)
  let rlen = len(xp.r)
  
  let ptn = s:ItemPattern(ctx.name)

  let ctx.lastcont = a:val
  let ctx.inplist = []

  let ctx.lastBefore = getline(s:CT(x))[:max([s:CL(x)-2, 0])]

  if ctx.name =~ '\V\^...\d\*\$' || ctx.name == ''
    let ctx.lastAfter = getline(s:CB(x))[s:CR(x)-1:]
    return
  endif

  let p0 =s:f.CBR(x)

  let last = s:f.CBR(x)

  call cursor(s:TL(x))

  let i = 0
  while i < 100
    let i = i + 1

    let p = searchpos(s:f.TmplRange().ptn, 'cW')


    if p == [0, 0]
      break
    endif


    " TODO caution with line break when calculate length
    let elt = {'t' : p[0] - last[0], 'l' : (p[0] == last[0] ? p[1] - last[1] : p[1]), 'len' : vlen}

    call add(ctx.inplist, elt)


    " 've' without 'oncmore' problem
    let len = llen + nlen + rlen - 1

    exe 'normal! '. len . 'x'

    let @0 = a:val
    normal! "0P

    let last = [line("."), col(".") + 1]

    exe "normal! \<right>x"


  endwhile


  let xcp.b = p0[0] - line("$")
  let xcp.r = p0[1] - len(getline(p0[0]))
  " call Log("after build pos:xcp.r = ".xcp.r)

  let ctx.lastAfter = getline(s:CB(x))[s:CR(x)-1:]

endfunction "}}}

fun! s:FindNextItem(flag) "{{{

  let flag = matchstr(a:flag, "[cC]")

  let xp = s:Ctx().tmpl.ptn

  let p0 = [line("."), col(".")]


  let ptn = s:Rng_to_TmplEnd() . xp.item
  " call Log("range to end:".string([getpos("'<"), getpos("'>")]))

  let p = searchpos(ptn, "nw" . flag)

  if p == [0, 0]
    " call Log("found nothing")
    let p = searchpos(s:f.TmplRange().xp.cursorPattern, 'n')
    let p += [s:GetName(p[0:1])]
    return p
  endif


  if s:GetName(p[0:1]) ==# s:cursorName
    " call Log("found curosr")

    call cursor(p)
    let ptn = s:Rng_to_TmplEnd() . xp.item
    " call Log("range to end2:".string([getpos("'<"), getpos("'>")]))

    let p = searchpos(ptn, "n")

    call cursor(p0)
  endif

  
  return p + [s:GetName(p[0:1])]
endfunction "}}}

fun! s:InitItem() " {{{
  let x = s:Data()
  let ctx = s:Ctx()
  let vals = s:Ctx().vals
  let xp = s:Ctx().tmpl.ptn
  let xcp = s:Ctx().pos.curpos

  let found = search(xp.lft, "cW")
  if !found
    throw "can not found xp.lft"
  endif


  let [xcp.t, xcp.l] = [line("."),  col(".")]

  exe "normal! ".len(xp.l)."x"

  call search(xp.rt, "cW")
  let [xcp.b, xcp.r] = [line(".") - line("$"), col(".") + len(xp.r) - len(getline("."))]
  " call Log("after init item:xcp.r = ".xcp.r)

  exe "normal! ".len(xp.r)."x"




  " apply default value
  if has_key(vals, ctx.name) && !vals[ctx.name][1] 
    let str = vals[ctx.name][0]

    let str = s:Eval(str)

    call cursor(s:f.CTL(x))
    call s:Replace(s:f.CTL(x), ctx.name, str)
    " exe 'normal! '.len(ctx.name).'x'


    " let @0 = str
    " normal! "0P

    call cursor(s:f.CTL(x))
    call s:BuildValues(1)
    let str = s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x))
  else
    let str = ctx.name
  endif


  call s:BuildItemPosList(str)


  call s:Format(1)




  call s:HighLightItem(ctx.name, 1)
  call s:CallPlugin('afterInitItem')

  call s:f.TmplRange()
  silent! normal! gvzO


  call s:f.GetRangeBetween(s:f.CTL(x), s:f.CBR(x))

  " does it need to select?

  let ctl = s:f.CTL(x)
  let cbr = s:f.CBR(x)
  return ctl[0] < cbr[0] || ctl[0] == cbr[0] && ctl[1] < cbr[1]

endfunction " }}}

fun! s:Unescape(str)
  let ptn = '\V\\\(\.\)'
  return substitute(a:str, ptn, '\1', 'g')
endfunction


fun! s:Eval(s, ...) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xfunc = x.funcs

  let evalCtx = a:0 >= 1 ? a:1 : {'typed' : ''}
  

  " non-escaped prefix
  let ep =   '\%(' . '\%(\[^\\]\|\^\)' . '\%(\\\\\)\*' . '\)' . '\@<='
  
  " non-escaped quotation
  let dqe = '\V\('. ep . '"\)'
  let sqe = '\V\('. ep . "'\\)"

  let dptn = dqe.'\_.\{-}\1'
  let sptn = sqe.'\_.\{-}\1'

  let fptn = '\V' . '\w\+(\[^($]\{-})' . '\|' . ep . '{\w\+(\[^($]\{-})}'
  let vptn = '\V' . '$\w\+' . '\|' . ep . '{$\w\+}'

  let ptn = fptn . '\|' . vptn


  " create mask hidden all string literal
  let mask = substitute(a:s, '[ *]', '+', 'g')
  while 1 "{{{
    let d = match(mask, dptn)
    let s = match(mask, sptn)

    if d == -1 && s == -1 
      break
    endif
    
    if d > -1 && (d < s || s == -1)
      let sub = matchstr(mask, dptn)
      let sub = repeat(' ', len(sub))
      let mask = substitute(mask, dptn, sub, '')
    elseif s > -1
      let sub = matchstr(mask, sptn)
      let sub = repeat(' ', len(sub))
      let mask = substitute(mask, sptn, sub, '')
    endif
      
  endwhile "}}}



  let xfunc._ctx = ctx.evalCtx
  let xfunc._ctx.tmpl = ctx.tmpl
  let xfunc._ctx.step = {}
  let xfunc._ctx.namedStep = {}
  let xfunc._ctx.value = ''
  if ctx.processing
    let xfunc._ctx.step = ctx.step
    let xfunc._ctx.namedStep = ctx.namedStep
    let xfunc._ctx.name = ctx.name
    let xfunc._ctx.value = evalCtx.typed
  endif
   


  " parameter string list
  let plist = {}
  let str = a:s 


  while 1

    let start = match(mask, ptn)
    if start == -1
      break
    endif


    let lmtc = len(matchstr(mask, ptn))
    let mtc = str[start : start + lmtc - 1]


    if mtc =~ '^{.*}$'
      let mtc = mtc[1:-2]
    endif

    
    let [pre, suf] = ['', '']
    if mtc[-1:] == ')' && has_key(xfunc, matchstr(mtc, '^\w\+'))
      let [pre, suf] = ["xfunc.", '']
    elseif mtc[0:0] == '$' && has_key(xfunc, mtc)
      let [pre, suf] = ['xfunc["', '"]']
    endif



    let q = pre . mtc . suf
    let ql = len(q)


    " remove spanned sub expression
    for i in keys(plist)
      if i >= start && i < start + lmtc
        call remove(plist, i)
      endif
    endfor

    " add unparsed string
    let plist[start] = ql


    let mask = (start == 0 ? "" : mask[:start-1]) . repeat(' ', ql). mask[start + lmtc :]
    let str  = (start == 0 ? "" :  str[:start-1]) . q              .  str[start + lmtc :]

  endwhile




  " remove unused parameter string
  let sp = ""
  let last = 0

  fun! S2l(a, b)
    return a:a - a:b
  endfunction

  " let list = sort(items(plist))
  let list = sort(keys(plist), "S2l")
  for k in list

    let kn = 0 + k
    let vn = 0 + k + plist[k]


    " unescape \{ and \(
    " let tmp = substitute( (k == 0 ? "" : (str[last : kn-1])), '\V'.ep.'\\\(\[{(]\)', '\1', 'g')
    let tmp = k == 0 ? "" : (str[last : kn-1])
    let tmp = substitute(tmp, '\\\(.\)', '\1', 'g')
    let sp .= tmp


    let sp .= eval(str[kn : vn-1])


    let last = vn
  endfor

  let tmp = str[last : ]
  let tmp = substitute(tmp, '\\\(.\)', '\1', 'g')
  let sp .= tmp

  return sp

endfunction "}}}



fun! s:EvalFunction(x, f) "{{{
  let xfunc = a:x.funcs
  if has_key(xfunc, matchstr(a:f, '^\w\+'))
    return eval("xfunc.".a:f)
  else
    return eval(a:f)
  endif
endfunction "}}}

fun! s:EvalVariable(x, v) "{{{
  let xvar = a:x.vars
  if has_key(xvar, v)
    return xvar[v]
  else
    return a:v
  endif
endfunction "}}}




" at the input area
fun! s:GetName(pos) " {{{
  let xp = s:Ctx().tmpl.ptn

  let p0 = [line("."), col(".")]

  call cursor(a:pos)

  let p1 = searchpairpos(xp.lft, '', xp.rt, 'nbcW')
  let p2 = searchpairpos(xp.lft, '', xp.rt, 'nW')

  if p1 == [0, 0] || p2 == [0, 0] || a:pos != p1 
    return ""
    " throw "invalid position :".string(a:pos)." p0:".string(p0)." p1:".string(p1)." p2:".string(p2)
  endif

  if p1[0] != p2[0]
    throw "span more than 1 lines"
  endif

  call cursor(p0)
  return strpart(getline(p1[0]), p1[1] + len(xp.l) - 1, p2[1] - (p1[1] + len(xp.l))) 

endfunction " }}}

fun! s:GetTypedContent() " {{{
  let x = s:Data()
  return s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x))
endfunction " }}}

fun! s:f.GetContentBetween(p1, p2) "{{{
  let p =  [line("."), col(".")]

  if a:p1[0] > a:p2[0] || a:p1[0] == a:p2[0] && a:p1[1] >= a:p2[1]
    return ""
  endif

  let [p1, p2] = [a:p1, a:p2]
  " call Log("get content:".string([p1, p2]))


  if p1[0] == p2[0]
    if p1[1] == p2[1]
      return ""
    endif
    return getline(p1[0])[ p1[1] - 1 : p2[1] - 2]
  endif


  if p1 == [1, 1] 
    let r = []
  else
    let r = [getline(p1[0])[p1[1] - 1:]]
  endif


  let r += getline(p1[0]+1, p2[0]-1)
  if p2[1] > 1
    let r += [ getline(p2[0])[:p2[1] - 2] ]
  else
    let r += ['']
  endif

  return join(r, "\n")

endfunction "}}}

fun! s:f.LeftPos(p) "{{{
  let p = a:p
  if p[1] == 1
    if p[0] > 1
      let p = [p[0]-1, col([p[0]-1, "$"])]
    endif
  else
    let p = [p[0], p[1]-1]
  endif

  let p[1] = max([p[1], 1])
  return p
endfunction "}}}

fun! s:CheckAndBS(k) "{{{
  let x = s:Data()
  
  let p = getpos(".")[1:2]
  let ctl = s:f.CTL(x)

  if p[0] == ctl[0] && p[1] == ctl[1]
    return ""
  else
    let k= eval('"\<'.a:k.'>"')
    return k
  endif
endfunction "}}}
fun! s:CheckAndDel(k) "{{{
  let x = s:Data()
  
  let p = getpos(".")[1:2]
  let cbr = s:f.CBR(x)

  if p[0] == cbr[0] && p[1] == cbr[1]
    return ""
  else
    let k= eval('"\<'.a:k.'>"')
    return k
  endif
endfunction "}}}

fun! s:ApplyMap() " {{{
  let xp = s:Ctx().tmpl.ptn


  " TODO mapstack
  inoremap <buffer> <bs> <C-r>=<SID>CheckAndBS("bs")<cr>
  inoremap <buffer> <C-w> <C-r>=<SID>CheckAndBS("C-w")<cr>
  inoremap <buffer> <Del> <C-r>=<SID>CheckAndDel("Del")<cr>
  " inoremap <buffer> <C-u> <C-r>=<SID>CheckAndDel("C-u")<cr>
  inoremap <buffer> <tab> <C-r>=<SID>NextItem()<cr>
  snoremap <buffer> <tab> <Esc>`>a<C-r>=<SID>NextItem()<cr>
  snoremap <buffer> <Del> <Del>i
  snoremap <buffer> <bs> <esc>`>a<bs>


  smap     <buffer> <CR> <Del><Tab>
  

  exe "snoremap ".g:xptemplate_to_right." <esc>`>a"

  exe "inoremap <buffer> ".xp.l.' \'.xp.l
  exe "inoremap <buffer> ".xp.r.' \'.xp.r

endfunction " }}}

fun! s:ClearMap() " {{{
  let xp = s:Ctx().tmpl.ptn

  iunmap <buffer> <bs>
  iunmap <buffer> <C-w>
  iunmap <buffer> <Del>
  iunmap <buffer> <tab>
  sunmap <buffer> <tab>
  sunmap <buffer> <Del>
  sunmap <buffer> <bs>
  sunmap <buffer> <CR>

  exe "sunmap ".g:xptemplate_to_right

  exe "iunmap <buffer> ".xp.l
  exe "iunmap <buffer> ".xp.r
endfunction " }}}

fun! s:StartAppend() " {{{


  let emptyline = (getline(".") =~ '^\s*$')
  if emptyline
    return ";\<C-c>==A\<BS>"
    try
      startinsert!
      call feedkeys(';'."\<C-c>==A\<BS>", 'n')
    catch /.*/
    endtry
  endif

  return ""

endfunction " }}}

fun! s:ReplaceAllMark(name, rep) " {{{
  if a:name == "" || a:name ==# a:rep
    return
  endif

  let xp = s:Ctx().tmpl.ptn

  let ptn = s:ItemPattern(a:name)
  let rep = substitute(a:rep, "\n", '\r', 'g')

  exe '%snomagic/\V' . s:f.TmplRange() . ptn . '/' . escape(rep, '/\') . "/g"
endfunction " }}}

fun! s:f.CTL(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  let cp = x.curctx.pos.curpos
  return [cp.t, cp.l]
endfunction "}}}
fun! s:f.CBR(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  let cp = x.curctx.pos.curpos
  let l = line("$") + cp.b
  return [l, len(getline(l)) + cp.r]
endfunction "}}}

fun! s:CT(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  return x.curctx.pos.curpos.t
endfunction "}}}
fun! s:CL(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  return x.curctx.pos.curpos.l
endfunction "}}}
fun! s:CB(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  return line("$") + x.curctx.pos.curpos.b
endfunction "}}}
fun! s:CR(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  let l = line("$") + x.curctx.pos.curpos.b
  return len(getline(l)) + x.curctx.pos.curpos.r
endfunction "}}}


fun! s:TL(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  let tp = x.curctx.pos.tmplpos
  return [tp.t, tp.l]
endfunction "}}}
fun! s:BR(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  let tp = x.curctx.pos.tmplpos
  let l = tp.b + line("$")
  return [l, tp.r + len(getline(l))]
endfunction "}}}

fun! g:X() "{{{
  return s:Data()
endfunction "}}}


fun! s:Ctx(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  return x.curctx
endfunction "}}}
fun! s:Data() "{{{
  if !exists("b:xptemplateData")
    let b:xptemplateData = {'tmplarr' : [], 'tmpls' : {}, 'funcs' : {}, 'vars' : {}, 'wrapStartPos' : 0, 'wrap' : '', 'functionContainer' : {}}
    let b:xptemplateData.funcs = b:xptemplateData.vars
    let b:xptemplateData.posStack = []
    let b:xptemplateData.stack = []
    let b:xptemplateData.curctx = deepcopy(s:emptyctx)

    let b:xptemplateData.bufsetting = {
          \'ptn' : {'l':'`', 'r':'^'},
          \'indent' : {'type' : 'auto', 'rate' : []}, 
          \'priority' : s:priorities.lang
          \}

    call s:RedefinePattern()

  endif
  return b:xptemplateData
endfunction "}}}
fun! s:RedefinePattern() "{{{
  let xp = b:xptemplateData.bufsetting.ptn

  " even number of '\' or start of line
  let ep = s:ep

  let xp.lft = ep . xp.l
  let xp.rt  = ep . xp.r

  " for search
  let xp.lft_e = ep. '\\'.xp.l
  let xp.rt_e  = ep. '\\'.xp.r

  " regular pattern to match any template item.
  let xp.itemPattern       = xp.lft . '\%(NAME\)' . xp.rt
  let xp.itemContentPattern= xp.lft . '\zs\%(NAME\)\ze' . xp.rt

  let xp.item_var          = '$\w\+'
  let xp.item_qvar         = '{$\w\+}'
  let xp.item_func         = '\w\+(\.\*)'
  let xp.item_qfunc        = '{\w\+(\.\*)}'
  let xp.itemContent       = xp.item_var . '\|' . xp.item_func . '\|' . '\.\{-}'
  let xp.item              = xp.lft . '\%(' . xp.itemContent . '\)' . xp.rt

  let xp.itemMarkLPattern  = '\zs'. xp.lft . '\ze\%(' . xp.itemContent . '\)' . xp.rt
  let xp.itemMarkRPattern  = xp.lft . '\%(' . xp.itemContent . '\)\zs' . xp.rt .'\ze'

  let xp.cursorPattern     = xp.lft . '\%('.s:cursorName.'\)' . xp.rt

  for [k, v] in items(xp)
    if k != "l" && k != "r"
      let xp[k] = '\V' . v
    endif
  endfor

endfunction "}}}

fun! s:PushCtx() "{{{
  let x = s:Data()

  let x.stack += [s:Ctx()]
  let x.curctx = deepcopy(s:emptyctx)
endfunction "}}}
fun! s:PopCtx() "{{{
  let x = s:Data()
  let x.curctx = x.stack[-1]
  call remove(x.stack, -1)
  call s:HighLightItem(x.curctx.name, 1)
endfunction "}}}

fun! s:ItemPattern(name) "{{{
  let xp = s:Data().curctx.tmpl.ptn
  let name = escape(a:name, '\')
  return xp.lft . '\%('.name.'\)' . xp.rt
endfunction "}}}

fun! s:GetBackPos() "{{{
  return [line(".") - line("$"), col(".") - len(getline("."))]
endfunction "}}}

fun! s:PushBackPos() "{{{
  call add(s:Data().posStack, s:GetBackPos())
endfunction "}}}
fun! s:PopBackPos() "{{{
  let x = s:Data()
  let bp = x.posStack[-1]
  call remove(x.posStack, -1)

  let l = bp[0] + line("$")
  let p = [l, bp[1] + len(getline(l))]
  call cursor(p)
  return p
endfunction "}}}


fun! s:SynNameStack(l, c) "{{{
  let ids = synstack(a:l, a:c)
  if empty(ids)
    return []
  endif

  let names = []
  for id in ids 
    let names = names + [synIDattr(id, "name")]
  endfor
  return names
endfunction "}}}

fun! s:CurSynNameStack() "{{{
  return SynNameStack(line("."), col("."))
endfunction "}}}

fun! XPTemplate_cursorLimit() "{{{
  let x = s:Data()
  let ctx = s:Ctx()

  if !ctx.processing
    return ""
  endif

  if g:xptemplate_limit_curosr 

    let m = mode()
    if m =~ "i"

      let [l, c] = [line("."), col(".")]
      if l < s:CT(x) || l == s:CT(x) && c < s:CL(x)
        call cursor(s:CT(x), s:CL(x))
      elseif l > s:CB(x) || l == s:CB(x) && c > s:CR(x)
        call cursor(s:CB(x), s:CR(x))
      endif

    endif

  endif

  let res = ""
  if g:xptemplate_show_stack
    let res = "XPT:"
    for v in x.stack
      let res = res. v.tmpl.name.'['.v.name.']'." > "
    endfor

    let res = res . ctx.tmpl.name.'['.ctx.name.']'." "
  endif

  return res
endfunction "}}}

if g:xptemplate_limit_curosr || g:xptemplate_show_stack

  " ruler used
  if &statusline == ""

    if g:xptemplate_fix

      if &rulerformat == ""
        let sl = "%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P"
      else
        let sl = &rulerformat
      endif

    else
      echom "XPT:You have NO statusline set, and did Not let g:xptemplate_fix=1. 'cursor_protection' or 'show_stack' can NOT work."
    endif

  else
    let sl = &statusline
  endif

  if sl !~ "\\VXPTemplate_cursorLimit()"
    let &statusline='%{XPTemplate_cursorLimit()}'.sl
  endif
endif

fun! s:f.RelToAbs(last, v) "{{{
  if a:v.t == 0 " same line
    let p = [a:last[0] + a:v.t, a:last[1] + a:v.l]
  else
    let p = [a:last[0] + a:v.t, a:v.l]
  endif
  return p
endfunction "}}}

fun! s:Replace(p, c, rep) "{{{

  let oldve = &ve
  set ve=onemore,insert

  let oldww = &ww
  set ww=b,s,h,l,<,>,~,[,]

  try
    let rep = a:rep."-"

    let cptn = escape(a:c, '\/')
    let cptn = '\V'.substitute(cptn, "\n", '\\n', 'g')

    let rptn = escape(a:rep, '\/')
    let rptn = '\V'.substitute(rptn, "\n", '\\n', 'g')


    call cursor(a:p)


    if a:rep != ""

      call s:PushBackPos()

      let @0 = rep
      normal! "0P

      silent! normal! zO

      call s:PopBackPos()


      " remove '-'
      normal! X

      silent! normal! zO
    endif

    let pl = getpos(".")[1:2]

    if a:c == ""
      return pl
    endif


    let cmd = 's/\V\%'.col(".").'c'.cptn.'//'
    exe cmd

    return pl

  catch /NO_ERROR_COUGHT/
  finally
    let &ve=oldve
    let &ww=oldww
  endtry


endfunction "}}}

fun! s:XPTupdate() "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xcp = s:Ctx().pos.curpos


  if !ctx.processing
    return
  endif

  let pp = getpos(".")[1:2]

  call s:CallPlugin("beforeUpdate")

  " update items

  let cont0 = s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x))




  if cont0 ==# ctx.lastcont
    return
  endif

  " call Log("-----------------------")
  " call Log("tmpl    =".ctx.tmpl.name)
  " call Log("lastcont=".ctx.lastcont)
  " call Log("cont0   =".cont0)
  " call Log("current =".string([s:f.CTL(x), s:f.CBR(x)]))
  " call Log("cur     =".string(ctx.pos.curpos))

  let p0 = s:f.CBR(x)



  " let ptn = ctx.lastcont[:-2]
  let ptn = ctx.lastcont
  let ptn = escape(ptn, '\/')
  let ptn = substitute(ptn, "\n", '\\n', 'g')

  let last = s:f.CBR(x)

  for v in ctx.inplist "{{{


    let p = [last[0] + v.t, v.l]

    if v.t == 0 " same line
      let p[1] = p[1] + last[1]
    endif

    let last = s:Replace(p, ctx.lastcont, cont0)

  endfor "}}}


  call cursor(pp)

  let ctx.lastcont = cont0


  let xcp.b = p0[0] - line("$")
  if p0[1] < 1
    let p0[1] =  1
  endif
  let xcp.r = p0[1] - len(getline(p0[0]))
  " call Log("after update:xcp.r = ".xcp.r)



  let l = s:CL(x)
  if l == 1
    let ctx.lastBefore = ""
  else
    let ctx.lastBefore = getline(s:CT(x))[:s:CL(x)-2]
  endif
  let ctx.lastAfter = getline(s:CB(x))[s:CR(x)-1:]


  call s:CallPlugin('afterUpdate')
  call cursor(pp)

endfunction "}}}

fun! s:XPTcheck() "{{{
  let x = s:Data()

  if x.wrap != ''
    let x.wrapStartPos = 0
    let x.wrap = ''
  endif
endfunction "}}}

augroup XPT "{{{
  au! XPT
  au CursorHoldI * call <SID>XPTupdate()
  au CursorMovedI * call <SID>XPTupdate()
  au InsertEnter * call <SID>XPTcheck()

augroup END "}}}

fun! s:XPTuninstall() "{{{
  let path = expand("%:p:h:h")."/xpt.files.txt"

  let fs = readfile(path)
  let ok = confirm("uninstall xptemplate?", "&yes\n&no") == 1
  if !ok 
    return
  endif

  for f in fs
    call delete(f)
  endfor

endfunction "}}}
com! XPTuninstall call <SID>XPTuninstall()


fun! g:XPTaddPlugin(event, func) "{{{
  if has_key(s:plugins, a:event)
    call add(s:plugins[a:event], a:func)
  else
    throw "XPT does NOT support event:".a:event
  endif
endfunction "}}}

fun! s:CallPlugin(ev) "{{{
  if !has_key(s:plugins, a:ev)
    throw "calling invalid event:".a:ev
  endif

  let x = s:Data()
  let v = 0

  for f in s:plugins[a:ev]
    let v = g:XPT[f](x)
    " if !v
      " return
    " endif
  endfor

endfunction "}}}

" runtime plugin/xpt.plugin.highlight.vim
runtime plugin/xpt.plugin.protect.vim


