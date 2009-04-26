if exists("b:__JAVA_XPT_VIM__")
  finish
endif
let b:__JAVA_XPT_VIM__ = 1

runtime ftplugin/_comment_c_like/cmt.xpt.vim
runtime ftplugin/_loop/javalike.xpt.vim

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

