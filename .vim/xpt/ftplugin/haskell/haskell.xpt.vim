if exists( "b:__HASKELL_XPT_VIM__")
    finish
endif
let b:__HASKELL_XPT_VIM__ = 1

call XPTemplate( "class", [
    \ "class `className^ `types^ where",
    \ "    `ar^ :: `type^ `...^",
    \ "    `methodName^ :: `methodType^`...^",
    \ ""])

call XPTemplate( "classcom", [
    \ "-- | `classDescr^",
    \ "class `className^ `types^ where",
    \ "    -- | `methodDescr^",
    \ "    `ar^ :: `type^ `...^",
    \ "    -- | `method_Descr^",
    \ "    `methodName^ :: `methodType^`...^",
    \ ""])

call XPTemplate( "datasum", [
    \ "data `context^^ `typename^ `typeParams^^ =",
    \ "    `Constructor^ `ctorParams^^ `...^",
    \ "  | `Ctor^ `params^^`...^",
    \ "  `cursor^" ])

call XPTemplate( "datasumcom", [
    \ "-- | `typeDescr^^^",
    \ "data `context^^ `typename^ `typeParams^^ =",
    \ "    -- | `ConstructorDescr^^^",
    \ "    `Constructor^ `ctorParams^^ `...^",
    \ "    -- | `Ctor descr^^",
    \ "  | `Ctor^ `params^^`...^",
    \ "  `cursor^" ])

call XPTemplate( "datarecord", [
    \ "data `context^^ `typename^ `typeParams^^ =",
    \ "     `Constructor^ {",
    \ "       `field^ :: `type^ `...^",
    \ "     , `fieldn^ :: `typen^`...^",
    \ "     }",
    \ "     `cursor^"])

call XPTemplate( "datarecordcom", [
    \ "-- | `typeDescr^",
    \ "data `context^^ `typename^ `typeParams^^ =",
    \ "     `Constructor^ {",
    \ "       `field^ :: `type^^^ -- ^ `fieldDescr^ `...^",
    \ "     , `fieldn^ :: `typen^^^ -- ^ `fielddescr^`...^",
    \ "     }",
    \ "     `cursor^"])

call XPTemplate( "instance", [
    \ "instance `className^ `instanceTypes^ where",
    \ "    `methodName^ `^ = `decl^ `...^",
    \ "    `method^ `^ = `declaration^`...^",
    \ "" ])

call XPTemplate( "if", [
    \ "if `expr^",
    \ "    then `thenCode^",
    \ "    else `elseCode^",
    \ "" ])

let s:f = g:XPTfuncs()
let s:v = g:XPTvars()

function! s:f.hsSaveFunName(  ... )
    let s:v['$hsFunName'] = self._ctx.value
    return self._ctx.value
endfunction

function! s:f.hsLoadFunName( ... )
    return s:v['$hsFunName']
endfunction

" That's the best snippet ever.
" It can avoid SO much redundant (=> error prone) typing
" even in a terse language like haskell. It's nice :'-)
call XPTemplate('fun', [
            \ "`funName^hsSaveFunName('.')^^ `pattern^ = `def^`...^",
            \ '`$hsFunName^ `pattern^ = `def^`...^',
            \ '' ])

" Here the same, but for a more documented version...
" still very nice :)
call XPTemplate('funcom', [
            \ "-- | `function_description^",
            \ "`funName^hsSaveFunName('.')^^ :: `type^",
            \ "`f^hsLoadFunName('.')^ `pattern^ = `def^`...^",
            \ '`$hsFunName^ `pattern^ = `def^`...^',
            \ '' ])

