if exists("b:__CS_XPT_VIM__")
  finish
endif
let b:__CS_XPT_VIM__ = 1

runtime ftplugin/_common/common.xpt.vim
runtime ftplugin/c/c.xpt.vim
runtime ftplugin/c/wrap.xpt.vim
runtime ftplugin/_loop/java.like.xpt.vim

call XPTemplate( "foreach", [
       \"foreach ( `var^var^ `e^ in `what^ )",
       \"{",
       \"    `cursor^",
       \"}"
       \])

call XPTemplate( "class", [
    \ "class `className^",
    \ "{",
    \ "    public `className^( `ctorParam^^ )",
    \ "    {",
    \ "        `cursor^",
    \ "    }",
    \ "}"
    \ ])

call XPTemplate( "main", [
    \ "public static void Main( string[] args )",
    \ "{",
    \ "    `cursor^",
    \ "}"
    \ ])

call XPTemplate( "prop", [
    \ "public `type^ `Name^",
    \ "{",
    \ "    get { return `what^; }",
    \ "    set { `what^ = value; }",
    \ "}"
    \ ])

call XPTemplate( "namespace", [
               \ "namespace `name^",
               \ "{",
               \ "    `cursor^",
               \ "}",
               \ "" ])

