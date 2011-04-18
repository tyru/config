" Utilities for 'runtimepath'.
" Version: 0.1.1
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim


" Options. {{{1
if !exists('g:rtputil#ignore_pattern')
  let g:rtputil#ignore_pattern = ''
endif


" RTP object. {{{1
let s:RTP = {}

function! s:RTP.initialize(rtp)  " {{{2
  let self._entries = []

  let list = rtputil#split(a:rtp)
  let index = {}
  for path in list
    if fnamemodify(path, ':t') ==# 'after'
      let up = s:normalize(fnamemodify(path, ':h'))
      if has_key(index, up)
        let index[up].after = 1
        continue
      endif
    endif
    let normalized = s:normalize(path)
    if has_key(index, normalized)
      " The duplicated entry.
      continue
    endif
    let entry = {
    \   'path': path,
    \   'normalized': normalized,
    \   'after': 0,
    \   'default': has_key(s:default_dict, normalized),
    \ }
    call add(self._entries, entry)
    let index[normalized] = entry
  endfor
  let self._index = index
  return self
endfunction

function! s:RTP.bundle(...)  " {{{2
  let name = 1 <= a:0 ? a:1 : 'bundle'
  let pattern = 2 <= a:0 ? a:2 : g:rtputil#ignore_pattern
  let list = []
  for entry in self._entries
    call add(list, entry)
    let bundle = entry.normalized . '/' . name
    if isdirectory(bundle)
      let paths = rtputil#subdirectories(bundle, pattern)
      let new_entries = map(paths, 's:build_entry(v:val)')
      call filter(new_entries, '!has_key(self._index, v:val.normalized)')
      let list += new_entries
    endif
  endfor
  let self._entries = list
  return self._update_index()
endfunction

function! s:RTP.append(path, ...)  " {{{2
  let paths = type(a:path) == type([]) ? copy(a:path) : [a:path]
  let pos = a:0 ? a:1 : {'default': 1}
  let new_entries = map(paths, 's:build_entry(v:val)')
  call filter(new_entries, '!has_key(self._index, v:val.normalized)')

  let i = 0
  let max = len(self._entries)
  if type(pos) == type(0)
    let i = pos
  else
    while i < max && !s:match(self._entries[i], pos)
      let i += 1
    endwhile
  endif
  if i < 0
    let i += max
  endif

  if 0 <= i && i <= max
    let pre = i == 0 ? [] : self._entries[ : i - 1]
    let self._entries = pre + new_entries + self._entries[i : -1]
  endif

  return self._update_index()
endfunction

function! s:RTP.remove(pattern)  " {{{2
  call filter(self._entries, '!s:match(v:val, a:pattern)')
  return self._update_index()
endfunction

function! s:RTP.unify(mods, ...)  " {{{2
  let sep = a:0 ? a:1 : s:path_separator()
  for entry in self._entries
    let entry.path = s:unify(entry.path, a:mods, sep)
  endfor
  return self
endfunction

function! s:RTP.helptags(...)  " {{{2
  let verbose = a:0 && a:1
  for dir in self.to_list()
    let doc = expand(dir) . '/doc'
    if dir[ : strlen($VIM)-1] !=# $VIM
    \ && filewritable(doc) == 2 && !empty(glob(doc . '/*', 1))
    \ && (!filereadable(doc . '/tags') || filewritable(doc . '/tags'))
      if verbose
        echo dir
      endif
      try
        helptags `=doc`
      catch
        " Avoid displaying stacktrace.
        call s:echoerr(matchstr(v:exception, '^.\{-}:\zsE\d\+:.*$'))
      endtry
    endif
  endfor
  return self
endfunction

