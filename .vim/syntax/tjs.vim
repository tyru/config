
if v:version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif


" TODO
runtime! syntax/javascript.vim



let b:current_syntax = 'tjs'
