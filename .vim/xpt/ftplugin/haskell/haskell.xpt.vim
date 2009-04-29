if exists( "b:__HASKELL_XPT_VIM__")
    finish
endif
let b:__HASKELL_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplate( 'class', [
    \ 'class `context^^ `className^ `types^ where',
    \ '    `ar^ :: `type^ `...^',
    \ '    `methodName^ :: `methodType^`...^',
    \ ''])

call XPTemplate( 'classcom', [
    \ '-- | `classDescr^',
    \ 'class `context^^ `className^ `types^ where',
    \ '    -- | `methodDescr^',
    \ '    `ar^ :: `type^ `...^',
    \ '    -- | `method_Descr^',
    \ '    `methodName^ :: `methodType^`...^',
    \ ''])

call XPTemplate( 'datasum', [
    \ 'data `context^^ `typename^ `typeParams^^ =',
    \ '    `Constructor^ `ctorParams^^ `...^',
    \ '  | `Ctor^ `params^^`...^',
    \ '  `deriving...^deriving (\`cursor\^)^^' ])

call XPTemplate( 'datasumcom', [
    \ '-- | `typeDescr^^^',
    \ 'data `context^^ `typename^ `typeParams^^ =',
    \ '    -- | `ConstructorDescr^^^',
    \ '    `Constructor^ `ctorParams^^ `...^',
    \ '    -- | `Ctor descr^^',
    \ '  | `Ctor^ `params^^`...^',
    \ '  `deriving...^deriving (\`cursor\^)^^' ])

call XPTemplate( 'datarecord', [
    \ 'data `context^^ `typename^ `typeParams^^ =',
    \ '     `Constructor^ {',
    \ '       `field^ :: `type^ `...^',
    \ '     , `fieldn^ :: `typen^`...^',
    \ '     }',
    \ '  `deriving...^deriving (\`cursor\^)^^'])

call XPTemplate( 'datarecordcom', [
    \ '-- | `typeDescr^',
    \ 'data `context^^ `typename^ `typeParams^^ =',
    \ '     `Constructor^ {',
    \ '       `field^ :: `type^^^ -- ^ `fieldDescr^ `...^',
    \ '     , `fieldn^ :: `typen^^^ -- ^ `fielddescr^`...^',
    \ '     }',
    \ '  `deriving...^deriving (\`cursor\^)^^'])

call XPTemplate( 'instance', [
    \ 'instance `className^ `instanceTypes^ where',
    \ '    `methodName^ `^ = `decl^ `...^',
    \ '    `method^ `^ = `declaration^`...^',
    \ '' ])

call XPTemplate( 'if', [
    \ 'if `expr^',
    \ '    then `thenCode^',
    \ '    else `elseCode^',
    \ '' ])

call XPTemplate('fun', [
            \ '`funName^ `pattern^ = `def^`...^',
            \ '`name^R("funName")^ `pattern^ = `def^`...^',
            \ '' ])

call XPTemplate('funcom', [
            \ '-- | `function_description^',
            \ '`funName^ :: `type^',
            \ '`name^R("funName")^ `pattern^ = `def^`...^',
            \ '`name^R("funName")^ `pattern^ = `def^`...^',
            \ '' ])

