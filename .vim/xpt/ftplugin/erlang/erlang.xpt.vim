if exists("b:__ERLANG_XPT_VIM__")
  finish
endif
let b:__ERLANG_XPT_VIM__ = 1


call XPTemplate( "inc", "-include( \"`cursor^^.hrl\")." )
call XPTemplate( "def", "-define( `what^, `def^ )." )
call XPTemplate( "ifdef", [
      \ "-ifdef( `what^ ).",
      \ "  `thenmacro^ `...^",
      \ "-else.",
      \ "  `elsemacro^`...^",
      \ "-endif().",
      \ "" ] )

call XPTemplate( "ifndef", [
      \ "-ifndef( `what^ ).",
      \ "  `thenmacro^ `...^",
      \ "-else.",
      \ "  `elsemacro^`...^",
      \ "-endif().",
      \ "" ] )

call XPTemplate( "record", [
      \ "-record( `recordName^",
      \ "       ,{ `field1^ `...^",
      \ "        , `fieldn^`...^",
      \ "        }).",
      \ "" ] )

call XPTemplate( "if", [
      \"if",
      \"   `cond^ ->",
      \"       `body^ `...^;",
      \"   `cond2^ ->",
      \"       `bodyn^`...^",
      \"end `cursor^",
      \""])

call XPTemplate( "case", [
      \"case `matched^ of",
      \"   `pattern^ ->",
      \"       `body^ `...^;",
      \"   `patternn^ ->",
      \"       `bodyn^`...^",
      \"end `cursor^",
      \""])

call XPTemplate( "rcv", [
      \"receive",
      \"   `pattern^ ->",
      \"       `body^ `...^;",
      \"   `patternn^ ->",
      \"       `bodyn^`...^",
      \"end `cursor^",
      \""])


call XPTemplate( "receive", [
      \"receive",
      \"   `pattern^ ->",
      \"       `body^ `...^;",
      \"   `patternn^ ->",
      \"       `bodyn^`...^",
      \"end `cursor^",
      \""])

call XPTemplate( "fun", [
      \"fun (`params^) `^ -> `body^ `...^;",
      \"(`paramsn^) `^ -> `bodyn^`...^",
      \"end `cursor^",
      \"" ])

call XPTemplate( "try", [
      \ "try `what^",
      \ "catch",
      \ "    `excep^ -> `toRet^ `...^;",
      \ "    `except^ -> `toRet^`...^",
      \ "end `cursor^",
      \ "" ] )

call XPTemplate( "tryof", [
      \ "try `what^ of",
      \ "   `pattern^ ->",
      \ "       `body^ `...0^;",
      \ "   `patternn^ ->",
      \ "       `bodyn^`...0^",
      \ "catch",
      \ "    `excep^ -> `toRet^ `...1^;",
      \ "    `except^ -> `toRet^`...1^",
      \ "end `cursor^",
      \ "" ] )

let s:f = g:XPTfuncs()
let s:v = g:XPTvars()

function! s:f.erlSaveName( ... )
    let s:v['$erlFunName'] = self._ctx.value
    return self._ctx.value
endfunction

call XPTemplate( "function", [
      \ "`fName^erlSaveName('.')^^ ( `args0^ ) `^ ->",
      \ "    `body0^ `...^;",
      \ "`$erlFunName^ ( `argsn^ ) `^ ->",
      \ "    `bodyn^`...^",
      \ ".",
      \ "" ])

