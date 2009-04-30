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
XPTemplateDef

XPT inc hint=-include\ ..
-include( \"`cursor^^.hrl\").
..XPT

XPT def hint=-define\ ..
-define( `what^, `def^ ).
..XPT

XPT ifdef hint=-ifdef\ ..\-endif..
-ifdef( `what^ ).
  `thenmacro^
`else...^-else.
  \`cursor\^^^
-endif().
..XPT

XPT ifndef hint=-ifndef\ ..\-endif
-ifndef( `what^ ).
  `thenmacro^
`else...^-else.
  \`cursor\^^^
-endif().
..XPT

XPT record hint=-record\ ..,{..}
-record( `recordName^
       ,{ `field1^`...^
        , `fieldn^`...^
        }).
..XPT

XPT if hint=if\ ..\ ->\ ..\ end
if
   `cond^ ->
       `body^`...^;
   `cond2^ ->
       `bodyn^`...^
end `cursor^
..XPT

XPT case hint=case\ ..\ of\ ..\ ->\ ..\ end
case `matched^ of
   `pattern^ ->
       `body^`...^;
   `patternn^ ->
       `bodyn^`...^
end `cursor^
..XPT

XPT rcv hint=receive\ ..\ ->\ ..\ end
receive
   `pattern^ ->
       `body^ `...^;
   `patternn^ ->
       `bodyn^`...^`after...^
after
    \`afterBody\^^^
end
..XPT


XPT receive hint=receive\ ..\ ->\ ..\ end
receive
   `pattern^ ->
       `body^ `...^;
   `patternn^ ->
       `bodyn^`...^`after...^
after
    \`afterBody\^^^
end
..XPT

XPT fun hint=fun\ ..\ ->\ ..\ end
fun (`params^) `^ -> `body^ `...^;
    (`paramsn^) `^ -> `bodyn^`...^
end `cursor^
..XPT

XPT try hint=try\ ..\ catch\ ..\ end
try `what^
catch
    `excep^ -> `toRet^ `...^;
    `except^ -> `toRet^`...^
`after...^after
    \`afterBody\^^^
end `cursor^
..XPT

XPT tryof hint=try\ ..\ of\ ..
try `what^ of
   `pattern^ ->
       `body^ `...0^;
   `patternn^ ->
       `bodyn^`...0^
catch
    `excep^ -> `toRet^ `...1^;
    `except^ -> `toRet^`...1^
`after...^after
    \`afterBody\^^^
end `cursor^
..XPT

XPT function hint=f\ \(\ ..\ \)\ ->\ ..
`funName^ ( `args0^ ) `^ ->
    `body0^ `...^;
`name^R('funName')^ ( `argsn^ ) `^ ->
    `bodyn^`...^
.
..XPT

