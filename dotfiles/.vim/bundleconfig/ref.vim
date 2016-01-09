let s:config = vivacious#bundleconfig#new()

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
    " Map -remap [n] K <SID>(open-help-window)<Plug>(ref-keyword)
    Map -remap [n] K <Plug>(ref-keyword)

    Map [n] <SID>(open-help-window) :<C-u>call <SID>open_help_window()<CR>
    function! s:open_help_window()
        if !s:has_help_window()
            Help
            wincmd w
        endif
    endfunction

    if $VIMRC_USE_VIMPROC !=# 2
        let g:ref_use_vimproc = $VIMRC_USE_VIMPROC
    endif
    let g:ref_open = 'SplitNicely split'
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
