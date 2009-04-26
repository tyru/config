" TODO variable evaluate
fun! Eval(s) "{{{
  let ep =   '\%(' . '\%(\[^\\]\|\^\)' . '\%(\\\\\)\*' . '\)' . '\@<='
  
  let dqe = '\V\('. ep . '"\)'
  let sqe = '\V\('. ep . "'\\)"

  let dptn = dqe.'\_.\{-}\1'
  let sptn = sqe.'\_.\{-}\1'

  let fptn = '\V' . '\w\+(\[^($]\{-})' . '\|' . ep . '{\w\+(\[^($]\{-})}'
  let vptn = '\V' . '$\w\+' . '\|' . ep . '{$\w\+}'

  let ptn = fptn . '\|' . vptn


  let mask = substitute(a:s, ' ', '+', 'g')

  while 1 
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
      
  endwhile



  " parameter string list
  let plist = {}
  let str = a:s 


  " deal with variable first
  while 1

    let has = match(mask, ptn)
    if has == -1
      break
    endif


    let lmtc = len(matchstr(mask, ptn))
    let mtc = str[has : has + lmtc - 1]



    if mtc =~ '^{.*}$'
      let mtc = mtc[1:-2]
    endif

    if mtc[-1:] == ')'
      let q = EvalFunction(mtc)
    else
      let q = EvalVariable(mtc)
    endif

    let q = '"' . escape(q, '\"') . '"'
    let ql = len(q)

    for i in keys(plist)
      if i >= has && i < has + lmtc
        call remove(plist, i)
      endif
    endfor

    let plist[has] = ql


    let mask = (has == 0 ? "" : mask[:has-1]) . repeat(' ', ql). mask[has + lmtc :]
    let str  = (has == 0 ? "" :  str[:has-1]) . q              .  str[has + lmtc :]

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
    let v = plist[k]

    let kn = 0 + k
    let vn = 0 + k + v

    " unescape \{ and \(
    let sp .= substitute( (k == 0 ? "" : (str[last : kn-1])), '\V'.ep.'\\\(\[{(]\)', '\1', 'g')


    let tmp = str[kn+1 : vn-2]
    " only '"' and '\' need to be unescaped
    let tmp = substitute(tmp, '\\\(["\\]\)', '\1', 'g')

    let sp .= tmp
    let last = vn
  endfor
  let sp .= str[last : ]

  return sp


endfunction "}}}

fun! EvalFunction(f)
  return eval(a:f)
endfunction

fun! EvalVariable(v) "{{{
  return a:v[1:]
endfunction "}}}


fun! F(x, y)
  return a:x.a:y
endfunction

echo Eval("...  \\{F(F('a(', '\"b'), \"tt't\")}--F('x', $abc)-abc$qq, c,")
" echo Eval("...  --F('x', 'y')abc$qq, c,")
" echo Eval("-$qq-")
