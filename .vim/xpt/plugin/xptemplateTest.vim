if !exists("g:__XPTEMPLATE_VIM__")
  runtime plugin/xptemplate.vim
endif

if exists("g:__XPTEMPLATETEST_VIM__")
  finish
endif
let g:__XPTEMPLATETEST_VIM__ = 1

" test suite support
" 

com! Slow redraw! | sleep 100m

fun s:XPTinsert()
  call feedkeys("i", 'mt')
endfunction


fun s:XPTtrigger(name)
  call feedkeys(a:name . "", 'mt')
endfunction

fun s:XPTtype(...)
  for v in a:000
    call feedkeys(v, 'nt')
    call feedkeys("\<tab>", 'mt')
  endfor
endfunction

fun s:XPTcancel(...)
  call feedkeys("\<cr>", 'mt')
endfunction


fun! s:LastLine() "{{{
  call feedkeys("\<C-c>G:silent a\<cr>\<cr>.\<cr>G", 'nt')
endfunction "}}}

fun s:XPTnew(name)
  call s:XPTinsert()
  call s:XPTtrigger(a:name)
endfunction

fun s:XPTwrapNew(name)
  call feedkeys("iWRAPPED_TEXT\<C-c>V", 'nt')
  if &slm =~ 'cmd'
    call feedkeys("\<C-g>", 'nt')
  endif
  call feedkeys("\<C-w>".a:name."", 'mt')

endfunction


fun! XPTtest(ft) "{{{

  exe 'e '.tempname().'/test.page'
  set buftype=nofile
  wincmd o
  let &ft = a:ft
  Slow

  let b:list = []
  let b:ctx = {}
  let b:testProcessing = 0
  let b:useDefault = 1
  let b:names = []

  let cmt = &cms
  let b:cmt = split(cmt, '\V%s')
  if len(b:cmt) == 0
    let b:cmt = ['', '']
  elseif len(b:cmt) == 1
    let b:cmt += ['']
  endif
  

  let tmpls = XPTgetAllTemplates()

  unlet tmpls.Path
  let b:list = values(tmpls)


  augroup XPTtestGroup
    au!
    au CursorHoldI * call <SID>TestProcess('i')
    au CursorMoved * call <SID>TestProcess('n')
    au CursorMovedI * call <SID>TestProcess('i')
  augroup END

endfunction "}}}

fun s:TestFinish()
  augroup XPTtestGroup
    au!
  augroup END

  let fn = split(globpath(&rtp, 'ftplugin/'.&ft.'/test.page'), "\n")
  if len(fn) > 0
    exe "vertical diffsplit ".fn[0]

    normal! gg=G
    wincmd x
    normal! gg=G
    diffupdate
    normal! zM
  endif
endfunction


fun! s:TestProcess(mode) "{{{
  let x = g:X()
  let ctx = x.curctx


  if b:testProcessing == 0

    let b:testProcessing = 1
    let b:names = []

    if len(b:list) == 0 
      call s:TestFinish()
      return
    endif


    let b:ctx = b:list[0]
    if !b:useDefault
      call remove(b:list, 0)
    endif

    let v = b:ctx

    call s:LastLine()

    if b:useDefault && b:cmt != ['', '']
      " first time rendering, show template

      let head = ' -------------'.v.name.'---------------'

      let tmpl0 = [head] + split( v.tmpl , "\n")

      let max = 0
      for line in tmpl0
        let max = max([len(line), max])
      endfor

      " let max += len(b:cmt[0]) + 1 " space

      let tmpl = []
      for line in tmpl0
        if b:cmt[1] != ''
          let line = substitute(line, '\V'.b:cmt[1], '_cmt_', 'g')
        endif
        let line = b:cmt[0] . ' ' . line . repeat(' ', max - len(line)) . ' ' . b:cmt[1]
        let tmpl += [line]
      endfor

      call feedkeys(":silent a\n" . join(tmpl, "\n") . "\n\n\n\n", 'nt')
      call s:LastLine()

    endif


    if b:ctx.wrapped
      call s:XPTwrapNew(b:ctx.name)
    else
      call s:XPTnew(v.name)
    endif

  else
    " b:testProcessing = 1

    " maybe do in normal mode and do something else
    if mode() =~? "[is]"
      if ctx.phase == 'fillin' 
        " Slow

        if ctx.name =~ '\V...'
          let b:names += [ctx.name]
          if len(b:names) > 5 
            call remove(b:names, 0)
          endif
        endif

        if b:useDefault
          if len(b:names) >= 3 && b:names[-3] == ctx.name
            " repetition
            call s:XPTcancel()
          else
            call s:XPTtype('')
          endif
        else
          call s:XPTtype(substitute(ctx.name, '\W', '', 'g')."_TYPED")
        endif

        " Slow

      elseif ctx.phase == 'finished'
        " template finished

        let b:useDefault = !b:useDefault
        let b:testProcessing = 0
        call feedkeys("\<C-c>Go\<C-c>", 'nt')
      endif
    endif
  endif
endfunction "}}}


com -nargs=1 XPTtest call XPTtest(<f-args>)
