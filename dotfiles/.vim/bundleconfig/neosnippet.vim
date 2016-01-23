let s:config = vivacious#bundleconfig#new()

function! s:config.config()
    Map -remap -expr [i] <Tab> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
    Map -remap -expr [s] <Tab> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: "\<Tab>"
endfunction
