let s:config = vivo#plugconf#new()

function! s:config.config()
    MapAlterCommand sh[ell] VimShell

    let g:vimshell_user_prompt = '"(" . getcwd() . ") --- (" . $USER . "@" . hostname() . ")"'
    let g:vimshell_prompt = '$ '
    let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
    let g:vimshell_ignore_case = 1
    let g:vimshell_smart_case = 1

    autocmd vimrc FileType vimshell call s:vimshell_settings()
    function! s:vimshell_settings()
        call s:build_env_path()

        " No -bar
        command!
        \   -buffer -nargs=+
        \   VimShellAlterCommand
        \   call vimshell#altercmd#define(
        \       s:parse_one_arg_from_q_args(<q-args>)[0],
        \       s:eat_n_args_from_q_args(<q-args>, 1)
        \   )

        " Alias
        VimShellAlterCommand vi vim
        VimShellAlterCommand df df -h
        VimShellAlterCommand diff diff --unified
        VimShellAlterCommand du du -h
        VimShellAlterCommand free free -m -l -t
        VimShellAlterCommand j jobs -l
        VimShellAlterCommand jobs jobs -l
        VimShellAlterCommand ll ls -lh
        VimShellAlterCommand l ll
        VimShellAlterCommand la ls -A
        " VimShellAlterCommand less less -r
        VimShellAlterCommand sc screen
        VimShellAlterCommand whi which
        VimShellAlterCommand whe where
        VimShellAlterCommand go gopen

        " VimShellAlterCommand l. ls -d .*
        call vimshell#set_alias('l.', 'ls -d .*')

        " Abbrev
        inoreabbrev <buffer> l@ <Bar> less
        inoreabbrev <buffer> g@ <Bar> grep
        inoreabbrev <buffer> p@ <Bar> perl
        inoreabbrev <buffer> s@ <Bar> sort
        inoreabbrev <buffer> u@ <Bar> sort -u
        inoreabbrev <buffer> c@ <Bar> xsel --input --clipboard
        inoreabbrev <buffer> x@ <Bar> xargs --no-run-if-empty
        inoreabbrev <buffer> n@ >/dev/null 2>/dev/null
        inoreabbrev <buffer> e@ 2>&1
        inoreabbrev <buffer> h@ --help 2>&1 <Bar> less
        inoreabbrev <buffer> H@ --help 2>&1

        if executable('perldocjp')
            VimShellAlterCommand perldoc perldocjp
        endif

        let less_sh = s:Prelude.globpath(&rtp, 'macros/less.sh')
        if !empty(less_sh)
            call vimshell#altercmd#define('vless', less_sh[0])
        endif

        " Hook
        call vimshell#hook#set('chpwd', [s:SNR('vimshell_chpwd_ls')])
        call vimshell#hook#set('preexec', [s:SNR('vimshell_preexec')])
        " call vimshell#hook#set('preexec', [s:SNR('vimshell_preexec_less')])

        " Add/Remove some mappings.
        nunmap <buffer> <C-n>
        nunmap <buffer> <C-p>
        iunmap <buffer> <Tab>
        imap <buffer> <Tab><Tab> <Plug>(vimshell_command_complete)
        nmap <buffer> <C-z> <Plug>(vimshell_switch)
        imap <buffer> <compl>r <Plug>(vimshell_history_complete_whole)

        " Misc.
        setlocal backspace-=eol
        setlocal updatetime=1000
        setlocal nowrap

        if 0
            if !exists(':NeoCompleteDisable')
                NeoCompleteEnable
            endif
            NeoCompleteAutoCompletionLength 1
            NeoCompleteUnlock
            augroup vimrc-vimshell-settings
                autocmd!
                autocmd TabEnter <buffer> NeoCompleteUnlock
                autocmd TabLeave <buffer> NeoCompleteLock
            augroup END
        endif
    endfunction

    function! s:vimshell_chpwd_ls(args, context)
        call vimshell#execute('ls')
    endfunction

    let s:PREEXEC_IEXE = [
    \   'termtter',
    \   'sudo',
    \   ['git', 'add', '-p'],
    \   ['git', 'log'],
    \   ['git', 'lp'],
    \   ['git', 'view'],
    \   ['git', 'blame'],
    \   ['git', 'help'],
    \   'earthquake',
    \]
    let s:PREEXEC_LESS = [
    \   ['git', 'log'],
    \   ['git', 'view'],
    \]
    function! s:vimshell_preexec(cmdline, context)
        let args = vimproc#parser#split_args(a:cmdline)
        if empty(args)
            return a:cmdline
        endif

        " Prepend "iexe".
        if args[0] ==# 'iexe'
            return a:cmdline
        elseif s:vimshell_preexec_match(args, s:PREEXEC_IEXE)
            return 'iexe '.a:cmdline
        endif

        " Prepend "less".
        if args[0] ==# 'less'
            return a:cmdline
        elseif s:vimshell_preexec_match(args, s:PREEXEC_LESS)
            return 'less '.a:cmdline
        endif

        " TODO: Detect args[1] is correct git command.
        " Avoid error like "git ls ..."
        " This also avoids "git git ..." :-)
        " if len(args) >= 2 &&
        " \   args[0] ==# 'git' && executable(args[1])
        "     return join(args[1:], ' ')
        " endif

        " TODO: Implement a feature like zsh correct

        " No rewrite.
        return a:cmdline
    endfunction
    function! s:vimshell_preexec_match(args, patlist)
        if empty(a:args)
            return 0
        endif
        for i in a:patlist
            let list_match = type(i) == type([]) && i ==# a:args[:len(i)-1]
            let string_match = type(i) == type("") && a:args[0] ==# i
            if list_match || string_match
                return 1
            endif
            unlet i
        endfor
        return 0
    endfunction

    let s:has_built_path = 0
    function! s:build_env_path()
        if s:has_built_path
            return
        endif
        let s:has_built_path = 1

        " build $PATH if vim started w/o shell.
        " XXX: :gui
        let is_win = has('win16') || has('win32') || has('win64') || has('win95')
        let $PATH = system(is_win ? 'echo %path%' : 'echo $PATH')
    endfunction
endfunction

function! s:skip_white(q_args)
    return substitute(a:q_args, '^\s*', '', '')
endfunction

function! s:parse_pattern(str, pat)
    let str = a:str
    " TODO: Use matchlist() for capturing group \1, \2, ...
    " and specify which group to use with arguments.
    let head = matchstr(str, a:pat)
    let rest = strpart(str, strlen(head))
    return [head, rest]
endfunction

function! s:parse_one_arg_from_q_args(q_args)
    let q_args = s:skip_white(a:q_args)
    return s:parse_pattern(q_args, '^.\{-}[^\\]\ze\([ \t]\|$\)')
endfunction

function! s:eat_n_args_from_q_args(q_args, n)
    let rest = a:q_args
    for _ in range(1, a:n)
        let rest = s:parse_one_arg_from_q_args(rest)[1]
    endfor
    let rest = s:skip_white(rest)    " for next arguments.
    return rest
endfunction

