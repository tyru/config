
let s:config = vivo#plugconf#new()

function! s:config.config()
  " operator-sort
  call operator#user#define_ex_command('sort', 'sort')
  nmap <Plug>(vimrc:prefix:operator)s <Plug>(operator-sort)
  xmap <Plug>(vimrc:prefix:operator)s <Plug>(operator-sort)
  omap <Plug>(vimrc:prefix:operator)s <Plug>(operator-sort)

  " operator-retab
  call operator#user#define_ex_command('retab', 'retab')
  nmap <Plug>(vimrc:prefix:operator)t <Plug>(operator-retab)
  xmap <Plug>(vimrc:prefix:operator)t <Plug>(operator-retab)
  omap <Plug>(vimrc:prefix:operator)t <Plug>(operator-retab)

  " operator-join
  call operator#user#define_ex_command('join', 'join')
  nmap <Plug>(vimrc:prefix:operator)j <Plug>(operator-join)
  xmap <Plug>(vimrc:prefix:operator)j <Plug>(operator-join)
  omap <Plug>(vimrc:prefix:operator)j <Plug>(operator-join)

  " operator-uniq
  call operator#user#define_ex_command('uniq', 'sort u')
  nmap <Plug>(vimrc:prefix:operator)u <Plug>(operator-uniq)
  xmap <Plug>(vimrc:prefix:operator)u <Plug>(operator-uniq)
  omap <Plug>(vimrc:prefix:operator)u <Plug>(operator-uniq)

  " operator-blank-killer
  call operator#user#define_ex_command('blank-killer', 's/\s\+$//')
  nmap <Plug>(vimrc:prefix:operator)bk <Plug>(operator-blank-killer)
  xmap <Plug>(vimrc:prefix:operator)bk <Plug>(operator-blank-killer)
  omap <Plug>(vimrc:prefix:operator)bk <Plug>(operator-blank-killer)

  " TODO: operator-zen2han, operator-han2zen
  if 0
    call operator#user#define('zen2han', 'Op_zen2han')
    function! Op_zen2han(motion_wiseness)
      " TODO
    endfunction

    call operator#user#define('han2zen', 'Op_han2zen')
    function! Op_han2zen(motion_wiseness)
      " TODO
    endfunction

    nmap <Plug>(vimrc:prefix:operator)zh <Plug>(operator-zen2han)
    xmap <Plug>(vimrc:prefix:operator)zh <Plug>(operator-zen2han)
    omap <Plug>(vimrc:prefix:operator)zh <Plug>(operator-zen2han)

    nmap <Plug>(vimrc:prefix:operator)hz <Plug>(operator-han2zen)
    xmap <Plug>(vimrc:prefix:operator)hz <Plug>(operator-han2zen)
    omap <Plug>(vimrc:prefix:operator)hz <Plug>(operator-han2zen)
  endif
endfunction
