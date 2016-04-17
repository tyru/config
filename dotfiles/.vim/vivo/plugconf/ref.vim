let s:config = vivo#plugconf#new()

function! s:config.config()
    " 'K' for ':Ref'.
    MapAlterCommand ref         Ref
    MapAlterCommand alc         Ref webdict alc
    MapAlterCommand rfc         Ref rfc
    MapAlterCommand man         Ref man
    MapAlterCommand pdoc        Ref perldoc
    MapAlterCommand cppref      Ref cppref
    MapAlterCommand cpp         Ref cppref
    MapAlterCommand py[doc]     Ref pydoc

    Map [n] <orig>K K
    Map -remap [n] K <Plug>(ref-keyword)
    augroup bundleconfig-ref
        autocmd!
        autocmd FileType vim Map -buffer [n] K K
    augroup END

    if $VIMRC_USE_VIMPROC !=# 2
        let g:ref_use_vimproc = $VIMRC_USE_VIMPROC
    endif
    let g:ref_open = 'vsplit'
    if executable('perldocjp')
        let g:ref_perldoc_cmd = 'perldocjp'
    endif
    let g:ref_noenter = 1

    " webdict source {{{

    let g:ref_source_webdict_cmd = ['lynx', '-dump', '-nonumbers', '%s']
    let g:ref_source_webdict_sites = {
    \   'default': 'alc',
    \
    \   'alc': {
    \       'url': 'http://eow.alc.co.jp/%s',
    \       'keyword_encoding': 'utf-8',
    \   },
    \   'wikipedia': {
    \       'url': 'http://ja.wikipedia.org/wiki/%s',
    \   },
    \ }
    function! g:ref_source_webdict_sites.alc.filter(output)
        return join(split(a:output, "\n")[38 :], "\n")
    endfunction

    function! g:ref_source_webdict_sites.wikipedia.filter(output)
        return join(split(a:output, "\n")[6 :], "\n")
    endfunction

    " }}}

endfunction
