
autocmd vimrc User dcs-initialized-styles call s:dcs_register_own_styles()
function! s:dcs_register_own_styles()
    let shiftwidth = 'shiftwidth='.(g:VIMRC.Compat.has_version('7.3.629') ? 0 : &sw)
    let softtabstop = 'softtabstop='.(g:VIMRC.Compat.has_version('7.3.693') ? -1 : &sts)
    call dcs#register_style('My style', {'hook_excmd': 'setlocal expandtab tabstop=4 ' . shiftwidth . ' ' . softtabstop})
    call dcs#register_style('Short indent', {'hook_excmd': 'setlocal expandtab tabstop=2 ' . shiftwidth . ' ' . softtabstop})
endfunction
