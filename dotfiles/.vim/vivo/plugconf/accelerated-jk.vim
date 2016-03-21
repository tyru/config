
let s:config = vivo#plugconf#new()

function! s:config.config()
    Map -remap [n] j <Plug>(accelerated_jk_gj)
    Map -remap [n] k <Plug>(accelerated_jk_gk)
    let g:accelerated_jk_deceleration_table = [
    \   [200, 10],
    \   [300, 15],
    \   [500, 30],
    \   [600, 40],
    \   [700, 50],
    \   [800, 60],
    \   [900, 70],
    \   [1000, 9999],
    \]
endfunction
