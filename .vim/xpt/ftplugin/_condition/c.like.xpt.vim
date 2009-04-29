if exists("b:___CONDITION_C_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_C_LIKE_XPT_VIM__ = 1


let s:f = g:XPTfuncs()
let s:v = g:XPTvars()


call XPTemplatePriority('like')
call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL'})



XPTemplateDef


XPT if		hint=if\ (..)\ {..}\ else...
if (`condi^) {', 
  `_^', 
}', 
`else...^else {', 
  \`cursor\^', 
}^^'
..XPT


XPT ifn		hint=if\ ($NULL\ ==\ ..)\ {..}\ else...
if (`$NULL^ == `var^) {', 
  `_^', 
}', 
`else...^else {', 
  \`cursor\^', 
}^^'
..XPT


XPT ifnn	hint=if\ ($NULL\ !=\ ..)\ {..}\ else...
if (`$NULL^ != `var^) {', 
  `_^', 
}', 
`else...^else {', 
  \`cursor\^', 
}^^'
..XPT


XPT if0		hint=if\ (0\ ==\ ..)\ {..}\ else...
if (0 == `var^) {', 
  `_^', 
}', 
`else...^else {', 
  \`cursor\^', 
}^^'
..XPT


XPT ifn0	hint=if\ (0\ !=\ ..)\ {..}\ else...
if (0 != `var^) {', 
  `_^', 
}', 
`else...^else {', 
  \`cursor\^', 
}^^'
..XPT


XPT ifee	hint=if\ (..)\ {..}\ elseif...
if (`condition^) {
   `_^
}', 
`...^else if (`cond^R("condition")^) {', 
  `_^
}`...^'
..XPT


XPT switch	hint=switch\ (..)\ {case..}
switch (`^) {
  case `_^ :
    `^
    break;
  `...^', 
  case `_^ :
    `^
    break;
  `...^', 

`default...^default:
    \`cursor\^^^
}'
..XPT

