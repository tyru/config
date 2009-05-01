if exists("b:___CONDITION_C_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_C_LIKE_XPT_VIM__ = 1


let s:f = g:XPTfuncs()
let s:v = g:XPTvars()


call XPTemplatePriority('like')
call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$INDENT_HELPER' : ';'})


XPTemplateDef


XPT if		hint=if\ (..)\ {..}\ else...
if (`condi^) { 
  `_^ 
} 
`else...^else { 
  \`cursor\^ 
}^^


XPT ifn		hint=if\ ($NULL\ ==\ ..)\ {..}\ else...
if (`$NULL^ == `var^) { 
  `_^ 
} 
`else...^else { 
  \`cursor\^ 
}^^


XPT ifnn	hint=if\ ($NULL\ !=\ ..)\ {..}\ else...
if (`$NULL^ != `var^) { 
  `_^ 
} 
`else...^else { 
  \`cursor\^ 
}^^


XPT if0		hint=if\ (0\ ==\ ..)\ {..}\ else...
if (0 == `var^) { 
  `_^ 
} 
`else...^else { 
  \`cursor\^ 
}^^


XPT ifn0	hint=if\ (0\ !=\ ..)\ {..}\ else...
if (0 != `var^) { 
  `_^ 
} 
`else...^else { 
  \`cursor\^ 
}^^


XPT ifee	hint=if\ (..)\ {..}\ elseif...
if (`condition^) {
   `_^
} 
`...^else if (`cond^R("condition")^) { 
  `_^
}`...^


XPT switch	hint=switch\ (..)\ {case..}
switch (`^) {
  case `_^ :
    `^
    break;
  `...^
  case `_^ :
    `^
    break;
  `...^ 

  `default...^default:
    \`cursor\^^^
}



