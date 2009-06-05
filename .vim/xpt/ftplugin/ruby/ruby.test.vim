finish
" TODO this is cnot updated to latest version
if exists("g:__RUBY_TEST_VIM__")
  finish
endif
let g:__RUBY_TEST_VIM__ = 1


fun XPTinsert()
  call feedkeys("i", 'mt')
endfunction

fun XPTend()
  call feedkeys("\<C-c>", 'nt')
endfunction

fun XPTtrigger(name)
  call feedkeys(a:name . "", 'mt')
endfunction

fun XPTtype(...)
  for v in a:000
    call feedkeys(v . "\<tab>", 'mt')
    " call feedkeys(v . "\<C-c>:redraw!\<cr>:sleep 200m\<cr>i\<tab>", 'mt')
  endfor
endfunction

fun XPTexpand(...)
  call feedkeys("\<tab>", 'mt')
endfunction

fun XPTcancel(...)
  call feedkeys("\<cr>", 'mt')
endfunction

fun XPTclear()
  normal! ggVGd
endfunction

fun XPTnew(name)
  call feedkeys("Go\<cr>\<cr>\<C-c>", 'nt')
  call XPTinsert()
  call XPTtrigger(a:name)
endfunction


" TODO draft 
fun XPTassert(texts) "{{{

  if g:X().curctx.processing
    throw "template is not finished yet"
  endif

  let i = 1
  for v in a:texts
    let v = matchstr(v, '^\s*\zs.*\ze\s*$')
    let line = matchstr(getline(i), '^\s*\zs.*\ze\s*$')

    if v != line
      echom "v =".v."--"
      echom "line[".i."]=".getline(i)."--"
      throw "unmatched at [".i."]:".v
    endif

    let i += 1
  endfor


  return 0
endfunction "}}}


