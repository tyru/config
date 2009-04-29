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
call XPTemplate( "foreach", [
      \ "for ( `type^ `var^ : `inWhat^ ) {",
      \ "    `cursor^",
      \ "}"
      \ ])

call XPTemplate( "class", [
      \ "public class `className^ {",
      \ "    public `className^( `ctorParam^^ ) {",
      \ "        `cursor^",
      \ "    }",
      \ "}"
      \ ])

call XPTemplate( "main", [
      \ "public static void main( String[] args )",
      \ "{",
      \ "    `cursor^",
      \ "}"
      \ ])

call XPTemplate('prop', [
      \ '`type^ `varName^;',
      \ '',
      \ '`get...^public \`\^R("type")\^ get\`\^S(R("varName"),".","\\u&","")\^()',
      \ '    { return \`\^R("varName")\^; }^^',
      \ '',
      \ '`set...^public void set\`\^S(R("varName"),".","\\u&","")\^( \`\^R("type")\^ val )',
      \ '    { \`\^R("varName")\^ = val; }^^',
      \ ''])

call XPTemplate('try', [
      \ 'try',
      \ '{',
      \ '    `what^',
      \ '}`...^',
      \ 'catch (`except^ e)',
      \ '{',
      \ '    `handler^',
      \ '}`...^',
      \ '`catch...^catch (Exception e)',
      \ '{',
      \ '    \`\^',
      \ '}^^',
      \ '`finally...^finally',
      \ '{',
      \ '    \`cursor\^',
      \ '}^^',
      \ ''
      \])

