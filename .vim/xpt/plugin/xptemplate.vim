" XPTEMPLATE ENGIE:
"   code template engine
" VERSION: 0.2.6
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


let s:stripPtn     = '\V\^\s\*\zs\.\*'
let s:cursorName   = "cursor"
let s:wrappedName  = "wrapped"
let s:repeatPtn    = '...'
let s:emptyctx     = {'tmpl' : {}, 'name' : '', 'processing' : 0, 'pos' : {'tmplpos' : {}, 'curpos' : {} }, 'vals' : {}, 'inplist' : [],  'lastcont' : '', 'lastBefore' : '', 'lastAfter' : '', 'unnameInx' : 0}
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

let s:f = {}
let g:XPT = s:f


fun! g:XPTvars() "{{{
  return s:Data().vars
endfunction "}}}
fun! g:XPTfuncs() "{{{
  return s:Data().funcs
endfunction "}}}

fun! XPTemplateMark(sl, sr) "{{{
  let x = s:Data().bufptn
  let x.l = a:sl
  let x.r = a:sr
  call s:RedefinePattern()
endfunction "}}}

" @param String name	 		tempalte name
" @param String context			[optional] context syntax name
" @param String|List|FunCRef str	template string
fun! XPTemplate(name, str_or_ctx, ...) " {{{

  let xa = s:Data().tmplarr
  let xt = s:Data().tmpls
  let xp = s:Data().bufptn

  let ctx = {}

  if a:0 == 0          " no syntax context
    let T_str = a:str_or_ctx
  elseif a:0 == 1      " with syntax context
    let ctx = a:str_or_ctx
    let T_str = a:1
  endif


  if type(T_str) == type([])
    let Str = join(T_str, "\n")
  elseif type(T_str) == type(function("tr"))
    let Str = T_str
  else 
    let Str = T_str
  endif

  if type(Str) == type('') 
    " if Str !~# xp.cursorPattern
      " let Str = Str . xp.l . s:cursorName . xp.r
    " endif
  endif


  if !has_key(xt, a:name)
    call add(xa, a:name)
  endif
  let xt[a:name] = {
        \ 'name' : a:name, 
        \ 'tmpl' : Str, 
        \ 'ctx' : ctx,
        \ 'ptn' : deepcopy(s:Data().bufptn),
        \ 'wrapped' : type(Str) != type(function("tr")) && Str =~ '\V' . xp.lft . s:wrappedName . xp.rt}


endfunction " }}}

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

  let ctx.processing = 1
  let ctx.tmpl = x.tmpls[tmplname]


  " leave 1 char at last to avoid the bug when 'virtualedit' is not set with
  " 'onemore'
  call cursor(lnn, coln)
  let len = col0 - coln - 1 " leave the last
  if len >= 1
    exe "normal! " . len . 'x'
  endif

  call s:RenderTemplate(lnn, coln, ctx.tmpl.tmpl)

  " remove the last
  call cursor(s:BR(x))
  normal! x 

  if empty(x.stack)
    call s:ApplyMap()
  endif

  let x.wrap = ''
  let x.wrapStartPos = 0

  return s:SelectNextItem(lnn, coln)



endfunction " }}}

fun! s:XPTemplateFinish() "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn

  match none

  let l = line(".")
  let toEnd = col(".") - len(getline("."))

  " unescape
  exe "silent! %snomagic/\\V" .s:f.TmplRange() . xp.lft_e . '/' . xp.l . '/g'
  exe "silent! %snomagic/\\V" .s:f.TmplRange() . xp.rt_e . '/' . xp.r . '/g'

  " format template text
  call s:f.TmplRange()
  exe "normal! gv="

  call cursor(l, toEnd + len(getline(l)))


  if empty(x.stack)
    let ctx.processing = 0
    call s:ClearMap()
  else
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

    if key =~ "^_"
      call add(cmpl2, key)
    else
      call add(cmpl, key)
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


  let rpt = ""

  let rp = xp.lft . s:repeatPtn . xp.rt
  let repPtn =  rp . '\_.\*' . rp 
  if tmpl =~ repPtn
    let rpt = matchstr(tmpl, rp.'\zs\_.\*'.rp)

    " '\\' used in replacing item
    let rpt = substitute(rpt, xp.lft, '\\'.xp.l, 'g')
    let rpt = substitute(rpt, xp.rt, '\\'.xp.r, 'g')

    " for rpt used as replacing item, it must be escaped
    let rpt = escape(rpt, '\')
    let tmpl = substitute(tmpl, repPtn, 
          \ xp.l . s:repeatPtn . xp.r . rpt . xp.r . xp.r, '')
  endif



  let tmpl = substitute(tmpl, '\V' . xp.lft . s:wrappedName . xp.rt, x.wrap, 'g')
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
  silent! normal! zO


  " the ';'
  call cursor(s:BR(x))
  " fix 've' setting
  call search(";", "cb")
  normal! x 
  silent! normal! zO


  let ctx.vals = {}
  call cursor(p)
  call s:BuildValues(0)



  call cursor(p)

  call s:ApplyPredefined()


  " open all folds
  call s:TopTmplRange()
  exe "silent! normal! gvzO"
  " format
  let p0 = s:TL(x)
  let p0[1] = p0[1] - len(getline(p0[0]))
  exe "normal! gv="
  let ctx.pos.tmplpos.l = p0[1] + len(getline(p0[0]))


endfunction " }}}

fun! s:BuildValues(isItemRange) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn



  let i = ctx.unnameInx
  while i < 1000
    if a:isItemRange
      let rt = s:GetCurrentTypedRange()
    else
      let rt = s:f.TmplRange()
    endif

    let _p = getpos(".")
    while  0 != search(rt.s:ItemPattern(i))
      let i = i + 1
    endwhile
    call cursor(_p[1:2])



    if a:isItemRange
      let rt = s:GetCurrentTypedRange()
    else
      let rt = s:f.TmplRange()
    endif
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

      " unescape
      let val = substitute(val, '\\\(.\)', '\1', 'g')



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

    if p[0:1] == [0, 0] || p[2] == s:cursorName
      break
    endif

    let name = p[2]

    let v = s:EvalValue(name)

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

  call s:ApplyDelayed()

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

  if has_key(vals, ctx.name) && vals[ctx.name][1]
    if s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x)) == ctx.name
      call s:GetCurrentTypedRange()
      normal! gvd
      
      call cursor(s:f.CBR())
      let @0 = s:EvalValue(vals[ctx.name][0])
      normal! "0P

      call s:BuildValues(1)
      call s:XPTupdate()
    endif
  endif
  