fun s:Test()
  let r = XPTnew('atw')
        \.XPTtype('a')
        \.XPTexpand().XPTtype('b').XPTcancel()
        \.XPTend()

  let r = XPTnew('atr')
        \.XPTtype('a')
        \.XPTexpand().XPTtype('b').XPTcancel()
        \.XPTend()

  let r = XPTnew('ata').XPTtype('a')
        \.XPTexpand().XPTtype('b').XPTcancel()
        \.XPTend()

  " 'do' with arguments
  let r = XPTnew('do').XPTtype('cond')
        \.XPTtype('cur')
        \.XPTend()

  " 'do' with no arguments
  let r = XPTnew('do').XPTtype("\<del>")
        \.XPTtype('cur')
        \.XPTend()


  let r = XPTnew('blk').XPTtype('args')
        \.XPTtype('cur')
        \.XPTend()

  let r = XPTnew('begin').XPTtype('type expr')
        \.XPTexpand('rescue_repitition').XPTtype('error_A').XPTtype("expr_A")
        \.XPTexpand('rescue_repitition').XPTtype('error_B').XPTtype("expr_B")
        \.XPTcancel('rescue_repitition')
        \.XPTexpand('else...').XPTtype("else_expr")
        \.XPTexpand('ensure').XPTtype('ensure_expr')
        \.XPTend()

  let r = XPTnew('case').XPTtype('case_target')
        \.XPTtype('comparison_A').XPTtype('job_A')
        \.XPTexpand('another when')
        \.XPTtype('comparison_B').XPTtype('job_B')
        \.XPTexpand('another when')
        \.XPTtype('comparison_B').XPTtype('job_B')
        \.XPTcancel('when_repetition')
        \.XPTexpand('else...')
        \.XPTtype('else_job')
        \.XPTend()

  let r = XPTnew('con').XPTtype('params').XPTend()

  let r = XPTnew('def').XPTtype('def_name').XPTtype('body').XPTend()

  let r = XPTnew('defi').XPTtype('init_name').XPTtype('body').XPTend()

  let r = XPTnew('defs').XPTtype('self_name').XPTtype('body').XPTend()

  let r = XPTnew('tif').XPTtype('bool_expr')
        \.XPTtype('expr_iftrue').XPTtype('expr_iffalse').XPTend()

  let r = XPTnew('if')
        \.XPTtype('expr').XPTtype('body')
        \.XPTexpand('elseif').XPTtype('expr_elseif').XPTtype('body_elseif')
        \.XPTexpand('elseif').XPTtype('expr_elseif').XPTtype('body_elseif')
        \.XPTcancel('elseif')
        \.XPTexpand('else...').XPTtype('body_else')
        \.XPTend()
  
  let r = XPTnew('eli').XPTtype('expr').XPTtype('body').XPTend()
  let r = XPTnew('unl').XPTtype('expr').XPTtype('body').XPTend()
  let r = XPTnew('ali').XPTtype('expr_new').XPTtype('expr_old').XPTend()
  let r = XPTnew('lam').XPTtype('body').XPTend()
  let r = XPTnew('beg').XPTtype('body').XPTend()
  let r = XPTnew('end').XPTtype('body').XPTend()

  let r = XPTnew('war').XPTtype('array_body').XPTend()
  let r = XPTnew('War').XPTtype('array_body').XPTend()
  let r = XPTnew('sqs').XPTtype('array_body').XPTend()
  let r = XPTnew('dqs').XPTtype('array_body').XPTend()

  let r = XPTnew('int').XPTtype('integer').XPTend()
  let r = XPTnew('mod').XPTtype('mod_name').XPTend()

  let r = XPTnew('cli')
        \.XPTtype('class_name').XPTtype('init_key')
        \.XPTtype('body')
        \.XPTend()

  let r = XPTnew('cl').XPTtype('class_name').XPTend()

  let r = XPTnew('subcl').XPTtype('class_name').XPTtype('parent_class').XPTend()

  let r = XPTnew('clsstr').XPTtype('class_name').XPTtype('struct_arg').XPTtype('body').XPTend()
  let r = XPTnew('dow').XPTtype('down_name').XPTtype('arguments').XPTtype('block_body').XPTend()

  let r = XPTnew('ste').XPTtype('step_count').XPTend()

  let r = XPTnew('tim').XPTtype('arguments').XPTtype('body').XPTend()
  let r = XPTnew('upt').XPTtype('ubound_key').XPTtype('arguments').XPTtype('body').XPTend()

  let r = XPTnew('ea').XPTtype('list', 'body').XPTend()
  let r = XPTnew('eai').XPTtype('list_index', 'body').XPTend()
  let r = XPTnew('eak').XPTtype('list_key', 'body').XPTend()
  let r = XPTnew('eal').XPTtype('list_line', 'body').XPTend()
  let r = XPTnew('eav').XPTtype('list_value', 'body').XPTend()
  let r = XPTnew('reve').XPTtype('list', 'body').XPTend()
  let r = XPTnew('eap').XPTtype('list_name', 'list_value', 'body').XPTend()
  let r = XPTnew('eab').XPTtype('list_byte', 'body').XPTend()
  let r = XPTnew('eac').XPTtype('list_char', 'body').XPTend()
  let r = XPTnew('eacon').XPTtype('window_size', 'cons_key', 'body').XPTend()
  let r = XPTnew('easli').XPTtype('slice_size', 'slice_key', 'body').XPTend()

  let r = XPTnew('win').XPTtype('expr_record', 'expr_index', 'body').XPTend()
  let r = XPTnew('map').XPTtype('map_arg', 'body').XPTend()
  let r = XPTnew('inj').XPTtype('arg_accumulator', 'arg_obj', 'body').XPTend()
  let r = XPTnew('inj0').XPTtype('arg_accumulator', 'arg_obj', 'body').XPTend()
  let r = XPTnew('inji').XPTtype('init_v', 'arg_accumulator', 'arg_obj', 'body').XPTend()
  let r = XPTnew('dirg').XPTtype('arg_dir', 'arg_d', 'body').XPTend()
  let r = XPTnew('file').XPTtype('arg_filename', 'arg_line', 'body').XPTend()
  let r = XPTnew('open').XPTtype('arg_fn', 'body').XPTend()
  let r = XPTnew('sor').XPTtype('elt_1', 'elt_2').XPTend()
  let r = XPTnew('sorb').XPTtype('arguments', 'body').XPTend()
  let r = XPTnew('all').XPTtype('arg_elt', 'expr_cond').XPTend()
  let r = XPTnew('any').XPTtype('arg_elt', 'expr_cond').XPTend()
  let r = XPTnew('cfy').XPTtype('arg_elt', 'expr_cond').XPTend()
  let r = XPTnew('col').XPTtype('arg_obj', 'body').XPTend()
  let r = XPTnew('det').XPTtype('arg_obj', 'body').XPTend()
  let r = XPTnew('fet').XPTtype('arg_name', 'arg_key', 'body').XPTend()
  let r = XPTnew('fin').XPTtype('arg_elt', 'body').XPTend()
  let r = XPTnew('fina').XPTtype('arg_elt', 'body').XPTend()
  let r = XPTnew('grep').XPTtype('arg_ptn', 'arg_match', 'body').XPTend()
  let r = XPTnew('max').XPTtype('elt_1', 'elt_2', 'body').XPTend()
  let r = XPTnew('min').XPTtype('elt_1', 'elt_2', 'body').XPTend()
  let r = XPTnew('par').XPTtype('elt', 'body').XPTend()
  let r = XPTnew('rej').XPTtype('elt', 'body').XPTend()
  let r = XPTnew('sel').XPTtype('elt', 'body').XPTend()
  let r = XPTnew('sub').XPTtype('arg_ptn', 'arg_match', 'body').XPTend()
  let r = XPTnew('gsub').XPTtype('arg_ptn', 'arg_match', 'body').XPTend()
  let r = XPTnew('scan').XPTtype('arg_ptn', 'arg_match', 'body').XPTend()

  let r = XPTnew('tc').XPTtype('arg_mod', 'nameOfTest', 'nameOfCase').XPTend()
  let r = XPTnew('deft').XPTtype('nameOfCase').XPTend()

  let r = XPTnew('ass')
        \.XPTtype('expr_cond')
        \.XPTexpand('message...').XPTtype('msg').XPTend()

  let r = XPTnew('ani')
        \.XPTtype('expr_obj')
        \.XPTexpand('message...').XPTtype('msg').XPTend()

  let r = XPTnew('ann').XPTtype('blabla').XPTend()

  let r = XPTnew('aeq').XPTtype('expr', 'expr_actual').XPTend()
  let r = XPTnew('ane').XPTtype('expr', 'expr_actual').XPTend()
  let r = XPTnew('aid').XPTtype('expr', 'expr_actual', 'delta').XPTend()
  let r = XPTnew('ara').XPTtype('expcetion', 'body').XPTend()
  let r = XPTnew('anr').XPTtype('expcetion', 'body').XPTend()
  let r = XPTnew('aio').XPTtype('class_name', 'body').XPTend()
  let r = XPTnew('ako').XPTtype('class_name', 'body').XPTend()
  let r = XPTnew('art').XPTtype('obj_name', 'body').XPTend()
  let r = XPTnew('ama').XPTtype('regular_expr', 'flags', 'body').XPTend()
  let r = XPTnew('anm').XPTtype('regular_expr', 'flags', 'body').XPTend()
  let r = XPTnew('asa').XPTtype('expected', 'actual').XPTend()
  let r = XPTnew('ans').XPTtype('expected', 'actual').XPTend()
  let r = XPTnew('aop').XPTtype('object_1', 'operator', 'object_2').XPTend()
  let r = XPTnew('ath').XPTtype('expected', 'body').XPTend()
  let r = XPTnew('ase').XPTtype('body').XPTend()

endfunction


com XPTtest call <SID>Test()
