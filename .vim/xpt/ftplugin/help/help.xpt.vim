if exists("b:__HELP_XPT_VIM__")
  finish
endif
let b:__HELP_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT ln hint=\ ========...
==============================================================================
..XPT

XPT fmt hint=vim:\ options...
vim:tw=78:ts=8:sw=8:sts=8:noet:ft=help:norl:
..XPT

XPT q hint=:\ >\ ...\ <
: >
	    `cursor^
<
..XPT

XPT r hint=|...|
|`content^|
..XPT