endfunction "}}}


fun! s:SelectNextItem(fromln, fromcol) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn

  let ln  = a:fromln
  let cur = a:fromcol

  call cursor(ln, cur)

  let p = s:FindNextItem('c')
  if p[0:1] == [0, 0]
    call cursor(s:BR(x))
    return s:XPTemplateFinish()
  endif

  let ctx.name = p[2]

  if ctx.name == s:cursorName
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


fun! s:Format(isfull) "{{{
  let x = s:Data()

  let p = getpos(".")[1:2]
  let p[1] = p[1] - len(getline(p[0]))

  let pt = s:TL()
  let pt[1] = pt[1] - len(getline(pt[1]))

  let pc = s:f.CTL()
  let pc[1] = pc[1] - len(getline(pc[0]))

  let bf = matchstr(x.curctx.lastBefore, s:stripPtn)

  if a:isfull
    call s:f.TmplRange()
    normal! gv=
  else
    normal! ==
  endif

  let x.curctx.pos.curpos.l = max([pc[1] + len(getline(pc[0])), 1])
  let x.curctx.pos.tmplpos.l = max([pt[1] + len(getline(pt[0])), 1])

  let x.curctx.lastBefore = matchstr(getline(p[0]), '\V\^\s\*'.escape(bf, '\'))

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

  let ctx.lastBefore = getline(s:CT(x))[:s:CL(x)-2]

  if ctx.name == '...' || ctx.name == ''
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

    exe 'normal! '. (llen + nlen + rlen) . 'x'

    let @0 = a:val
    normal! "0P

    let last = [line("."), col(".") + 1]


  endwhile


  let xcp.b = p0[0] - line("$")
  let xcp.r = p0[1] - len(getline(p0[0]))

  let ctx.lastAfter = getline(s:CB(x))[s:CR(x)-1:]

endfunction "}}}

fun! s:FindNextItem(flag) "{{{

  let flag = matchstr(a:flag, "[cC]")

  let xp = s:Ctx().tmpl.ptn

  let p0 = [line("."), col(".")]


  let ptn = s:Rng_to_TmplEnd() . xp.item

  let p = searchpos(ptn, "nw" . flag)

  if p == [0, 0]
    let p = searchpos(s:f.TmplRange().xp.cursorPattern, 'n')
    let p += [s:GetName(p[0:1])]
    return p
  endif


  if s:GetName(p[0:1]) == s:cursorName

    call cursor(p)
    let ptn = s:Rng_to_TmplEnd() . xp.item

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

  exe "normal! ".len(xp.r)."x"




  " apply default value
  if has_key(vals, ctx.name) && !vals[ctx.name][1] 
    let str = vals[ctx.name][0]

    let str = s:EvalValue(str)

    call cursor(s:f.CTL(x))
    exe 'normal! '.len(ctx.name).'x'


    let @0 = str
    normal! "0P

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

fun! s:EvalValue(str) "{{{
  let xp = s:Ctx().tmpl.ptn
  let xvar = s:Data().vars
  let xfunc = s:Data().funcs

  let name = a:str
  let v = name

  let varptn = '\V' . '\%(' . xp.item_var . '\)\|\%(' . xp.item_qvar . '\)'
  let funptn = '\V' . '\%(' . xp.item_func . '\)\|\%(' . xp.item_qfunc . '\)'

  let r = ""

  while 1

    let vs = matchstr(name, varptn)
    if vs != "" 
      let c = match(name, varptn)
      if c > 0
        let r .= name[:c-1]
      endif

      " remove variable pattern
      let name = name[c + len(vs):]

      " strip '{}'
      let vs = matchstr(vs, xp.item_var)

      if  has_key(xvar, vs)
        let r .= xvar[vs]
      else
        throw "undefined variable:".vs
      endif

      continue

    endif


    let fs = matchstr(name, funptn)
    if fs != ""
      let c = match(name, funptn)
      if c > 0
        let r .= name[:c-1]
      endif

      let name = name[c + len(fs):]

      let fs = matchstr(fs, xp.item_func)


      let funcname = matchstr(fs, '\V\^\.\{-}\ze(')
      let funcparam = matchstr(fs, '\V\^\.\{-}(\zs\.\*\ze)')


      if has_key(xfunc, funcname) 

        let tctx = {}

        if funcparam == ""
          let funcparam = "tctx"
        else
          let funcparam = "tctx, ".funcparam
        endif

        let fun = "xfunc.".funcname."(".funcparam.")"
      else
        let fun = fs
      endif

      let r .= eval(fun)

      continue

    endif

    let r .= name
    break

  endwhile

  return r

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

  if p1[0] == p2[0]
    return getline(p1[0])[ p1[1] - 1 : p2[1] - 2 ]
  endif

  let r = [getline(p1[0])[p1[1] - 1:]]
  let r += getline(p1[0]+1, p2[0]-1)
  let r += [getline(p2[0])[:p2[1] - 2]]

  return join(r, "\n")

endfunction "}}}

fun! s:f.LeftPos(p)
  let p = a:p
  if p[1] == 1
    if p[0] > 1
      let p = [p[0]-1, col([p[0]-1, "$"])-1]
    endif
  else
    let p = [p[0], p[1]-1]
  endif

  let p[1] = max([p[1], 1])
  return p
endfunction

fun! s:CheckAndBS(k)
  let x = s:Data()
  
  let p = getpos(".")[1:2]
  let ctl = s:f.CTL(x)

  if p[0] == ctl[0] && p[1] == ctl[1]
    return ""
  else
    let k= eval('"\<'.a:k.'>"')
    return k
  endif
endfunction
fun! s:CheckAndDel(k)
  let x = s:Data()
  
  let p = getpos(".")[1:2]
  let cbr = s:f.CBR(x)

  if p[0] == cbr[0] && p[1] == cbr[1]
    return ""
  else
    let k= eval('"\<'.a:k.'>"')
    return k
  endif
endfunction

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
  if a:name == "" || a:name == a:rep
    return
  endif

  let xp = s:Ctx().tmpl.ptn

  let ptn = s:ItemPattern(a:name)
  " let ptn = substitute(xp.itemPattern, "NAME", a:name, "")
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

fun! s:Ctx(...) "{{{
  let x = a:0 == 1 ? a:1 : s:Data()
  return x.curctx
endfunction "}}}
fun! s:Data() "{{{
  if !exists("b:xptemplateData")
    let b:xptemplateData = {'tmplarr' : [], 'tmpls' : {}, 'funcs' : {}, 'vars' : {}, 'wrapStartPos' : 0, 'wrap' : '', 'functionContainer' : {}}
    let b:xptemplateData.posStack = []
    let b:xptemplateData.stack = []
    let b:xptemplateData.curctx = deepcopy(s:emptyctx)
    let b:xptemplateData.bufptn = {'l':'`', 'r':'^'}

    call s:RedefinePattern()

  endif
  return b:xptemplateData
endfunction "}}}
fun! s:RedefinePattern() "{{{
  let xp = b:xptemplateData.bufptn

  " even number of '\' or start of line
  let ep = '\%(' . '\%(\[^\\]\|\^\)' . '\%(\\\\\)\*' . '\)' . '\@<='

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
  return substitute(s:Ctx().tmpl.ptn.itemPattern, 'NAME', a:name, '')
endfunction "}}}

fun! s:GetPos() "{{{
  return [line("."), col(".")]
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

  if sl !~ "\VXPTemplate_cursorLimit()"
    exe 'set statusline=%{XPTemplate_cursorLimit()}'.escape(sl, '\ ')
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

  if cont0 == ctx.lastcont
    return
  endif


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


    call cursor(p) " goto next item

    if ctx.lastcont != ""
      let fptn = 's/\V\%'.p[1].'c'.ptn.'//'
      exe fptn

      silent! normal! zO
    endif

    call cursor(p) " goto next item

    if cont0 != ""
      let pc = [line(".") - line("$"), col(".") - len(getline("."))]
      let @0 = cont0.";"
      normal! "0P
      silent! normal! zO


      let dl = pc[0] + line("$")
      let dc = pc[1] + len(getline(dl)) - 1 " the last ';'
      call cursor(dl, dc)

      normal! x
    endif


    let v.len =  len(cont0)

    let last = [line("."), col(".")]
  endfor "}}}



  call cursor(pp)

  let ctx.lastcont = cont0


  let xcp.b = p0[0] - line("$")
  if p0[1] < 1
    let p0[1] =  1
  endif
  let xcp.r = p0[1] - len(getline(p0[0]))


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
  echo fs
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

runtime plugin/xpt.plugin.highlight.vim
runtime plugin/xpt.plugin.protect.vim
