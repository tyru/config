" Vim syntax file
" Language:     YAML
" Maintainer:   motemen <motemen@gmail.com>
" Version:	20070822

syntax clear

if !exists('g:yaml_syntax_highlight_numbers')
    let g:yaml_syntax_highlight_numbers = 0
endif

syn match  yamlValue contained +\s*\%(#.*\)\?+ contains=yamlComment nextgroup=yamlType,yamlLabel,yamlFlowMap,yamlFlowSeq,yamlBool,yamlNull,yamlTextBlock,yamlString,yamlTimestamp,yamlInt,yamlFloat,yamlPlainString

" Plain string
syn match  yamlPlainString       contained +.\++
syn match  yamlPlainStringInFlow contained +[^}\],]\++

" Number
if g:yaml_syntax_highlight_numbers
    syn match  yamlInt contained /[-+]\?\%(0\|[1-9][0-9_]*\)\+\%(\.\|[0-9]\)\@!/
    syn match  yamlInt contained /[-+]\?0b[0-1_]\+/
    syn match  yamlInt contained /[-+]\?0[0-7_]\+/
    syn match  yamlInt contained /[-+]\?0x[0-9a-fA-F_]\+/
    syn match  yamlInt contained /[-+]\?[1-9][0-9_]*\%(:[0-5]\?[0-9]\)\+/
    syn match  yamlFloat contained /[-+]\?\%([0-9][0-9_]*\)\?\.[0-9_]\+\%([eE][-+][0-9]\+\)\?\%(\.\|[0-9]\)\@!/
    syn match  yamlFloat contained /[-+]\?[0-9][0-9_]*\%(:[0-5]\?[0-9]\)\+\.[0-9_]*/
endif
syn match  yamlFloat contained /[-+]\?\.\%(inf\|Inf\|INF\)\s*\%(#.*\)\?$/
syn match  yamlFloat contained /\.\%(nan\|NaN\|NAN\)\s*\%(#.*\)\?$/

" Timestamp
syn match  yamlTimestamp contained /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/
syn match  yamlTimestamp contained /[0-9][0-9][0-9][0-9]-[0-9][0-9]\?-[0-9][0-9]\?\%([Tt]\|[ \t]\+\)[0-9][0-9]\?:[0-9][0-9]:[0-9][0-9]\%(\.[0-9]*\)\?\%([ \t]*Z\|[-+][0-9][0-9]\?\%(:[0-9][0-9]\)\?\)\?/

" Flow sequence
syn region yamlFlowSeq matchgroup=Delimiter start=+\[+ end=+\]+ contains=yamlKeyInFlow,yamlQuotedKeyInFlow,yamlComma

" Flow mapping
syn region yamlFlowMap matchgroup=Delimiter start=+{+ end=+}+ contains=yamlKeyInFlow,yamlQuotedKeyInFlow,yamlComma

" Flow mapping/sequence
syn match  yamlComma +,+

syn match  yamlKeyColonInFlow  contained +:+ nextgroup=yamlValueInFlow
syn match  yamlValueInFlow     contained +\s*+ nextgroup=yamlTypeInFlow,yamlFlowMap,yamlFlowSeq,yamlConstant,yamlTextBlock,yamlString,yamlPlainStringInFlow
syn match  yamlKeyInFlow       contained +[^,#'" ][^}\]]\{-}\ze:+ nextgroup=yamlKeyColonInFlow
syn region yamlQuotedKeyInFlow contained matchgroup=String start=+"+rs=e skip=+\\"+ end=+"\s*\ze:+ contains=yamlEscape nextgroup=yamlKeyColonInFlow
syn region yamlQuotedKeyInFlow contained matchgroup=String start=+'+rs=e skip=+''+  end=+'\s*\ze:+ contains=yamlSingleEscape nextgroup=yamlKeyColonInFlow

" Block mapping
syn match  yamlKeyColon  +:+ nextgroup=yamlValue
syn match  yamlKey       +[^#'"{\[ ]\%(.\)\{-}\ze:\%( \|$\)+ nextgroup=yamlKeyColon
syn region yamlQuotedKey matchgroup=String start=+"+rs=e skip=+\\"+ end=+"\s*\ze:+ contains=yamlEscape       nextgroup=yamlKeyColon
syn region yamlQuotedKey matchgroup=String start=+'+rs=e skip=+''+  end=+'\s*\ze:+ contains=yamlSingleEscape nextgroup=yamlKeyColon
syn region yamlKey matchgroup=Delimiter start=+?+ end=+:+rs=e-1 contains=yamlValue nextgroup=yamlKeyColon

" Block sequence
syn match  yamlSeqMark   +-\s*+ nextgroup=yamlValue,yamlKey

" Label
syn match  yamlLabel contained +[*&]\S\++

" Comment
syn keyword yamlTodo    contained TODO FIXME XXX NOTE
syn match   yamlComment +#.*+ contains=yamlTodo
syn region  yamlComment start=+^\.\.\.+ end=+\%$+ contains=yamlTodo

" String
syn region yamlString       contained start=+"+ skip=+\\"+ end=+"+ contains=yamlEscape
syn region yamlString       contained start=+'+ skip=+''+  end=+'+ contains=yamlSingleEscape
syn match  yamlEscape       contained +\\[\\"abefnrtv^0_ NLP]+
syn match  yamlEscape       contained '\\x\x\{2}'
syn match  yamlEscape       contained '\\u\x\{4}'
syn match  yamlEscape       contained '\\U\x\{8}'
syn match  yamlEscape       contained '\\\%(\r\n\|[\r\n]\)'
syn match  yamlSingleEscape contained +''+

" Type
syn match  yamlType +!\S*+ nextgroup=yamlValue

" Block style
syn region yamlTextBlock start=/[|>][+-]\?\%([1-9]\d*\)\?\n\z\( \+\)/ end=/^\%(\z1\|$\)\@!/

" Constant
syn match  yamlBool     +\%(y\|Y\|yes\|Yes\|YES\|n\|N\|no\|No\|NO\|true\|True\|TRUE\|false\|False\|FALSE\|on\|On\|ON\|off\|Off\|OFF\)\ze\s*\%(#.*\)\?$+ contained
syn match  yamlNull     +\%(null\|\~\)\ze\s*\%(#.*\)\?$+ contained

" Directive
syn match  yamlDirective +^%[^#]*\%(#.*\)\?$+ contains=yamlComment
syn match  yamlDocHeader +^---\s*+

highlight link yamlTodo            TODO
highlight link yamlComment         Comment
highlight link yamlKeyColon        Delimiter
highlight link yamlKeyColonInFlow  Delimiter
highlight link yamlSeqMark         Delimiter
highlight link yamlKey             Identifier
highlight link yamlQuotedKey       Identifier
highlight link yamlKeyInFlow       Identifier
highlight link yamlQuotedKeyInFlow Identifier
highlight link yamlBool            Constant
highlight link yamlNull            Constant
highlight link yamlTextBlock       String
highlight link yamlType            Type
highlight link yamlDocHeader       Statement
highlight link yamlDirective       PreProc
highlight link yamlLabel           Label
highlight link yamlInt             Number
highlight link yamlFloat           Number


let b:current_syntax = "yaml"
