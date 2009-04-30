if exists("b:__PS1_XPT_VIM__")
    finish
endif
let b:__PS1_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _condition/perl.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef
XPT cmdlet hint=cmdlet\ ..-..\ {}
Cmdlet `verb^-`noun^
{
    `Param...^Param\(
       \`\^
    \)^^
    `Begin...^Begin
    {
    }^^
    Process
    {
    }
    `End...^End
    {
    }^^
}

..XPT

XPT fun hint=function\ ..(..)\ {\ ..\ }
function `funName^( `params^ )
{
   `cursor^
}
..XPT

XPT function hint=function\ {\ BEGIN\ PROCESS\ END\ }
function `funName^( `params^ )
{
    `Begin...^Begin
    {
        \`\^
    }^^
    `Process...^Process
    {
        \`\^
    }^^
    `End...^End
    {
        \`\^
    }^^
}
..XPT

XPT foreach hint=foreach\ (..\ in\ ..)
foreach ($`var^ in `other^)
    { `cursor^ }
..XPT

XPT switch hint=switch\ (){\ ..\ {..}\ }
switch `option^^ (`what^)
{
 `pattern^ { `action^ }`...^
 `pattern^ { `action^ }`...^
 `Default...^Default { \`action\^ }^^
}
..XPT

XPT trap hint=trap\ [..]\ {\ ..\ }
trap [`exception^Exception^]
{
    `body^
}
..XPT

XPT for hint=for\ (..;..;++)
for ($`var^i^ = `init^; $`var^ -ge `val^; $`var^--)
{
    `cursor^
}
..XPT

XPT forr hint=for\ (..;..;--)
for ($`var^i^ = `init^; $`var^ -ge `val^; $`var^--)
{
    `cursor^
}
..XPT

