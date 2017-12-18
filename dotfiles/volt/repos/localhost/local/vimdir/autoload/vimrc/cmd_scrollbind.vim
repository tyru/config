" Enable/Disable 'scrollbind', 'cursorbind' options.

function! vimrc#cmd_scrollbind#enable() abort
  call s:cmd_scrollbind(1)
endfunction

function! vimrc#cmd_scrollbind#disable() abort
  call s:cmd_scrollbind(0)
endfunction

function! vimrc#cmd_scrollbind#toggle() abort
  if get(t:, 'vimrc_scrollbind', 0)
    ScrollbindDisable
  else
    ScrollbindEnable
  endif
endfunction

function! s:cmd_scrollbind(enable)
  let winnr = winnr()
  try
    call s:scrollbind_specific_mappings(a:enable)
    windo let &l:scrollbind = a:enable
    if exists('+cursorbind')
      windo let &l:cursorbind = a:enable
    endif
    let t:vimrc_scrollbind = a:enable
  finally
    execute winnr . 'wincmd w'
  endtry
endfunction

function! s:scrollbind_specific_mappings(enable)
  if a:enable
    " Check either buffer-local those mappings are mapped already or not.
    if get(maparg('<C-e>', 'n', 0, 1), 'buffer', 0)
      nnoremap <buffer> <C-e> :<C-u>call <SID>no_scrollbind('<C-e>')<CR>
    endif
    if get(maparg('<C-y>', 'n', 0, 1), 'buffer', 0)
      nnoremap <buffer> <C-y> :<C-u>call <SID>no_scrollbind('<C-y>')<CR>
    endif
  else
    " Check either those mappings are above one or not.
    let map = maparg('<C-e>', 'n', 0, 1)
    if get(map, 'buffer', 0)
    \   || get(map, 'rhs', '') =~# 'no_scrollbind('
      nunmap <buffer> <C-e>
    endif
    let map = maparg('<C-y>', 'n', 0, 1)
    if get(map, 'buffer', 0)
    \   || get(map, 'rhs', '') =~# 'no_scrollbind('
      nunmap <buffer> <C-y>
    endif
  endif
endfunction

function! s:no_scrollbind(key)
  let scrollbind = &l:scrollbind
  try
    execute 'normal!' a:key
  finally
    let &l:scrollbind = scrollbind
  endtry
endfunction
