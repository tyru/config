
let s:config = vivo#bundleconfig#new()

function! s:config.config()
    " operator-sort
    call operator#user#define_ex_command('sort', 'sort')
    Map -remap [nxo] <operator>s <Plug>(operator-sort)

    " operator-retab
    call operator#user#define_ex_command('retab', 'retab')
    Map -remap [nxo] <operator>t <Plug>(operator-retab)

    " operator-join
    call operator#user#define_ex_command('join', 'join')
    Map -remap [nxo] <operator>j <Plug>(operator-join)

    " operator-uniq
    call operator#user#define_ex_command('uniq', 'sort u')
    Map -remap [nxo] <operator>u <Plug>(operator-uniq)

    " operator-blank-killer
    call operator#user#define_ex_command('blank-killer', 's/\s\+$//')
    Map -remap [nxo] <operator>bk <Plug>(operator-blank-killer)

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

    Map -remap [nxo] <operator>zh <Plug>(operator-zen2han)
    Map -remap [nxo] <operator>hz <Plug>(operator-han2zen)
    endif
endfunction
