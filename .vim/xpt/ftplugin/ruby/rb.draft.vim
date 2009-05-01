" from i C. Coutinho
if exists("b:__RUBY_XPT_VIM__")
  finish
endif
let b:__RUBY_XPT_VIM__ = 1


finish

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

fun! s:f.RubyBlockArg() "{{{
  return s:f.SV("\^[\^|]\\(.\\{-}\\)[\^|]$","|&|")
endfunction "}}}

fun! s:f.RubyCamelCase() "{{{
  let r = substitute(s:f.SV("[\/ _]", ' ', 'g'), '\<.', '\u&', 'g')
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
    return s:f.RubySnakeCase(str[0:i-1]) . str[i:-1]
  else
    return s:f.RubySnakeCase(str)
  endif
endfunction "}}}



" ================================= Snippets ===================================
XPTemplateDef

XPT atr hint=attr_reader\ :\ ...
attr_reader :`reader^`...^, :`readern^`...^
..XPT

XPT atw hint=attr_writer\ :\ ...
attr_writer :`writer^`...^, :`writern^`...^
..XPT

XPT ata hint=attr_accessor\ :\ ...
attr_accessor :`accessor^`...^, :`accessorn^`...^
..XPT

XPT do hint=do\ |..|\ ..\ end
do `|...|^RubyBlockArg()^^
`cursor^
end
..XPT

XPT case hint=case\ ..\ when\ ..\ end
case `target^
when `comparison^
`^  `...^
when `comparisonn^
`_n^  `...^  `else...^
else
\`cursor\^^^
end
..XPT

XPT def hint=def\ ..\ end
def `^RubyMethodName()^^
`cursor^
end
..XPT

XPT defi hint=def\ initialize\ ..\ end
def initialize`^
`cursor^
end
..XPT

XPT defs hint=def\ self.\ ..\ end
def self.`^RubyMethodName()^^
`cursor^
end
..XPT

XPT defmm hint=def method_missing(...)\ ..\ end
def method_missing(meth, *args, &block)
`cursor^
end
..XPT

XPT defd hint=def_delegator\ :\ ..
def_delegator :`del obj^, :`del meth^, :`new name^
..XPT

XPT defds hint=def_delegators\ :\ ..
def_delegators :`del obj^, :`del methods^
..XPT

XPT tif hint=..\ ?\ ..\ :\ ..
(`boolean exp^) ? `exp if true^ : `exp if false^
..XPT

XPT eli hint=elsif\ ..
elsif `boolean exp^
`^ `...^elsif `boolean exp^
`^`...^
..XPT

XPT if hint=if\ ..\ else\ ..\ end
if `cond^
`^ `else...^
else
\`cursor\^^^
end
..XPT

XPT unless hint=unless\ ..\ end
unless `boolean cond^
`cursor^
end
..XPT

XPT while hint=while\ ..\ end
while `boolean cond^
`cursor^
end
..XPT

XPT until hint=until\ ..\ end
until `boolean cond^
`cursor^
end
..XPT

XPT ali hint=alias\ :\ ..\ :\ ..
alias :`new^ :`old^
..XPT

XPT amm hint=alias_method\ :\ ..\ :\ ..
alias_method :`new^, :`old^
..XPT

XPT lam hint=lambda\ {..}
lambda {`|...|^RubyBlockArg()^^ `cursor^ }
..XPT

XPT BEG hint=BEGIN\ {\ ..\ }
BEGIN {
`cursor^
}
..XPT

XPT END hint=END\ {\ ..\ }
END {
`cursor^
}
..XPT

" Mnemonic Array Of Words
XPT aow hint=%w[..]
%w[`^]
..XPT

XPT aoW hint=%W[..]
%W[`^]
..XPT

XPT sqs hint=%q[..]
%q[`^]
..XPT

XPT dqs hint=%Q[..]
%Q[`^]
..XPT

call XPTemplate('int', {'syn' : 'string'}, "#{`^}")

