
let g:nf_map_next     = ''
let g:nf_map_previous = ''
Map -remap [n] ,n <Plug>(nextfile-next)
Map -remap [n] ,p <Plug>(nextfile-previous)

let g:nf_include_dotfiles = 1    " don't skip dotfiles
let g:nf_ignore_ext = ['o', 'obj', 'exe', 'bin']


function! NFLoopMsg(file_to_open)
    redraw
    call s:warn('open a file from the start...')
    " Always open a next/previous file...
    return 1
endfunction
function! NFLoopPrompt(file_to_open)
    return input('open a file from the start? [y/n]:') =~? 'y\%[es]'
endfunction

" g:nf_loop_hook_fn only works when g:nf_loop_files is true.
let g:nf_loop_files = 1
" Call this function when wrap around.
" let g:nf_loop_hook_fn = 'NFLoopPrompt'
let g:nf_loop_hook_fn = 'NFLoopMsg'
" To avoid |hit-enter| for NFLoopMsg().
let g:nf_open_command = 'silent edit'

