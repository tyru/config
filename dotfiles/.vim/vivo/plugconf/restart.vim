let s:config = vivo#plugconf#new()

function! s:config.config()
    " command!
    " \   -bar
    " \   RestartWithSession
    " \   let g:restart_sessionoptions = 'folds,help,resize,tabpages,winpos,winsize'
    " \   | Restart

    let g:restart_sessionoptions = 'folds,help,resize,tabpages,winpos,winsize'

    MapAlterCommand res[tart] Restart
    MapAlterCommand ers[tart] Restart
    MapAlterCommand rse[tart] Restart
endfunction
