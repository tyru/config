if exists("b:__JAVA_XPT_VIM__")
  finish
endif
let b:__JAVA_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude 
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loop/java.like
      \ c/wrap

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT foreach hint=for\ \(\ ..\ :\ ..\ \)
for ( `type^ `var^ : `inWhat^ ) {
    `cursor^
}
..XPT

XPT class hint=class\ ..\ ctor
public class `className^ {
    public `className^( `ctorParam^^ ) {
        `cursor^
    }
}
..XPT

XPT main hint=main\ (\ String\ )
public static void main( String[] args )
{
    `cursor^
}
..XPT

XPT prop hint=var\ getVar\ ()\ setVar\ ()
`type^ `varName^;

`get...^public \`\^R("type")\^ get\`\^S(R("varName"),".","\\u&","")\^()
    { return \`\^R("varName")\^; }^^

`set...^public void set\`\^S(R("varName"),".","\\u&","")\^( \`\^R("type")\^ val )
    { \`\^R("varName")\^ = val; }^^
..XPT

XPT try hint=try\ ..\ catch\ (..)\ ..\ finally
try
{
    `what^
}`...^
catch (`except^ e)
{
    `handler^
}`...^
`catch...^catch (Exception e)
{
    \`\^
}^^
`finally...^finally
{
    \`cursor\^
}^^

..XPT

