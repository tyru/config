"{{{1 Начало
"{{{2
scriptencoding utf-8
if (exists("s:g.pluginloaded") && s:g.pluginloaded) ||
            \exists("g:loadOptions.DoNotLoad")
    finish
endif
"{{{2 Объявление переменных
"{{{3 Словари с функциями
" Функции для внутреннего использования
let s:F={
            \"plug": {},
            \"cons": {},
            \"stuf": {},
            \"main": {},
            \ "mng": {},
            \ "reg": {},
            \"comm": {},
            \"comp": {},
        \}
lockvar 1 s:F
"{{{3 Глобальная переменная
let s:g={}
let s:g.chk={}
let s:g.load={}
let s:g.pluginloaded=1
let s:g.load.scriptfile=expand("<sfile>")
let s:g.srccmd="source ".(s:g.load.scriptfile)
"{{{4 sid
function s:SID()
    return matchstr(expand('<sfile>'), '\d\+\ze_SID$')
endfun
let s:g.scriptid=s:SID()
delfunction s:SID
"{{{4 Настройки по умолчанию
let s:g.defaultOptions={
            \ "CmdPrefix": "Load",
            \"FuncPrefix": "Load",
        \}
lockvar! s:g.defaultOptions
"{{{3 Команды и функции
" Определяет команды. Для значений ключей словаря см. :h :command. Если 
" некоторому ключу «key» соответствует непустая строка «str», то в аргументы 
" :command передаётся -key=str, иначе передаётся -key. Помимо ключей 
" :command, в качестве ключа словаря также используется строка «func». Ключ 
" «func» является обязательным и содержит функцию, которая будет вызвана при 
" запуске команды (без префикса s:F.).
let s:g.load.commands={
            \"Command": {
            \      "nargs": '+',
            \       "func": "mng.main",
            \   "complete": "customlist,s:_complete",
            \},
        \}
" Список видимых извне функции
let s:g.load.functions=[["Funcdict", "comm.rdict", {}]]
"{{{2 Выводимые сообщения
let s:g.p={
            \"emsg": {
            \    "uact": "Unknown action",
            \     "str": "Value must be of a type “string”",
            \   "fpref": "Function prefix must start either with g: or with a ".
            \            "capital latin letter and contain latin letters and ".
            \            "numbers",
            \   "cpref": "Command prefix must start with a capital latin ".
            \            "letter and contain latin letters and numbers",
            \    "preg": "Plugin already registered",
            \   "nplug": "No such plugin",
            \    "nvar": "No such variable",
            \   "nfunc": "No such function",
            \    "iarg": "Invalid argument",
            \    "iopt": "Invalid option",
            \    "uopt": "Unknown option",
            \   "cexst": "Command “%s” already exists",
            \   "fexst": "Function “%s” already exists",
            \},
            \"etype": {
            \    "value": "InvalidValue",
            \   "syntax": "SyntaxError",
            \   "option": "InvalidOption",
            \     "perm": "PermissionDenied",
            \     "nfnd": "NotFound",
            \},
            \"th": ["SID", "Name", "File", "Status"],
            \"nfnd": "Not found",
        \}
lockvar! s:g.p
"{{{1 Функции
"{{{2 cons: eerror, option
"{{{3 cons.eerror
function s:F.cons.eerror(plugin, from, type, ...)
    let etype=((type(a:type)==type("") &&
                \   exists("a:plugin.g.p.etype") &&
                \   type(a:plugin.g.p.etype)==type({}) &&
                \   has_key(a:plugin.g.p.etype, a:type))?
                \(a:plugin.g.p.etype[a:type]):
                \(s:F.stuf.string(a:type)))
    let emsg=((exists("a:plugin.g.p.emsg") &&
                \   type(a:plugin.g.p.emsg)==type({}))?
                \(a:plugin.g.p.emsg):
                \({}))
    let dothrow=0
    let outmsgs=[]
    let args=a:000
    if len(args) && type(args[0])==type(0)
        let dothrow=!!args[0]
        let args=args[1:]
    endif
    for e in args
        if type(e)==type([])
            if e!=[] && type(e[0])==type("") && has_key(emsg, e[0])
                if len(e)>1
                    call add(outmsgs, call("printf",
                                \[s:F.stuf.string(emsg[e[0]])]+e[1:]))
                else
                    call add(outmsgs, emsg[e[0]])
                endif
            else
                call add(outmsgs, s:F.stuf.string(e))
            endif
        elseif type(e)==type("")
            call add(outmsgs, e)
        else
            call add(outmsgs, s:F.stuf.string(e))
        endif
        unlet e
    endfor
    let comm="(".join(outmsgs, ': ').")"
    let msg=(a:plugin.name)."/".s:F.stuf.string(a:from).":".(etype).(comm)
    echohl Error
    echo msg
    echohl None
    if dothrow
        throw msg
    endif
    return 0
