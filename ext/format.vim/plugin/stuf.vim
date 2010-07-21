"{{{1 Начало
scriptencoding utf-8
if (exists("s:g.pluginloaded") && s:g.pluginloaded) ||
            \exists("g:stufOptions.DoNotLoad")
    finish
"{{{1 Первая загрузка
elseif !exists("s:g.pluginloaded")
    "{{{2 Объявление переменных
    "{{{3 Словари с функциями
    " Функции для внутреннего использования
    let s:F={
                \"stuf": {},
                \"plug": {},
                \"file": {},
                \ "str": {},
                \"main": {},
                \ "mng": {},
            \}
    lockvar 1 s:F
    "{{{3 Глобальная переменная
    let s:g={}
    let s:g.load={}
    let s:g.pluginloaded=0
    let s:g.load.scriptfile=expand("<sfile>")
    let s:g.srccmd="source ".(s:g.load.scriptfile)
    let s:g.reg={}
    let s:g.reg.oprefix='^[[:alnum:]_]\+$'
    let s:g.reg.intname='^\([[:alnum:]_]\+.\)*[[:alnum:]_]\+$'
    "{{{4 s:g.out
    let s:g.out={}
    let s:g.out.option={}
    "{{{4 Функции
    let s:g.c={}
    let s:g.c.sid=["nums", [1]]
    let s:g.c.functions=[
                \["regescape",   "str.escapefor.regex",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["mapprepare",  "str.escapefor.map",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["squote",      "str.escapefor.quote",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["iscombining", "str.iscombining",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["strlen",      "str.strlen",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["nextchar",    "str.nextchar",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["nextchar_nr", "str.nextchar_nr",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["printl",      "str.printl",
                \       {   "model": "simple",
                \        "required": [["type", type(0)],
                \                     ["type", type("")]]}],
                \["printtable",  "str.printtable",
                \       {   "model": "simple",
                \        "required": [["alllst", ["type", type("")]],
                \                     ["alllst", ["alllst", ["type", type("")]]]
                \                    ]}],
                \["string",      "str.string", {}],
                \["iswriteable", "file.checkwr",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["readfile",    "file.readfile",
                \       {   "model": "simple",
                \        "required": [["file", "r"]]}],
            \]
    "{{{4 sid
    function s:SID()
        return matchstr(expand('<sfile>'), '\d\+\ze_SID$')
    endfun
    let s:g.scriptid=s:SID()
    delfunction s:SID
    "{{{2 Регистрация плагина
    let s:F.plug.load=load#LoadFuncdict()
    let s:g.reginfo=s:F.plug.load.registerplugin({
                \     "funcdict": s:F,
                \     "globdict": s:g,
                \      "oprefix": "stuf",
                \          "sid": s:g.scriptid,
                \   "scriptfile": s:g.load.scriptfile,
                \"dictfunctions": s:g.c.functions,
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
"{{{1 Вторая загрузка — функции
"{{{2 plug
let s:F.plug.chk=s:F.plug.load.getfunctions("chk")
"{{{2 stuf
"{{{3 stuf.writevar: записать в переменную
", возможно, являющуюся частью несуществующего словаря, или имеющую другой тип 
"по сравнению с тем, что мы собираемся туда записать
function s:F.stuf.writevar(varname, what)
    let selfname="stuf.writevar"
    if a:varname=~#'\.'
        if !exists(a:varname)
            let dct=matchstr(a:varname, '^.*\.\@=')
            if !exists(dct) || type(eval(dct))!=type({})
                let lastret=s:F.stuf.writevar(dct, {})
                if !lastret
                    return 0
                endif
            endif
        endif
    elseif exists(a:varname) && !islocked(a:varname)
        execute "unlet ".a:varname
    endif
    if exists(a:varname) && islocked(a:varname)
        return s:F.main.eerror(selfname, "perm", ["vlock"], a:varname)
    endif
    execute "let ".a:varname."=a:what"
    return 1
endfunction
"{{{2 str
let s:g.str={}
"{{{3 str.escapefor
let s:F.str.escapefor={}
let s:g.str.escapefor={
            \"regex": 'escape(a:str, ''^$*~[]\'')',
            \"map": 'escape(substitute(substitute(a:str, "<", "<LT>", "g"), '.
            \                         '" ", "<SPACE>", "g"), "|")',
            \"quote": "\"'\".substitute(substitute(a:str, \"'\", '&&', 'g'), ".
            \         "'\\n', \"'.\\\"\\\\\\\\n\\\".'\", 'g').\"'\"",
        \}
for s:key in keys(s:g.str.escapefor)
    execute      "function s:F.str.escapefor.".s:key."(str)\n".
                \"    return ".s:g.str.escapefor[s:key]."\n".
                \"endfunction"
endfor
unlet s:key
"{{{3 str.string: failsafe string() replacement
function s:F.str.string(obj)
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
"{{{3 str.strlen: получение длины строки
function s:F.str.strlen(str)
    return len(split(a:str, '\zs'))
endfunction
"{{{3 str.iscombining: проверить, является ли символ диакритикой
" Если да, то вернуть его длину в байтах
" Unicode: combining diacritical marks: определение
" Wikipedia: http://en.wikipedia.org/wiki/Combining_character:
"   Combining Diacritical Marks (0300–036F)
"   Combining Diacritical Marks Supplement (1DC0–1DFF)
"   Combining Diacritical Marks for Symbols (20D0–20FF)
"   Combining Half Marks (FE20–FE2F)
function s:F.str.iscombining(char)
    let chnr=char2nr(a:char)
    if           (0x0300<=chnr && chnr<=0x036F) ||
                \(0x1DC0<=chnr && chnr<=0x1DFF) ||
                \(0x20D0<=chnr && chnr<=0x20FF) ||
                \(0xFE20<=chnr && chnr<=0xFE2F)
        return len(nr2char(chnr))
    endif
    return 0
endfunction
"{{{3 str.nextchar: получить следующий символ (reg('.'))
" Получить следующий символ. Если дан второй аргумент, то получить следующий за 
" позицией, данной во втором аргументе, символ.
function s:F.str.nextchar(str, ...)
    return matchstr(a:str, '.', ((len(a:000))?(a:000[0]):(0)))
endfunction
"{{{3 str.nextchar_nr получить следующий символ (nr2char(char2nr))
" То же, что и предыдущая функция, но получение следующего символа выполняется 
" с помощью nr2char(char2nr)
function s:F.str.nextchar_nr(str, ...)
    return nr2char(char2nr(a:str[((len(a:000))?(a:000[0]):(0)):]))
endfunction
"{{{3 str.printl: printf{'%-*s', ...}
" Напечатать {str}, шириной {len}, выровненное по левому краю, оставшееся 
" пространство заполнив пробелами (вместо printf('%-*s', len, str)).
function s:F.str.printl(len, str)
    return a:str . repeat(" ", a:len-s:F.str.strlen(a:str))
endfunction
"{{{3 str.printtline: печать строки таблицы
" Напечатать одну линию таблицы
"   {line} — список строк таблицы,
" {lenlst} — список длин
function s:F.str.printtline(line, lenlst)
    let result=""
    let i=0
    while i<len(a:line)
        let result.=s:F.str.printl(a:lenlst[i], a:line[i])
        let i+=1
        if i<len(a:line)
            let result.="  "
        endif
    endwhile
    return result
endfunction
"{{{3 str.printtable: напечатать таблицу
" Напечатать таблицу с заголовками рядов {headers} и линиями {lines}.
" {headers}: список строк
"   {lines}: список списков строк
function s:F.str.printtable(header, lines)
    let lineswh=a:lines+[a:header]
    let columns=max(map(copy(lineswh), 'len(v:val)'))
    let lenlst=[]
    let i=0
    while i<columns
        call add(lenlst, max(map(copy(lineswh),
                    \'(i<len(v:val))?s:F.str.strlen(v:val[i]):0')))
        let i+=1
    endwhile
    if a:header!=[]
        echohl PreProc
        echo s:F.str.printtline(a:header, lenlst)
        echohl None
    endif
    echo join(map(copy(a:lines), 's:F.str.printtline(v:val, lenlst)'), "\n")
    return 1
endfunction
"{{{2 file
"{{{3 file.checkwr
function s:F.file.checkwr(fname)
    let fwr=filewritable(a:fname)
    return (fwr==1 || (fwr!=2 && !filereadable(a:fname) &&
                \filewritable(fnamemodify(a:fname, ":p:h"))==2))
endfunction
"{{{3 file.readfile: прочитать файл
function s:F.file.readfile(fname)
    " Как ни странно, такой вариант работает быстрее, чем все придуманные мною 
    " альтернативы на чистом Vim
    let result=system("cat ".shellescape(a:fname))
    if v:shell_error
        let result=join(readfile(a:fname, 'b'), "\n")
    endif
    return result
    " Если в аргументах readfile не указывать 'b', то файл, не содержащий 
    " переводов строки, прочитается как будто он пустой.
    " return join(readfile(fname, 'b'), "\n")
    " Есть ещё варианты через открытие буфера, но они всё равно медленнее 
    " данного. Тем не менее, даже они могут быть быстрее join(readfile).
endfunction
"{{{2 main: destruct
"{{{3 main.destruct: выгрузить плагин
function s:F.main.destruct()
    unlet s:g
    unlet s:F
    return 1
endfunction
"{{{1
lockvar! s:g
unlockvar! s:g.out.option
lockvar! s:F
" vim: ft=vim:ts=8:fdm=marker:fenc=utf-8

