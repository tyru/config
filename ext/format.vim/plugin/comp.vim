"{{{1 Начало
scriptencoding utf-8
if (exists("s:g.pluginloaded") && s:g.pluginloaded) ||
            \exists("g:compOptions.DoNotLoad")
    finish
"{{{1 Первая загрузка
elseif !exists("s:g.pluginloaded")
    "{{{2 Объявление переменных
    "{{{3 Словари с функциями
    " Функции для внутреннего использования
    let s:F={
                \"plug": {},
                \"main": {},
                \ "mod": {},
                \"comp": {},
                \ "out": {},
            \}
    lockvar 1 s:F
    "{{{3 Глобальная переменная
    let s:g={}
    let s:g.pluginloaded=0
    let s:g.load={}
    let s:g.out={}
    let s:g.chk={}
    let s:g.chk.id=["type", type("")]
    let s:g.chk.id_comp=["and", [s:g.chk.id,
                \                ["not", ["keyof", s:g.out]]]]
    let s:g.load.scriptfile=expand("<sfile>")
    let s:g.srccmd="source ".(s:g.load.scriptfile)
    let s:g.chk.f=[
                \["ccomp",     "out.constructcompletion",
                \       {   "model": "simple",
                \        "required": [s:g.chk.id_comp,
                \                     ["type", type({})]]}],
                \["delcomp", "out.delcompletion",
                \       {   "model": "simple",
                \        "required": [["keyof", s:g.out]]}],
            \]
    let s:g.plugname=fnamemodify(s:g.load.scriptfile, ":t:r")
    "{{{3 sid
    function s:SID()
        return matchstr(expand('<sfile>'), '\d\+\ze_SID$')
    endfun
    let s:g.scriptid=s:SID()
    delfunction s:SID
    "}}}2
    let s:F.plug.load=load#LoadFuncdict()
    let s:g.reginfo=s:F.plug.load.registerplugin({
                \     "funcdict": s:F,
                \     "globdict": s:g,
                \      "oprefix": "comp",
                \          "sid": s:g.scriptid,
                \   "scriptfile": s:g.load.scriptfile,
                \"dictfunctions": s:g.chk.f,
                \   "apiversion": "0.0",
            \})
    let s:F.main.eerror=s:g.reginfo.functions.eerror
    finish
endif
"{{{1 Вторая загрузка
let s:g.pluginloaded=1
"{{{2 Чистка
unlet s:g.load
"{{{2 Выводимые сообщения
let s:g.p={
            \"emsg": {
            \   "idexists": "This completion ID already exists",
            \       "umod": "Unknown model",
            \},
            \"etype": {},
        \}
call add(s:g.chk.f[0][2].required[0][1][1], s:g.p.emsg.idexists)
"{{{1 Вторая загрузка — функции
"{{{2 Внешние дополнения
let s:F.plug.stuf=s:F.plug.load.getfunctions("stuf")
let s:F.plug.chk=s:F.plug.load.getfunctions("chk")
"{{{2 main: eerror, destruct
"{{{3 main.destruct: выгрузить плагин
function s:F.main.destruct()
    unlet s:g
    unlet s:F
    return 1
endfunction
"{{{2 mod
"{{{3 mod.actions
function s:F.mod.actions(comp, s)
    if !len(a:s.arguments)
        return ((has_key(a:comp, "actions"))?(keys(a:comp.actions)):([]))
    endif
    if has_key(a:comp, "actions")
        let action=tolower(a:s.arguments[0])
        if len(a:s.arguments)==1 && !has_key(a:comp.actions, action)
            return keys(a:comp.actions)
        endif
        if has_key(a:comp.actions, action)
            let comp=a:comp.actions[action]
            let a:s.arguments=a:s.arguments[1:]
            return s:F.mod[comp.model](comp, a:s)
        endif
    endif
    return []
endfunction
"{{{3 mod.simple
function s:F.mod.simple(comp, s)
    if has_key(a:comp, "arguments")
        let lsarg=len(a:s.arguments)
        if lsarg<=len(a:comp.arguments)
            return s:F.comp.getlist(a:comp.arguments[lsarg-1],
                        \           a:s.arguments[-1])
        endif
    endif
    return []
endfunction
"{{{3 mod.pref
function s:F.mod.pref(comp, s)
    let larg=len(a:s.arguments)
    if has_key(a:comp, "arguments")
        let lcarg=len(a:comp.arguments)
        if larg<=lcarg
            return s:F.mod.simple(a:comp, a:s)
        else
            let a:s.arguments=a:s.arguments[(lcarg):]
        endif
    endif
    let larg=len(a:s.arguments)
    if has_key(a:comp, "prefix")
        if !(larg%2)
            let pref=a:s.arguments[-2]
            if has_key(a:comp.prefix, pref)
                return s:F.comp.getlist(a:comp.prefix[pref],
                            \           a:s.arguments[-1])
            endif
        else
            return keys(a:comp.prefix)
        endif
    endif
    return []
