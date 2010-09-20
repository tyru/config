
if v:version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif



syn case match


syn match kirikiriScenarioLineComment "^\t*;.*$"
syn match kirikiriScenarioLabel       "^\t*\*.*$"


syn match kirikiriScenarioCommandLine "^\t*\[[^\[\]]\+\][ \t]*$" contains=kirikiriScenarioCommandTag,kirikiriScenarioCommandParameters
syn match kirikiriScenarioCommandLine "^\t*@.*$" contains=kirikiriScenarioCommandTag,kirikiriScenarioCommandParameters

syn match kirikiriScenarioCommandTag  "^\t*\[[ \t]*\zs\w\+" contained nextgroup=kirikiriScenarioCommandParameters
syn match kirikiriScenarioCommandTag  "^\t*@\zs\w\+" contained nextgroup=kirikiriScenarioCommandParameters


syn match kirikiriScenarioCommandParameters /\w\+=\%(\w\+\|"[^"]*"\|'[^']*'\)/ contained skipwhite contains=kirikiriScenarioCommandParametersKey,kirikiriScenarioCommandParametersEqual,kirikiriScenarioCommandParametersValue,kirikiriScenarioString,kirikiriScenarioBoolean

syn match kirikiriScenarioCommandParametersKey "\w\+\ze=" contained skipwhite nextgroup=kirikiriScenarioCommandParametersEqual
syn match kirikiriScenarioCommandParametersEqual "=" contained nextgroup=kirikiriScenarioCommandParametersValue,kirikiriScenarioString,kirikiriScenarioBoolean
syn match kirikiriScenarioCommandParametersValue "=\zs\w\+" contained

syn region kirikiriScenarioString start=/"/ end=/"/
syn region kirikiriScenarioString start=/'/ end=/'/

syn keyword kirikiriScenarioBoolean true false




if v:version >= 508 || !exists("did_kirikiriscenario_syn_inits")
    if v:version < 508
        let did_kirikiriscenario_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink kirikiriScenarioLineComment Comment
    HiLink kirikiriScenarioLabel       Label

    HiLink kirikiriScenarioCommandLine           Identifier
    HiLink kirikiriScenarioCommandTag            Identifier
    HiLink kirikiriScenarioCommandParametersKey  Type

    HiLink kirikiriScenarioString    String
    HiLink kirikiriScenarioBoolean   Boolean

    delcommand HiLink
endif



let b:current_syntax = 'kirikiriscenario'
