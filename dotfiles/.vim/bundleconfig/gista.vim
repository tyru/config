scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:gista = vivo#bundleconfig#new()

" Configuration for gista.
function! s:gista.config()
    let g:gista#command#post#allow_empty_description = 1

    if vivo#loaded_plugin('open-browser.vim')
        function! s:on_GistaPost() abort
            let gistid = g:gista#avars.gistid
            call openbrowser#open('https://gist.github.com/' . gistid)
        endfunction
        augroup vimrc-gista-autocmd
            autocmd! *
            autocmd User GistaPost call s:on_GistaPost()
        augroup END
    endif
endfunction

" Plugin dependencies for gista.
function! s:gista.depends()
    return []
endfunction

" Recommended plugin dependencies for gista.
" If the plugins are not installed, vivo shows recommended plugins.
function! s:gista.recommends()
    return []
endfunction

" External commands dependencies for gista.
" (e.g.: curl)
function! s:gista.depends_commands()
    return []
endfunction

" Recommended external commands dependencies for gista.
" If the plugins are not installed, vivo shows recommended commands.
function! s:gista.recommends_commands()
    return []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
