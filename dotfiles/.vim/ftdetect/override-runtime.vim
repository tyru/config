" Override runtime ftdetects


autocmd BufNewFile,BufRead *.ks
            \ setlocal filetype=kirikiri
autocmd BufNewFile,BufRead *.markdown,*.mkd,*.md,*.mkdn
            \ setlocal filetype=markdown
autocmd BufNewFile,BufRead ~/Dropbox/memo/**/*.txt
            \ setlocal filetype=markdown
