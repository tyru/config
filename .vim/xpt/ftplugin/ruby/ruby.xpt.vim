if exists("b:__RUBY_XPT_VIM__")
  finish
endif
let b:__RUBY_XPT_VIM__ = 1



" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

fun! s:f.RubyCamelCase(...) "{{{
  let str = a:0 == 0 ? s:f.V() : a:1
  let r = substitute(substitute(str, "[\/ _]", ' ', 'g'), '\<.', '\u&', 'g')
  return substitute(r, " ", '', 'g')
endfunction "}}}

fun! s:f.RubySnakeCase(...) "{{{
  let str = a:0 == 0 ? s:f.V() : a:1
  return substitute(str," ",'_','g')
endfunction "}}}

let s:each_map = {
      \'b' : 'byte',
      \'c' : 'char',
      \'co' : 'cons',
      \'i' : 'index',
      \'k' : 'key',
      \'l' : 'line',
      \'p' : 'pair',
      \'s' : 'slice',
      \'v' : 'value'
      \}

fun! s:f.RubyEachBrace() "{{{
  let v = s:f.V()

  if has_key(s:each_map, v)
    let v = s:each_map[v]
  endif

  if v =~# 'slice\|cons'
    return v.'(`var^) {'
  else
    return v.' {'
  endif
endfunction "}}}

fun! s:f.RubyEachPair() "{{{
  let v = s:f.R('what')
  if v =~# 'pair'
    return '`name^, `value^'
  else
    return '`var^'
  endif
endfunction "}}}

fun! s:f.RubyClassAttr() "{{{
  let v = s:f.V()
  let attr = {
        \'a' : 'accessor',
        \'r' : 'reader',
        \'w' : 'writer',
        \}
  if has_key(attr, v)
    let r = attr[v]
    return r
  else
    return ''
  endif
endfunction "}}}

fun! s:f.Concat(...) "{{{
  let r = ''
  for v in a:000
    let r = r . v
  endfor
  return r
endfunction "}}}

let s:assert_map = {
      \'eq' : {'name': 'equals', 'body' : '`expected^, `actual^'},
      \'id' : {'name' : 'in_delta', 'body' : '`expected float^, `actual float^, `delta^'},
      \'io' : {'name' : 'instance_of', 'body' : '`class^, `object to compare^'},
      \'ko' : {'name' : 'kind_of', 'body' : '`class^, `object to compare^'},
      \'m' : {'name' : 'match', 'body' : '/`regexp^/`flags^, `string^'},
      \'ne' : {'name' : 'not_equal', 'body' : '`expected^, `actual^'},
      \'ni' : {'name' : 'nil', 'body' : '`object^'},
      \'nm' : {'name' : 'no_match', 'body' : '/`regexp^/`flags^, `string^'},
      \'nn' : {'name' : 'not_nil', 'body' : '`object^'},
      \'nr' : {'name' : 'nothing_raised', 'body' : '`exception^'},
      \'ns' : {'name' : 'not_same', 'body' : '`expected^, `actual^'},
      \'op' : {'name' : 'operator', 'body' : '`obj1^, `operator^, `obj2^'},
      \'ra' : {'name' : 'raise', 'body' : '`exception^'},
      \'rt' : {'name' : 'respond_to', 'body' : '`object^, `respond to this message^'},
      \'sa' : {'name' : 'same', 'body' : '`expected^, `actual^'},
      \'se' : {'name' : 'send', 'body' : '`send array^'},
      \'th' : {'name' : 'throws', 'body' : '`expected symbol^'}
      \}

let s:assert_expected_body = ''

fun! RubyAssertMethod() "{{{
  let v = s:f.V()
  let s:assert_expected_body = ''
  if has_key(s:assert_map, v)
    let s:assert_expected_body = s:assert_map[v]['body']
    return s:assert_map[v]['name'] . '('
  else
    return ''
  endif
endfunction "}}}

fun! RubyAssertArgs() "{{{
  let r = ''

  if !empty(s:assert_expected_body)
    let r = r . s:assert_expected_body
  endif

  if s:f.R('what') =~# 'raise'
    let r = r . ', `message^'
  endif 

  let r = r . ')'

  if s:f.R('what') =~ 'raise\|throws'
    let r = r . ' { `cursor^ }'
  endif 

  return r
endfunction "}}}