endfunction
"{{{3 cons.option
function s:F.cons.option(plugin, option)
    let selfname="cons.option"
    "{{{4 Объявление переменных
    if type(a:option)!=type("")
        return s:F.cons.eerror(a:plugin, selfname, "value", 1, s:g.p.emsg.str,
                    \s:F.stuf.string(a:option))
    endif
    let oname=(a:plugin.optionprefix)."Options"
    let defaults=((exists("a:plugin.g.defaultOptions") &&
                \   type(a:plugin.g.defaultOptions)==type({}))?
                \(a:plugin.g.defaultOptions):
                \({}))
    let chk=((exists("a:plugin.c.options") &&
                \   type(a:plugin.c.options)==type({}) &&
                \   has_key(a:plugin.c.options, a:option))?
                \(a:plugin.c.options[a:option]):
                \(0))
    "{{{4 Получить настройку
    if exists("b:".oname) && has_key(eval("b:".oname), a:option)
        let src='b'
        let retopt=eval("b:".oname)[a:option]
    elseif exists("g:".oname) && has_key(eval("g:".oname), a:option)
        let src='g'
        let retopt=eval("g:".oname)[a:option]
    else
        if has_key(defaults, a:option)
            return defaults[a:option]
        else
            return s:F.cons.eerror(a:plugin, selfname, "value", 1, ["uopt"],
                        \a:option)
        endif
    endif
    "{{{4 Проверить правильность
    let optstr=a:option."/".src
    if type(chk)!=type(0) && !s:F.plug.chk.checkargument(chk, retopt)
        return s:F.cons.eerror(a:plugin, selfname, "value", 1, ["iopt"], optstr)
    endif
    "}}}4
    return retopt
endfunction
"{{{2 stuf: findnr, findpath, eeerror, printtable, fdictstr, string
"{{{3 stuf.string
function s:F.stuf.string(obj)
    if type(a:obj)==type("")
        return a:obj
    endif
    try
        let r=string(a:obj)
    catch
        redir => r
        silent echo a:obj
        redir END
        let r=r[1:]
    endtry
    return r
endfunction
"{{{3 stuf.findf: Найти функцию по номеру
function s:F.stuf.findf(nr, pos, d, depth)
    if a:depth > &maxfuncdepth-10
        return 0
    endif
    if type(a:d)==2 && string(a:d)=~#"'".a:nr."'"
        return a:pos
    elseif type(a:d)==type({})
        for [key, Value] in items(a:d)
            let pos=s:F.stuf.findf(a:nr, a:pos."/".key, Value, a:depth+1)
            unlet Value
            if type(pos)==type("")
                return pos
            endif
        endfor
    endif
    return 0
endfunction
"{{{3 stuf.findr: Найти функцию по номеру
function s:F.stuf.findnr(nr)
    for [key, value] in items(s:g.reg.registered)
        let pos=s:F.stuf.findf(a:nr, "/".key, value.F, 0)
        if type(pos)==type("")
            return pos
        endif
    endfor
    if has_key(s:g.reg.unnamedfunctions, a:nr)
        return s:g.reg.unnamedfunctions[a:nr]
    endif
    return 0
endfunction
"{{{3 stuf.findpath: Найти номер функции
function s:F.stuf.findpath(path)
    let selfname="stuf.findpath"
    let s=split(a:path, '/')
    if !len(s)
        return 0
    endif
    let [plugname; path]=s
    if !has_key(s:g.reg.registered, plugname)
        return s:F.main.eerror(selfname, "nfnd", ["nplug"], plugname)
    endif
    let Fdict=s:g.reg.registered[plugname].F
    for component in path
        if type(Fdict)!=type({}) || !has_key(Fdict, component)
            return 0
        endif
        let Tmp=Fdict[component]
        unlet Fdict
        let Fdict=Tmp
        unlet Tmp
    endfor
    return Fdict
endfunction
"{{{3 stuf.strlen: получение длины строки
function s:F.stuf.strlen(stuf)
    return len(split(a:stuf, '\zs'))
endfunction
"{{{3 stuf.printl: printf{'%-*s', ...}
" Напечатать {stuf}, шириной {len}, выровненное по левому краю, оставшееся 
" пространство заполнив пробелами (вместо printf('%-*s', len, stuf)).
function s:F.stuf.printl(len, stuf)
    return a:stuf . repeat(" ", a:len-s:F.stuf.strlen(a:stuf))
endfunction
"{{{3 stuf.printtline: печать строки таблицы
" Напечатать одну линию таблицы
"   {line} — список строк таблицы,
" {lenlst} — список длин
function s:F.stuf.printtline(line, lenlst)
    let result=""
    let i=0
    while i<len(a:line)
        let result.=s:F.stuf.printl(a:lenlst[i], a:line[i])
        let i+=1
        if i<len(a:line)
            let result.="  "
        endif
    endwhile
    return result
