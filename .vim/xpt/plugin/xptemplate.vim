" XPTEMPLATE ENGIE:
"   code template engine
" VERSION: 0.3.7.7
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
" TODO mechanism to set personal variables
" TODO laststatus!=2 cause cursor protection failed.
" TODO auto crash
" TODO $BRACKETSTYLE caused indent problem
" TODO more g: option
" TODO nested repetition in expandable
" TODO change on previous item
" TODO ordered item
" TODO ontime filter
" TODO lock key variables
" TODO as function call template
" TODO map stack
" TODO when popup displayed, map <cr> to trigger template start 
" TODO undo
" TODO wrapping on different visual mode
" TODO prefixed template trigger
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


let s:ep      =   '\%(' . '\%(\[^\\]\|\^\)' . '\%(\\\\\)\*' . '\)' . '\@<='
let s:escaped =   '\%(' . '\%(\[^\\]\|\^\)' . '\%(\\\\\)\*' . '\)' . '\@<=' . '\\'

let s:stripPtn     = '\V\^\s\*\zs\.\*'
let s:cursorName   = "cursor"
let s:wrappedName  = "wrapped"
let s:expandablePtn= '\V\^\_s\*'.'\w\+'. '...' . '\_s\*\$'
let s:repeatPtn    = '...\d\*'
let s:emptyctx     = {
      \'tmpl' : {}, 
      \'evalCtx' : {}, 
      \'name' : '', 
      \'fullname' : '', 
      \'step': [], 
      \'namedStep':{}, 
      \'processing' : 0, 
      \'pos' : {'tmplpos' : {}, 'curpos' : {}, 'editpos' : {} }, 
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

let s:priorities = {'all' : 64, 'spec' : 48, 'like' : 32, 'lang' : 16, 'sub' : 8, 'personal' : 0}
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
  elseif a:p =~ '/\d\+\(\*\d\+\)\?'
    let x.type = 'rate'

    let str = matchstr(a:p, '/\d\+\(\*\d\+\)\?')

    let x.rate =split(str, '/\|\*')

    if len(x.rate) == 1
      let x.rate[1] = &l:shiftwidth
    endif
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
    " let override_priority = s:ParsePriority("")
    let override_priority = x.bufsetting.priority
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


fun! s:XPTemplateParse(lines) "{{{
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

  let def = {}
  let post = {}
  let start = 1
  while start < len(lines)
    if lines[start] =~# '^XSET\s\+'
      let item = matchstr(lines[start], '^XSET\s\+\zs.*')

      let key = matchstr(item, '[^=]*\ze=')
      let val = matchstr(item, '=\zs.*')
      let val = substitute(val, '\\n', "\n", 'g')

      let keytype = matchstr(key, '\V'.s:ep.'|\zs\.\{-}\$')
      if keytype == ""
        let keytype = matchstr(key, '\V'.s:ep.'.\zs\.\{-}\$')
      endif

      let keyname = keytype == "" ? key :  key[ : - len(keytype) - 2 ]
      let keyname = substitute(keyname, '\V\\\(\[.|\\]\)', '\1', 'g')


      if keytype == "" || keytype ==# 'def'
        let def[keyname] = val
      elseif keytype ==# 'post'
        let post[keyname] = val
      else
        throw "unknown key type:".keytype
      endif

    elseif lines[start] =~# '^\\XSET'
      let lines[start] = lines[start][1:]
      break
    else
      break
    endif

    let start += 1
  endwhile


  let ctx.vdef = def
  let ctx.vpost = post


  let tmpl = lines[start : ]

  call XPTemplate(name, ctx, tmpl)

endfunction "}}}

fun! s:XPTemplate_def(fn) "{{{
  let lines = readfile(a:fn)


  " find the line where XPTemplateDef called
  let [i, len] = [0, len(lines)]
  while i < len
    if lines[i] =~# '^XPTemplateDef'
      break
    endif

    let i += 1
  endwhile


  " parse lines
  " start end and blank start
  let [s, e, blk] = [-1, -1, 10000]
  while i < len-1 | let i += 1

    let v = lines[i]

    " blank line
    if v =~ '^\s*$' || v =~ '^"[^"]*$'
      let blk = min([blk, i - 1])
      continue
    endif


    if v =~# '^\.\.XPT'

      let e = i - 1
      call s:XPTemplateParse(lines[s : e])
      let [s, e, blk] = [-1, -1, 10000]

    elseif v =~# '^XPT\s'

      if s != -1
        " template with no end
        let e = min([i - 1, blk])
        call s:XPTemplateParse(lines[s : e])
        let [s, e, blk] = [i, -1, 10000]
      else
        let s = i
        let blk = i
      endif

    else
      let blk = i
    endif

  endwhile

  if s != -1
    call s:XPTemplateParse(lines[s : min([blk, i])])
  endif

endfunction "}}}

com! XPTemplateDef call s:XPTemplate_def(expand("<sfile>")) | finish
 



fun! s:GetHint(ctx, str) "{{{
  let xp = s:Data().bufsetting.ptn
  let hint = a:str

  if has_key(a:ctx, 'hint')
    let hint = s:Eval(a:ctx.hint)
  else
    let hint = ""
  endif

  return hint
endfunction "}}}

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

  let ppr = s:Popup(tmplname, coln)
  if ppr == "" 
    return ""
  endif

  let tmplname = ppr


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

    " TODO filter
    if a:pref != "" && key !~ "^".a:pref | continue | endif
    if val.wrapped && empty(x.wrap) || !val.wrapped && !empty(x.wrap) | continue | endif
    if has_key(val.ctx, "syn") && val.ctx.syn != '' && match(ctxs, '\c'.val.ctx.syn) == -1 | continue | endif

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


  if len(cmpl) == 1 || len(cmpl) > 0 && a:pref == cmpl[0].word
    return cmpl[0].word
  endif

  call complete(a:coln, cmpl)
  return ""

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

  " process indent
  let preindent = repeat(" ", virtcol(".") - 1)

  " at first, only use default indent
  if ctx.tmpl.indent.type =~# 'keep\|rate\|auto'
    if ctx.tmpl.indent.type ==# "rate"
      let idtptn = repeat(' ', ctx.tmpl.indent.rate[0])
      let idtptn ='\(\%('.idtptn.'\)*\)'

      let idtrep = repeat('\1', ctx.tmpl.indent.rate[1] / ctx.tmpl.indent.rate[0])


      let tmpl = substitute(tmpl, '\%(^\|\n\)\zs'.idtptn, idtrep, 'g')
    endif
    let tmpl = substitute(tmpl, '\n', '&'.preindent, 'g')
  endif


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
  call s:TopTmplRange()
  silent! normal! gvzO



  " the ';'
  call cursor(s:BR(x))
  " fix 've' setting
  call search(";", "cb")
  normal! x 
  call s:TopTmplRange()
  silent! normal! gvzO


  call cursor(p)
  call s:BuildValues(0)



  call cursor(p)

  call s:ApplyPredefined('')



  " open all folds
  call s:TopTmplRange()
  silent! normal! gvzO

  " at first, only use default indent
  " call s:Format(2)

  call s:TopTmplRange()
  silent! normal! gvzO



endfunction " }}}

fun! s:GetNameInfo(end) "{{{
  let x = s:Data()
  let xp = x.curctx.tmpl.ptn

  if getline(".")[col(".") - 1] != xp.l
    throw "cursor is not at item start position:".string(getpos(".")[1:2])
  endif


  let endn = a:end[0] * 10000 + a:end[1]

  let l0 = getpos(".")[1:2]
  let r0 = searchpos(xp.rt, 'nW')

  let r0n = r0[0] * 10000 + r0[1]

  if r0 == [0, 0] || r0n >= endn
    " no item exists
    return [[0, 0], [0, 0], [0, 0], [0, 0]]
  endif

  let l1 = searchpos(xp.lft, 'W')
  let l2 = searchpos(xp.lft, 'W')

  let l1n = l1[0] * 10000 + l1[1]
  let l2n = l2[0] * 10000 + l2[1]

  if l1n > r0n || l1n >= endn
    let l1 = [0, 0]
  endif
  if l2n > r0n || l1n >= endn
    let l2 = [0, 0]
  endif

  if l1 != [0, 0] && l2 != [0, 0]
    " 2 edges
    return [l0, l1, l2, r0]
  elseif l1 == [0, 0] && l2 == [0, 0]
    " no edge
    return [l0, l0, r0, r0]
  else
    " only left edge
    return [l0, l1, r0, r0]
    " throw "unmatch item edge mark, at:".string([l0, r0])."=".s:f.GetContentBetween(l0, r0)
  endif

endfunction "}}}

fun! s:GetValueInfo(end) "{{{
  let x = s:Data()
  let xp = x.curctx.tmpl.ptn

  if getline(".")[col(".") - 1] != xp.r
    throw "cursor is not at item end position:".string(getpos(".")[1:2])
  endif

  let endn = a:end[0] * 10000 + a:end[1]

  let r0 = getpos(".")[1:2]

  let l0 = searchpos(xp.lft, 'nW')
  let l0n = min([l0[0] * 10000 + l0[1], endn])
  if l0n == 0
    let l0n = 10000 * 10000
  endif

  let r1 = searchpos(xp.rt, 'W')
  if r1 == [0, 0] || r1[0] * 10000 + r1[1] > l0n
    return [r0, [0, 0], [0, 0]]
  endif

  let r2 = searchpos(xp.rt, 'W')
  if r2 == [0, 0] || r2[0] * 10000 + r2[1] > l0n
    return [r0, r1, r1]
  endif

  return [r0, r1, r2]
endfunction "}}}

fun! s:BuildValues(isItemRange) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn


  let i = ctx.unnameInx
  while i < 1000
    let rt = a:isItemRange ? s:GetCurrentTypedRange() : s:f.TmplRange()

    " TODO count from back to identify anonymous item
    " TODO not reliable for ```^ item
    let _p = getpos(".")[1:2]
    while  search(rt.s:ItemPattern(i))
      let i = i + 1
    endwhile

    call cursor(_p)



    " let rt = a:isItemRange ? s:GetCurrentTypedRange() : s:f.TmplRange()

    let poso = a:isItemRange ? ctx.pos.curpos : ctx.pos.tmplpos

    " let start = 
    let end = s:Xbr(poso)
    let endn = end[0] * 10000 + end[1]

    let nn = searchpos(xp.lft, 'cW')
    if nn == [0, 0] || nn[0] * 10000 + nn[1] >= endn
      break
    endif

    let ninfo = s:GetNameInfo(end)
    if ninfo[0] == [0, 0]
      break
    endif

    call cursor(ninfo[3])
    let vinfo = s:GetValueInfo(end)
    if vinfo[0] == [0, 0]
      break
    endif



    if vinfo[1] != [0, 0]
      let isdelayed = vinfo[1][0] == vinfo[2][0] && vinfo[1][1] + len(xp.r) == vinfo[2][1]

      let np1 = [ninfo[1][0], ninfo[1][1] + len(xp.l)]
      let np2 = [ninfo[2][0], ninfo[2][1]]
      let fullname = s:f.GetContentBetween([ninfo[0][0], ninfo[0][1] + len(xp.l)], ninfo[3])
      " let fullname = substitute(fullname, xp.lft, '', 'g')
      let name = s:f.GetContentBetween(np1, np2)
      let val = s:f.GetContentBetween([vinfo[0][0], vinfo[0][1]+len(xp.r)], vinfo[1])


      " [default_value, is_delayed]
      let dic = isdelayed ? 'vpost' : 'vdef'
      if name == ""
        let ctx.tmpl.ctx[dic][i] = val
      else 
        let ctx.tmpl.ctx[dic][name] = val
      endif



      call cursor(vinfo[2])
      call s:PushBackPos()
      let fullname = name == "" ? i : fullname
      call s:Replace(ninfo[0], s:f.GetContentBetween(ninfo[0], vinfo[2]), xp.l . fullname)
      call s:PopBackPos()

    else
      call cursor(ninfo[3])
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

fun! s:ApplyPredefined(flag) " {{{
  let x = s:Data()
  let xp = s:Ctx().tmpl.ptn
  let xpos = x.curctx.pos
  let xvar = s:Data().vars
  let xfunc = s:Data().funcs



  if a:flag == 'typed'
    let start = s:Xtl(xpos.curpos)
    let end = s:Xbr(xpos.curpos)
  else
    let start = s:Xtl(xpos.tmplpos)
    let end = s:Xbr(xpos.tmplpos)
  endif

  let endn = end[0] * 10000 + end[1]

  call cursor(start)

  let i = 0
  while i < 100
    let i = i + 1

    let p = s:FindNextItem('cW')

    if p[0:1] == [0, 0] || p[2] ==# s:cursorName || p[0] * 10000 + p[1] >= endn
      break
    endif

    let name = p[3]

    
    let v = s:Eval(name)

    if v != name
      call s:ReplaceAllMark(name, escape(v, '\'), a:flag)
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

fun! s:NextItem(flag) " {{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xpos = ctx.pos

  let p0 = s:f.CTL(x)

  let p = [line("."), col(".")]
  let name = ctx.name

  call s:HighLightItem(name, 0)

  if a:flag ==# 'clear'
    call s:Replace(s:Xtl(xpos.curpos), [s:Xtl(xpos.curpos), s:Xbr(xpos.curpos)], '')
  endif

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


  " let typed = s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x))
  let typed = s:f.GetContentBetween(s:Xtl(ctx.pos.curpos), s:Xbr(ctx.pos.curpos))


  if has_key(ctx.tmpl.ctx.vpost, ctx.name)

    if ctx.name =~ '^\.\.\.\d*$' || ctx.name =~ s:expandablePtn
      let post = ctx.tmpl.ctx.vpost[ctx.name]
      let post = s:Unescape(post)
    else
      let post = s:Eval(ctx.tmpl.ctx.vpost[ctx.name], {'typed' : typed})
    endif


    let isrep = 0


    if ctx.name =~ '^\.\.\.\d*$' || ctx.name =~ s:expandablePtn
      let isrep = typed =~# '\V\^\_s\*' . ctx.name . '\_s\*\$'
    else
      let isrep = 1
    endif


    if isrep

      call s:Replace(s:Xtl(ctx.pos.curpos), typed, post)
      call s:ApplyPredefined('typed')
      call cursor(s:Xtl(ctx.pos.curpos))
      call s:BuildValues(1)

    endif

    if isrep
      call s:XPTupdate()
      return post
    endif
  endif

  call s:XPTupdate()
  return typed

endfunction "}}}


fun! s:SelectNextItem(...) "{{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xp = s:Ctx().tmpl.ptn

  let pos = a:0 == 1 ? a:1 : [a:1, a:2]

  call cursor(pos)

  let p = s:FindNextItem('c')
  if p[0:1] == [0, 0]
    call cursor(s:BR(x))

    return s:XPTemplateFinish(1)

  endif

  let ctx.fullname = p[2]
  let ctx.name = p[3]
  " let ctx.name = p[2]

  if ctx.fullname ==# s:cursorName
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

  call s:PushBackPos()
  " let p = getpos(".")[1:2]
  " let p[1] = p[1] - len(getline(p[0]))

  let pt = s:TL()
  let pt[1] = pt[1] - len(getline(pt[0]))




  if ctx.processing && ctx.pos.curpos != {}
    let pi = s:Xtl(ctx.pos.editpos)
    let pi[1] = pi[1] - len(getline(pi[0]))

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
    call s:Xtl(ctx.pos.editpos, pi[0], max([pi[1] + len(getline(pi[0])), 1]))
    let x.curctx.pos.curpos.l = max([pc[1] + len(getline(pc[0])), 1])
    let x.curctx.lastBefore = matchstr(getline(pc[0]), '\V\^\s\*'.escape(bf, '\'))
  endif


  call s:PopBackPos()
  " call cursor(p[0], p[1] + len(getline(".")))

endfunction "}}}




fun! s:BuildItemPosList(val) "{{{

  let x = s:Data()
  let xcp = s:Ctx().pos.curpos
  let ctx = s:Ctx()
  let xpos= ctx.pos

  let xp = s:Ctx().tmpl.ptn



  let nlen = len(ctx.name)
  let vlen = len(a:val)
  let llen = len(xp.l)
  let rlen = len(xp.r)

  " let ptn = s:ItemPattern(ctx.name)
  let ptn = s:ItemFullPattern(ctx.name)


  let ctx.lastcont = a:val
  let ctx.inplist = []

  if s:CL(x) == 1
    let ctx.lastBefore = ""
  else
    let ctx.lastBefore = getline(s:CT(x))[:max([s:CL(x)-2, 0])]
  endif

  if ctx.name =~ '\V\^...\d\*\$' || ctx.name == ''
    let ctx.lastAfter = getline(s:CB(x))[s:CR(x)-1:]
    return
  endif

  let p0 =s:f.CBR(x)
  let pitem =s:Xbr(xpos.editpos)

  let last = s:f.CBR(x)

  call cursor(s:TL(x))

  let i = 0
  while i < 100
    let i = i + 1

    let p = searchpos(s:f.TmplRange().ptn, 'cW')

    if p == [0, 0]
      break
    endif

    " delete left most mark
    call cursor(p)
    exe 'silent! normal! '. len(xp.l) . 'xzO'



    " TODO find out real name
    let right = searchpos(s:vrange . xp.rt, 'W')
    if right == [0, 0]
      throw "can not find right mark"
    endif

    call s:PushBackPos()

    " TODO
    let [cl, cr] = [p, right]

    let rng = s:f.GetRangeBetween(p, right)

    call cursor(p)
    let left1 = searchpos(rng . xp.lft, 'cW') " cursor moved
    if left1 != [0, 0] 
      " has left edge
      let cl = left1
      exe 'silent! normal! '. len(xp.l) . 'xzO'


      let cr = s:PopBackPos()
      let right = cr
      call s:PushBackPos()

      let rng = s:f.GetRangeBetween(p, right)

      call cursor(cl)
      let left2 = searchpos(rng . xp.lft, 'W')
      if left2 != [0, 0]
        " has right edge
        let cr = left2
        exe 'silent! normal! '. len(xp.l) . 'xzO'

      endif
    endif

    let right = s:PopBackPos()
    exe 'silent! normal! '. len(xp.r) . 'xzO'



    " TODO items before it
    " TODO use back counted pos
    " TODO caution with line break when calculate length
    let elt = {
          \'t' : cl[0] - last[0], 
          \'l' : (cl[0] == last[0] ? cl[1] - last[1] : cl[1]), 
          \'len' : vlen
          \}

    call add(ctx.inplist, elt)

    " call s:PushBackPos()

    let last = s:Replace(cl, ctx.name, a:val)

    call cursor(last)

  endwhile


  let xcp.b = p0[0] - line("$")
  let xcp.r = p0[1] - len(getline(p0[0]))

  call s:Xbr(xpos.editpos, pitem)


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
    if p == [0, 0]
      let p += ["", ""]
    else
      let p += s:GetName(p[0:1])
    endif
    return p
  endif


  if s:GetName(p[0:1])[0] ==# s:cursorName

    call cursor(p)
    let ptn = s:Rng_to_TmplEnd() . xp.item

    let p = searchpos(ptn, "n")

    call cursor(p0)
  endif


  return p + s:GetName(p[0:1])
endfunction "}}}

fun! s:GetTypeArea() "{{{

  let ctx = s:Ctx()
  let xp = ctx.tmpl.ptn
  let xpos = ctx.pos


  let oldve = &l:ve
  setlocal ve=all

  try
    let [ctl, cbr] = [s:Xtl(xpos.curpos), s:Xbr(xpos.curpos)]
    let cbrn = cbr[0] * 10000 + cbr[1]

    " set default
    call s:Xtl(xpos.editpos, ctl)
    call s:Xbr(xpos.editpos, cbr)


    let ptn = s:f.GetRangeBetween(ctl, cbr) . xp.lft

    call cursor(ctl)

    let markLeft = searchpos(ptn, 'cW')
    if markLeft == [0, 0] || markLeft[0] * 10000 + markLeft[1] >= cbrn
      return
    endif

    call s:Xtl(xpos.editpos, getpos(".")[1:2])
    " delete left mark
    exe 'silent! normal! '.len(xp.l).'xzO'

    " cbr is changed since last deletion of right mark
    let [ctl, cbr] = [s:Xtl(xpos.curpos), s:Xbr(xpos.curpos)]
    let cbrn = cbr[0] * 10000 + cbr[1]

    " only 1 mark
    let markRight = searchpos(ptn, 'cW')
    if markRight == [0, 0] || markRight[0] * 10000 + markRight[1] >= cbrn
      return
    endif

    " 2 mark
    exe 'silent! normal! '.len(xp.l).'xzO'
    call s:Xbr(xpos.editpos, getpos(".")[1:2])

  catch /NO_ERROR_COUGHT/
  finally
    let &l:ve = oldve
  endtry
endfunction "}}}

fun! s:InitItem() " {{{
  let x = s:Data()
  let ctx = s:Ctx()
  let xpos = ctx.pos
  let xp = s:Ctx().tmpl.ptn
  let xcp = s:Ctx().pos.curpos

  let found = search(xp.lft, "cW")
  if !found
    throw "can not found xp.lft"
  endif



  call s:Xtl(xpos.curpos, getpos(".")[1:2])


  exe "normal! ".len(xp.l)."x"
  silent! normal! zO

  call search(xp.rt, "cW")
  call s:Xbr(xpos.curpos, line("."), col(".") + len(xp.r))



  exe "normal! ".len(xp.r)."x"
  silent! normal! zO

  call s:GetTypeArea()




  " apply default value
  if has_key(ctx.tmpl.ctx.vdef, ctx.name)
    let str = ctx.tmpl.ctx.vdef[ctx.name]

    let str = s:Eval(str)

    " TODO needed?
    call cursor(s:Xtl(xpos.curpos))
    call s:Replace(s:Xtl(xpos.curpos), ctx.name, str)


    " TODO needed?
    call cursor(s:Xtl(xpos.curpos))

    " recursively search
    " TODO predefined does not take in place yet
    if str =~ '\V'.xp.lft.'\.\*'.xp.rt
      call s:BuildValues(1)
      return s:SelectNextItem(s:f.CTL(x)) != ""
    endif



    let str = s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x))
  else
    let str = ctx.name
  endif


  call s:BuildItemPosList(str)


  " call s:Format(0)




  call s:HighLightItem(ctx.name, 1)
  call s:CallPlugin('afterInitItem')

  call s:f.TmplRange()
  silent! normal! gvzO

  call s:XPTupdate()


  " call s:f.GetRangeBetween(s:f.CTL(x), s:f.CBR(x))
  call s:f.GetRangeBetween(s:Xtl(xpos.editpos), s:Xbr(xpos.editpos))


  " does it need to select?

  let ctl = s:f.CTL(x)
  let cbr = s:f.CBR(x)
  return ctl[0] < cbr[0] || ctl[0] == cbr[0] && ctl[1] < cbr[1]

endfunction " }}}

fun! s:Unescape(str) "{{{
  let ptn = '\V\\\(\.\)'
  return substitute(a:str, ptn, '\1', 'g')
endfunction "}}}


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

  let p1 = searchpos(xp.lft, 'nbcW')
  let p2 = searchpos(xp.rt, 'nW')

  if p1 == [0, 0] || p2 == [0, 0] || a:pos != p1 
    return ["", ""]
    " throw "invalid position :".string(a:pos)." p0:".string(p0)." p1:".string(p1)." p2:".string(p2)
  endif

  let p1[1] += len(xp.l)

  let name = s:f.GetContentBetween(p1, p2)
  
  let rname = matchstr(name, xp.lft . '\zs\_.\{-}\ze\%(' . xp.lft . '\|\$\)')
  if rname == ''
    let rname = name
  endif
  " let [ml, mr] = [-1, -1]
  " let ml = match(name, xp.lft)
  " let mr = match(name, xp.lft, ml + 1) : -1
" 
  " if mr != -1
    " let rname = name[ml + len(xp.l) : mr - 1]
  " elseif ml != -1
    " let rname = name[ml + len(xp.l) :]
  " else
    " let rname = name
  " endif

  call cursor(p0)
  return [name, rname]

endfunction " }}}

fun! s:GetTypedContent() " {{{
  let x = s:Data()
  return s:f.GetContentBetween(s:f.CTL(x), s:f.CBR(x))
endfunction " }}}

fun! s:f.GetContentBetween(p1, p2) "{{{
  if a:p1[0] > a:p2[0] || a:p1[0] == a:p2[0] && a:p1[1] >= a:p2[1]
    return ""
  endif

  let [p1, p2] = [a:p1, a:p2]


  if p1[0] == p2[0]
    if p1[1] == p2[1]
      return ""
    endif
    return getline(p1[0])[ p1[1] - 1 : p2[1] - 2]
  endif


  let r = [getline(p1[0])[p1[1] - 1:]]


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
  inoremap <buffer> <tab> <C-r>=<SID>NextItem('')<cr>
  snoremap <buffer> <tab> <Esc>`>a<C-r>=<SID>NextItem('')<cr>
  snoremap <buffer> <Del> <Del>i
  snoremap <buffer> <bs> <esc>`>a<bs>


  " smap     <buffer> <CR> <Del><Tab>
  smap     <buffer> <CR> <Del><C-r>=<SID>NextItem('clear')<cr>
  

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

  " return ""

  let emptyline = (getline(".") =~ '^\s*$')
  if emptyline
    return "\<END>;\<C-c>==A\<BS>"
    try
      startinsert!
      call feedkeys(';'."\<C-c>==A\<BS>", 'n')
    catch /.*/
    endtry
  endif

  return ""

endfunction " }}}

" TODO edge item
fun! s:ReplaceAllMark(name, rep, flag) " {{{
  if a:name == "" || a:name ==# a:rep
    return
  endif

  let xp = s:Ctx().tmpl.ptn

  let ptn = s:ItemPattern(a:name)
  let rep = substitute(a:rep, "\n", '\r', 'g')

  if a:flag == 'typed'
    exe '%snomagic/\V' . s:GetCurrentTypedRange() . ptn . '/' . escape(rep, '/\') . "/g"
  else
    exe '%snomagic/\V' . s:f.TmplRange() . ptn . '/' . escape(rep, '/\') . "/g"
  endif
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

" top left
fun! s:Xtl(p, ...) "{{{
  if a:0 == 0
    return [a:p.t, a:p.l]
  elseif a:0 == 1
    let [a:p.t, a:p.l] = a:1
  elseif a:0 == 2
    let [a:p.t, a:p.l] = [a:1, a:2]
  endif
endfunction "}}}
" bottom right
fun! s:Xbr(p, ...) "{{{
  if a:0 == 0
    let l = a:p.b + line("$")
    return [l, a:p.r + len(getline(l))]
  elseif a:0 == 1
    let [a:p.b, a:p.r] = [a:1[0] - line("$"), a:1[1] - len(getline(a:1[0]))]
  elseif a:0 == 2
    let [a:p.b, a:p.r] = [a:1 - line("$"), a:2 - len(getline(a:1))]
  endif
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
  " let xp.itemContent       = xp.item_var . '\|' . xp.item_func . '\|' . '\_.\{-}'
  let xp.itemContent       = '\_.\{-}'
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

fun! s:ItemFullPattern(name) "{{{
  let xp = s:Data().curctx.tmpl.ptn
  let name = escape(a:name, '\')

  let notlr = '\%(\_[^' . xp.l . xp.r . ']\|' . s:escaped . '\[' . xp.l . xp.r . ']\)\{-}'

  let edge = '\%(' . xp.lft . notlr . '\)\?'

  return edge . xp.lft . '\%('. name .'\)' . edge . xp.rt
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

  let oldve = &l:ve
  setlocal ve=onemore,insert

  let oldww = &l:ww
  setlocal ww=b,s,h,l,<,>,~,[,]
  
  let oldsel = &l:sel
  setlocal sel=exclusive

  let isrange = 0
  if type(a:c) == type('')
    let c = a:c
  else
    let rng = a:c
    let isrange = 1

    let start = [rng[0][0] - line("$"), rng[0][1] - len(getline(rng[0][0]))]
    let end   = [rng[1][0] - line("$"), rng[1][1] - len(getline(rng[1][0]))]
  endif

  try
    let rep = a:rep."-"

    if !isrange
      let cptn = escape(c, '\/')
      let cptn = '\V'.substitute(cptn, "\n", '\\n', 'g')
    endif


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

    if isrange && start == end || !isrange && c == ""
      return pl
    endif


    if isrange
      let start[0] = start[0] + line("$")
      let start[1] = start[1] + len(getline(start[0]))
      let end[0] = end[0] + line("$")
      let end[1] = end[1] + len(getline(end[0]))

      
      call cursor(start)
      normal! v
      call cursor(end)
      normal! d
      silent! normal! zO
    else
      let cmd = 's/\V\%'.col(".").'c'.cptn.'//'
      exe cmd
      silent! normal! zO
    endif

    return pl

  catch /NO_ERROR_COUGHT/
  finally
    let &l:ve=oldve
    let &l:ww=oldww
    let &l:sel=oldsel
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

" fun! s:XPTuninstall() "{{{
  " let path = expand("%:p:h:h")."/xpt.files.txt"
" 
  " let fs = readfile(path)
  " let ok = confirm("uninstall xptemplate?", "&yes\n&no") == 1
  " if !ok 
    " return
  " endif
" 
  " for f in fs
    " call delete(f)
  " endfor
" 
" endfunction "}}}
" com! XPTuninstall call <SID>XPTuninstall()


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


