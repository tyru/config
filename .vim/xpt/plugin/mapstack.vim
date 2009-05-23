if exists("g:__MAPSTACK_VIM__")
  finish
endif
let g:__MAPSTACK_VIM__ = 1



fun! s:GetBufStack() "{{{
  if !exists("b:_map_stack")
    let b:_map_stack = []
  endif
  return b:_map_stack
endfunction "}}}

fun! s:GetCmdOutput(cmd) "{{{
  let l:a = ""

  redir => l:a
  exe a:cmd
  redir END

  return l:a

endfunction "}}}

" Critical implementation.
" not sure whether it works well on each platform
"
" TODO Maybe use <script> mapping is better
fun! s:GetAlighWidth() "{{{
  nmap <buffer> 1 2
  let line = s:GetCmdOutput("silent nmap <buffer> 1")
  nunmap <buffer> 1

  let line = split(line, "\n")[0]

  return len(matchstr(line, '^n.*\ze2$'))
endfunction "}}}

let s:alignWidth = s:GetAlighWidth()



fun! s:GetMapLine(key, mode, isbuffer) "{{{
  let mcmd = "silent ".a:mode."map ".(a:isbuffer ? "<buffer> " : "").a:key

  " get fixed mapping
  let str = s:GetCmdOutput(mcmd)

  let lines = split(str, "\n")


  " *  norepeat
  " &@ script or buffer local
  "
  " The :map command format: if a mapped key length is less than s:alignWidth,
  " the right hand part is aligned. Or 1 space separates the left part and the
  " right part
  let localmark = a:isbuffer ? '@' : ' '
  let ptn = '\V\c'.a:mode.'  '.escape(a:key, '\').'\s\{-}'.'\zs\[* ]'.localmark.'\%>'.s:alignWidth.'c\S\.\{-}\$'


  for line in lines
    if line =~? ptn
      return matchstr(line, ptn)
    endif
  endfor


  return ""

endfunction "}}}

fun! s:GetMapInfo(key, mode, isbuffer) "{{{
  let line = s:GetMapLine(a:key, a:mode, a:isbuffer)
  if line == ''
    return {}
  endif

  let item = line[0:1] " the first 2 characters

  return {'mode' : a:mode,
        \'key'   : a:key,
        \'nore'  : item =~ '*' ? 'nore' : '',
        \'isbuf' : a:isbuffer ? ' <buffer> ' : ' ',
        \'cont'  : line[2:]}

endfunction "}}}

fun! g:MapPush(key, mode, isbuffer) "{{{

  let info = s:GetMapInfo(a:key, a:mode, a:isbuffer)


  let st = s:GetBufStack()
  call add(st, info)


endfunction "}}}

fun! g:MapPop() "{{{
  let st = s:GetBufStack()

  let info = st[-1]

  unlet st[-1]

  if empty(info)
    return
  endif


  if info.cont == ''
    let cmd = "silent ".info.mode.'unmap '. info.isbuf . info.key
  else
    let cmd = "silent " . info.mode . info.nore .'map '. info.isbuf . info.key . ' ' . info.cont
  endif


  exe cmd


endfunction "}}}
