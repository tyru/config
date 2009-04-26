if exists("b:__JAVALIKE_XPT_VIM__")
  finish
endif
let b:__JAVALIKE_XPT_VIM__ = 1


call XPTemplate("for", ""
      \."for (`^int^ `i^ = `0^; `i^ < `len^; ++`i^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("forr", ""
      \."for (`^int^ `i^ = `n^; `i^ >`^=^ `end^; --`i^){\n"
      \."  `cursor^\n"
      \."}")