endfunction
"{{{3 stuf.printtable: напечатать таблицу
" Напечатать таблицу с заголовками рядов {headers} и линиями {lines}.
" {headers}: список строк
"   {lines}: список списков строк
function s:F.stuf.printtable(header, lines)
    let lineswh=a:lines+[a:header]
    let columns=max(map(copy(lineswh), 'len(v:val)'))
    let lenlst=[]
    let i=0
    while i<columns
        call add(lenlst, max(map(copy(lineswh),
                    \'(i<len(v:val))?s:F.stuf.strlen(v:val[i]):0')))
        let i+=1
    endwhile
    if a:header!=[]
        echohl PreProc
        echo s:F.stuf.printtline(a:header, lenlst)
        echohl None
    endif
    echo join(map(copy(a:lines), 's:F.stuf.printtline(v:val, lenlst)'), "\n")
    return 1
endfunction
"{{{3 stuf.fdictstr
function s:F.stuf.fdictstr(dict, indent)
    if a:indent > &maxfuncdepth-10
        return []
    endif
    let result=[]
    for [key, Value] in items(a:dict)
        if type(Value)==type({})
            let list=s:F.stuf.fdictstr(Value, a:indent+1)
            if list!=[]
                let result+=[[a:indent, key, ""]]+list
            endif
        elseif type(Value)==2
            call add(result, [a:indent, key, Value])
        endif
        unlet Value
    endfor
    return result
endfunction
"{{{2 main: eerror, destruct
"{{{3 main.destruct: Выгрузить дополнение
function s:F.main.destruct()
    unlet s:F
    unlet s:g
    return 1
endfunction
"{{{2 reg: register, unreg
"{{{3 s:g.reg
let s:g.reg={}
let s:g.reg.lazyload={}
let s:g.reg.registered={}
let s:g.reg.plugsids={}
let s:g.reg.unnamedfunctions={}
let s:g.reg.mapdict={}
lockvar 1 s:g.reg
"{{{3 reg.getprefix: Получить префикс
function s:F.reg.getprefix(oprefix, type, default)
    "{{{4 Объявление переменных
    let selfname="reg.getprefix"
    let ovar="g:".a:oprefix."Options"
    let oprefvar=ovar.".".a:type."Prefix"
    "{{{4 Попытка получения префикса из настройки
    if exists(oprefvar)
        let pref=eval(oprefvar)
        if pref!=type("")
            call s:F.main.eerror(selfname, "option", 1, ["str"])
        else
            if type==#"Cmd" && pref!~#s:g.chk.reg.cmd
                call s:F.main.eerror(selfname, "option", 1, ["fpref"])
            elseif type==#"Func" && pref!~#s:g.chk.reg.func
                call s:F.main.eerror(selfname, "option", 1, ["cpref"])
            else
                return pref
            endif
        endif
    endif
    "}}}4
    return a:default
endfunction
"{{{3 reg.register:  Зарегистрировать плагин
"{{{4 s:g.reg.mapdict
call extend(s:g.reg.mapdict, {
            \     "commands": ["commands", 'a:regdict.commands'],
            \      "cprefix": ["commandprefix",
            \                  's:F.reg.getprefix(a:regdict.oprefix, "Cmd", '.
            \                                    'a:regdict.cprefix)'],
            \      "fprefix": ["functionprefix",
            \                  's:F.reg.getprefix(a:regdict.oprefix, "Func", '.
            \                                    'a:regdict.fprefix)'],
            \    "functions": ["functions", 'a:regdict.functions'],
            \"dictfunctions": ["dictfunctions", 'a:regdict.dictfunctions'],
        \})