" ================================= Snippets ===================================
XPTemplateDef
XPT BEG hint=BEGIN\ {\ ..\ }
BEGIN {
`cursor^
}


XPT Comp hint=include\ Comparable\ def\ <=>\ ...
include Comparable

def <=>(other)
`cursor^
end


XPT END hint=END\ {\ ..\ }
END {
`cursor^
}


XPT Enum hint=include\ Enumerable\ def\ each\ ...
include Enumerable

def each(&block)
`cursor^
end


XPT Forw hint=extend\ Forwardable
extend Forwardable


XPT Md hint=Marshall\ Dump
XSET file=file
File.open("`filename^", "wb") { |`file^| Marshal.dump(`obj^, `file^) }


XPT Ml hint=Marshall\ Load
XSET file=file
File.open("`filename^", "rb") { |`file^| Marshal.load(`file^) }


XPT Pn hint=PStore.new\\(..)
PStore.new("`filename^")


XPT Yd hint=YAML\ dump
XSET file=file
File.open("`filename^.yaml", "wb") { |`file^| YAML.dump(`obj^,`file^) }


XPT Yl hint=YAML\ load
XSET file=file
File.open("`filename^.yaml") { |`file^| YAML.load(`file^) }


XPT _d hint=__DATA__
__DATA__


XPT _e hint=__END__
__END__


XPT _f hint=__FILE__
__FILE__


XPT ali hint=alias\ :\ ..\ :\ ..
XSET new.post=RubySnakeCase()
XSET old=Concat("old_",R('new'))
XSET old.post=RubySnakeCase()
alias :`new^ :`old^


XPT all hint=all?\ {\ ..\ }
all? { |`element^| `cursor^ }


XPT amm hint=alias_method\ :\ ..\ :\ ..
XSET new.post=RubySnakeCase()
XSET old=Concat("old_",R('new'))
XSET old.post=RubySnakeCase()
alias_method :`new^, :`old^


XPT any hint=any?\ {\ |..|\ ..\ }
any? { |`element^| `cursor^ }


XPT app hint=if\ __FILE__\ ==\ $PROGRAM_NAME\ ...
if __FILE__ == $PROGRAM_NAME
`cursor^
end


XPT array hint=Array.new\\(..)\ {\ ...\ }
XSET arg=i
XSET size=5
Array.new(`size^) { |`arg^| `cursor^ }

XPT ass hint=assert\\(..)
XSET message...|post=, `_^
assert(`boolean condition^` `message...^)

XPT ass_ hint=assert_**\\(..)\ ...
XSET what|post=RubyAssertMethod()
XSET _=RubyAssertArgs()
XSET block=RubyAssertBlock()
XSET flags=
assert_`what^`_^


XPT attr hint=attr_**\ :...
XSET what=r
XSET what.post=RubyClassAttr()
XSET attr=
attr_`what^ :`attr^`...^, :`attr^`...^

XPT begin hint=begin\ ..\ rescue\ ..\ else\ ..\ end
XSET exception=Exception
XSET block=# block
XSET rescue...|post=\nrescue `exception^\n  `block^`\n`rescue...^
XSET else...|post=\nelse\n  `block^
XSET ensure...|post=\nensure\n  `cursor^
begin
  `expr^`
`rescue...^`
`else...^`
`ensure...^
end

XPT bm hint=Benchmark.bmbm\ do\ ...\ end
TESTS = `times^10_000^

Benchmark.bmbm do |result|
`cursor^
end


XPT case hint=case\ ..\ when\ ..\ end
XSET when...|post=\nwhen `comparison^\n  `_^`\n`when...^
XSET else...|post=\nelse\n  `_^
XSET _=
case `target^`
`when...^`
`else...^
end


XPT cfy hint=classify\ {\ |..|\ ..\ }
classify { |`element^| `cursor^ }


XPT cl hint=class\ ..\ end
XSET ClassName.post=RubyCamelCase()
class `ClassName^
`cursor^
end


XPT cld hint=class\ ..\ <\ DelegateClass\ ..\ end
XSET ClassName.post=RubyCamelCase()
XSET ParentClass.post=RubyCamelCase()
class `ClassName^ < DelegateClass(`ParentClass^)
  def initialize`(`args`)^
    super(`delegate object^)

    `cursor^
  end
end


XPT cls hint=class\ <<\ ..\ end
XSET self=self
class << `self^
`cursor^
end


XPT clstr hint=..\ =\ Struct.new\ ...
XSET do...|post=do\n`cursor^\nend
XSET ClassName|post=RubyCamelCase()
`ClassName^ = Struct.new(:`attr^`...^, :`attrn^`...^) `do...^


XPT col hint=collect\ {\ ..\ }
collect { |`obj^| `cursor^ }


