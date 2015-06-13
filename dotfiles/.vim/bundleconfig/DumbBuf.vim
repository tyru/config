let s:config = BundleConfigGet()

function! s:config.config()
    let dumbbuf_hotkey = 'gb'
    " たまにQuickBuf.vimの名残で<Esc>を押してしまう
    let dumbbuf_mappings = {
    \'n': {
    \'<Esc>': {'alias_to': 'q'},
    \}
    \}
    let dumbbuf_wrap_cursor = 0
    let dumbbuf_remove_marked_when_close = 1
    " let dumbbuf_shown_type = 'project'
    " let dumbbuf_close_when_exec = 1


    " DumbBuf nmap s    split #<bufnr>
    " DumbBuf nmap g    sbuffer <bufnr>
    " call dumbbuf#map('n', '', 0, 'g', ':sbuffer %d')

    " let dumbbuf_cursor_pos = 'keep'

    " For (compatibility) test
    "
    " let dumbbuf_shown_type = 'foobar'
    " let dumbbuf_listed_buffer_name = "*foo bar*"
    "
    " let dumbbuf_verbose = 1
endfunction
