if exists("b:___COMMENT_XML_LIKE_XPT_VIM__")
  finish
endif
let b:___COMMENT_XML_LIKE_XPT_VIM__ = 1


runtime ftplugin/_comment/pattern.xpt.vim


let s:v = g:XPTvars()

call extend(s:v, {'$CL': '<!--', '$CM' : '' , '$CR' : '-->', '$CS' : ''})

