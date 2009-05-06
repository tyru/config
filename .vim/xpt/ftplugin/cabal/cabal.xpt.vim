if exists("g:__CABAL_XPT_VIM__")
    finish
endif
let g:__CABAL_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT infos hint=Name:\ Version\: Synopsys:\ Descr:\ Author:\ ...
Name:       `name^
Version:    `ver^
Synopsis:   `synop^ 
Build-Type: `Simple^
Cabal-Version: >= `v^1.2^`Description...^
Description: \`_\^ ^^`Author...^
Author: \`_\^^^`Maintainer...^
Maintainer: \`_\^ ^^

XPT if hint=if\ ...\ else\ ...
if `cond^
    `what^
`else...^else
    \`cursor\^^^


XPT lib hint=library\ Exposed-Modules...
library
  Exposed-Modules: `_^^`...0^
                   `_^^`...0^
  Build-Depends: base >= `ver^2.0^`...1^, `_^^`...1^

XPT exe hint=Main-Is:\ ..\ Build-Depends
Executable `execName^
    Main-Is: `mainFile^
    Build-Depends: base >= `ver^2.0^`...1^, `_^^`...1^

