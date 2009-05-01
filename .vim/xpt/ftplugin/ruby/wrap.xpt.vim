if exists("b:__RUBY_WRAP_XPT_VIM__")
    finish
endif
let b:__RUBY_WRAP_XPT_VIM__ = 1


XPTinclude
      \ _common/common
"================ Wrapped Items ================"
XPTemplateDef

XPT comment_ hint=#\ SEL
# `wrapped^
..XPT

XPT invoke_ hint=..(SEL)
`name^(`wrapped^)
..XPT

XPT def_ hint=def\ ..()\ SEL\ end
def `^RubyMethodName()^^
`wrapped^
end
..XPT

XPT class_ hint=class\ ..\ SEL\ end
class `^RubyCamelCase()^^
`wrapped^
end
..XPT

XPT module_ hint=module\ ..\ SEL\ end
module `^RubyCamelCase()^^
`wrapped^
end
..XPT

XPT begin_ hint=begin\ SEL\ rescue\ ...
begin
`wrapped^
rescue `ex^Exception^ => `e^e^
`block^  `...^
rescue `exn^ => `e^e^
`blockn^  `...^ `ensure...^
ensure
\`cursor\^^^
end
..XPT
