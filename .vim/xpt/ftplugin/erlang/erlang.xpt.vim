if exists("b:__ERLANG_XPT_VIM__")
  finish
endif
let b:__ERLANG_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate( "inc", "-include( \"`cursor^^.hrl\")." )
call XPTemplate( "def", "-define( `what^, `def^ )." )
call XPTemplate( "ifdef", [
      \ '-ifdef( `what^ ).',
      \ '  `thenmacro^',
      \ '`else...^-else.',
      \ '  \`cursor\^^^',
      \ '-endif().',
      \ '',
      \ '' ] )

call XPTemplate( 'ifndef', [
      \ '-ifndef( `what^ ).',
      \ '  `thenmacro^',
      \ '`else...^-else.',
      \ '  \`cursor\^^^',
      \ '-endif().',
      \ '' ] )

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

call XPTemplate( 'case', [
      \'case `matched^ of',
      \'   `pattern^ ->',
      \'       `body^ `...^;',
      \'   `patternn^ ->',
      \'       `bodyn^`...^',
      \'end `cursor^',
      \''])

call XPTemplate( 'rcv', [
      \'receive',
      \'   `pattern^ ->',
      \'       `body^ `...^;',
      \'   `patternn^ ->',
      \'       `bodyn^`...^',
      \'`after...^after',
      \'    \`afterBody\^^^',
      \'end',
      \''])


call XPTemplate( "receive", [
      \'receive',
      \'   `pattern^ ->',
      \'       `body^ `...^;',
      \'   `patternn^ ->',
      \'       `bodyn^`...^',
      \'`after...^after',
      \'    \`afterBody\^^^',
      \'end',
      \''])

call XPTemplate( "fun", [
      \"fun (`params^) `^ -> `body^ `...^;",
      \"(`paramsn^) `^ -> `bodyn^`...^",
      \"end `cursor^",
      \"" ])

call XPTemplate( 'try', [
      \ 'try `what^',
      \ 'catch',
      \ '    `excep^ -> `toRet^ `...^;',
      \ '    `except^ -> `toRet^`...^',
      \ '`after...^after',
      \ '    \`afterBody\^^^',
      \ 'end `cursor^',
      \ '' ] )

call XPTemplate( 'tryof', [
      \ 'try `what^ of',
      \ '   `pattern^ ->',
      \ '       `body^ `...0^;',
      \ '   `patternn^ ->',
      \ '       `bodyn^`...0^',
      \ 'catch',
      \ '    `excep^ -> `toRet^ `...1^;',
      \ '    `except^ -> `toRet^`...1^',
      \ '`after...^after',
      \ '    \`afterBody\^^^',
      \ 'end `cursor^',
      \ '' ] )

call XPTemplate( 'function', [
      \ '`funName^ ( `args0^ ) `^ ->',
      \ '    `body0^ `...^;',
      \ '`name^R('funName')^ ( `argsn^ ) `^ ->',
      \ '    `bodyn^`...^',
      \ '.',
      \ '' ])

