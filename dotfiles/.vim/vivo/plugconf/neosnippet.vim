let s:config = vivo#plugconf#new()

function! s:config.config()
  imap <expr> <Tab> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
  smap <expr> <Tab> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
endfunction
