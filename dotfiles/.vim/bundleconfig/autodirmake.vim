let s:config = BundleConfigGet()

function! s:config.config()
    let g:autodirmake#msg_highlight = 'Question'
    let g:autodirmake#char_prompt = 1
endfunction
