"{{{1 Начало
scriptencoding utf-8
if (exists("s:g.pluginloaded") && s:g.pluginloaded) ||
            \exists("g:chkOptions.DoNotLoad")
    finish
"{{{1 Первая загрузка
elseif !exists("s:g.pluginloaded")
    "{{{2 Объявление переменных
    "{{{3 Словари с функциями
    " Функции для внутреннего использования
    let s:F={
                \"plug": {},
                \"stuf": {},
                \"main": {},
                \"cchk": {},
                \"achk": {},
                \"tran": {},
                \"comm": {},
                \ "mod": {},
            \}
    " lockvar 1 s:F
    "{{{3 Глобальная переменная
    let s:g={}
    let s:g.load={}
    let s:g.pluginloaded=0
    let s:g.load.scriptfile=expand("<sfile>")
    let s:g.srccmd="source ".(s:g.load.scriptfile)
    let s:g.load.f=[
                \["checkargument",  "achk._main", {}],
                \["checkarguments", "cchk._main", {}]]
    "{{{4 sid
    function s:SID()
        return matchstr(expand('<sfile>'), '\d\+\ze_SID$')
    endfun
    let s:g.load.sid=s:SID()
    delfunction s:SID
    "{{{2 Регистрация плагина
    let s:F.plug.load=load#LoadFuncdict()
    let s:g.reginfo=s:F.plug.load.registerplugin({
                \     "funcdict": s:F,
                \     "globdict": s:g,
                \      "oprefix": "chk",
                \"dictfunctions": s:g.load.f,
                \          "sid": s:g.load.sid,
                \   "scriptfile": s:g.load.scriptfile,
                \   "apiversion": "0.0",
            \})
    let s:F.main.eerror=s:g.reginfo.functions.eerror
    "}}}2
    finish
endif
"{{{1 Вторая загрузка
let s:g.pluginloaded=1
"{{{2 Чистка
unlet s:g.load
"{{{2 Выводимые сообщения
let s:g.p={
            \"emsg": {
            \     "num": "Value must be number",
            \    "bool": "Value must be number, equal to either 0 or 1",
            \    "uint": "Value must be unsigned integer",
            \     "int": "Value must be integer",
            \    "func": "Value must be a reference to a function",
            \     "str": "Value must be of a type “string”",
            \    "dict": "Value must be of a type “dictionary”",
            \    "list": "Value must be of a type “list”",
            \    "nums": "Value must be a string representation of either ".
            \            "Number or Float",
            \   "kbool": "Key “allowtrun” must be number, equal to either 0 or 1",
            \    "type": "Invalid type",
            \   "notin": "Value not in list %s",
            \    "nreg": "Value does not match regular expression /%s/",
            \   "nfunc": "Function %s returned a error",
            \   "mmiss": "Key “model” is missing",
            \    "uknm": "Unknown model",
            \    "uchk": "Uknown check",
            \   "utran": "Uknown transformation",
            \     "upr": "Uknown prefix",
            \     "uvt": "Uknown variable type",
            \    "uact": "Uknown action",
            \    "ukey": "Uknown key (key does not match any check)",
            \    "ufct": "Uknown file check type",
            \      "uf": "Number must be greater then or equal to %g",
            \      "of": "Number must be less then or equal to %g",
            \     "key": "Key “%s” not found",
            \    "nkey": "Dictionary does not have “%s” key",
            \    "vars": "Variable name must start with a latin letter ".
            \            "and a colon",
            \   "varls": "Function (l: and a:) and script variable name",
            \   "varne": "Variable does not exist",
            \     "neq": "Value not equal to “%s”",
            \    "ivar": "Invalid variable name",
            \    "ichk": "Invalid check",
            \    "ival": "Invalid value",
            \    "ilen": "Invalid length",
            \     "ina": "Invalid number of arguments",
            \    "irng": "Invalid range",
            \    "ireg": "Invalid regular expression",
            \    "cstr": "First element in Check is its name, so it must be ".
            \            "of a type “string”",
            \    "topt": "Too many optional arguments",
            \   "tslst": "Too short list",
            \   "tllst": "Too long list",
            \   "eexpr": "Expression resulted in error",
            \   "evalf": "Eval failed",
            \    "chkf": "Check #%u failed",
            \    "chks": "Check #%u succeed, but some previous check failed",
            \     "amb": "Ambigious argument",
            \    "pmis": "Some required keys are missing",
            \   "nfull": "Full version not found",
            \      "pl": "Prefix list must be a list of strings",
            \},
            \"etype": {
            \     "value": "InvalidValue",
            \       "chk": "InvalidCheck",
            \       "mod": "InvalidModel",
            \     "trans": "InvalidTransformation",
            \},
        \}