endfunction
"{{{2 comp
"{{{3 comp.getlist
function s:F.comp.getlist(descr, arglead)
    let [type, Arg]=a:descr
    if type=="merge"
        let result=[]
        for descr in Arg
            let result+=s:F.comp.getlist(descr, a:arglead)
        endfor
        return result
    endif
    return eval(s:g.comp.list[type])
endfunction
"{{{4 s:g.comp.list
let s:g.comp={}
let s:g.comp.list={
            \"func": "call(Arg, [a:arglead], {})",
            \"list": "Arg",
            \"keyof": "keys(Arg)",
            \"file": 'split(glob(a:arglead."*".Arg)."\n".glob(a:arglead."*"), '.
            \              '"\n")',
        \}
"{{{3 comp.toarglead
function s:F.comp.toarglead(arglead, list)
    if type(a:list)!=type([])
        return []
    endif
    let results=[[], [], [], [], a:list]
    let reg=s:F.plug.stuf.regescape(a:arglead)
    for item in a:list
        if type(item)==type("")
            if item=~#'^'.reg
                call add(results[0], item)
            elseif item=~?'^'.reg
                call add(results[1], item)
            elseif item=~#reg
                call add(results[2], item)
            elseif item=~?reg
                call add(results[3], item)
            endif
        endif
    endfor
    let result=[]
    let i=0
    while !len(result) && i<len(results)
        let result+=results[i]
        let i+=1
    endwhile
    return result
endfunction
"{{{3 comp.split
function s:F.comp.split(arglead, cmdline, position)
    let r={"origin": [a:cmdline, a:arglead, a:position]}
    let r.cmd=a:cmdline[:(a:position)]
    let r.range=matchstr(r.cmd, '^'.s:g.reg.range)
    let r.cmd=r.cmd[len(r.range):]
    let r.command=matchstr(r.cmd, '^\(\u[[:alnum:]_]*\)!\=')
    let r.cmd=r.cmd[len(r.command):]
    let r.arguments=split(r.cmd)
    if !len(a:arglead)
        call add(r.arguments, '')
    endif
    return r
endfunction
"{{{4 s:g.reg
let s:g.reg={}
let s:g.reg.range='\(%\|'.
            \       '\('.
            \         '\(\d\+\|'.
            \           '[.$]\|'.
            \           '''.\|'.
            \           '\\[/?&]\|'.
            \           '/\([^\\/]\|\\.\)\+/\=\|'.
            \           '?\([^\\?]\|\\.\)\+?\='.
            \         '\)[;,]\='.
            \       '\)*'.
            \     '\)\='
"{{{3 comp.main
function s:F.comp.main(comp, arglead, cmdline, position)
    let s=s:F.comp.split(a:arglead, a:cmdline, a:position)
    let result=s:F.mod[a:comp.model](a:comp, s)
    return s:F.comp.toarglead(a:arglead, result)
endfunction
"{{{4 Проверки
let s:g.chk.alist=["alllst",]
let s:g.chk.list=["and", [["len", [2]],
            \             ["eval", 'type(a:Arg[0])==type("")'],
            \             ["or", [["chklst", [["equal", "merge"],
            \                                 s:g.chk.alist]],
            \                     ["chklst", [["equal", "func"],
            \                                 ["type", 2]]],
            \                     ["chklst", [["equal", "list"],
            \                                 ["alllst", ["type", type("")]]]],
            \                     ["chklst", [["equal", "file"],
            \                                 ["type", type("")]]],
            \                     ["chklst", [["equal", "keyof"],
            \                                 ["type", type({})]]]]]]]
call add(s:g.chk.alist, s:g.chk.list)
let s:g.chk.pref=["dict", [[["any", ""], s:g.chk.list]]]
let s:g.chk.model=["and",]
let s:g.chk.actions=["dict", [[["any", ""], s:g.chk.model]]]
call add(s:g.chk.model,  [["hkey", "model"],
            \             ["dict", [[["equal", "model"], ["keyof", s:F.mod]],
            \                       [["equal", "actions"], s:g.chk.actions],
            \                       [["equal", "arguments"], s:g.chk.alist],
            \                       [["equal", "prefix"], s:g.chk.pref]]]])
let s:g.chk.f[0][2].required[1]=s:g.chk.model
"{{{2 out
"{{{3 out.constructcompletion
function s:F.out.constructcompletion(id, comp)
    let s:g.out[a:id]=[a:comp]
    let id=s:F.plug.stuf.squote(a:id)
    let r={}
    execute      "function r._complete(...)\n".
                \"    return call(s:F.comp.main, s:g.out[".id."]+".
                \           "a:000, {})\n".
                \"endfunction"
    return r._complete
endfunction
"{{{3 out.delcompletion
function s:F.out.delcompletion(id)
    unlet s:g.out[a:id]
endfunction
"{{{1
lockvar! s:F
lockvar s:g
unlockvar! s:g.out
let t=s:F
" vim: ft=vim:ts=8:fdm=marker:fenc=utf-8