lockvar! s:g.reg.mapdict
"}}}4
function s:F.reg.register(regdict)
    let selfname="reg.register"
    "{{{4 Проверка аргументов
    let plugname=fnamemodify(a:regdict.scriptfile, ":t:r")
    if has_key(a:regdict, "plugname")
        let plugname=a:regdict.plugname
    endif
    "{{{5 Если проверяющее дополнение не загружено
    if !has_key(s:g.reg.registered, "chk") && plugname!=#"load"
        runtime plugin/chk.vim
    endif
    "}}}5
    if plugname!=#"chk" && plugname!="load"
        if !has_key(s:F.plug, "chk")
            let s:F.plug.chk=s:F.comm.getfunctions("chk")
        endif
        if !s:F.plug.chk.checkargument(s:g.chk.register, a:regdict)
            return s:F.main.eerror(selfname, "value", 1, ["iarg"])
        endif
    endif
    if has_key(s:g.reg.registered, plugname)
        return s:F.main.eerror(selfname, "perm", ["preg"], plugname)
    endif
    "{{{4 Построение записи
    let entry={
                \        "status": ((has_key(a:regdict, "oneload") &&
                \                    a:regdict.oneload)?
                \                           ("loaded"):
                \                           ("registered")),
                \             "F": a:regdict.funcdict,
                \             "g": a:regdict.globdict,
                \      "scriptid": a:regdict.sid,
                \          "file": a:regdict.scriptfile,
                \  "extfunctions": [],
                \   "extcommands": [],
                \  "optionprefix": a:regdict.oprefix,
                \          "name": plugname,
                \    "quotedname": "'".substitute(plugname, "'", "''", "g")."'",
                \    "apiversion": map(split(matchstr(a:regdict.apiversion,
                \                                     '^\d\+\.\d\+'), '\.'),
                \                      'v:val+0'),
            \}
    for [regdictkey, value] in items(s:g.reg.mapdict)
        if has_key(a:regdict, regdictkey)
            let [entrykey, expression]=value
            let entry[entrykey]=eval(expression)
        endif
    endfor
    let entry.intfuncprefix='s:g.reg.registered['.entry.quotedname.'].F'
    let locks={}
    call map(["F", "g"], 'extend(locks, {(v:val): islocked("entry.".v:val)})')
    lockvar entry
    for v in ["status", "extfunctions", "extcommands", "g", "F"]
        if !(has_key(locks, v) && locks[v])
            unlockvar entry[v]
        endif
    endfor
    let s:g.reg.registered[plugname]=entry
    let s:g.reg.plugsids[plugname]=a:regdict.sid
    "{{{4 Создание функций
    let F={}
    for fname in keys(s:F.cons)
        execute      "function F.".fname."(...)\n".
                    \"    return call(s:F.cons.".fname.", ".
                    \"             [s:g.reg.registered[".entry.quotedname."]]+".
                    \"             a:000, {})\n".
                    \"endfunction"
        let fnr=matchstr(string(F[fname]), '\d\+')
        let s:g.reg.unnamedfunctions[fnr]="cons:/".plugname."/".fname
    endfor
    "}}}4
    call s:F.comm.cf(entry)
    return      {     "name": plugname,
                \"functions": F}
endfunction
"{{{4 Проверки аргументов
let s:g.chk.reg={}
let s:g.chk.reg.func='^g:[[:alnum:]_]\+\|\u[[:alnum:]_]*$'
let s:g.chk.reg.cmd='^\u[[:alnum:]_]*$'
let s:g.chk.reg.tf='^[[:alnum:]_]\+$'
let s:g.chk.reg.rf='^\([[:alnum:]_]\+.\)*[[:alnum:]_]\+$'
lockvar! s:g.chk.reg
"{{{5 Проверка для command
let s:g.chk.comdict=[[["equal", "nargs" ],   ["or", [["in", ['*',
            \                                                '?',
            \                                                '+',
            \                                                '0']],
            \                                        ["regex",
            \                                          '^[1-9][0-9]*$']]]],
            \        [["equal", "range" ],   ["or", [["in", ['', '%']],
            \                                        ["regex",
            \                                          '^[1-9][0-9]*$']]]],
            \        [["equal", "count" ],   ["regex",
            \                                      '^\([1-9][0-9]*\)\=$']],
            \        [["equal", "bang"  ],   ["equal", ""]],
            \        [["equal", "reg"   ],   ["equal", ""]],
            \        [["equal", "bar"   ],   ["equal", ""]],
            \        [["equal", "complete"], ["or", [["in", ["augroup",
            \                                                "buffer",
            \                                                "command",
            \                                                "dir",
            \                                                "enviroment",
            \                                                "event",
            \                                                "expression",
            \                                                "file",
            \                                                "shellcmd",
            \                                                "function",
            \                                                "help",
            \                                                "highlight",
            \                                                "mapping",
            \                                                "menu",
            \                                                "option",
            \                                                "tag",
            \                                                "tag_listfiles",
            \                                                "var"]],
            \                                        ["regex",
            \                                 '^custom\(list\)\=,s:.*']]]],
            \        [["equal", "func"], ["regex", s:g.chk.reg.rf]]]