"{{{1 Вторая загрузка — функции
"{{{2 stuf: checkwr, regescape, string
"{{{3 stuf.checkwr: проверить возможность записи в файл
function s:F.stuf.checkwr(fname)
    let fwr=filewritable(a:fname)
    return (fwr==1 || (fwr!=2 && !filereadable(a:fname) &&
                \filewritable(fnamemodify(a:fname, ":p:h"))==2))
endfunction
"{{{3 stuf.regescape
function s:F.stuf.regescape(str)
    return escape(a:str, '^$*~[]\')
endfunction
"{{{3 stuf.string
function s:F.stuf.string(obj)
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
"{{{2 main: eerror, destruct
"{{{3 main.destruct: выгрузить плагин
function s:F.main.destruct()
    unlet s:g
    unlet s:F
    return 1
endfunction
"{{{2 comm: getarg
"{{{3 s:g.comm
let s:g.comm={ "rdict": {} }
"{{{3 comm.getarg: Получить аргумент
function s:F.comm.getarg(chk, arg)
    let selfname="comm.getarg"
    if type(a:chk)!=type({})
        if type(a:chk)==type([])
            let chk={"check": a:chk}
        else
            return s:F.main.eerror(selfname, "chk", ["dict"])
        endif
    else
        let chk=a:chk
    endif
    if has_key(chk, "check") && !s:F.achk._main(chk.check, a:arg)
        return 0
    endif
    if has_key(chk, "trans")
        let tres=s:F.tran._main(chk.trans, a:arg)
        if type(tres)!=type({})
            return 0
        endif
        if has_key(chk, "transchk") && !s:F.achk._main(chk.transchk,
                    \tres.result)
            return 0
        endif
        return tres
    endif
    if has_key(chk, "skip")
        return {}
    endif
    return {"result": a:arg}
endfunction
"{{{2 tran: _main
"{{{3 s:g.tran
let s:g.tran={}
"{{{4 Проверки для аргументов
let s:g.tran.transchecks={
            \"pipe": ["type(Trans)==type([])", s:g.p.emsg.list],
            \"call": ["type(Trans)==type([])", s:g.p.emsg.list],
            \"func": ["type(Trans)==2",        s:g.p.emsg.func],
            \"eval": ["type(Trans)==type('')", s:g.p.emsg.str ],
            \"earg": ["1",                     ""             ],
            \  "eq": ["1",                     ""             ],
        \}
let s:g.tran.chkroot=["chklst", [["in",   keys(s:g.tran.transchecks)],
            \                    ["any",  "1"                       ]]
        \]
"{{{4 Простые трансформации
let s:g.tran.simpletrans={
            \"func": "call(a:Trans, [a:Arg], {})",
            \"eval": "eval(a:Trans)",
            \"earg": "eval(a:Arg)",
            \"call": "call(a:Arg, a:Trans, {})",
            \  "eq": "type(a:Arg)==type(a:Trans) && a:Arg==#a:Trans",
        \}
for s:T in keys(s:g.tran.simpletrans)
    execute      "function s:F.tran.".s:T."(Trans, Arg)\n".
                \"    return {'result': ".s:g.tran.simpletrans[s:T]."}\n".
                \"endfunction"
endfor
unlet s:T
"{{{3 tran.pipe
function s:F.tran.pipe(Trans, Arg)
    let Result=a:Arg
    for Trans in a:Trans
        let curarg=s:F.tran._main(Trans, Result)
        unlet Result
        if type(curarg)==type(0)
            return 0
        endif
        let Result=curarg.result
    endfor
    return {"result": Result}
endfunction
"{{{3 tran._main
function s:F.tran._main(trans, Arg)
    let selfname="tran._main"
    "{{{4 Проверка аргументов
    if !s:F.achk._main(s:g.tran.chkroot, a:trans)
        return 0
    endif
    "{{{4 Объявление переменных
    let [ttrans, Trans]=a:trans[0:1]
    "{{{4 Проверка трансформации
    if !eval(s:g.tran.transchecks[ttrans][0])
        return s:F.main.eerror(selfname, "tran", ["itran"],
                    \s:g.tran.transchecks[ttrans][1])
    endif
    "}}}4
    return call(s:F.tran[ttrans], [Trans, a:Arg], {})
endfunction
"{{{2 mod: simple, optional, prefixed, actions, aslist
"{{{3 s:g.mod
let s:g.mod={}
"{{{3 mod.actions: Проверка в зависимости от первого аргумента
function s:F.mod.actions(chk, args, shift)
    let selfname="mod.actions"
    "{{{4 Проверка аргументов
    if !s:F.achk._main(s:g.mod.actcheck, a:chk)
        return 0
    elseif type(a:args[a:shift])!=type("")
        return s:F.main.eerror(selfname, "value", ["str"], 0)
    endif
    "{{{4 Проверка, разрешены ли сокращения
    let allowtrun=1
    if has_key(a:chk, "allowtrun")
        if !s:F.achk._main(["bool", "", s:g.p.emsg.kbool], a:chk.allowtrun)
            return 0
        endif
        let allowtrun = a:chk.allowtrun
    endif
    "}}}4
    let action=tolower(a:args[a:shift])
    "{{{4 Получение действия, если разрешены сокращения
    if allowtrun
        let foundaction=s:F.cchk.gettrun(action, a:chk.actions)
        if type(foundaction)!=type("")
            return s:F.main.eerror(selfname, "value", ["uact"], action)
        endif
        let action=foundaction
    "{{{4 если не разрешены
    elseif !has_key(a:chk.actions, action)
        return s:F.main.eerror(selfname, "value", ["uact"], action)
    endif
    "{{{4 Получение аргументов
    let result=s:F.cchk._main(a:chk.actions[action], a:args, a:shift+1)
    if type(result)!=type([])
        return 0
    endif
    "}}}4
    return [action]+result
endfunction
let s:g.mod.actcheck=["hkey", "actions"]
"{{{3 mod.simple: Простая модель
function s:F.mod.simple(chk, args, shift)
    let selfname="mod.simple"
    "{{{4 Проверяем на наличие ключа «required»
    if !s:F.achk._main(s:g.mod.reqcheck, a:chk)
        return 0
    endif
    "{{{4 Проверяем количество аргументов
    if (len(a:args)-a:shift)!=len(a:chk.required)
        return s:F.main.eerror(selfname, "value", ["ilen"],
                    \(len(a:args)-a:shift)."≠".len(a:chk.required))
    endif
    "{{{4 Получение аргументов
    let result=s:F.cchk.getrequired(a:chk, a:args, a:shift)
    if type(result)!=type({})
        return 0
    endif
    return result.result
    "}}}4
endfunction
let s:g.mod.reqcheck=["hkey", "required"]
"{{{3 mod.optional: Простая модель с необязательными аргументами
"                          и значениями по-умолчанию
function s:F.mod.optional(chk, args, shift)
    let selfname="mod.optional"
    "{{{4 Получаем обязательные аргументы
    let result=s:F.cchk.getrequired(a:chk, a:args, a:shift)
    if type(result)!=type({})
        return 0
    endif
    let reqlen=result.last+1
    let args=result.result
    unlet result
    "{{{4 Получаем необязательные аргументы
    let result=s:F.cchk.getoptional(a:chk, a:args, reqlen)
    if type(result)!=type({})
        return 0
    endif
    let args+=result.result
    if (result.last)!=(len(a:args)-1)
        return s:F.main.eerror(selfname, "value", ["ilen"],
                    \(result.last)."≠".(len(a:args)-1))
    endif
    "}}}4
    return args
endfunction
"{{{3 mod.prefixed
" Простая модель, за которой следуют в произвольном порядке необязательные 
" аргументы, опозноваемые по префиксу.
function s:F.mod.prefixed(chk, args, shift)
    let selfname="mod.prefixed"
    "{{{4 Получаем обязательные аргументы
    let result=s:F.cchk.getrequired(a:chk, a:args, a:shift)
    if type(result)!=type({})
        return 0
    endif
    let blen=result.last+1
    let args=result.result
    unlet result
    "{{{4 ?chk
    let ochk={}
    let rchk={}
    if has_key(a:chk, "prefoptional")
        let ochk=copy(a:chk.prefoptional)
    endif
    if has_key(a:chk, "prefrequired")
        let rchk=copy(a:chk.prefrequired)
    endif
    let chk=keys(ochk)+keys(rchk)
    "{{{4 Получаем необязательные аргументы
    let prefchk=["in", chk]
    let result=s:F.cchk.getoptional(a:chk, a:args, blen, prefchk)
    if type(result)!=type({})
        return 0
    endif
    let args+=result.result
    let blen=result.last+1
    "{{{4 Проверка, разрешены ли сокращения
    let haspreflist=has_key(a:chk, "preflist")
    let plcheck=["alllst", ["in", chk], s:g.p.emsg.pl]
    if haspreflist && !s:F.achk._main(plcheck, a:chk.preflist)
        return 0
    endif
    let allowtrun=!(len(result.result) || haspreflist)
    unlet result
    if allowtrun && has_key(a:chk, "allowtrun")
        if !s:F.achk._main(s:g.mod.atcheck, a:chk.allowtrun)
            return 0
        endif
        let allowtrun = a:chk.allowtrun
    endif
    "{{{4 Собственно, префиксы
    if has_key(a:chk, "prefoptional") || has_key(a:chk, "prefrequired")
        "{{{5 Объявление переменных
        let i=blen
        let result={}
        let pref=""
        let inlist=0
        "{{{5 Получение префиксов
        while i<len(a:args)
            "{{{6 Если ещё нет префикса
            if !len(pref)
                let pref=a:args[i]
                let inlist=0
                if type(pref)!=type("")
                    return s:F.main.eerror(selfname, "value", ["str"], i)
                elseif allowtrun
                    let foundpref=s:F.cchk.gettrun(pref, chk)
                    if type(foundpref)!=type("")
                        return s:F.main.eerror(selfname, "value",
                                    \["upr"], i, pref)
                    endif
                    let pref=foundpref
                elseif index(chk, pref)==-1
                    return s:F.main.eerror(selfname, "value", ["upr"], i, pref)
                endif
                if haspreflist && index(a:chk.preflist, pref)!=-1
                    let result[pref]=[]
                    let inlist=1
                    if has_key(ochk, pref)
                        let listchk=ochk[pref][0]
                        unlet ochk[pref]
                    else
                        let listchk=rchk[pref]
                        unlet rchk[pref]
                    endif
                endif
                let i+=1
                continue
            endif
            "{{{6 Получение аргумента
            let arg=a:args[i]
            "{{{7 Если мы внутри списка,
            " то надо остановиться на аргументе, являющемся префиксом
            if inlist && index(chk, arg)!=-1
                let pref=""
                unlet listchk
                continue
            endif
            "{{{7 Получения значения, соответствующего префиксу
            if inlist
                let gres=s:F.comm.getarg(listchk, arg)
            elseif has_key(ochk, pref)
                let gres=s:F.comm.getarg(ochk[pref][0], arg)
                unlet ochk[pref]
            else
                let gres=s:F.comm.getarg(rchk[pref], arg)
                unlet rchk[pref]
            endif
            if type(gres)!=type({})
                return s:F.main.eerror(selfname, "value", ["ival"], i+1)
            "{{{7 Запись полученного значения
            elseif has_key(gres, "result")
                if inlist
                    call add(result[pref], gres.result)
                else
                    let result[pref]=gres.result
                    let pref=""
                endif
            endif
            "}}}6
            let i+=1
        endwhile
        "{{{5 Проверка завершенности
        if len(pref) && !inlist
            return s:F.main.eerror(selfname, "value", ["ina"], len(a:args))
        endif
        "{{{5 Проверка наличия всех обязательных префиксов
        if len(keys(rchk))
            return s:F.main.eerror(selfname, "value", ["pmis"],
                        \          "<<".join(keys(rchk), ">>, <<").">>")
        endif
        "{{{5 Получение неуказанных необязательных префиксов
        for pref in keys(ochk)
            let gres=s:F.comm.getarg(ochk[pref][1], ochk[pref][2])
            if type(gres)!=type({})
                return s:F.main.eerror(selfname, "value", ["ival"], i)
            elseif has_key(gres, "result")
                let result[pref]=gres.result
            endif
        endfor
        "}}}5
        call add(args, result)
    endif
    "}}}4
    return args
endfunction
let s:g.mod.atcheck=["bool", "", s:g.p.emsg.kbool]
"{{{3 mod.aslist Проверить оставшиеся аргументы как один аргумент
function s:F.mod.aslist(chk, args, shift)
    let selfname="mod.aslist"
    let args=a:args[(a:shift):]
    if !s:F.achk._main(["hkey", "check"], a:chk)
        return 0
    endif
    let gres=s:F.comm.getarg(a:chk.check, args)
    if type(gres)!=type({})
        return s:F.main.eerror(selfname, "value", ["ival"],
                    \          a:shift.":".len(a:args))
    elseif has_key(gres, "result")
        return gres.result
    endif
    return []
endfunction
"{{{2 cchk: _main, gettrun, getoptional, getrequired
"{{{3 cchk.gettrun
function s:F.cchk.gettrun(trun, fulls)
    let selfname="cchk.gettrun"
    if type(a:fulls)==type({})
        let fulls=keys(a:fulls)
    else
        let fulls=a:fulls
    endif
    let reg='^'.s:F.stuf.regescape(a:trun)
    let fullsfound=0
    for full in fulls
        if full=~#reg
            let fullsfound+=1
            let foundfull=full
            if fullsfound>1
                return s:F.main.eerror(selfname, "value",
                            \["amb"], a:trun)
            endif
        endif
    endfor
    if exists("foundfull")
        return foundfull
    endif
    return s:F.main.eerror(selfname, "value", ["nfull"], a:trun)
endfunction
"{{{3 cchk.getoptional
function s:F.cchk.getoptional(chk, args, reqlen, ...)
    let selfname="cchk.getoptional"
    "{{{4 Проверяем наличие ключа «optional»
    if !has_key(a:chk, "optional")
        return {"last": a:reqlen-1, "result": []}
    endif
    "{{{4 Проверяем, надо ли останавливаться
    if len(a:000)
        let stop=a:000[0]
    endif
    "{{{4 Объявление переменных
    let i=a:reqlen
    let args=[]
    let largs=len(a:args)
    let last=i-1
    "{{{4 Основной цикл: получение аргументов
    for check in a:chk.optional
        "{{{5 Проверяем длину check
        if len(check)!=3
            return s:F.main.eerror(selfname, "mod", ["ilen"], len(check)."≠3")
        endif
        "{{{5 Остановка (если требуется)
        silent if i!=-1 && i<largs && exists("stop") &&
                    \s:F.achk._main(stop, a:args[i])
            let i=-1
        endif
        "{{{5 Аргументы для функции получения аргумента
        if i<largs && i!=-1
            let gachk=check[0]
            let Gaarg=a:args[i]
            let last=i
        else
            let gachk=check[1]
            let Gaarg=check[2]
        endif
        "{{{5 Получение аргумента
        let gres=s:F.comm.getarg(gachk, Gaarg)
        if type(gres)!=type({})
            return s:F.main.eerror(selfname, "value", ["ival"], i)
        elseif has_key(gres, "result")
            call add(args, gres.result)
        endif
        unlet gres
        unlet gachk
        unlet Gaarg
        "}}}5
        let i+=1
    endfor
    "}}}4
    return {"last": last, "result": args}
endfunction
"{{{3 cchk.getrequired
function s:F.cchk.getrequired(chk, args, shift)
    let selfname="cchk.getrequired"
    "{{{4 Проверяем наличие ключа «required»
    if !has_key(a:chk, "required")
        return {"result": [], "last": a:shift-1}
    endif
    "{{{4 Проверяем длину аргументов
    if len(a:args)<len(a:chk.required)
        return s:F.main.eerror(selfname, "value", ["ilen"],
                    \len(a:args)."<".len(a:chk.required))
    endif
    "{{{4 Объявление переменных
    let args=[]
    let i=a:shift
    let last=i-1
    "{{{4 Основной цикл: получение аргументов
    for check in a:chk.required
        let last=i
        let gres=s:F.comm.getarg(check, a:args[i])
        if type(gres)!=type({})
            return s:F.main.eerror(selfname, "value", ["ival"], i)
        elseif has_key(gres, "result")
            call add(args, gres.result)
        endif
        let i+=1
    endfor
    "}}}4
    return {"result": args, "last": last}
endfunction
"{{{3 cchk._main: Проверить аргументы команды
function s:F.cchk._main(chk, args, ...)
    let selfname="cchk._main"
    if type(a:args)!=type([])
        return s:F.main.eerror(selfname, "value", ["list"])
    endif
    if !s:F.achk._main(s:g.cchk.chkcheck, a:chk) ||
                \!s:F.achk._main(s:g.cchk.modelcheck, a:chk.model)
        return 0
    endif
    let shift=0
    if len(a:000)
        let shift=a:000[0]
    endif
    return call(s:F.mod[a:chk.model], [a:chk, a:args, shift], {})
endfunction
"{{{3 s:g.cchk
let s:g.cchk={
            \  "chkcheck": ["hkey", "model"],
            \"modelcheck": ["in", keys(s:F.mod), s:g.p.emsg.uknm],
        \}
"{{{2 achk: _main
"{{{3 s:g.achk
let s:g.achk={}
let s:g.achk.error=""
"{{{4 Простые проверки:
let s:g.achk.simplechecks={
            \   "in": ["index(a:Chk, a:Arg)!=-1",
            \          "['notin', s:F.stuf.string(a:Chk)], ".
            \          "s:F.stuf.string(a:Arg)"],
            \"regex": ["type(a:Arg)==type('') && a:Arg=~#a:Chk",
            \          "['nreg', s:F.stuf.string(a:Chk)], ".
            \          "s:F.stuf.string(a:Arg)"],
            \ "func": ["!!call(a:Chk, [a:Arg], {})",
            \          "['nfunc', s:F.stuf.string(a:Chk)]"],
            \ "type": ["type(a:Arg)==a:Chk",
            \          "['type'], type(a:Arg).'≠'.a:Chk"],
            \ "bool": ["index([0, 1], a:Arg)!=-1", "['bool']"],
            \"keyof": ["type(a:Arg)==type('') && has_key(a:Chk, a:Arg)",
            \          "['nkey', s:F.stuf.string(a:Arg)]"],
            \ "hkey": ["type(a:Arg)==type({}) && has_key(a:Arg, a:Chk)",
            \          "['key', a:Chk]"],
            \"equal": ["type(a:Arg)==type(a:Chk) && a:Arg==#a:Chk",
            \          "['neq', s:F.stuf.string(a:Chk)]"],
        \}
for s:C in keys(s:g.achk.simplechecks)
    execute      "function s:F.achk.".s:C."(Chk, Arg)\n".
                \"    let selfname='achk.".s:C."'\n".
                \"    if ".s:g.achk.simplechecks[s:C][0]."\n".
                \"        return 1\n".
                \"    endif\n".
                \"    return s:F.main.eerror(selfname, 'value', ".
                \           s:g.achk.simplechecks[s:C][1].")\n".
                \"endfunction"
endfor
unlet s:C
"{{{3 achk.eval:
function s:F.achk.eval(chk, Arg)
    let selfname="achk.eval"
    try
        return !!eval(a:chk)
    catch
        return s:F.main.eerror(selfname, "chk", ["eexpr"], v:exception)
    endtry
endfunction
"{{{3 achk.map
function s:F.achk.map(chk, Arg)
    let selfname="achk.map"
    if len(a:chk)!=2
        return s:F.main.eerror(selfname, "chk", ["ilen"], len(a:Arg)."≠2")
    elseif type(a:chk[1])!=type([])
        return s:F.main.eerror(selfname, "chk", ["dict"])
    endif
    let i=0
    for Check in a:chk[1]
        if !s:F.achk._main([a:chk[0], Check], a:Arg)
            return s:F.main.eerror(selfname, "chk", ["chkf", i])
        endif
        let i+=1
    endfor
    return 1
endfunction
"{{{3 achk.allorno
function s:F.achk.allorno(chk, Arg)
    let selfname="achk.allorno"
    let matchcount=0
    let curcheck=0
    for Check in a:chk
        let curcheck+=1
        silent if !s:F.achk._main(Check, a:Arg)
            if matchcount
                return s:F.main.eerror(selfname, "value",
                            \          ["chkf", curcheck])
            endif
        else
            let matchcount+=1
            if matchcount < curcheck
                return s:F.main.eerror(selfname, "value",
                            \          ["chks", curcheck])
            endif
        endif
    endfor
    return 1
endfunction
"{{{3 achk.var:    Имя переменной
"{{{4 s:g.achk.var
let s:g.achk.var={
            \ "buffer": "a:Arg=~#'^b:'",
            \ "window": "a:Arg=~#'^w:'",
            \"tabpage": "a:Arg=~#'^t:'",
            \ "global": "a:Arg=~#'^g:'",
            \    "vim": "a:Arg=~#'^v:'",
            \    "any": "1",
        \}
"}}}4
function s:F.achk.var(chk, Arg)
    let selfname="achk.var"
    "{{{4 Проверка аргументов
    let checks=split(a:chk, ',')
    "{{{5 Тип
    if type(a:Arg)!=type("")
        return s:F.main.eerror(selfname, "value", ["str"])
    "{{{5 Начало
    elseif a:Arg!~'^\w:'
        return s:F.main.eerror(selfname, "value", ["vars"], a:Arg)
    elseif a:Arg=~#'^[lsa]:'
        return s:F.main.eerror(selfname, "value", ["varls"], a:Arg)
    "{{{5 Ограничения
    elseif len(checks)
        let result=0
        for check in checks
            "{{{6 Неизвестная проверка
            if !has_key(s:g.achk.var, check)
                return s:F.main.eerror(selfname, "chk", ["uvt"], check)
            endif
            "}}}6
            if eval(s:g.achk.var[check])
                let result=1
                break
            endif
        endfor
        if !result
            return s:F.main.eerror(selfname, "value", ["ivar"], a:Arg)
        endif
    endif
    "{{{4 Проверка существования
    if !exists(a:Arg)
        return s:F.main.eerror(selfname, "value", ["varne"], a:Arg)
    endif
    "}}}4
    return 1
endfunction
"{{{3 achk.any:    Любое значение
function s:F.achk.any(...)
    return 1
endfunction
"{{{3 achk.and:    Список проверок
function s:F.achk.and(chk, Arg)
    for chk in a:chk
        if !s:F.achk._main(chk, a:Arg)
            return 0
        endif
    endfor
    return 1
endfunction
"{{{3 achk.or:     Список проверок
function s:F.achk.or(chk, Arg)
    silent! redir => s:g.achk.error
    for chk in a:chk
        silent if s:F.achk._main(chk, a:Arg)
            return 1
        endif
    endfor
    redir END
    echohl Error
    echo s:g.achk.error[1:]
    echohl None
    return 0
endfunction
"{{{3 achk.not:    Обратная проверка
function s:F.achk.not(chk, Arg)
    silent return !s:F.achk._main(a:chk, a:Arg)
endfunction
"{{{3 achk.chklst: Проверить список с фиксированным количеством элементов
function s:F.achk.chklst(chk, Arg)
    let selfname="achk.chklst"
    "{{{4 Проверка аргументов
    if type(a:Arg)!=type([])
        return s:F.main.eerror(selfname, "value", ["list"])
    elseif len(a:Arg)!=len(a:chk)
        return s:F.main.eerror(selfname, "value", ["ilen"],
                    \len(a:Arg)."≠".len(a:chk))
    endif
    "{{{4 Проверка значения
    let i=0
    for Arg in a:Arg
        if !s:F.achk._main(a:chk[i], Arg)
            return 0
        endif
        unlet Arg
        let i+=1
    endfor
    "}}}4
    return 1
endfunction
"{{{3 achk.alllst: Проверить каждый элемент в списке
function s:F.achk.alllst(chk, Arg)
    let selfname="achk.alllst"
    "{{{4 Проверка аргумент: список
    if type(a:Arg)!=type([])
        return s:F.main.eerror(selfname, "value", ["list"])
    endif
    "{{{4 Проверка списка
    let i=0
    for Arg in a:Arg
        if !s:F.achk._main(a:chk, Arg)
            return s:F.main.eerror(selfname, "value", ["ival"], i)
        endif
        unlet Arg
        let i+=1
    endfor
    "}}}4
    return 1
endfunction
"{{{3 achk.num:    Проверить число
function s:F.achk.num(chk, Arg)
    let selfname="achk.num"
    "{{{4 Проверить тип
    let tchk=type(a:chk[0])
    if tchk==type("")
        let tchk=type(a:chk[1])
    endif
    if tchk==type(0)
        if type(a:Arg)!=type(0)
            return s:F.main.eerror(selfname, "value", ["int"], a:Arg)
        endif
    elseif tchk==type(0.0)
        if type(a:Arg)!=type(0) && type(a:Arg)!=type(0.0)
            return s:F.main.eerror(selfname, "value", ["num"])
        endif
    endif
    "{{{4 Нижняя граница
    if type(a:chk[0])!=type("")
        if a:Arg<a:chk[0]
            return s:F.main.eerror(selfname, "value", ["uf", a:chk[0]], a:Arg)
        endif
    endif
    "{{{4 Верхняя граница
    if len(a:chk)==2
        if a:Arg>a:chk[1]
            return s:F.main.eerror(selfname, "value", ["of", a:chk[1]], a:Arg)
        endif
    endif
    "}}}4
    return 1
endfunction
"{{{3 achk.nums:   Проверить число, записанное в виде строки
function s:F.achk.nums(chk, Arg)
    let selfname="achk.nums"
    if type(a:Arg)!=type("")
        return s:F.main.eerror(selfname, "value", ["str"])
    elseif a:Arg!~#'^\(\d\+\(\.\d\+\(e[+-]\=\d\+\)\=\)\=\|0x\d\+\)$'
        return s:F.main.eerror(selfname, "value", ["nums"])
    endif
    try
        let e=eval(a:Arg)
    catch
        return s:F.main.eerror(selfname, "value", ["evalf"], v:exception)
    endtry
    return s:F.achk.num(a:chk, e)
endfunction
"{{{3 achk.len:    Проверить длину
function s:F.achk.len(chk, Arg)
    let selfname="achk.len"
    let larg=len(a:Arg)
    if type(a:Arg)!=type([])
        return s:F.main.eerror(selfname, "value", ["list"])
    elseif type(a:chk[0])!=type(0) || a:chk[0]<0
        return s:F.main.eerror(selfname, "chk",   ["uint"])
    elseif larg<a:chk[0]
        return s:F.main.eerror(selfname, "value", ["tslst"], larg."<".a:chk[0])
    endif
    if len(a:chk)==2
        if type(a:chk[1])!=type(0) || a:chk[1]<0
            return s:F.main.eerror(selfname, "chk", ["uint"])
        elseif a:chk[1]<a:chk[0]
            return s:F.main.eerror(selfname, "chk", ["irng"], join(a:chk, ", "))
        elseif larg>a:chk[1]
            return s:F.main.eerror(selfname, "value", ["tllst"],
                        \larg.">".a:chk[1])
        endif
    endif
    return 1
endfunction
"{{{3 achk.dict:   Проверить словарь
function s:F.achk.dict(chk, Arg)
    let selfname="achk.dict"
    if type(a:Arg)!=type({})
        return s:F.main.eerror(selfname, "value", ["dict"])
    endif
    for key in keys(a:Arg)
        let passed=0
        for check in a:chk
            if len(check)!=2
                return s:F.main.eerror(selfname, "chk", ["ilen"],
                            \len(check)."≠2")
            endif
            silent if s:F.achk._main(check[0], key)
                if !s:F.achk._main(check[1], a:Arg[key])
                    return s:F.main.eerror(selfname, "value",
                                \["ival"], key)
                else
                    let passed=1
                    break
                endif
            endif
        endfor
        if !passed
            return s:F.main.eerror(selfname, "value", ["ukey"], key)
        endif
    endfor
    return 1
endfunction
"{{{3 achk.file:   Проверить файл
function s:F.achk.file(chk, Arg)
    if type(a:Arg)!=type("")
        return s:F.main.eerror(selfname, "value", ["str"])
    endif
    if a:chk==#"r"
        return filereadable(a:Arg)
    elseif a:chk==#"rw"
        return filewritable(a:Arg)==1
    elseif a:chk==#"dw"
        return filewritable(a:Arg)==2
    elseif a:chk==#"w"
        return s:F.stuf.checkwr(a:Arg)
    endif
    return s:F.main.eerror(selfname, "chk", ["ufct"])
endfunction
"{{{3 achk.isreg:  Проверить, является ли a:Arg регулярным выражением
function s:F.achk.isreg(Chk, Arg)
    let selfname="achk.isreg"
    if type(a:Arg)!=type("")
        return s:F.main.eerror(selfname, "value", ["str"])
    endif
    try
        call matchstr("", a:Arg)
    catch
        return s:F.main.eerror(selfname, "value", ["ireg"], a:Arg, v:exception)
    endtry
    return 1
endfunction
"{{{3 achk._main:  Проверить значение
"{{{4 Проверка проверок
let s:g.achk.chkchecks={
            \"allorno": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \    "map": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \     "in": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \    "and": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \     "or": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \    "not": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \    "num": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \   "nums": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \ "chklst": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \ "alllst": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \   "dict": ["type(Chk)==type([])", s:g.p.emsg.list           ],
            \    "len": ["type(Chk)==type([]) && len(Chk) && len(Chk)<=2",
            \                                   s:g.p.emsg.list           ],
            \  "regex": ["s:F.achk.isreg('', Chk)",
            \                                   s:g.p.emsg.str            ],
            \   "eval": ["type(Chk)==type('')", s:g.p.emsg.str            ],
            \   "hkey": ["type(Chk)==type('')", s:g.p.emsg.str            ],
            \    "var": ["type(Chk)==type('')", s:g.p.emsg.str            ],
            \   "file": ["type(Chk)==type('')", s:g.p.emsg.str            ],
            \  "keyof": ["type(Chk)==type({})", s:g.p.emsg.dict           ],
            \   "func": ["type(Chk)==2",        s:g.p.emsg.func           ],
            \   "type": ["type(Chk)==type(0) && Chk>=0 && Chk<=5",
            \                                   s:g.p.emsg.int            ],
            \   "bool": ["1",                   ""                        ],
            \    "any": ["1",                   ""                        ],
            \  "equal": ["1",                   ""                        ],
            \  "isreg": ["1",                   ""                        ],
        \}
let s:g.achk.chkroot=[["type(a:chk)==type([])",          s:g.p.emsg.list],
            \         ["len(a:chk)==2 || len(a:chk)==3", s:g.p.emsg.ilen],
            \         ["type(a:chk[0])==type('')",       s:g.p.emsg.cstr],
            \         ["has_key(s:g.achk.chkchecks, a:chk[0])",
            \                                            s:g.p.emsg.uchk],
            \]
"}}}4
function s:F.achk._main(chk, Arg)
    let selfname="achk._main"
    "{{{4 Проверка проверки
    for check in s:g.achk.chkroot
        if !eval(check[0])
            return s:F.main.eerror(selfname, "chk", check[1],
                        \          s:F.stuf.string(a:chk))
        endif
    endfor
    "{{{4 Объявление переменных
    let emsg=((len(a:chk)==3)?(a:chk[2]):(s:g.p.emsg.ival))
    let [tchk, Chk]=a:chk[0:1]
    "{{{4 Проверка проверки
    if !eval(s:g.achk.chkchecks[tchk][0])
        return s:F.main.eerror(selfname, "chk", ["ichk"],
                    \s:g.achk.chkchecks[tchk][1])
    endif
    "{{{4 Проверка значения
    if call(s:F.achk[tchk], [Chk, a:Arg], {})
        return 1
    endif
    "}}}4
    return s:F.main.eerror(selfname, "value", emsg)
endfunction
"{{{2 Внешние дополнения
" let s:F.plug.stuf=s:F.plug.load.getfunctions("stuf")
"{{{1
lockvar! s:F
unlockvar 1 s:F.main
lockvar! s:g
unlockvar 1 s:g
unlockvar s:g.achk.error
unlockvar s:g.comm.rdict
" vim: ft=vim:ts=8:fdm=marker:fenc=utf-8

