
if v:version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif



syn case match
syn match GrassProgram /.*/ contains=GrassLeafSmallW,GrassLeafW,GrassLeafV,GrassComment
syn match GrassLeafSmallW /[wｗ]/ contained
syn match GrassLeafW /[WＷ]/ contained
syn match GrassLeafV /[vｖ]/ contained
syn match GrassComment /[^wｗWＷvｖ]\+/ contained

hi GrassLightGreen guifg=#00ff00
hi GrassGreen guifg=#00aa00
hi GrassDarkGreen guifg=#006600



if v:version >= 508 || !exists("did_grass_syn_inits")
    if v:version < 508
        let did_grass_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
    HiLink GrassLeafSmallW GrassLightGreen
    HiLink GrassLeafW GrassGreen
    HiLink GrassLeafV GrassDarkGreen
    HiLink GrassComment Comment
    delcommand HiLink
endif



let b:current_syntax = 'grass'
