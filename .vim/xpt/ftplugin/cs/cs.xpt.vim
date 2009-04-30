if exists('b:__CS_XPT_VIM__')
  finish
endif
let b:__CS_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude 
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loops/java.like
      \ c/wrap

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT foreach hint=foreach\ (..\ in\ ..)\ {..}
foreach ( `var^var^ `e^ in `what^ )
{
    `cursor^
}
..XPT

XPT class hint=class\ +ctor
class `className^
{
    public `className^( `ctorParam^^ )
    {
        `cursor^
    }
}
..XPT

XPT main hint=static\ main\ string[]
public static void Main( string[] args )
{
    `cursor^
}
..XPT

XPT prop hint=..\ ..\ {get\ set}
public `type^ `Name^
{`get...^
    get { return \`what\^; }^^`set...^
    set { \`what\^ = value; }^^
}
..XPT

XPT namespace hint=namespace\ {}
namespace `name^
{
    `cursor^
}
..XPT

XPT try hint=try\ ..\ catch\ ..\ finally
try
{
    `what^
}`...^
catch (`except^ e)
{
    `handler^
}`...^`catch...^
catch
{
    \`_\^
}^^`finally...^
finally
{
    \`cursor\^
}^^

..XPT

