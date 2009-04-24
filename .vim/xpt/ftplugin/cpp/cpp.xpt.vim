call XPTemplate( "class", [
      \ "class `className^",
      \ "{",
      \ "public:",
      \ "    `className^();",
      \ "    ~`className^();",
      \ "    `cursor^",
      \ "private:",
      \ "};",
      \ ""]) 
