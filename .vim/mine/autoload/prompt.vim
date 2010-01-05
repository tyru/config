" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: prompt.vim
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2010-01-04.
"
" Description:
"   Smart prompt function like IO::Prompt.
"
" Change Log: {{{
" }}}
" Usage: {{{
"   Global Variables: {{{
"   }}}
" }}}
"
"
" TODO: {{{
" - support migemo.
" - support FuzzyFinder.vim like interface.
" - treat EOF(C-d) as "\<CR>" when input is empty string.
" - :redraw menu's list when too many bad choices.
" - incremental filtering about menu's list
" -- currently I don't think run_menu() shows many such list.
" -- IO::Prompt also warns like "Too many -menu items ..."
"    if -menu's list is greater than 26.
" - echo warning at current line.
" - iPod touch/iPhone like password input interface.
" -- show only last character for a while.
" }}}
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_prompt') && g:loaded_prompt
    finish
endif
let g:loaded_prompt = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


" Validation functions {{{
func! s:no_validate(val)
    return 1
endfunc
func! s:is_int(val)
    return type(a:val) == type(0)
    \   || (type(a:val) == type("")
    \      && a:val =~# '^'.'\d\+'.'$')
endfunc
func! s:is_num(val)
    return s:is_int(a:val)
    \   || type(a:val) == type(0.0)
    \   || (type(a:val) == type("")
    \       && a:val =~# '^'.'\d\+'.'\.'.'\d\+'.'$')
endfunc
func! s:is_str(val)
    return type(a:val) == type("")
endfunc
func! s:is_dict(val)
    return type(a:val) == type({})
endfunc
func! s:is_list(val)
    return type(a:val) == type([])
endfunc
func! s:is_function(val)
    return type(a:val) == type(function('tr'))
endfunc
func! s:is_callable(val)
    if s:is_function(a:val) | return 1 | endif
    if s:is_str(a:val) && exists('*'.a:val)
        return 1
    endif
    return 0
endfunc

func! s:is_menutype(val)
    return a:val =~#
    \       '^'.'\(cmdline\|buffer\|allbuffer\|dialog\)'.'$'
endfunc
" }}}
" Sort functions {{{
func! s:sortfn_string(s1, s2)
    return a:s1 ==# a:s2 ? 0 : a:s1 > a:s2 ? 1 : -1
endfunc
func! s:sortfn_number(i1, i2)
    return a:i1 ==# a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
endfunc
" }}}
" Candidates generator functions {{{
func! s:generate_alpha(idx, key)
    return prompt#gen_seq_str("abcdefghijklmnopqrstuvwxyz", a:idx)
endfunc
func! s:generate_asdf(idx, key)
    return prompt#gen_seq_str("asdfghjkl;", a:idx)
endfunc
func! s:generate_num(idx, key)
    return a:idx + 1
endfunc
" }}}


" Scope Variables {{{
let s:debug_errmsg = []
" }}}
" Global Variables {{{
if !exists('g:prompt_debug')
    let g:prompt_debug = 0
endif
if !exists('g:prompt_prompt')
    let g:prompt_prompt = '> '
endif
" }}}

" Functions {{{

" Utility functions
" Debug {{{
if g:prompt_debug
    func! s:debug(cmd, ...)
        if a:cmd ==# 'on'
            let g:prompt_debug = 1
        elseif a:cmd ==# 'off'
            let g:prompt_debug = 0
        elseif a:cmd ==# 'list'
            for i in s:debug_errmsg
                echo i
            endfor
        elseif a:cmd ==# 'eval'
            redraw
            execute join(a:000, ' ')
        endif
    endfunc

    com! -nargs=+ PromptDebug
        \ call s:debug(<f-args>)
endif

" s:debugmsg {{{
func! s:debugmsg(msg)
    if g:prompt_debug
        call s:warn(a:msg)
    endif
endfunc
" }}}
" s:debugmsgf {{{
func! s:debugmsgf(fmt, ...)
    call s:debugmsg(call('printf', [a:fmt] + a:000))
endfunc
" }}}

" }}}
" s:warn {{{
func! s:warn(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None

    call add(s:debug_errmsg, a:msg)
endfunc
" }}}
" s:warnf {{{
func! s:warnf(fmt, ...)
    call s:warn(call('printf', [a:fmt] + a:000))
endfunc
" }}}
" s:bad_choice {{{
func! s:bad_choice(msg)
    call s:warn(a:msg)
    sleep 1
endfunc
" }}}


" Objects.
" s:Object {{{
let s:Object = {}

func! s:Object.init() dict
    call s:debugmsg("s:Object.init()...")
endfunc

func! s:Object.clone() dict
    return deepcopy(self)
endfunc
" }}}
" s:OptionManager {{{
let s:OptionManager = s:Object.clone()

" s:OptionManager.init {{{
func! s:OptionManager.init() dict
    " TODO
    " - speed
    " - require
    " - until
    " - while
    " - menutype
    let self.opt_info_all = {
    \   'speed': {'arg_type': 'num'},
    \   'echo': {'arg_type': 'str'},
    \   'newline': {'arg_type': 'str'},
    \   'default': {'arg_type': 'str'},
    \   'require': {'arg_type': 'dict'},
    \   'until': {'arg_type': 'str'},
    \   'while': {'arg_type': 'str'},
    \   'menu': {
    \       'arg_type': ['list', 'dict'],
    \       'expand_to': {'menuasdf': 1},
    \       'remain_myself': 1,
    \   },
    \   'onechar': {'arg_type': 'bool'},
    \   'escape': {'arg_type': 'bool'},
    \   'line': {'arg_type': 'bool'},
    \   'yes': {'arg_type': 'bool'},
    \   'yesno': {'arg_type': 'bool'},
    \   'YES': {'arg_type': 'bool'},
    \   'YESNO': {'arg_type': 'bool'},
    \   'number': {'arg_type': 'bool'},
    \   'integer': {'arg_type': 'bool'},
    \
    \   'execute': {'arg_type': 'str'},
    \   'menuidfunc': {'arg_type': 'fn'},
    \   'menualpha': {
    \       'arg_type': 'bool',
    \       'expand_to': {
    \           'menuidfunc': function('<SID>generate_alpha'),
    \           'sortmenu': 1,
    \       }
    \   },
    \   'menuasdf': {
    \       'arg_type': 'bool',
    \       'expand_to': {
    \           'menuidfunc': function('<SID>generate_asdf'),
    \           'sortmenu': 0,
    \       }
    \   },
    \   'menunum': {
    \       'arg_type': 'bool',
    \       'expand_to': {
    \           'menuidfunc': function('<SID>generate_num'),
    \           'sortmenu': 0,
    \       }
    \   },
    \   'menutype': {
    \       'arg_type':
    \           'custom:' .
    \           string(function('<SID>is_menutype'))
    \   },
    \   'sortmenu': {
    \       'arg_type': 'bool',
    \   },
    \   'sortby': {
    \       'arg_type': 'fn',
    \   },
    \}

    let self.opt_alias = {
    \   's': 'speed',
    \   'e': 'echo',
    \   'nl': 'newline',
    \   'd': 'default',
    \   'r': 'require',
    \   'u': 'until',
    \   'okayif': 'until',
    \   'w': 'while',
    \   'failif': 'while',
    \   'm': 'menu',
    \   '1': 'onechar',
    \   'x': 'escape',
    \   'c': 'clear',
    \   'f': 'clearfirst',
    \   'a': 'argv',
    \   'l': 'line',
    \   't': 'tty',
    \   'y': 'yes',
    \   'yn': 'yesno',
    \   'Y': 'YES',
    \   'YN': 'YESNO',
    \   'num': 'number',
    \   'i': 'integer',
    \
    \   'exe': 'execute',
    \   'alpha': 'menualpha',
    \   'asdf': 'menuasdf',
    \   'sm': 'sortmenu',
    \   'sb': 'sortby',
    \}
endfunc
" }}}
call s:OptionManager.init()

" s:OptionManager.exists {{{
func! s:OptionManager.exists(name) dict
    if self.is_alias(a:name)
        return self.exists(a:name)
    endif
    return has_key(self.opt_info_all, a:name)
endfunc
" }}}
" s:OptionManager.get {{{
func! s:OptionManager.get(name, ...) dict
    if self.is_alias(a:name)
        return call(self.get,
        \       [self.opt_alias[a:name]] + a:000,
        \       self)
    endif
    if !self.exists(a:name)
        if a:0 == 0
            throw 'internal_error'
        else
            return a:1
        endif
    endif
    return self.opt_info_all[a:name]
endfunc
" }}}
" s:OptionManager.is_alias {{{
func! s:OptionManager.is_alias(name) dict
    return has_key(self.opt_alias, a:name)
endfunc
" }}}
" s:OptionManager.filter_alias {{{
func! s:OptionManager.filter_alias(options, extend_opt) dict
    let ret = {}
    for k in keys(a:options)
        if self.is_alias(k)
            call extend(ret,
            \           self.filter_alias(self.get(k), a:extend_opt),
            \           a:extend_opt)
        else
            let ret[k] = a:options[k]
        endif
    endfor
    return ret
endfunc
" }}}
" s:OptionManager.expand {{{
"   expand abbrev options if it has 'expand_to'.
func! s:OptionManager.expand(options, extend_opt) dict
    let ret = {}
    for k in keys(a:options)
        call s:debugmsgf("options = {%s:%s}", k, string(a:options[k]))

        let info = self.get(k)
        if has_key(info, 'expand_to')
            call extend(ret,
            \           self.expand(info.expand_to, a:extend_opt),
            \           a:extend_opt)
            if has_key(info, 'remain_myself')
                let ret[k] = a:options[k]
            endif
        else
            let ret[k] = a:options[k]
        endif
    endfor
    return ret
endfunc
" }}}
" }}}
" s:Prompt {{{
let s:Prompt = s:Object.clone()

" s:Prompt.init {{{
func! s:Prompt.init(option_manager) dict
    let self.opt_info = a:option_manager

    let self.validate_fn = {
    \   'str': function('<SID>no_validate'),
    \   'int': function('<SID>is_int'),
    \   'num': function('<SID>is_num'),
    \   'bool': function('<SID>no_validate'),
    \   'dict': function('<SID>is_dict'),
    \   'list': function('<SID>is_list'),
    \   'fn': function('<SID>is_function'),
    \}

    let self.YESNO_PAT = {
    \   'yes': '[\w\W]*',
    \   'yesno': '^\s*[yYnN]',
    \   'YES': '[\w\W]*',
    \   'YESNO': '^\s*[YN]',
    \}

    let self.YESNO_ERR_MSG = {
    \   'yesno': "Please answer 'y' or 'n'",
    \   'YESNO': "Please answer 'Y' or 'N'",
    \}
endfunc
" }}}
call s:Prompt.init(s:OptionManager)

" s:Prompt.set_msg {{{
func! s:Prompt.set_msg(msg) dict
    let self.msg = a:msg
endfunc
" }}}
" s:Prompt.set_options {{{
func! s:Prompt.set_options(options) dict
    let self.options = a:options
endfunc
" }}}

" s:Prompt.run {{{
func! s:Prompt.run() dict
    call s:debugmsg('options = ' . string(self.options))

    " Remove '_' in keys.
    let opts = self.options
    let self.options = {}    " clear
    for k in keys(opts)
        let self.options[substitute(k, '_', '', 'g')] = opts[k]
    endfor

    let self.options = self.opt_info.filter_alias(self.options, 'force')
    let self.options = self.opt_info.expand(self.options, 'force')
    call self.add_default_options()
    call self.validate_options()

    call s:debugmsg('options = ' . string(self.options))


    try
        let value = self.dispatch()
    catch /^pressed_esc_with:/
        return substitute(v:exception, '^pressed_esc_with:', '', '')."\e"
    endtry

    if has_key(self.options, 'execute') && !empty(value)
        redraw
        execute printf(self.options.execute, value)
    endif
    return value
endfunc
" }}}
" s:Prompt.dispatch {{{
func! s:Prompt.dispatch() dict
    let yesno_type =
    \   get(self.options, 'yes', 0)     ? 'yes'
    \   : get(self.options, 'yesno', 0) ? 'yesno'
    \   : get(self.options, 'YES', 0)   ? 'YES'
    \   : get(self.options, 'YESNO', 0) ? 'YESNO'
    \   : ''

    if yesno_type != ''
        call s:debugmsg('run_yesno()')
        return self.run_yesno(yesno_type)
    elseif has_key(self.options, 'menu')
        call s:debugmsg('run_menu()')
        let self.options.escape = 1
        return self.run_menu(self.options.menu)
    else
        call s:debugmsg('run_other()')
        return self.run_other()
    endif
endfunc
" }}}
" s:Prompt.run_menu {{{
func! s:Prompt.run_menu(list) dict
    " Make displaying list.
    let choice = {}
    if type(a:list) == type({})
        let i = 0
        for key in keys(a:list)
            let id = self.options.menuidfunc(i, key) . ""
            let choice[id] = {'show_value': key, 'dict_value': a:list[key]}
            let i += 1
        endfor
    elseif type(a:list) == type([])
        for idx in range(0, len(a:list) - 1)
            let id = self.options.menuidfunc(idx, '') . ""
            let choice[id] = {'show_value': a:list[idx]}
        endfor
    else
        throw "internal_error: "
        \    ."'menu' allows only List or Dictionary."
    endif
    call s:debugmsg('choice = '.string(choice))

    " Show candidates.
    echo self.msg
    for k in self.sort_menu_ids(keys(choice))
        echon printf("\n%s. %s", k, choice[k].show_value)
    endfor

    while 1
        echon "\n"
        let input = self.get_input(g:prompt_prompt)
        call s:debugmsg('input = '.input)

        if has_key(choice, input)
            let value = get(choice[input], 'dict_value', choice[input].show_value)
            if s:is_dict(value) || s:is_list(value)
                return self.run_menu(value)
            else
                " Return result.
                return value
            endif
        else
            call s:bad_choice('bad choice.')
            continue
        endif
    endwhile
endfunc
" }}}
" s:Prompt.run_yesno {{{
func! s:Prompt.run_yesno(yn_type) dict
    while 1
        let input = self.get_input(self.msg)
        call s:debugmsg(input)

        if input =~# self.YESNO_PAT[a:yn_type]
            return input
        else
            call s:bad_choice(self.YESNO_ERR_MSG[a:yn_type])
        endif
    endwhile
endfunc
" }}}
" s:Prompt.run_other {{{
func! s:Prompt.run_other() dict
    " NOTE:
    " s:Prompt.run_other() has some different points
    " with other methods like 's:Prompt.run_*()'.
    "
    " - Replace input with self.options.default
    "   if input is empty string.
    " - Check input. (self.check_input(input))
    let args =
    \   has_key(self.options, 'default') ?
    \       [self.msg, self.options.default]
    \       : [self.msg]

    while 1
        let input = call(self.get_input, args, self)
        if self.check_input(input)
            return input
        endif
    endwhile
endfunc
" }}}

" s:Prompt.get_input {{{
func! s:Prompt.get_input(prompt, ...) dict
    let input = ''
    let has_default = a:0 !=# 0

    let opt_escape =
    \   get(self.options, 'escape', 0)
    \   && self.options.escape
    let opt_onechar =
    \   get(self.options, 'onechar', 0)
    \   && self.options.onechar

    " TODO Global variable to decide
    " if Vim echoes option 'default' value.
    if has_default
        if a:prompt =~# ':$'
            let pr = printf('%s [%s]:',
            \     strpart(a:prompt, 0, strlen(a:prompt) - 1),
            \     a:1)
        else
            let pr = printf('%s [%s]',
            \     a:prompt,
            \     a:1)
        endif
    else
        let pr = a:prompt
    endif
    echon pr

    while 1
        let c = getchar()
        let c = type(c) == type(0) ? nr2char(c) : c

        if opt_escape && c ==# "\<Esc>"
            throw 'pressed_esc_with:'.input
        elseif c ==# "\<CR>"
            echon get(self.options, 'newline', "\n")

            if input == '' && has_default
                let input = a:1
            elseif get(self.options, 'line', 0)
                " NOTE: 'line' is exclusive. (elseif)
                let input .= "\n"
            endif

            if opt_onechar
                " NOTE: Return one character anyway if opt_onechar.
                let input = strpart(input, 0, 1)
            endif
            return input
        elseif c == "\<BS>"
            " Dispose "\<BS>" and one char.
            let input = strpart(input, 0, strlen(input) - 1)

            if has_key(self.options, 'echo')
                let sp  = repeat(' ', strlen(self.options.echo))
                let msg = repeat(self.options.echo, strlen(input))
            else
                let sp  = ' '
                let msg = input
            endif

            " Clear rest of input.
            " (Overwrite deleted one character with spaces)
            echon sp . "\<CR>"
            " Overwrite current input.
            echon pr . msg

            continue
        " elseif c == "\<C-d>" && input == ''
        "     " TODO Global variable to allow <C-d>
        "     " return empty string or "\<C-d>".
        "     return ''
        endif
        if opt_onechar
            return c
        endif

        if has_key(self.options, 'echo')
            echon self.options.echo
        else
            echon c
        endif

        let input .= c
    endwhile

    throw 'internal_error: this block will never be reached'
endfunc
" }}}
" s:Prompt.check_input {{{
func! s:Prompt.check_input(input)
    if get(self.options, 'integer', 0)
        return s:is_int(a:input)
    elseif get(self.options, 'number', 0)
        return s:is_num(a:input)
    elseif has_key(self.options, 'while')
        return a:input !~# self.options.while
    elseif has_key(self.options, 'until')
        return a:input =~# self.options.until
    else
        return 1
    endif
endfunc
" }}}
" s:Prompt.sort_menu_ids {{{
func! s:Prompt.sort_menu_ids(keys) dict
    let keys = a:keys
    if get(self.options, 'sortmenu', 0)
        call sort(keys, self.options.sortby)
    endif
    return keys
endfunc
" }}}

" s:Prompt.add_default_options {{{
func! s:Prompt.add_default_options() dict
    return extend(self.options, self.opt_info.expand(
    \   {
    \      'speed': '0.075',
    \      'menualpha': 1,
    \      'menutype': 'cmdline',
    \      'sortby': function('<SID>sortfn_string'),
    \   },
    \   'force'),
    \'keep')
endfunc
" }}}
" s:Prompt.validate_options {{{
func! s:Prompt.validate_options() dict
    for k in keys(self.options)
        call s:debugmsgf("k = %s, v = %s", string(k), string(self.options[k]))

        if !self.opt_info.exists(k)
            throw 'unknown_option:'.k
        else
            let got = self.opt_info.get(k)
            if has_key(got, 'expand_to') && !has_key(got, 'remain_myself')
                throw 'all_options_must_be_expanded:'.k
            endif
        endif
        if !self.__validate(self.opt_info.get(k).arg_type, self.options[k])
            throw printf('invalid_type:{%s:%s}', string(k), string(self.options[k]))
        endif
    endfor
endfunc
" }}}
" s:Prompt.__validate {{{
func! s:Prompt.__validate(opt_name, opt_val) dict
    if s:is_str(a:opt_name)
        if stridx(a:opt_name, 'custom:') == 0
            let fn_str = substitute(a:opt_name, '^custom:', '', '')
            return eval(fn_str)(a:opt_val)
        else
            return self.validate_fn[a:opt_name](a:opt_val)
        endif
    elseif s:is_list(a:opt_name)
        if len(a:opt_name) == 1
            return self.__validate(a:opt_name[0], a:opt_val)
        else
            return self.__validate(a:opt_name[0], a:opt_val)
            \   || self.__validate(a:opt_name[1:], a:opt_val)
        endif
    else
        throw 'internal_error'
    endif
endfunc
" }}}
" }}}


" Autoload functions.
" prompt#gen_seq_str {{{
"   len(a:seq) must NOT be 0, maybe.
func! prompt#gen_seq_str(seq, idx)
    let div  = (a:idx + 1) / len(a:seq)
    let quot = (a:idx + 1) % len(a:seq)
    if div < 1 || (div == 1 && quot == 0)
        if quot == 0
            " NOTE: "abc"[-1] is ''. [1,2,3][-1] is 3, though...
            let quot = len(a:seq)
        endif
        return a:seq[quot - 1]
    else
        return a:seq[quot - 1] . prompt#gen_seq_str(a:seq, div - 1)
    endif
endfunc
" }}}
" prompt#prompt {{{
func! prompt#prompt(msg, ...)
    if a:0 == 0
        let options = {}
    elseif a:0 == 1 && type(a:1) == type({})
        let options = a:1
    else
        throw "prompt#prompt() can take message to display and optional options."
    endif

    call s:Prompt.set_msg(a:msg)
    call s:Prompt.set_options(options)
    return s:Prompt.run()
endfunc
" }}}
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
