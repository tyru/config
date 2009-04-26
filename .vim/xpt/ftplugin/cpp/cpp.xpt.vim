if exists("b:__CPP_XPT_VIM__")
  finish
endif
let b:__CPP_XPT_VIM__ = 1

runtime ftplugin/_common/common.xpt.vim
runtime ftplugin/_loop/javalike.xpt.vim

runtime ftplugin/c/c.xpt.vim
runtime ftplugin/c/wrap.xpt.vim

call XPTemplate( "namespace", [
      \ "namespace `name^",
      \ "{",
      \ "    `cursor^",
      \ "}",
      \ "" ])

call XPTemplate( "class", [
      \ "class `className^",
      \ "{",
      \ "public:",
      \ "    `className^( `ctorParam^ );",
      \ "    ~`className^();",
      \ "    `className^( const `className^ &cpy );",
      \ "    `cursor^",
      \ "private:",
      \ "};",
      \ " ",
      \ "\/\/ Scratch implementation",
      \ "\/\/ feel free to copy/paste or destroy",
      \ "`className^::`className^( `ctorParam^ )",
      \ "{",
      \ "}",
      \ " ",
      \ "`className^::~`className^()",
      \ "{",
      \ "}",
      \ " ",
      \ "`className^::`className^( const `className^ &cpy )",
      \ "{",
      \ "}",
      \ "" ])

let s:f = g:XPTfuncs()
let s:v = g:XPTvars()

" just to avoid evaluation order problem
let s:v['$cppCleanTemplate'] = ''

function! s:f.cppSaveTemplate( ... )
    let ctx = self._ctx
    let notypename = substitute( ctx.value,"\\s*typename\\s*","","g" )
    let cleaned = substitute( notypename, "\\s*class\\s*", "", "g" )
    let s:v['$cppCleanTemplate'] = cleaned
    return ctx.value
endfunction

function! s:f.cppReload( ... )
    return s:v['$cppCleanTemplate']
endfunction

call XPTemplate( "templateclass", [
               \ "template",
               \ "    <`templateParam^cppSaveTemplate('.')^^>",
               \ "class `className^",
               \ "{",
               \ "public:",
               \ "    `className^( `ctorParam^ );",
               \ "    ~`className^();",
               \ "    `className^( const `className^ &cpy );",
               \ "    `cursor^",
               \ "private:",
               \ "};",
               \ " ",
               \ "\/\/ Scratch implementation",
               \ "\/\/ feel free to copy/paste or destroy",
               \ "template <`templateParam^>",
               \ "`className^<`^cppReload('.')^^>::`className^( `ctorParam^ )",
               \ "{",
               \ "}",
               \ " ",
               \ "template <`templateParam^>",
               \ "`className^<`^cppReload('.')^^>::~`className^()",
               \ "{",
               \ "}",
               \ " ",
               \ "template <`templateParam^>",
               \ "`className^<`^cppReload('.')^^>::`className^( const `className^ &cpy )",
               \ "{",
               \ "}",
               \ "" ])

