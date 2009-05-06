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
XPTemplateDef
XPT class hint=class\ ..\ where..
class `context^^ `className^ `types^ where
    `ar^ :: `type^ `...^
    `methodName^ :: `methodType^`...^


XPT classcom hint=--\ |\ class..
-- | `classDescr^
class `context^^ `className^ `types^ where
    -- | `methodDescr^
    `ar^ :: `type^ `...^
    -- | `method_Descr^
    `methodName^ :: `methodType^`...^


XPT datasum hint=data\ ..\ =\ ..|..|..
data `context^^ `typename^ `typeParams^^ =
    `Constructor^ `ctorParams^^ `...^
  | `Ctor^ `params^^`...^
  `deriving...^deriving (\`cursor\^)^^


XPT datasumcom hint=--\ |\ data\ ..\ =\ ..|..|..
-- | `typeDescr^^^
data `context^^ `typename^ `typeParams^^ =
    -- | `ConstructorDescr^^^
    `Constructor^ `ctorParams^^ `...^
    -- | `Ctor descr^^
  | `Ctor^ `params^^`...^
  `deriving...^deriving (\`cursor\^)^^

XPT parser hint=..\ =\ ..\ <|>\ ..\ <|>\ ..\ <?>
`funName^ = `rule^`...^
         <|> `rule^`...^
         `err...^<?> \`cursor\^^^


XPT datarecord hint=data\ ..\ ={}
data `context^^ `typename^ `typeParams^^ =
     `Constructor^ {
       `field^ :: `type^ `...^
     , `fieldn^ :: `typen^`...^
     }
     `deriving...^deriving (\`cursor\^)^^


XPT datarecordcom hint=--\ |\ data\ ..\ ={}
-- | `typeDescr^
data `context^^ `typename^ `typeParams^^ =
     `Constructor^ {
       `field^ :: `type^^^ -- ^ `fieldDescr^ `...^
     , `fieldn^ :: `typen^^^ -- ^ `fielddescr^`...^
     }
     `deriving...^deriving (\`cursor\^)^^


XPT instance hint=instance\ ..\ ..\ where
instance `className^ `instanceTypes^ where
    `methodName^ `^ = `decl^ `...^
    `method^ `^ = `declaration^`...^


XPT if hint=if\ ..\ then\ ..\ else
if `expr^
    then `thenCode^
    else `elseCode^


XPT fun hint=fun\ pat\ =\ ..
`funName^ `pattern^ = `def^`...^
`name^R("funName")^ `pattern^ = `def^`...^


XPT funcom hint=--\ |\ fun\ pat\ =\ ..
-- | `function_description^
`funName^ :: `type^
`name^R("funName")^ `pattern^ = `def^`...^
`name^R("funName")^ `pattern^ = `def^`...^


