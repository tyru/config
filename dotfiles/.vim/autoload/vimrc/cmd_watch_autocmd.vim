
function! vimrc#cmd_watch_autocmd#call(event, bang) abort
  if a:bang
    call s:cmd_unwatch_autocmd(a:event)
  else
    call s:cmd_watch_autocmd(a:event)
  endif
endfunction


" Create watch-autocmd augroup.
augroup watch-autocmd
  autocmd!
augroup END

let s:watching_events = {}

function! s:cmd_unwatch_autocmd(event)
  if !exists('#'.a:event)
    echohl ErrorMsg
    echomsg "Invalid event name: ".a:event
    echohl None
    return
  endif
  if !has_key(s:watching_events, a:event)
    echohl ErrorMsg
    echomsg "Not watching ".a:event." event yet..."
    echohl None
    return
  endif

  execute 'autocmd! watch-autocmd' a:event
  unlet s:watching_events[a:event]
  echomsg 'Removed watch for '.a:event.' event.'
endfunction

function! s:cmd_watch_autocmd(event)
  if !exists('#'.a:event)
    echohl ErrorMsg
    echomsg "Invalid event name: ".a:event
    echohl None
    return
  endif
  if has_key(s:watching_events, a:event)
    echomsg "Already watching ".a:event." event."
    return
  endif

  execute 'autocmd watch-autocmd' a:event '*'
  \       'echohl MoreMsg |'
  \       'echomsg "Executing '''.a:event.''' event..." |'
  \       'echohl None'
  let s:watching_events[a:event] = 1
  echomsg 'Added watch for' a:event 'event.'
endfunction
