
augroup coding-or-not
    autocmd!
    autocmd FileType
    \   actionscript,c,cpp,cs,java,javascript,
    \perl,powershell,python,ruby,scheme,scala,
    \lua,html,vim,vimperator
    \   runtime! ftplugin/code.vim
augroup END
