
" http://tyru.hatenablog.com/entry/2015/06/21/082955
" http://d.hatena.ne.jp/thinca/20130708/1373210009

noremap <silent> <buffer> <expr> j <SID>jk(v:count1)
noremap <silent> <buffer> <expr> k <SID>jk(-v:count1)

noremap <silent> <buffer> <expr>
\   gg (v:count > 0 ? <SID>jk(v:count-line('.')) : <SID>gg(1))
noremap <silent> <buffer> <expr>
\   G  (v:count > 0 ? <SID>jk(v:count-line('.')) : <SID>gg(0))

noremap <buffer> p  <CR>zz<C-w>p

let s:opt_wraparound = 0

setlocal statusline+=\ %L

nnoremap <silent> <buffer> dd :call <SID>del_entry()<CR>
nnoremap <silent> <buffer> x :call <SID>del_entry()<CR>
vnoremap <silent> <buffer> d :call <SID>del_entry()<CR>
vnoremap <silent> <buffer> x :call <SID>del_entry()<CR>
nnoremap <silent> <buffer> u :<C-u>call <SID>undo_entry()<CR>


if exists('*s:undo_entry')
  finish
endif

function! s:undo_entry()
  let history = get(w:, 'qf_history', [])
  if !empty(history)
    call setqflist(remove(history, -1), 'r')
  endif
endfunction

function! s:del_entry() range
  let qf = getqflist()
  let history = get(w:, 'qf_history', [])
  call add(history, copy(qf))
  let w:qf_history = history
  unlet! qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(qf, 'r')
  execute a:firstline
endfunction

function! s:modulo(n, m)
  let d = a:n * a:m < 0 ? 1 : 0
  return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
endfunction

function! s:wraparound(n, max, motion) abort
  if s:opt_wraparound
    return s:modulo(a:n, a:max)
  else
    return (0 <= a:n && a:n < a:max) ? a:n :
    \       0 < a:motion ? a:max-1 : 0
  endif
endfunction

function! s:jk(motion)
  let max = line('$')
  let list = getloclist(0)
  if empty(list) || len(list) != max
    let list = getqflist()
  endif
  let cur = line('.') - 1
  let pos = cur + a:motion
  let pos = s:wraparound(cur + a:motion, max, a:motion)
  let m = 0 < a:motion ? 1 : -1
  let oldpos = -1
  while pos != oldpos && cur != pos && list[pos].bufnr == 0
    let oldpos = pos
    let pos = s:wraparound(pos + m, max, a:motion)
  endwhile
  let pos = pos == oldpos ? line('.') - 1 : pos
  if pos == line('.') - 1
    return 0 < a:motion ? "\<C-e>" : "\<C-y>"
  endif
  return "\<Esc>" . (pos + 1) . 'G'
endfunction

function! s:gg(gotop)
  let max = line('$')
  let list = getloclist(0)
  if empty(list) || len(list) != max
    let list = getqflist()
  endif
  let cur = line('.') - 1
  let pos = a:gotop ? 0 : line('$') - 1
  let m = 0 < a:gotop ? 1 : -1
  while cur != pos && list[pos].bufnr == 0
    let pos = pos + m
  endwhile
  return (pos + 1) . 'G'
endfunction