function! s:RTP.reset()  " {{{2
  return self.initialize(rtputil#default())
endfunction

function! s:RTP.to_list()  " {{{2
  let list = []
  let sep = s:path_separator()
  for entry in reverse(copy(self._entries))
    call insert(list, entry.path)
    if entry.after
      let after = entry.path . sep . 'after'
      call add(list, after)
    endif
  endfor
  return list
endfunction

function! s:RTP.to_runtimepath()  " {{{2
  return rtputil#join(self.to_list())
endfunction

function! s:RTP.apply()  " {{{2
  let &runtimepath = self.to_runtimepath()
  return self
endfunction

function! s:RTP._update_index()  " {{{2
  let self._index = s:list2dict(map(copy(self._entries), 'v:val.normalized'))
  return self
endfunction

function! s:build_entry(path)  " {{{2
  let normalized = s:normalize(a:path)
  return {
  \   'path': a:path,
  \   'normalized': normalized,
  \   'after': isdirectory(normalized . '/after'),
  \   'default': has_key(s:default_dict, normalized),
  \ }
endfunction


" Interfaces. {{{1
function! rtputil#new(...)  " {{{2
  let rtp = a:0 ? a:1 : &runtimepath
  let obj = copy(s:RTP)
  return obj.initialize(rtp)
endfunction

function! rtputil#bundle(...)  " {{{2
  let name = 1 <= a:0 ? a:1 : 'bundle'
  let pattern = 2 <= a:0 ? a:1 : g:rtputil#ignore_pattern
  return rtputil#new().bundle(name, pattern).apply()
endfunction

" Append the directory to runtimepath.
function! rtputil#append(path, ...)  " {{{2
  let pos = a:0 ? a:1 : {'default': 1}
  return rtputil#new().append(a:path, pos).apply()
endfunction

" Remove the directory from runtimepath.
function! rtputil#remove(path)  " {{{2
  return rtputil#new().remove(a:path).apply()
endfunction

" Unify the form of each path.
function! rtputil#unify(mods, ...)  " {{{2
  return rtputil#new().unify(a:mods, a:0 ? a:1 : s:path_separator())
endfunction

" Do :helptags for all of 'runtimepath'.
function! rtputil#helptags(...)  " {{{2
  return rtputil#new().helptags(a:0 && a:1)
endfunction

" Split a comma separated string to a list.
function! rtputil#split(...)  " {{{2
  let rtp = a:0 ? a:1 : &runtimepath
  if type(rtp) == type([])
    return rtp
  endif
  let split = split(rtp, '\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val, ''\\\([\\,]\)'', "\\1", "g")')
endfunction

" Join a list of paths for runtimepath.
function! rtputil#join(list)  " {{{2
  return join(map(copy(a:list), 's:escape(v:val)'), ',')
endfunction

function! rtputil#subdirectories(path, ...)  " {{{2
  let pattern = 1 <= a:0 ? a:1 : g:rtputil#ignore_pattern
  let dirs = split(glob(a:path . s:path_separator() . '*', 1), "\n")
  return filter(dirs, '!s:match(v:val, pattern)')
endfunction

function! rtputil#userdir()  " {{{2
  let home = s:normalize($HOME)
  for entry in rtputil#new(rtputil#default())._entries
    if s:normalize(fnamemodify(entry.path, ':h')) ==? home
      return entry.path
    endif
  endfor
  return ''
endfunction

" Get the default value of 'runtimepath'.
function! rtputil#default()  " {{{2
  return s:default_rtp
endfunction



" Misc functions. {{{1

function! s:match(entry, pattern)  " {{{2
  let entry = type(a:entry) == type({}) ? a:entry : s:build_entry(a:entry)
  if entry.normalized ==? s:normalize($VIMRUNTIME)
    return 0
  endif
  if type(a:pattern) == type([])
    for pat in a:pattern
      if s:match(entry, pat)
        return 1
      endif
    endfor

  elseif type(a:pattern) == type({})
    return s:check(a:pattern, entry, 'path', '=~?')
    \   && s:check(a:pattern, entry, 'normalized', '=~?')
    \   && s:check(a:pattern, entry, 'after', 'is')
    \   && s:check(a:pattern, entry, 'default', 'is')

  elseif type(a:pattern) == type('') && a:pattern != ''
    return fnamemodify(entry.path, ':t') =~? a:pattern
  endif
  return 0
endfunction

function! s:check(left, right, key, op)  " {{{2
  return !has_key(a:left, a:key) || !has_key(a:right, a:key) ||
  \      eval(printf('a:left[a:key] %s a:right[a:key]', a:op))
endfunction

function! s:normalize(path)  " {{{2
  return s:unify(a:path, ':p', '/')
endfunction

" Normalize a path or a list of paths.
" - Unify the path separators.
" - Modify the path form with {mods}.
" - Remove the path separator of tail.
function! s:unify(path, mods, sep)  " {{{2
  if type(a:path) == type([])
    return map(a:path, 's:unify(v:val, a:mods, a:sep)')
  endif

  let sep = escape(a:sep, '\')
  let path = a:path
  let path = fnamemodify(path, a:mods)
  let path = substitute(path, s:path_sep_pattern, sep, 'g')
  let path = substitute(path, sep . '$', '', '')
  return path
endfunction

" Escape a path for runtimepath.
function! s:escape(path)  " {{{2
  return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
endfunction

" Get the path separator.
function! s:path_separator()  " {{{2
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction

let s:path_sep_pattern = exists('+shellslash') ? '[\\/]' : '/'

function! s:echoerr(mes)  " {{{2
  echohl ErrorMsg
  for m in split(a:mes, "\n")
    echomsg m
  endfor
  echohl None
endfunction

" Get a dictionary that contains element of list in key.
function! s:list2dict(list)  " {{{2
  let dict = {}
  for e in a:list
    let dict[e] = 1
  endfor
  return dict
endfunction

" For default runtimepath. {{{1
function! s:default()  " {{{2
  let rtp = &runtimepath
  try
    set runtimepath&
    return &runtimepath
  finally
    let &runtimepath = rtp
  endtry
endfunction

let s:default_rtp = s:default()
let s:default_dict = s:list2dict(s:normalize(rtputil#split(s:default_rtp)))




let &cpo = s:save_cpo
