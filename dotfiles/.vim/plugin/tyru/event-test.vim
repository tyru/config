
if exists('g:loaded_tyru_event_test') && g:loaded_tyru_event_test
    finish
endif
let g:loaded_tyru_event_test = 1

MyAutocmd BufEnter * Decho 'BufEnter:' . tabpagenr('$')
MyAutocmd BufLeave * Decho 'BufLeave:' . tabpagenr('$')
MyAutocmd WinEnter * Decho 'WinEnter:' . tabpagenr('$')
MyAutocmd WinLeave * Decho 'WinLeave:' . tabpagenr('$')
MyAutocmd TabEnter * Decho 'TabEnter:' . tabpagenr('$')
MyAutocmd TabLeave * Decho 'TabLeave:' . tabpagenr('$')
MyAutocmd BufWinEnter * Decho 'BufWinEnter:' . tabpagenr('$')
MyAutocmd BufWinLeave * Decho 'BufWinLeave:' . tabpagenr('$')
