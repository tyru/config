let s:config = vivo#plugconf#new()

function! s:config.config()
    let g:quickrun_no_default_key_mappings = 1
    nmap <Space>r <Plug>(quickrun)
    xmap <Space>r <Plug>(quickrun)

    if has('vim_starting')
        let g:quickrun_config = {}

        let g:quickrun_config['_'] = {
        \   'outputter/buffer/close_on_empty': 1,
        \}

        let g:quickrun_config['lisp'] = {
        \   'command': 'clisp',
        \   'eval': 1,
        \   'eval_template': '(print %s)',
        \}

        " http://d.hatena.ne.jp/osyo-manga/20121125/1353826182
        let g:quickrun_config["cpp0x"] = {
        \   "command" : "g++",
        \   "cmdopt" : "--std=c++0x",
        \   "type" : "cpp/g++",
        \}
    endif
endfunction