XPT deec hint=Deep\ copy
Marshal.load(Marshal.dump(`obj^))


XPT def hint=def\ ..\ end
XSET method|post=RubySnakeCase()
def `method^`(`args`)^
`cursor^
end


XPT defd hint=def_delegator\ :\ ...
def_delegator :`del obj^, :`del meth^, :`new name^


XPT defds hint=def_delegators\ :\ ...
def_delegators :`del obj^, :`del methods^


XPT defi hint=def\ initialize\ ..\ end
def initialize`(`args`)^
`cursor^
end


XPT defmm hint=def\ method_missing\\(..)\ ..\ end
def method_missing(meth, *args, &block)
`cursor^
end


XPT defs hint=def\ self.\ ..\ end
XSET method.post=RubySnakeCase()
def self.`method^`(`args`)^
`cursor^
end


XPT deft hint=def\ test_..\ ..\ end
XSET name|post=RubySnakeCase()
def test_`name^`(`args`)^
`cursor^
end


XPT deli hint=delete_if\ {\ |..|\ ..\ }
delete_if { |`arg^| `cursor^ }


XPT det hint=detect\ {\ ..\ }
detect { |`obj^| `cursor^ }


XPT dir hint=Dir[..]
XSET _=/**/*
Dir[`_^]


XPT dirg hint=Dir.glob\\(..)\ {\ |..|\ ..\ }
XSET d=file
Dir.glob('`dir^') { |`f^| `cursor^ }


XPT do hint=do\ |..|\ ..\ end
do` |`args`|^
`cursor^
end


XPT dow hint=downto\\(..)\ {\ ..\ }
XSET arg=i
XSET lbound=0
downto(`lbound^) { |`arg^| `cursor^ }


XPT ea hint=each\ {\ ..\ }
each { |`e^| `cursor^ }


XPT ea_ hint=each_**\ {\ ..\ }
XSET what.post=RubyEachBrace()
XSET _=RubyEachPair()
each_`what^|`_^| `cursor^ }


XPT fdir hint=File.dirname\\(..)
XSET _=
File.dirname(`_^)


XPT fet hint=fetch\\(..)\ {\ |..|\ ..\ }
fetch(`name^) { |`key^| `cursor^ }


XPT file hint=File.foreach\\(..)\ ...
XSET line=line
File.foreach('`filename^') { |`line^| `cursor^ }


XPT fin hint=find\ {\ |..|\ ..\ }
find { |`element^| `cursor^ }


XPT fina hint=find_all\ {\ |..|\ ..\ }
find_all { |`element^| `cursor^ }


XPT fjoin hint=File.join\\(..)
File.join(`dir^, `path^)


XPT fread hint=File.read\\(..)
File.read('`filename^')


XPT grep hint=grep\\(..)\ {\ |..|\ ..\ }
XSET match=m
grep(/`pattern^/) { |`match^| `cursor^ }


XPT gsub hint=gsub\\(..)\ {\ |..|\ ..\ }
XSET match=m
gsub(/`pattern^/) { |`match^| `cursor^ }


XPT hash hint=Hash.new\ {\ ...\ }
XSET hash=h
XSET key=k
Hash.new { |`hash^,`key^| `hash^[`key^] = `cursor^ }

XPT if hint=if\ ..\ elsif\ ..\ else\ ..\ end
XSET block=# block
XSET else...|post=\nelse\n`cursor^
XSET elsif...|post=\nelsif `boolean exp^\n  `block^`\n`elsif...^
if `boolean exp^
  `block^`
`elsif...^`
`else...^
end


XPT inj hint=inject\\(..)\ {\ |..|\ ..\ }
XSET accumulator=acc
XSET element=el
inject`(`arg`)^ { |`accumulator^, `element^| `cursor^ }


XPT int hint=#{..}
XSET _=
#{`_^}


XPT kv hint=:...\ =>\ ...
:`key^ => `value^`...^, :`keyn^ => `valuen^`...^


XPT lam hint=lambda\ {\ ..\ }
lambda {` |`args`|^ `cursor^ }


XPT lit hint=%**[..]
XSET _=w
XSET content=
%`_^[`content^]

XPT loop hint=loop\ do\ ...\ end
loop do
`cursor^
end

XPT map hint=map\ {\ |..|\ ..\ }
map { |`arg^| `cursor^ }


XPT max hint=max\ {\ |..|\ ..\ }
max { |`element1^, `element2^| `cursor^ }