XPT mod hint=module\ ..\ ..\ end
module `module name^RubyCamelCase()^^
`cursor^
end
..XPT

XPT modf hint=module\ ..\ module_function\ end
module `module name^RubyCamelCase()^^
module_function

`cursor^
end
..XPT

XPT cl hint=class\ ..\ end
class `^RubyCamelCase()^^
`cursor^
end
..XPT

XPT cli hint=class\ ..\ def\initialize\ ..\ ...\ end
class `^RubyCamelCase()^^
def initialize`^
`_^
end`...^

def `methodn^RubyMethodName()^^
`_n^
end`...^
end
..XPT

XPT sinc hint=class\ <<\ self;\ self;\ end
class << self; self; end
..XPT

XPT cls hint=class\ <<\ ..\ end
class << `self^ self^
`cursor^
end
..XPT

XPT subcl hint=class\ ..\ <\ ..\ end
class `^RubyCamelCase()^^ < `parent^RubyCamelCase()^^
`cursor^
end
..XPT

XPT clstr hint=..\ =\ Struct.new\ ...
`ClassName^RubyCamelCase()^^ = Struct.new(:`attr^`...0^, :`attrn^`...0^) do
def `method^RubyMethodName()^^
`_^
end`...1^

def `methodn^RubyMethodName()^^
`_n^
end`...1^
end
..XPT

XPT cld hint=class\ ..\ <\ DelegateClass\ ..\ end
class `ClassName^RubyCamelCase()^^ < DelegateClass(`ParentClass^RubyCamelCase()^^)
def initialize`^
super(`delegate object^)

`cursor^
end
end
..XPT

XPT Enum hint=include\ Enumerable\ def\ each\ ...
include Enumerable

def each(&block)
`cursor^
end
..XPT

XPT Comp hint=include\ Comparable\ def\ <=>\ ...
include Comparable

def <=>(other)
`cursor^
end
..XPT

XPT Forw hint=
extend Forwardable
..XPT

XPT dow hint=
downto(`lbound^) {|`arg^i^| `cursor^ }
..XPT

XPT ste hint=
step(`count^) {|`arg^i^| `cursor^ }
..XPT

XPT tim hint=
times {`|...|^RubyBlockArg()^^ `cursor^ }
..XPT

XPT upt hint=
upto(`ubound^) {|`arg^i^| `cursor^ }
..XPT

XPT ea hint=
each {|`e^| `cursor^ }
..XPT

XPT eai hint=
each_index {|`index^i^| `cursor^ }
..XPT

XPT eak hint=
each_key {|`key^key^| `cursor^ }
..XPT

XPT eal hint=
each_line {|`line^line^| `cursor^ }
..XPT

XPT eav hint=
each_value {|`value^| `cursor^ }
..XPT

XPT reve hint=
reverse_each {|`e^| `cursor^ }
..XPT

XPT eap hint=
each_pair {|`name^, `value^| `cursor^ }
..XPT

XPT eab hint=
each_byte {|`byte^byte^| `cursor^ }
..XPT

XPT eac hint=
each_char {|`char^char^| `cursor^ }
..XPT

XPT eacon hint=
each_cons(`window size^) {|`cons^| `cursor^ }
..XPT

XPT easli hint=
each_slice(`slice size^) {|`slice^slice^| `cursor^ }
..XPT

XPT wid hint=
with_index {|`record^, `index^i^| `cursor^ }
..XPT

XPT map hint=
map {|`arg^| `cursor^ }
..XPT

XPT inj hint=
inject {|`accumulator^acc^, `element^el^| `cursor^ }
..XPT

XPT inj0 hint=
inject(0) {|`accumulator^acc^, `element^el^| `cursor^ }
..XPT

XPT inji hint=
inject(`initial^) {|`accumulator^acc^, `element^el^| `cursor^ }
..XPT

XPT dir hint=
Dir[`path^./**/*^]
..XPT

XPT dirg hint=
Dir.glob('`dir^') {|`d^file^| `cursor^ }
..XPT

XPT file hint=
File.foreach('`filename^') {|`line^line^| `cursor^ }
..XPT

XPT fread hint=
File.read('`filename^')
..XPT

XPT fdir hint=
File.dirname(`^)
..XPT

XPT fjoin hint=
File.join(`dir^, `path^)
..XPT

XPT open hint=
open("`filename^" `mode...^, "\`wb\^"^^) {|io| `cursor^ }
..XPT

XPT sor hint=
sort {|`el1^, `el2^| `el2^ <=> `el1^ }
..XPT

XPT sorb hint=
sort_by {`|arg|^RubyBlockArg()^^ `cursor^ }
..XPT

XPT all hint=
all? {|`element^| `cursor^ }
..XPT

XPT any hint=
any? {|`element^| `cursor^ }
..XPT

XPT cfy hint=
classify {|`element^| `cursor^ }
..XPT

XPT col hint=
collect {|`obj^| `cursor^ }
..XPT

XPT det hint=
detect {|`obj^| `cursor^ }
..XPT

XPT fet hint=
fetch(`name^) {|`key^| `cursor^ }
..XPT

XPT fin hint=
find {|`element^| `cursor^ }
..XPT

XPT fina hint=
find_all {|`element^| `cursor^ }
..XPT

XPT grep hint=
grep(/`pattern^/) {|`match^m^| `cursor^ }
..XPT

XPT max hint=
max {|`element1^, `element2^| `cursor^ }
..XPT

XPT min hint=
min {|`element1^, `element2^| `cursor^ }
..XPT

XPT par hint=
partition {|`element^| `cursor^ }
..XPT

XPT rej hint=
reject {|`element^| `cursor^ }
..XPT

XPT deli hint=
delete_if { |`arg^| `cursor^ }
..XPT

XPT sel hint=
select {|`element^| `cursor^ }
..XPT

XPT sub hint=
sub(/`pattern^/) {|`match^m^| `cursor^ }
..XPT

XPT gsub hint=
gsub(/`pattern^/) {|`match^m^| `cursor^ }
..XPT

XPT scan hint=
scan(/`pattern^/) {|`match^m^| `cursor^ }
..XPT

XPT zip hint=zip(..)\ {|..|\ ..\ }
zip(`enum^) {|`row^row^| `cursor^ }
..XPT

XPT tc hint=
require "test/unit"
require "`module^"
 
class Test`module^RubyCamelCase()^^ < Test::Unit:TestCase
def test_`test case name^RubyMethodName()^^
`^
end `...^

def test_`test_case_namen^RubyMethodName()^^
`_n^
end`...^
end
..XPT

XPT deft hint=
def test_`case name^RubyMethodName()^^
`cursor^
end
..XPT

XPT ass hint=
assert(`boolean condition^ `message...^, \`\^^^)
..XPT

XPT ani hint=
assert_nil(`object^ `message...^, \`\^^^)
..XPT

XPT ann hint=
assert_not_nil(`object^ `message...^, \`\^^^)
..XPT

XPT aeq hint=
assert_equal(`expected^, `actual^ `message...^, \`\^^^)
..XPT

XPT ane hint=
assert_not_equal(`expected^, `actual^ `message...^, \`\^^^)
..XPT

XPT aid hint=
assert_in_delta(`expected float^, `actual float^, `delta^ `message...^, \`\^^^)
..XPT

XPT ara hint=
assert_raise(`exception^) { `cursor^ }
..XPT

XPT anr hint=
assert_nothing_raised(`exception^) { `cursor^ }
..XPT

XPT aio hint=
assert_instance_of(`class^, `object to compare^ `message...^, \`\^^^)
..XPT

XPT ako hint=
assert_kind_of(`class^, `object to compare^ `message...^, \`\^^^)
..XPT

XPT art hint=
assert_respond_to(`object^, `resp. to this message^ `message...^, \`\^^^)
..XPT

XPT ama hint=
assert_match(/`regexp^/`flags^, `string^ `message...^, \`\^^^)
..XPT

XPT anm hint=
assert_no_match(/`regexp^/`flags^, `string^ `message...^, \`\^^^)
..XPT

XPT asa hint=
assert_same(`expected^, `actual^ `message...^, \`\^^^)
..XPT

XPT ans hint=
assert_not_same(`expected^, `actual^ `message...^, \`\^^^)
..XPT

XPT aop hint=
assert_operator(`obj1^, `operator^, `obj2^ `message...^, \`\^^^)
..XPT

XPT ath hint=
assert_throws(`expected symbol^ `message...^, \\`\\^^^) { `cursor^ }
..XPT

XPT ase hint=
assert_send(`send array (send array[1] to [0] with [x] as args; exp true).^ `message...^, \`\^^^)
..XPT

XPT app hint=
if __FILE__ == $PROGRAM_NAME
`cursor^
end
..XPT

XPT usai hint=
if ARGV`^
abort "Usage: #{$PROGRAM_NAME} `args^[options]^"
end
..XPT

XPT usau hint=
unless ARGV`^
abort "Usage: #{$PROGRAM_NAME} `args^[options]^"
end
..XPT

XPT rdoc hint=
=begin rdoc
`cursor^
=end
..XPT

call XPTemplate('y', {'syn' : 'comment'}, ":yields:")

XPT rb hint=
#!/usr/bin/env ruby -w
..XPT

XPT req hint=
require `lib^
..XPT

" require several libs
XPT reqs hint=
%w[`libs^].map {|lib| require lib}
..XPT

XPT _e hint=
__END__
..XPT

XPT _d hint=
__DATA__
..XPT

XPT _f hint=
__FILE__
..XPT

XPT array hint=
Array.new(`size^) {|`arg^i^| `cursor^ }
..XPT

XPT hash hint=
Hash.new {|`hash^hash^,`key^key^| `hash^[`key^] = `cursor^ }
..XPT

XPT kv hint=
:`key^ => `value^`...^, :`keyn^ => `valuen^`...^
..XPT

" path from here
XPT pathf hint=
File.join(File.dirname(__FILE__), "`path^../lib^")
..XPT

" unix filter
XPT unif hint=
ARGF.each_line do |`line^line^|
`cursor^
end
..XPT

XPT bm hint=
TESTS = `times^10_000^
Benchmark.bmbm do |results|
`cursor^
end
..XPT

XPT rep hint=
result.report("`name^: ") { TESTS.times { `cursor^ } }
..XPT

XPT Md hint=
File.open("`filename^", "wb") {|`file^file^| Marshal.dump(`obj^, `file^) }
..XPT

XPT Ml hint=
File.open("`filename^", "rb") {|`file^file^| Marshal.load(`file^) }
..XPT

XPT deec hint=
Marshal.load(Marshal.dump(`obj^))
..XPT

XPT Pn hint=
PStore.new("`filename^")
..XPT

XPT tra hint=
transaction(`^true^) { `cursor^ }
..XPT

XPT Yl hint=
File.open("`filename^.yaml") {|`file^file^| YAML.load(`file^) }
..XPT

XPT Yd hint=
File.open("`filename^.yaml", "wb") {|`file^file^| YAML.dump(`obj^,`file^) }
..XPT

XPT xml hint=
REXML::Document.new(File.read("`filename^"))
..XPT

XPT nam hint=
namespace :`ns^fileRoot()^ do
`cursor^
end
..XPT

XPT tas hint=
desc "`task description^"
task :`task name^RubySnakeCase()^^ do
`cursor^
end
..XPT

XPT begin hint=
begin
`^
rescue `ex^Exception^ => `e^e^
`block^  `...^
rescue `exn^ => `e^e^
`blockn^  `...^ `ensure...^
ensure
\`cursor\^^^
end
..XPT

" Instanciate a new object
XPT new hint=
`var^ = `Object^RubyCamelCase()^^.new
..XPT