"{{{5 s:g.chk.register
let s:g.chk.register=["and", [
            \["map", ["hkey", ["oprefix",
            \                  "funcdict",
            \                  "globdict",
            \                  "sid",
            \                  "scriptfile",
            \                  "apiversion",]]],
            \["allorno", [["hkey", "fprefix"],
            \             ["hkey", "functions"]]],
            \["allorno", [["hkey", "cprefix"],
            \             ["hkey", "commands"]]],
            \["dict", [
            \   [["equal", "dictfunctions"],
            \             ["alllst", ["chklst", [["type", type("")],
            \                                    ["regex", s:g.chk.reg.rf],
            \                                    ["type",  type({})]]]]],
            \   [["equal", "fprefix"],  ["regex", s:g.chk.reg.func]],
            \   [["equal", "cprefix"],  ["regex", s:g.chk.reg.cmd]],
            \   [["equal", "oprefix"],  ["regex", s:g.chk.reg.tf]],
            \   [["equal", "funcdict"], [ "type", type({})]],
            \   [["equal", "globdict"], [ "type", type({})]],
            \   [["equal", "commands"], [ "dict", [[["type", type("")],
            \                                       ["dict", s:g.chk.comdict]]]]
            \   ],
            \   [["equal", "functions"],["alllst", ["chklst", [
            \                                         ["regex", s:g.chk.reg.tf],
            \                                         ["regex", s:g.chk.reg.rf],
            \                                         ["type",  type({})]]]]],
            \   [["equal", "oneload"],  ["bool", ""]],
            \   [["equal", "plugname"], ["type", type("")]],
            \   [["equal", "sid"],      ["regex", '^[1-9][0-9]*$']],
            \   [["equal", "scriptfile"], ["and", [["file", "r"],
            \                                      ["regex", '\.vim$']]]],
            \   [["equal", "apiversion"], ["regex", '^\d\+\.\d\+']],
            \   [["equal", "requires"],   ["alllst", ["dict", [[["any", ""],
            \                                                   ["regex",
            \                                                    '^\d\+']]]]]],
            \ ]
            \],
        \]]
"{{{3 reg.unreg:     Удалить команды и функции
function s:F.reg.unreg(plugname)
    let plugdict=s:g.reg.registered[a:plugname]
    for F in plugdict.extfunctions
        execute "delfunction ".F
    endfor
    for C in plugdict.extcommands
        execute "delcommand ".C
    endfor
    unlet s:g.reg.registered[a:plugname]
    unlet plugdict
endfunction
"{{{2 comm: load, cf, getfunctions, lazyload, unload
"{{{3 s:g.comm
let s:g.comm={}
"{{{3 comm.cmdadd:       Создать команду
function s:F.comm.cmdadd(key, value, cmdargs, plugdict, command)
    "{{{4 Объявление переменных
    let result='-'.a:key
    let append=""
    "{{{4 Автодополнение
    if a:key==#"complete" && a:value=~'^custom'
        "{{{5 Объявление переменных
        let plugname=a:plugdict.quotedname
        " -complete=custom,func или -complete=customlist,func
        let funcname=matchstr(a:value, 'custom\(list\)\=,\zss:.*')
        " удаляем s:
        let intfunc=funcname[2:]
        let quotedintfunc="'".substitute(intfunc, "'", "''", "g")."'"
        " имя функции внутри дополнения (s:F.comp.funcname)
        let intfuncname=(a:plugdict.intfuncprefix).'.comp['.quotedintfunc.']'
        " чтобы функции к разным командам не пересекались добавим имя команды 
        " к имени функции
        let realname=funcname.(a:command)
        let append=a:command
        " шаблон для автокоманды
        let fpattern="*P".(s:g.scriptid)."_".realname[2:]
        "{{{5 Если дополнение загружено
        if a:plugdict.status==#"loaded"
            "{{{6 Создание функции
            if !exists("*".realname)
                execute      "function ".realname."(...)\n".
                            \"    silent! return call(".intfuncname.", ".
                            \                        "a:000, {})\n".
                            \"endfunction"
            endif
            "{{{6 Удаление автокоманды
            augroup LoadBeforeLoadComp
                execute "autocmd! FuncUndefined ".fpattern
            augroup END
        "{{{5 Если нет
        else
            augroup LoadBeforeLoadComp
                execute "autocmd! FuncUndefined ".fpattern
                execute "autocmd FuncUndefined ".fpattern." ".
                            \"call s:F.comm.load(".plugname.")"
            augroup END
        endif
        "}}}5
    endif
    "}}}4
    if a:value!=""
        let result.='='.a:value.append
    endif
    call add(a:cmdargs, result)
    return result
