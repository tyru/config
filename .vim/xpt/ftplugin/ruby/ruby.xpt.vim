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

" remove "||" if no args contained
fun! s:f.RubyBlockArg() "{{{
  return s:f.SV("^\s*|\s*|\s*$","")
endfunction "}}}

fun! s:f.RubyCamelCase(...) "{{{
  let str = a:0 == 0 ? s:f.V() : a:1
  let r = substitute(substitute(str, "[\/ _]", ' ', 'g'), '\<.', '\u&', 'g')
  return substitute(r, " ", '', 'g')
endfunction "}}}

fun! s:f.RubySnakeCase(...) "{{{
  let str = a:0 == 0 ? s:f.V() : a:1
  return substitute(str," ",'_','g')
endfunction "}}}

fun! s:f.RubyMethodName() "{{{
 let str = s:f.V()
 let i = match(str,'(')
 if i == -1
   return s:f.RubySnakeCase(str)
 else
   let j = str[i-1] == " " ? i-2 : i-1
   return s:f.RubySnakeCase(str[0 : j]) . str[i : -1]
 endif
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
    return v.' (`var^) {'
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
File.open("`filename^", "wb") {|`file^file^| Marshal.dump(`obj^, `file^) }


XPT Ml hint=Marshall\ Load
File.open("`filename^", "rb") {|`file^file^| Marshal.load(`file^) }


XPT Pn hint=PStore.new\\(..)
PStore.new("`filename^")




XPT Yd hint=YAML\ dump
File.open("`filename^.yaml", "wb") {|`file^file^| YAML.dump(`obj^,`file^) }


XPT Yl hint=YAML\ load
File.open("`filename^.yaml") {|`file^file^| YAML.load(`file^) }


XPT _d hint=__DATA__
__DATA__


XPT _e hint=__END__
__END__


XPT _f hint=__FILE__
__FILE__


XPT aeq hint=assert_equal\\(..)
assert_equal(`expected^, `actual^ `message...^, \`\^^^)


XPT aid hint=assert_in_delta\\(..)
assert_in_delta(`expected float^, `actual float^, `delta^ `message...^, \`\^^^)


XPT aio hint=assert_instance_of\\(..)
assert_instance_of(`class^, `object to compare^ `message...^, \`\^^^)


XPT ako hint=assert_kind_of\\(..)
assert_kind_of(`class^, `object to compare^ `message...^, \`\^^^)


XPT ali hint=alias\ :\ ..\ :\ ..
alias :`new^ :`old^


XPT all hint=all?\ {\ ..\ }
all? {|`element^| `cursor^ }


XPT ama hint=assert_match\\(..)
assert_match(/`regexp^/`flags^, `string^ `message...^, \`\^^^)


XPT amm hint=alias_method\ :\ ..\ :\ ..
alias_method :`new^, :`old^


XPT ane hint=assert_not_equal\\(..)
assert_not_equal(`expected^, `actual^ `message...^, \`\^^^)


XPT ani hint=assert_nil\\(..)
assert_nil(`object^ `message...^, \`\^^^)


XPT anm hint=assert_no_match\\(..)
assert_no_match(/`regexp^/`flags^, `string^ `message...^, \`\^^^)


XPT ann hint=assert_not_nil\\(..)
assert_not_nil(`object^ `message...^, \`\^^^)


XPT anr hint=assert_nothing_raised\\(..)
assert_nothing_raised(`exception^) { `cursor^ }


XPT ans hint=assert_not_same\\(..)
assert_not_same(`expected^, `actual^ `message...^, \`\^^^)


XPT any hint=any?\ {|..|\ ..\ }
any? {|`element^| `cursor^ }




XPT aop hint=assert_operator\\(..)
assert_operator(`obj1^, `operator^, `obj2^ `message...^, \`\^^^)




XPT app hint=if\ __FILE__\ ==\ $PROGRAM_NAME\ ...
if __FILE__ == $PROGRAM_NAME
`cursor^
end


XPT ara hint=assert_raise\\(..)
assert_raise(`exception^) { `cursor^ }


XPT array hint=Array.new\\(..)\ {\ ...\ }
Array.new(`size^) {|`arg^i^| `cursor^ }


XPT art hint=assert_respond_to\\(..)
assert_respond_to(`object^, `resp. to this message^ `message...^, \`\^^^)


XPT asa hint=assert_same\\(..)
assert_same(`expected^, `actual^ `message...^, \`\^^^)


XPT ase hint=assert_send\\(..)
assert_send(`send array (send array[1] to [0] with [x] as args; exp true).^ `message...^, \`\^^^)


XPT ass hint=assert\\(..)
assert(`boolean condition^ `message...^, \`\^^^)


XPT ata hint=attr_accessor\ :\ ..
attr_accessor :`accessor^`...^, :`accessorn^`...^


XPT ath hint=assert_throws\\(..)
assert_throws(`expected symbol^ `message...^, \\`\\^^^) { `cursor^ }


XPT atr hint=attr_reader\ :\ ..
attr_reader :`reader^`...^, :`readern^`...^


XPT atw hint=attr_writer\ :\ ..
attr_writer :`writer^`...^, :`writern^`...^


XPT begin hint=begin\ ..\ rescue\ ..\ else\ ..\ end
begin
   `expr^
`...^rescue `error_type^
    `expr^
`...^`else...^else
    \`expr\^^^
`ensure...^ensure
    \`expr\^^^
end

XPT bm hint=Benchmark.bmbm\ do\ ...\ end
TESTS = `times^10_000^
Benchmark.bmbm do |result|
`cursor^
end


XPT case hint=case\ ..\ when\ ..\ end
case `target^
when `comparison^
`_^^
`...^
when `comparison^
`_^^
`...^
`else...^else
    \`\^^^
end


XPT cfy hint=classify\ {|..|\ ..\ }
classify {|`element^| `cursor^ }


XPT cl hint=class\ ..\ end
class `^RubyCamelCase()^^
`cursor^
end


XPT cld hint=class\ ..\ <\ DelegateClass\ ..\ end
class `ClassName^RubyCamelCase()^^ < DelegateClass(`ParentClass^RubyCamelCase()^^)
def initialize`_^^
super(`delegate object^)

`cursor^
end
end


XPT cli hint=class\ ..\ def\initialize\ ..\ ...\ end
class `^RubyCamelCase()^^
def initialize`_^^
`block^
end`...^

def `methodn^RubyMethodName()^^
`_n^
end`...^
end


XPT cls hint=class\ <<\ ..\ end
class << `self^self^
`cursor^
end


XPT clstr hint=..\ =\ Struct.new\ ...
`ClassName^RubyCamelCase()^^ = Struct.new(:`attr^`...0^, :`attrn^`...0^) do
def `method^RubyMethodName()^^
`_^
end`...1^

def `methodn^RubyMethodName()^^
`_n^
end`...1^
end


XPT col hint=collect\ {\ ..\ }
collect {|`obj^| `cursor^ }


XPT deec hint=Deep\ copy
Marshal.load(Marshal.dump(`obj^))


XPT def hint=def\ ..\ end
def `^RubyMethodName()^^
`cursor^
end


XPT defd hint=def_delegator\ :\ ...
def_delegator :`del obj^, :`del meth^, :`new name^


XPT defds hint=def_delegators\ :\ ...
def_delegators :`del obj^, :`del methods^


XPT defi hint=def\ initialize\ ..\ end
def initialize`_^^
`cursor^
end


XPT defmm hint=def\ method_missing\\(..)\ ..\ end
def method_missing(meth, *args, &block)
`cursor^
end


XPT defs hint=def\ self.\ ..\ end
def self.`^RubyMethodName()^^
`cursor^
end


XPT deft hint=def\ test_..\ ..\ end
def test_`case name^RubyMethodName()^^
`cursor^
end


XPT deli hint=delete_if\ {|..|\ ..\ }
delete_if { |`arg^| `cursor^ }


XPT det hint=detect\ {\ ..\ }
detect {|`obj^| `cursor^ }


XPT dir hint=Dir[..]
Dir[`path^./**/*^]


XPT dirg hint=Dir.glob\\(..)\ {|..|\ ..\ }
Dir.glob('`dir^') {|`d^file^| `cursor^ }


XPT do hint=do\ |..|\ ..\ end
do `|`args`|^RubyBlockArg()^^
`cursor^
end


XPT dow hint=downto\\(..)\ {\ ..\ }
downto(`lbound^) {|`arg^i^| `cursor^ }


XPT ea hint=each\ {\ ..\ }
each {|`e^| `cursor^ }


XPT ea_ hint=each_**\ {\ ..\ }
each_`what^RubyEachBrace()^^|`_^RubyEachPair()^| `cursor^ }


XPT eli hint=elsif\ ..
elsif `boolean exp^
`_^^ `...^elsif `boolean exp^
`_^^`...^


XPT fdir hint=File.dirname\\(..)
File.dirname(`_^^)


XPT fet hint=fetch\\(..)\ {|..|\ ..\ }
fetch(`name^) {|`key^| `cursor^ }


XPT file hint=File.foreach\\(..)\ ...
File.foreach('`filename^') {|`line^line^| `cursor^ }


XPT fin hint=find\ {|..|\ ..\ }
find {|`element^| `cursor^ }


XPT fina hint=find_all\ {|..|\ ..\ }
find_all {|`element^| `cursor^ }


XPT fjoin hint=File.join\\(..)
File.join(`dir^, `path^)


XPT fread hint=File.read\\(..)
File.read('`filename^')


XPT grep hint=grep\\(..)\ {|..|\ ..\ }
grep(/`pattern^/) {|`match^m^| `cursor^ }


XPT gsub hint=gsub\\(..)\ {|..|\ ..\ }
gsub(/`pattern^/) {|`match^m^| `cursor^ }


XPT hash hint=Hash.new\ {\ ...\ }
Hash.new {|`hash^hash^,`key^key^| `hash^[`key^] = `cursor^ }


XPT if hint=if\ ..\ elsif\ ..\ end
if `boolean exp^
`block^
`...^
elsif `bool exp^
   `block^`...^
`else...^else
   \`block\^^^
end


XPT inj hint=inject\ {|..|\ ..\ }
inject {|`accumulator^acc^, `element^el^| `cursor^ }


XPT inj0 hint=inject\\(0)\ {|..|\ ..\ }
inject(0) {|`accumulator^acc^, `element^el^| `cursor^ }


XPT inji hint=inject\\(..)\ {|..|\ ..\ }
inject(`initial^) {|`accumulator^acc^, `element^el^| `cursor^ }


XPT int hint=#{..}
#{`_^^}


XPT kv hint=:...\ =>\ ...
:`key^ => `value^`...^, :`keyn^ => `valuen^`...^


XPT lam hint=lambda\ {\ ..\ }
lambda {`|`args`|^RubyBlockArg()^^ `cursor^ }


XPT lit hint=%*[..]
%`_^^[`content^^]

XPT map hint=map\ {|..|\ ..\ }
map {|`arg^| `cursor^ }


XPT max hint=max\ {|..|\ ..\ }
max {|`element1^, `element2^| `cursor^ }


XPT min hint=min\ {|..|\ ..\ }
min {|`element1^, `element2^| `cursor^ }


XPT mod hint=module\ ..\ ..\ end
module `module name^RubyCamelCase()^^
`cursor^
end


XPT modf hint=module\ ..\ module_function\ ..\ end
module `module name^RubyCamelCase()^^
module_function

`cursor^
end


XPT nam hint=Rake\ Namespace
namespace :`ns^fileRoot()^ do
`cursor^
end


XPT new hint=Instanciate\ new\ object
`var^ = `Object^RubyCamelCase()^^.new


XPT open hint=open\\(..)\ {|..|\ ..\ }
open("`filename^" `mode...^, "\`wb\^"^^) {|io| `cursor^ }


XPT par hint=partition\ {|..|\ ..\ }
partition {|`element^| `cursor^ }


XPT pathf hint=Path\ from\ here
File.join(File.dirname(__FILE__), "`path^../lib^")


XPT rb hint=#!/usr/bin/env\ ruby\ -w
#!/usr/bin/env ruby -w


XPT rdoc hint=RDoc\ description
=begin rdoc
`cursor^
=end


XPT rej hint=reject\ {|..|\ ..\ }
reject {|`element^| `cursor^ }


XPT rep hint=Benchmark\ report
result.report("`name^: ") { TESTS.times { `cursor^ } }


XPT req hint=require\ ..
require `lib^


XPT reqs hint=%w[..].map\ {|lib|\ require\ lib\ }
%w[`libs^].map {|lib| require lib}


XPT reve hint=reverse_each\ {\ ..\ }
reverse_each {|`e^| `cursor^ }


XPT scan hint=scan\\(..)\ {|..|\ ..\ }
scan(/`pattern^/) {|`match^m^| `cursor^ }


XPT sel hint=select\ {|..|\ ..\ }
select {|`element^| `cursor^ }


XPT sinc hint=class\ <<\ self;\ self;\ end
class << self; self; end


XPT sor hint=sort\ {|..|\ ..\ }
sort {|`el1^, `el2^| `el2^ <=> `el1^ }


XPT sorb hint=sort_by\ {|..|\ ..\ }
sort_by {`|`arg`|^RubyBlockArg()^^ `cursor^ }


XPT ste hint=step\\(..)\ {\ ..\ }
step(`count^) {|`arg^i^| `cursor^ }


XPT sub hint=sub\\(..)\ {|..|\ ..\ }
sub(/`pattern^/) {|`match^m^| `cursor^ }


XPT subcl hint=class\ ..\ <\ ..\ end
class `^RubyCamelCase()^^ < `parent^RubyCamelCase()^^
`cursor^
end


XPT tas hint=Rake\ Task
desc "`task description^"
task :`task name^RubySnakeCase()^^ `depends of...^=> [:\`task\^\`...\^, :\\\`taskn\\\^\\\`...\\\^\^\^]^^ do
`cursor^
end


XPT tc hint=require\ 'test/unit'\ ...\ class\ Test..\ <\ Test::Unit:TestCase\ ...
require "test/unit"
require "`module^"

class Test`^RubyCamelCase(R("module"))^ < Test::Unit:TestCase
def test_`test case name^RubyMethodName()^^
`_^^
end `...^

def test_`test_case_namen^RubyMethodName()^^
`_n^
end`...^
end


XPT tif hint=..\ ?\ ..\ :\ ..
(`boolean exp^) ? `exp if true^ : `exp if false^


XPT tim hint=times\ {\ ..\ }
times {`|`index`|^RubyBlockArg()^^ `cursor^ }


XPT tra hint=transaction\\(..)\ {\ ...\ }
transaction(`_^true^) { `cursor^ }


XPT unif hint=Unix\ Filter
ARGF.each_line do |`line^line^|
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
upto(`ubound^) {|`arg^i^| `cursor^ }


XPT usai hint=if\ ARGV..\ abort("Usage...
if ARGV`_^^
abort "Usage: #{$PROGRAM_NAME} `args^[options]^"
end


XPT usau hint=unless\ ARGV..\ abort("Usage...
unless ARGV`_^^
abort "Usage: #{$PROGRAM_NAME} `args^[options]^"
end




XPT while hint=while\ ..\ end
while `boolean cond^
`cursor^
end


XPT wid hint=with_index\ {\ ..\ }
with_index {|`record^, `index^i^| `cursor^ }


XPT xml hint=REXML::Document.new\\(..)
REXML::Document.new(File.read("`filename^"))


XPT y hint=:yields:
:yields:


XPT zip hint=zip\\(..)\ {|..|\ ..\ }
zip(`enum^) {|`row^row^| `cursor^ }


