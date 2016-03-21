let s:config = vivo#plugconf#new()

function! s:config.config()
    let g:vt_author = "tyru"
    let g:vt_email = "tyru.exe@gmail.com"
    let g:vt_email = "tyru.exe@gmail.com"
    let g:vt_template_dir_path = $MYVIMDIR.'/template'
    let g:vt_files_metainfo = {
    \   'cppsrc-scratch.cpp': {'filetype': "cpp"},
    \   'cppsrc.cpp'    : {'filetype': "cpp"},
    \   'csharp.cs'     : {'filetype': "cs"},
    \   'csrc.c'        : {'filetype': "c"},
    \   'header.h'      : {'filetype': "c"},
    \   'hina.html'     : {'filetype': "html"},
    \   'javasrc.java'  : {'filetype': "java"},
    \   'perl.pl'       : {'filetype': "perl"},
    \   'perlmodule.pm' : {'filetype': "perl"},
    \   'python.py'     : {'filetype': "python"},
    \   'scala.scala'   : {'filetype': "scala"},
    \   'scheme.scm'    : {'filetype': "scheme"},
    \   'vimscript.vim' : {'filetype': "vim"}
    \}

    let g:vt_open_command = 'botright 7new'
    " Disable &modeline when opened template file.
    execute
    \   'autocmd vimrc BufReadPre'
    \   $MYVIMDIR . '/template/*'
    \   'setlocal nomodeline'
endfunction
