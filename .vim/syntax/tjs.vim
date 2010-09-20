
if v:version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif



syn case match


syn keyword tjsReservedWords break continue const catch class case
syn keyword tjsReservedWords debugger default delete do extends export
syn keyword tjsReservedWords enum else function finally false for
syn keyword tjsReservedWords global getter goto incontextof Infinity
syn keyword tjsReservedWords invalidate instanceof isvalid import int in
syn keyword tjsReservedWords if NaN null new octet protected property
syn keyword tjsReservedWords private public return real synchronized switch
syn keyword tjsReservedWords static setter string super typeof throw
syn keyword tjsReservedWords this true try void var while with


syn region tjsDictionaryLiteral start="%\[" end="\]"
syn region tjsArrayLiteral      start="\[" end="\]"




if v:version >= 508 || !exists("did_tjs_syn_inits")
    if v:version < 508
        let did_tjs_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink tjsReservedWords Identifier
    HiLink tjsDictionaryLiteral Identifier
    HiLink tjsArrayLiteral Identifier

    delcommand HiLink
endif



let b:current_syntax = 'tjs'
