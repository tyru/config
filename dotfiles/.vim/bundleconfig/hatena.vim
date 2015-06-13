let s:config = BundleConfigGet()

function! s:config.config()
    let g:hatena_no_default_keymappings = 1
    let g:hatena_user = 'tyru'
    let g:hatena_entry_file = '~/Dropbox/memo/blogentry.txt'
    " must type :w! to upload.
    let g:hatena_upload_on_write = 0
    let g:hatena_upload_on_write_bang = 1
endfunction