XPT min hint=min\ {\ |..|\ ..\ }
min { |`element1^, `element2^| `cursor^ }


XPT mod hint=module\ ..\ ..\ end
XSET module name|post=RubyCamelCase()
module `module name^
`cursor^
end


XPT modf hint=module\ ..\ module_function\ ..\ end
XSET module name|post=RubyCamelCase()
module `module name^
  module_function

  `cursor^
end


XPT nam hint=Rake\ Namespace
XSET ns=fileRoot()
namespace :`ns^ do
`cursor^
end


XPT new hint=Instanciate\ new\ object
XSET Object|post=RubyCamelCase()
`var^ = `Object^.new`(`args`)^


XPT open hint=open\\(..)\ {\ |..|\ ..\ }
XSET mode...|post=, '`wb^'
XSET wb=wb
XSET io=io
open("`filename^"` `mode...^) { |`io^| `cursor^ }


XPT par hint=partition\ {\ |..|\ ..\ }
partition { |`element^| `cursor^ }


XPT pathf hint=Path\ from\ here
XSET path=../lib
File.join(File.dirname(__FILE__), "`path^")


XPT rb hint=#!/usr/bin/env\ ruby\ -w
#!/usr/bin/env ruby -w


XPT rdoc syn=comment hint=RDoc\ description
=begin rdoc
#`cursor^
#=end


XPT rej hint=reject\ {\ |..|\ ..\ }
reject { |`element^| `cursor^ }


XPT rep hint=Benchmark\ report
result.report("`name^: ") { TESTS.times { `cursor^ } }


XPT req hint=require\ ..
require '`lib^'


XPT reqs hint=%w[..].map\ {\ |lib|\ require\ lib\ }
%w[`libs^].map { |lib| require lib }


XPT reve hint=reverse_each\ {\ ..\ }
reverse_each { |`element^| `cursor^ }


XPT scan hint=scan\\(..)\ {\ |..|\ ..\ }
XSET match=m
scan(/`pattern^/) { |`match^| `cursor^ }


XPT sel hint=select\ {\ |..|\ ..\ }
select { |`element^| `cursor^ }


XPT sinc hint=class\ <<\ self;\ self;\ end
class << self; self; end


XPT sor hint=sort\ {\ |..|\ ..\ }
sort { |`element1^, `element2^| `element1^ <=> `element2^ }


XPT sorb hint=sort_by\ {\ |..|\ ..\ }
sort_by {` |`arg`|^ `cursor^ }


XPT ste hint=step\\(..)\ {\ ..\ }
XSET arg=i
XSET count=10
XSET step...|post=, `step^
XSET step=2
step(`count^` `step...^) { |`arg^| `cursor^ }


XPT sub hint=sub\\(..)\ {\ |..|\ ..\ }
XSET match=m
sub(/`pattern^/) { |`match^| `cursor^ }


XPT subcl hint=class\ ..\ <\ ..\ end
XSET ClassName.post=RubyCamelCase()
XSET Parent.post=RubyCamelCase()
class `ClassName^ < `Parent^
`cursor^
end


XPT tas hint=Rake\ Task
XSET task name|post=RubySnakeCase()
XSET taskn...|post=, :`task^` `taskn...^
XSET deps...|post==> [:`task^` `taskn...^]
desc "`task description^"
task :`task name^` `deps...^ do
`cursor^
end


XPT tc hint=require\ 'test/unit'\ ...\ class\ Test..\ <\ Test::Unit:TestCase\ ...
XSET block=# block
XSET name|post=RubySnakeCase()
XSET ClassName=RubyCamelCase(R("module"))
XSET ClassName.post=RubyCamelCase()
XSET def...|post=\n\n  def test_`name^`(`args`)^\n    `block^\n  end`\n\n  `def...^
require "test/unit"
require "`module^"

class Test`ClassName^ < Test::Unit:TestCase
  def test_`name^`(`args`)^
    `block^
  end`

  `def...^
end


XPT tif hint=..\ ?\ ..\ :\ ..
(`boolean exp^) ? `exp if true^ : `exp if false^


XPT tim hint=times\ {\ ..\ }
times {` |`index`|^ `cursor^ }


XPT tra hint=transaction\\(..)\ {\ ...\ }
XSET _=true
transaction(`_^) { `cursor^ }


XPT unif hint=Unix\ Filter
XSET line=line
ARGF.each_line do |`line^|
`cursor^
end


XPT unless hint=unless\ ..\ end
unless `boolean cond^
`cursor^
end


XPT until hint=until\ ..\ end
until `boolean cond^
`cursor^
end


XPT upt hint=upto\\(..)\ {\ ..\ }
XSET arg=i
XSET ubound=10
upto(`ubound^) { |`arg^| `cursor^ }


XPT usai hint=if\ ARGV..\ abort("Usage...
XSET _=
XSET args=[options]
if ARGV`_^
  abort "Usage: #{$PROGRAM_NAME} `args^"
end


XPT usau hint=unless\ ARGV..\ abort("Usage...
XSET _=
XSET args=[options]
unless ARGV`_^
  abort "Usage: #{$PROGRAM_NAME} `args^"
end




XPT while hint=while\ ..\ end
while `boolean cond^
`cursor^
end


XPT wid hint=with_index\ {\ ..\ }
XSET index=i
with_index { |`element^, `index^| `cursor^ }


XPT xml hint=REXML::Document.new\\(..)
REXML::Document.new(File.read("`filename^"))


XPT y syn=comment hint=:yields:
:yields:


XPT zip hint=zip\\(..)\ {\ |..|\ ..\ }
XSET row=row
zip(`enum^) { |`row^| `cursor^ }
