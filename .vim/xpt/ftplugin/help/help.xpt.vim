runtime ftplugin/_common/common.xpt.vim

call XPTemplate('ln', [
      \ '=============================================================================='
      \])

call XPTemplate('fmt', [
      \ 'vim:tw=78:ts=8:sw=8:sts=8:noet:ft=help:norl:'
      \])

call XPTemplate('q', [
      \ ': >',
      \ '	    `cursor^',
      \ '<'
      \])
call XPTemplate('r', [
      \ '|`content^|'
      \])
