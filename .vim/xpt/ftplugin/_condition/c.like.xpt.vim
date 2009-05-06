if exists("b:___CONDITION_C_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_C_LIKE_XPT_VIM__ = 1


let s:f = g:XPTfuncs()
let s:v = g:XPTvars()


call XPTemplatePriority('like')
call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$INDENT_HELPER' : '/* void */;'}, 'keep')


XPTemplateDef


XPT if		hint=if\ (..)\ {..}\ else...
if (`condi^) `$BRACKETSTYLE^{ 
  `job^$INDENT_HELPER^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifn		hint=if\ ($NULL\ ==\ ..)\ {..}\ else...
if (`$NULL^ == `var^) `$BRACKETSTYLE^{ 
  `job^$INDENT_HELPER^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifnn	hint=if\ ($NULL\ !=\ ..)\ {..}\ else...
if (`$NULL^ != `var^) `$BRACKETSTYLE^{ 
  `job^$INDENT_HELPER^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT if0		hint=if\ (0\ ==\ ..)\ {..}\ else...
if (0 == `var^) `$BRACKETSTYLE^{ 
  `job^$INDENT_HELPER^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifn0	hint=if\ (0\ !=\ ..)\ {..}\ else...
if (0 != `var^) `$BRACKETSTYLE^{ 
  `job^$INDENT_HELPER^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifee	hint=if\ (..)\ {..}\ elseif...
if (`condition^) `$BRACKETSTYLE^{
  `job^$INDENT_HELPER^
} 
`...^\`$BRACKETSTYLE\^ else if (`cond^R("condition")^) `$BRACKETSTYLE^{ 
  `job^$INDENT_HELPER^
}
`...^


XPT switch	hint=switch\ (..)\ {case..}
switch (`var^) `$BRACKETSTYLE^{
  case `_^ :
    `job^$INDENT_HELPER^
    break;
  `...^
  case `_^ :
    `job^$INDENT_HELPER^
    break;
  `...^ 

  `default...^default:
    \`cursor\^^^
}

