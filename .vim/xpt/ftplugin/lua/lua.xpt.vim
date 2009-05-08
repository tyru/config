if exists("b:__LUA_XPT_VIM__")
  finish
endif
let b:__LUA_XPT_VIM__ = 1



" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Variables =============================

" ================================= Snippets ===================================

XPTemplateDef

XPT do hint=do\ ...\ end
do
`cursor^
end

XPT fn hint=function\ \\(..) .. end
function () `cursor^ end

XPT for hint=for\ ..=..,..\ do\ ...\ end
for `var^=`start^, `end^ `step...^,\`step\^^^ do
`cursor^
end

XPT forin hint=for\ ..\ in\ ..\ do\ ...\ end
for `var^ in `expr^ do
`cursor^
end

XPT forip hint=for\ ..,..\ in\ ipairs\\(..)\ do\ ...\ end
for `var1^i^,`var2^v^ in ipairs(`table^) do
`cursor^
end

XPT forp hint=for\ ..,..\ in\ pairs\\(..)\ do\ ...\ end
for `var1^k^,`var2^v^ in pairs(`table^) do
`cursor^
end

XPT fun hint=function\ ..\\(..)\ ..\ end
function `name^(`args^)
`cursor^
end

XPT if hint=if\ ..\ then\ ..\ else\ ..\ end
if `cond^ then
`_^ `...^
elseif `condn^ then
`_n^ `...^
`else...^else
\`cursor\^^^
end

XPT locf hint=local\ function\ ..\\(..)\ ...\ end
local function `name^(`args^)
`cursor^
end

XPT locv hint=local\ ..\ =\ ..
local `var^ = `cursor^

XPT p hint=print\\(..)
print(`cursor^)

XPT repeat hint=repeat\ ..\ until\ ..
repeat
`_^
until `cursor^

XPT tab hint={\ ...\ }
{
`var^ = `_^^ `...^,
`var^ = `_^^ `...^
}

XPT while hint=while\ ..\ do\ ...\ end
while `cond^ do
`cursor^
end
