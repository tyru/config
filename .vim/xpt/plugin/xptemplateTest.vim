if !exists("g:__XPTEMPLATE_VIM__")
  runtime plugin/xptemplate.vim
endif

if exists("g:__XPTEMPLATETEST_VIM__")
  finish
endif
let g:__XPTEMPLATETEST_VIM__ = 1

" test suite support
" 

com! XPTSlow redraw! | sleep 100m

fun s:XPTinsert() "{{{
  call feedkeys("i", 'mt')
endfunction "}}}
fun s:XPTtrigger(name) "{{{
  call feedkeys(a:name . "", 'mt')
endfunction "}}}
fun s:XPTtype(...) "{{{
  for v in a:000
    call feedkeys(v, 'nt')
    call feedkeys("\<tab>", 'mt')
  endfor
endfunction "}}}
fun s:XPTcancel(...) "{{{
  call feedkeys("\<cr>", 'mt')
endfunction "}}}
fun! s:LastLine() "{{{
  call feedkeys("\<C-c>G:silent a\<cr>\<cr>.\<cr>G", 'nt')
endfunction "}}}
fun s:XPTnew(name) "{{{
  call s:XPTinsert()
  call s:XPTtrigger(a:name)
endfunction "}}}
fun s:XPTwrapNew(name) "{{{
  call feedkeys("iWRAPPED_TEXT\<C-c>V", 'nt')
  if &slm =~ 'cmd'
    call feedkeys("\<C-g>", 'nt')
  endif
  call feedkeys("\<C-w>".a:name."", 'mt')

endfunction "}}}


fun! XPTtest(ft) "{{{

  exe 'e '.tempname().'/test.page'
  set buftype=nofile
  wincmd o
  let &ft = a:ft

  let b:list = []
  let b:currentTmpl = {}
  let b:testProcessing = 0
  let b:useDefault = 1
  let b:itemNames = []

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

fun s:TestFinish() "{{{
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
endfunction "}}}

fun! s:TestProcess(mode) "{{{
  let x = g:X()
  let ctx = x.curctx


  if b:testProcessing == 0

    let b:testProcessing = 1
    let b:itemNames = []

    if len(b:list) == 0 
      call s:TestFinish()
      return
    endif


    " Each template is rendered 2 times.
    " The 1st time(useDefault = 1) use all default value for each item. 
    " The 2nd time(useDefault = 0) render it with  some pseudo typed value.

    let b:currentTmpl = b:list[0]
    if !b:useDefault
      call remove(b:list, 0)
    endif

    
    call s:LastLine()

    " if no comment string found, do not risk to draw template in comment.
    if b:useDefault && b:cmt != ['', '']
      " first time rendering the template, show original template content

      let tmpl0 = [ ' ' . '-------------' . b:currentTmpl.name . '---------------' ] 
            \+ split( b:currentTmpl.tmpl , "\n" )

      let maxLength = 0
      for line in tmpl0
        let maxLength = max( [ len(line), maxLength ] )
      endfor

      let tmpl = []
      for line in tmpl0
        if b:cmt[ 1 ] != ''
          let line = substitute( line, '\V'.b:cmt[ 1 ], '_cmt_', 'g' )
        endif
        let line = b:cmt[0] . ' ' . line . repeat( ' ', maxLength - len( line ) ) . ' ' . b:cmt[ 1 ]
        let tmpl += [ line ]
      endfor

      call feedkeys( ":silent a\n" . join( tmpl, "\n" ) . "\n\n\n\n", 'nt' )
      call s:LastLine()
    endif

    " render template
    if b:currentTmpl.wrapped
      call s:XPTwrapNew( b:currentTmpl.name )
    else
      call s:XPTnew( b:currentTmpl.name )
    endif


  else
    " b:testProcessing = 1

    " Insert mode or select mode
    " If it is in normal mode, maybe something else is going.
    if mode() =~? "[is]"
      if ctx.phase == 'fillin' 

        " XPTSlow

        " repitition, expandable or super repetition
        if ctx.name =~ '\V..'
          let b:itemNames += [ ctx.name ]

          " keep at most 5 steps
          if len( b:itemNames ) > 5 
            call remove(b:itemNames, 0)
          endif
        endif


        if len(b:itemNames) >= 3 && b:itemNames[-3] == ctx.name
          " repetition 
          call s:XPTcancel()
        elseif b:useDefault
          " next
          call s:XPTtype('')
        else
          " pseudo type
          call s:XPTtype(substitute(ctx.name, '\W', '', 'g')."_TYPED")
        endif

        " XPTSlow

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
