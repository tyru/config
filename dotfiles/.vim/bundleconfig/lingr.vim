let s:config = vivo#bundleconfig#new()

function! s:config.disable_if()
    return !exists('g:lingr')
endfunction

function! s:config.config()
    " from thinca's .vimrc {{{
    " http://soralabo.net/s/vrcb/s/thinca

    if 0
        " Update GNU screen tab name. {{{

        augroup vimrc-plugin-lingr
            autocmd!
            autocmd User plugin-lingr-* call s:lingr_event(
            \     matchstr(expand('<amatch>'), 'plugin-lingr-\zs\w*'))
            autocmd FileType lingr-* call s:init_lingr(expand('<amatch>'))
        augroup END

        function! s:lingr_ctrl_l() "{{{
            call lingr#mark_as_read_current_room()
            call s:screen_auto_window_name()
            redraw!
        endfunction "}}}
        function! s:init_lingr(ft) "{{{
            if exists('s:screen_is_running')
                Map -silent -buffer [n] <C-l> :<C-u>call <SID>lingr_ctrl_l()<CR>
                let b:window_name = 'lingr'
            endif
        endfunction "}}}
        function! s:lingr_event(event) "{{{
            if a:event ==# 'message' && s:screen_is_running
                execute printf('WindowName %s(%d)', 'lingr', lingr#unread_count())
            endif
        endfunction "}}}

        " }}}
    endif



    autocmd vimrc FileType lingr-messages
    \   call s:lingr_messages_mappings()
    function! s:lingr_messages_mappings() "{{{
        Map -remap -buffer [n] o <Plug>(lingr-messages-show-say-buffer)
        Map -buffer [n] <C-g><C-n> gt
        Map -buffer [n] <C-g><C-p> gT
    endfunction "}}}

    autocmd vimrc FileType lingr-say
    \   call s:lingr_say_mappings()
    function! s:lingr_say_mappings() "{{{
        Map -remap -buffer [n] <CR> <SID>(lingr-say-say)
    endfunction "}}}

    Map -silent [n] <SID>(lingr-say-say) :<C-u>call <SID>lingr_say_say()<CR>
    function! s:lingr_say_say() "{{{
        let all_lines = getline(1, '$')
        let blank_line = '^\s*$'
        call filter(all_lines, 'v:val =~# blank_line')
        if empty(all_lines)    " has blank line(s).
            let doit = 1
        else
            let doit = input('lingr-say buffer has one or more blank lines. say it?[y/n]:') =~? '^y\%[es]'
        endif
        if doit
            execute "normal \<Plug>(lingr-say-say)"
        endif
    endfunction "}}}

    " }}}


    let g:lingr_vim_user = 'tyru'

    let g:lingr_vim_additional_rooms = [
    \   'tyru',
    \   'vim',
    \   'emacs',
    \   'editor',
    \   'vim_users_en',
    \   'vimperator',
    \   'filer',
    \   'completion',
    \   'shell',
    \   'git',
    \   'termtter',
    \   'lingr',
    \   'ruby',
    \   'few',
    \   'gc',
    \   'scala',
    \   'lowlevel',
    \   'lingr_vim',
    \   'vimjolts',
    \   'gentoo',
    \   'LinuxKernel',
    \]
    let g:lingr_vim_rooms_buffer_height = len(g:lingr_vim_additional_rooms) + 3
    let g:lingr_vim_count_unread_at_current_room = 1
endfunction
