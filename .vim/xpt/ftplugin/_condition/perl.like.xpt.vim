if exists("b:___CONDITION_PERL_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_PERL_LIKE_XPT_VIM__ = 1


XPTvar $BODY    # some code here ...


call XPTemplatePriority('like')

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef


XPT if hint=if\ (..)\ {\ ..\ }\ ...
XSET body=$BODY
XSET body2=$BODY
XSET body3=$BODY
if (`cond^) {
    `body^
}``...^ elsif (`cond2^) {
    `body2^
}``...^``else...^ else {
    \`body3\^
}^^