endfunction
"{{{3 comm.mkcmd:        Создать команду
function s:F.comm.mkcmd(cmd, plugdict)
    let selfname="comm.mkcmd"
    "{{{4 Объявление переменных
    let cmdargs=[]
    let fargs=[]
    let plugname=a:plugdict.quotedname
    let intfuncprefix=a:plugdict.intfuncprefix
    let cmddescr=a:plugdict.commands[a:cmd]
    let cmd=(a:plugdict.commandprefix).a:cmd
    let loadcmd="call s:F.comm.load(".plugname.")"
    "{{{4 Получение ключей для :command
    for key in keys(cmddescr)
        if has_key(s:g.comm.cmdfargs, key)
            call s:F.comm.cmdadd(key, cmddescr[key], cmdargs, a:plugdict, cmd)
            if s:g.comm.cmdfargs[key]!=""
                call add(fargs, s:g.comm.cmdfargs[key])
            endif
        endif
    endfor
    "{{{4 Удаление старой команды
    if exists(':'.cmd)
        if index(a:plugdict.extcommands, cmd)!=-1
            execute "delcommand ".cmd
        else
            return s:F.main.eerror(selfname, "perm", ["cexst", cmd])
        endif
    endif
    "{{{4 Создание команды
    execute "command ".join(cmdargs, " ")." ".cmd." ".
                \((a:plugdict.status==#"loaded")?(""):(loadcmd." | ")).
                \"call ".(intfuncprefix.".".(cmddescr.func)).
                \"(".join(sort(fargs), ", ").")"
    "{{{4 Регистрация команды
    if a:plugdict.status==#"registered"
        call add(a:plugdict.extcommands, cmd)
    endif
    return 1
    "}}}4
endfunction
"{{{4 Аргументы для command
" Порядок аргументов будет (благодаря сортировке по алфавиту):
"   "'<bang>'", "'<reg>'", "<LINE1>, <LINE2>", "<count>", "<f-args>"
let s:g.comm.cmdfargs={
            \   "nargs": "<f-args>",
            \   "range": "<LINE1>, <LINE2>",
            \   "count": "<count>",
            \    "bang": "'<bang>'",
            \     "reg": "'<reg>'",
            \  "buffer": "",
            \"complete": ""
        \}
lockvar! s:g.comm.cmdfargs
"{{{3 comm.getcheck:     Создать строку проверки для аргументов функции
function s:F.comm.getcheck(check, checkstr)
    if len(keys(a:check))
        return "let args=s:F.plug.chk.checkarguments(".a:checkstr.", a:000)\n".
                    \"if type(args)!=type([])\n".
                    \"throw 'checkFailed'\n".
                    \"endif\n"
    endif
    return "let args=a:000\n"
endfunction
"{{{3 comm.mkfuncs
" Создать функции или события FuncUndefined. Событие создаётся, если 
" plugdict.status!="loaded"
function s:F.comm.mkfuncs(plugdict)
    let selfname='comm.mkfuncs'
    if !has_key(a:plugdict, "functions")
        return 0
    endif
    let plugname=a:plugdict.quotedname
    let loadcmd="call s:F.comm.load(".plugname.")"
    let i=0
    for [extname, intname, acheck] in a:plugdict.functions
        let intfuncprefix=a:plugdict.intfuncprefix
        let extname=(a:plugdict.functionprefix).extname
        if exists('*'.extname)
            call s:F.main.eerror(selfname, "perm", ["fexst", extname])
            continue
        endif
        let checkstr='s:g.reg.registered['.plugname.'].functions['.i.'][2]'
        let check=s:F.comm.getcheck(acheck, checkstr)
        if a:plugdict.status==#"loaded"
            execute      "function ".extname."(...)\n".
                        \     (check).
                        \"    return call(".intfuncprefix.".".intname.", ".
                        \           "args, s:F)\n"
                        \"endfunction"
            call add(a:plugdict.extfunctions, extname)
        else
            augroup LoadBeforeLoad
                execute "autocmd! FuncUndefined ".extname
                execute "autocmd FuncUndefined ".extname." ".loadcmd
            augroup END
        endif
        let i+=1
    endfor
    return 1
endfunction
"{{{3 comm.load:         Загрузить плагин
function s:F.comm.load(plugname)
    let plugdict=s:F.comm.getpldict(a:plugname)
    let plugdict.status="loaded"
    execute "source ".(plugdict.file)
    call s:F.comm.cf(plugdict)
    "{{{4 Ленивая загрузка
    if has_key(s:g.reg.lazyload, a:plugname)
        while len(s:g.reg.lazyload[a:plugname])
            call extend(s:g.reg.lazyload[a:plugname][-1],
                        \s:F.comm.cdict(plugdict))
            unlet s:g.reg.lazyload[a:plugname][-1]
        endwhile
    endif
    "}}}4
    return 1
endfunction
"{{{3 comm.cdict:        Создать словарь с функциями
function s:F.comm.cdict(plugdict)
    if !has_key(a:plugdict, "dictfunctions")
        return {}
    endif
    let plugname=a:plugdict.quotedname
    let intfuncprefix=a:plugdict.intfuncprefix
    let r={}
    let i=0
    for [dictname, intname, acheck] in a:plugdict.dictfunctions
        let checkstr='s:g.reg.registered['.plugname.'].dictfunctions['.i.'][2]'
        let check=s:F.comm.getcheck(acheck, checkstr)
        execute      "function r.".dictname."(...)\n".
                    \(check).
                    \"    return call(".intfuncprefix.".".intname.", ".
                    \                 "args, {})\n".
                    \"endfunction"
        let fnr=matchstr(string(r[dictname]), '\d\+')
        let s:g.reg.unnamedfunctions[fnr]="dict:/".(a:plugdict.name)."/".
                    \dictname." -> /".(a:plugdict.name)."/".
                    \tr(intname, '.', '/')
        let i+=1
    endfor
    return r
endfunction
"{{{3 comm.cf:           Создать команды и функции
function s:F.comm.cf(plugdict)
    if has_key(a:plugdict, "commands")
        call map(keys(a:plugdict.commands), 's:F.comm.mkcmd(v:val, a:plugdict)')
    endif
    call s:F.comm.mkfuncs(a:plugdict)
endfunction
"{{{3 comm.getpldict:    Получить словарь, связанный с плагином
function s:F.comm.getpldict(plugname, ...)
    let selfname="comm.getpldict"
    if !has_key(s:g.reg.registered, a:plugname)
        execute "runtime plugin/".a:plugname.".vim"
    endif
    if !has_key(s:g.reg.registered, a:plugname)
        return s:F.main.eerror(selfname, "value", !len(a:000), ["nplug"],
                    \a:plugname)
    endif
    return s:g.reg.registered[a:plugname]
endfunction
"{{{3 comm.getfunctions: Получить функции плагина
function s:F.comm.getfunctions(plugname)
    let selfname="comm.getfunctions"
    let plugdict=s:F.comm.getpldict(a:plugname)
    if plugdict.status!=#"loaded"
        call s:F.comm.load(a:plugname)
    endif
    return s:F.comm.cdict(plugdict)
endfunction
"{{{3 comm.lazyload:
function s:F.comm.lazyload(plugname)
    let selfname="comm.lazyload"
    if !has_key(s:g.reg.registered, a:plugname) ||
                \s:g.reg.registered[a:plugname].status!=#"loaded"
        if !has_key(s:g.reg.lazyload, a:plugname)
            let s:g.reg.lazyload[a:plugname]=[]
        endif
        let result={}
        call add(s:g.reg.lazyload[a:plugname], result)
        return result
    else
        return s:F.comm.cdict(s:g.reg.registered[a:plugname])
    endif
endfunction
"{{{3 comm.rdict:        Вернуть словарь с функциями данного плагина
function s:F.comm.rdict()
    return s:F.comm.cdict(s:g.reg.registered.load)
endfunction
let s:g.chk.tstr={
            \"model": "simple",
            \"required": [["type", type("")]]
        \}
lockvar! s:g.chk.tstr
let s:g.comm.f=[
            \["registerplugin",   "reg.register", {}],
            \["unregister",       "reg.unreg",
            \                   {"model": "simple",
            \                    "required": [["keyof", s:g.reg.registered]]}],
            \["getfunctions",     "comm.getfunctions", s:g.chk.tstr],
            \["lazygetfunctions", "comm.lazyload", s:g.chk.tstr],
        \]
lockvar! s:g.comm
unlockvar! s:g.reg.registered
"{{{3 comm.unload:       Удалить плагин
function s:F.comm.unload(plugname)
    let plugdict=s:g.reg.registered[a:plugname]
    let srccmd="source ".(plugdict.file)
    if has_key(plugdict.F, "main") && has_key(plugdict.F.main, "destruct")
        call plugdict.F.main.destruct()
    endif
    unlockvar plugdict.g
    unlockvar plugdict.F
    for key in keys(plugdict.g)
        unlet plugdict.g[key]
    endfor
    for key in keys(plugdict.F)
        unlet plugdict.F[key]
    endfor
    unlet plugdict.g
    unlet plugdict.F
    call s:F.reg.unreg(a:plugname)
    return srccmd
endfunction
"{{{2 mng: main
"{{{3 mng.main
"{{{4 s:g.chk.cmd
let s:g.chk.nothing={"model": "optional"}
let s:g.chk.cmd={
            \"model": "actions",
            \"actions": {}
        \}
let s:g.chk.cmd.actions.unload={
            \   "model": "simple",
            \"required": [["keyof", s:g.reg.registered]]
        \}
let s:g.chk.cmd.actions.reload=s:g.chk.cmd.actions.unload
let s:g.chk.cmd.actions.show=s:g.chk.nothing
let s:g.chk.cmd.actions.findnr={"model": "simple",
            \                "required": [{"check": ["nums", [1]],
            \                              "trans": ["earg", ""]}]}
let s:g.chk.cmd.actions.nrof={"model": "simple",
            \              "required": [{"check": ["regex", '^/']}]}
lockvar! s:g.chk
unlockvar! s:g.reg.registered
"}}}4
function s:F.mng.main(action, ...)
    "{{{4 Объявление переменных
    let selfname="mng.main"
    let action=tolower(a:action)
    "{{{4 Проверка ввода
    let args=s:F.plug.chk.checkarguments(s:g.chk.cmd, [action]+a:000)
    if type(args)!=type([])
        return 0
    endif
    "{{{4 Действия
    "{{{5 Выгрузить дополнение
    if action==#"unload"
        return !!len(s:F.comm.unload(args[1]))
    "{{{5 Перезагрузить дополнение
    elseif action==#"reload"
        execute s:F.comm.unload(args[1])
        return 1
    "{{{5 Показать список загруженных дополнений
    elseif action==#"show"
        let lines=values(map(copy(s:g.reg.registered),
                    \'[v:val.scriptid, v:key, v:val.file, v:val.status]'))
        return s:F.stuf.printtable(s:g.p.th, lines)
    "{{{5 Найти функцию, соответствующую номеру
    elseif action==#"findnr"
        let result=s:F.stuf.findnr(args[1])
        if type(result)!=type("")
            echo s:g.p.nfnd
        else
            echo result
            return 1
        endif
    "{{{5 Найти номер, соответствующий функции
    elseif action==#"nrof"
        let Result=s:F.stuf.findpath(args[1])
        if type(Result)==2
            echo Result
            return 1
        elseif type(Result)==type({})
            let list=s:F.stuf.fdictstr(Result, 0)
            call map(list, '[repeat(" ", v:val[0]).v:val[1], '.
                        \"substitute(s:F.stuf.string(v:val[2]), ".
                        \                   "'^.*''\\([^'']*\\)''.*$', ".
                        \                   "'\\1', '')]")
            return s:F.stuf.printtable([], list)
        else
            echo s:g.p.nfnd
        endif
    endif
    "}}}4
endfunction
"{{{2 comp: автодополнение
"{{{3 comp.nrof
function s:F.comp.nrof(arglead)
    let s=split(a:arglead, '/')
    if len(s)<=1 && a:arglead[-1:][0]!=#'/'
        return map(keys(s:g.reg.registered), '"/".v:val."/"')
    else
        let path='/'.join(s, '/')
        let P=s:F.stuf.findpath(path)
        if type(P)==type({})
            return map(keys(P), 'path."/".v:val')
        elseif type(P)!=2
            unlet P
            let path='/'.join(s[:(-2)], '/')
            let P=s:F.stuf.findpath('/'.join(s[:(-2)], '/'))
            if type(P)==type({})
                return map(keys(P), 'path."/".v:val')
            endif
        endif
    endif
    return []
endfunction
"{{{3 comp._complete
function s:F.comp._complete(...)
    if has_key(s:F.comp, "__complete")
        return call(s:F.comp.__complete, a:000, {})
    elseif has_key(s:F.plug.comp, "ccomp")
        let s:F.comp.__complete=s:F.plug.comp.ccomp(s:g.comp._cname, s:g.comp.a)
        lockvar! s:F.comp
        return call(s:F.comp.__complete, a:000, {})
    else
        runtime plugin/comp.vim
        call s:F.comm.load("comp")
        if has_key(s:F.plug.comp, "ccomp")
            let s:F.comp.__complete=s:F.plug.comp.ccomp(s:g.comp._cname,
                        \s:g.comp.a)
            lockvar! s:F.comp
            return call(s:F.comp.__complete, a:000, {})
        endif
    endif
    return []
endfunction
"{{{3 s:g.comp
let s:g.comp={}
let s:g.comp.plug=["keyof", s:g.reg.registered]
let s:g.comp.a={"model": "actions"}
let s:g.comp.a.actions={}
let s:g.comp.a.actions.unload={"model": "simple",
            \              "arguments": [s:g.comp.plug]}
let s:g.comp.a.actions.reload={"model": "simple",
            \              "arguments": [s:g.comp.plug]}
let s:g.comp.a.actions.show={"model": "simple"}
let s:g.comp.a.actions.findnr={"model": "simple"}
let s:g.comp.a.actions.nrof={"model": "simple",
            \              "arguments": [["func", s:F.comp.nrof]]}
let s:g.comp._cname="load"
"{{{1
let s:g.reginfo=s:F.reg.register({
            \     "funcdict": s:F,
            \     "globdict": s:g,
            \      "fprefix": "Load",
            \      "cprefix": "Load",
            \      "oprefix": "load",
            \     "commands": s:g.load.commands,
            \    "functions": s:g.load.functions,
            \          "sid": s:g.scriptid,
            \   "scriptfile": s:g.load.scriptfile,
            \      "oneload": 1,
            \"dictfunctions": s:g.comm.f,
            \   "apiversion": "0.0",
        \})
            "s:g.comm.f, "Load", "Load", "load", s:F, s:g,
            "s:g.load.commands, s:g.load.functions, s:g.scriptid,
            "s:g.load.scriptfile, 1)
lockvar! s:g.reginfo
let s:F.main.eerror=s:g.reginfo.functions.eerror
unlet s:g.load
" let s:F.plug.comp=s:F.comm.getfunctions("comp")
let s:F.plug.comp=s:F.comm.lazyload("comp")
let s:F.plug.stuf=s:F.comm.lazyload("stuf")
lockvar! s:F
unlockvar s:F.plug
unlockvar s:F.comp
lockvar s:g
" vim: ft=vim:ts=8:fdm=marker:fenc=utf-8

