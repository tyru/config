setlocal expandtab
setlocal noignorecase
setlocal suffixesadd=.hs
setlocal cpoptions+=M

" iabbrev case case of<Left><Left><Left>
" iabbrev W where
" iabbrev M module
" iabbrev In instance
" iabbrev Im import

compiler ghc

inoremap <C-T> _<BS><ESC>:call <SID>Indent()<CR>i

function! s:Indent()
    let pos = getpos('.')
    let lnum = pos[1]
    let cnum = pos[2]

    if lnum == 1
        return
    endif

    let line = getline('.')

    if line =~ '^\s*$' | execute 'normal a ' | endif
    normal ^kW

    let indent_pos = getpos('.')
    if indent_pos[1] >= lnum
        call cursor(lnum - 1, 0)
        normal ^
        let indent_pos = getpos('.')
    endif
    normal j

    s/^\s*/\=repeat(' ', line =~ '^\s*$' ? indent_pos[2] : indent_pos[2] - 1)/
    let new_line = getline('.')

    call cursor(lnum, cnum + len(new_line) - len(line) + 1)

endfunction
