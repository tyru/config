let s:config = vivo#plugconf#new()

function! s:config.config()
    Map -remap [nxo] <operator>he <Plug>(operator-html-escape)
    Map -remap [nxo] <operator>hu <Plug>(operator-html-unescape)
endfunction
