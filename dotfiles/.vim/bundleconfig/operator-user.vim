
let s:config = BundleConfigGet()

function! s:config.config()
    " operator-adjust {{{
    call operator#user#define('adjust', 'Op_adjust_window_height')
    function! Op_adjust_window_height(motion_wiseness)
        execute (line("']") - line("'[") + 1) 'wincmd _'
        normal! `[zt
    endfunction

    Map -remap [nxo] <operator>adj <Plug>(operator-adjust)
    " }}}


    " operator-sort {{{
    call operator#user#define_ex_command('sort', 'sort')
    Map -remap [nxo] <operator>s <Plug>(operator-sort)
    " }}}

    " operator-retab {{{
    call operator#user#define_ex_command('retab', 'retab')
    Map -remap [nxo] <operator>t <Plug>(operator-retab)
    " }}}

    " operator-join {{{
    call operator#user#define_ex_command('join', 'join')
    Map -remap [nxo] <operator>j <Plug>(operator-join)
    " }}}

    " operator-uniq {{{
    call operator#user#define_ex_command('uniq', 'sort u')
    Map -remap [nxo] <operator>u <Plug>(operator-uniq)
    " }}}

    " operator-narrow {{{
    call operator#user#define_ex_command('narrow', 'Narrow')

    Map -remap [nxo] <operator>na <Plug>(operator-narrow)
    Map [nxo]        <operator>nw :<C-u>Widen<CR>

    let g:narrow_allow_overridingp = 1
    " }}}

    " operator-zen2han, operator-han2zen {{{
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
    " }}}

    " operator-blank-killer {{{
    call operator#user#define_ex_command('blank-killer', 's/\s\+$//')
    Map -remap [nxo] <operator>bk <Plug>(operator-blank-killer)
    " }}}

    " operator-fillblank {{{
    " from daisuzu .vimrc:
    "   http://vim-jp.org/reading-vimrc/archive/023.html
    "   http://lingr.com/room/vim/archives/2012/12/08#message-13176343
    "   https://raw.github.com/daisuzu/dotvim/master/.vimrc

    function! OperatorFillBlank(motion_wise)
        let v = operator#user#visual_command_from_wise_name(a:motion_wise)
        execute 'normal! `['.v.'`]"xy'
        let text = getreg('x', 1)
        let text = s:map_lines(text,
        \   'substitute(v:val, ".", "\\=s:charwidthwise_r(submatch(0))", "g")')
        call setreg('x', text, v)
        normal! gv"xp
    endfunction
    function! s:charwidthwise_r(char)
        return repeat(' ', exists('*strwidth') ? strwidth(a:char) : 1)
    endfunction
    call operator#user#define('fillblank', 'OperatorFillBlank')
    Map -remap [nxo] <operator><Space> <Plug>(operator-fillblank)
    " }}}
endfunction
