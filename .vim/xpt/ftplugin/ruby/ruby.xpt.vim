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

fun! s:f.RubyBlockArg() "{{{
  return s:f.SV("\^[\^|]\\(.\\{-}\\)[\^|]$","|&|")
endfunction "}}}

fun! s:f.RubySnackCase() "{{{
  return s:f.S(s:f.V(),'\<.',"\\u&")
endfunction "}}}


" ================================= Snippets ===================================

call XPTemplate('atw', "attr_writer :`writer^`...^, :`writern^`...^")
call XPTemplate('atr', "attr_reader :`reader^`...^, :`readern^`...^")


call XPTemplate('ata', "attr_accessor :`accessor^`...^, :`accessorn^`...^")

call XPTemplate('do', "
  \do `|...|^RubyBlockArg()^^\n
  \`cursor^\n
  \end")

call XPTemplate('blk', "
  \do |`arg^|\n
  \`block^\n
  \end")

call XPTemplate('begin', [
            \ 'begin',
            \ '   `expr^',
            \ '`...^rescue `error_type^',
            \ '    `expr^`...^',
            \ '`else...^else',
            \ '    \`expr\^^^',
            \ '`ensure...^ensure',
            \ '    \`expr\^^^',
            \ ''])

call XPTemplate('case', [
  \ 'case `target^',
  \ 'when `comparison^',
  \ '`^',
  \ '`...^',
  \ 'when `comparison^',
  \ '`^',
  \ '`...^',
  \ '`else...^else',
  \ '    \`\^^^',
  \ 'end',
  \ '' ])

call XPTemplate('con', "concat( `other_array^ )")

call XPTemplate('def', "
  \def `^\n
  \`^\n
  \end")

call XPTemplate('defi', "
  \def initialize`^\n
  \`^\n
  \end")

call XPTemplate('defs', "
  \def self.`^\n
  \`^\n
  \end")

call XPTemplate('tif', "(`boolean exp^) ? `exp if true^ : `exp if false^")

call XPTemplate('if', [
  \ 'if `boolean exp^',
  \ '`block^',
  \ '`...^',
  \ 'eslif `bool exp^',
  \ '   `block^`...^',
  \ '`else...^else',
  \ '   \`block\^^^',
  \ 'end',
  \ ''])

call XPTemplate('eli', "
  \elsif `boolean exp^\n
  \`block^")

call XPTemplate('unl', "
  \unless `boolean exp^\n
  \`block^\n
  \end")

call XPTemplate('ali', "alias `new^ `old^")

call XPTemplate('lam', "lambda { `block^ }")

call XPTemplate('beg', "
  \BEGIN {\n
  \`code to run while file loading^\n
  \}")

call XPTemplate('end', "
  \END {\n
  \`code to run after execution finished^\n
  \}")

call XPTemplate('war', "%w[`array of words^]")

call XPTemplate('War', "%W[`array of words^]")

call XPTemplate('sqs', "%q[`single quoted string^]")

call XPTemplate('dqs', "%Q[`double quoted string^]")

call XPTemplate('int', "#{`^}")

call XPTemplate('mod', "
  \module `module name^ \n
  \end")

call XPTemplate('cli', "
  \class `^\n
  \def initialize`^\n
  \`^\n
  \end\n
  \end")

call XPTemplate('cl', "
  \class `^\n
  \end")

call XPTemplate('subcl', "
  \class `^ < `parent^\n
  \end")

call XPTemplate('clstr', "
  \class `^ < Struct.new(:`arg_to_constructor^)\n
  \def initialize(*args)\n
  \`^\n
  \super\n
  \end\n
  \end")

call XPTemplate('dow', "downto(`lbound^) {|`arg^| `block^ }")

call XPTemplate('ste', "step(`count^) {|`arg^| `block^ }")

call XPTemplate('tim', "times {|`arg^| `block^ }")

call XPTemplate('upt', "upto(`ubound^) {|`arg^| `block^ }")

call XPTemplate('ea', "each {|`e^| `block^ }")

call XPTemplate('eai', "each_index {|`index^| `block^ }")

call XPTemplate('eak', "each_key {|`key^| `block^ }")

call XPTemplate('eal', "each_line {|`line^| `block^ }")

call XPTemplate('eav', "each_value {|`value^| `block^ }")

call XPTemplate('reve', "reverse_each {|`e^| `block^ }")

call XPTemplate('eap', "each_pair {|`name^, `value^| `block^ }")

call XPTemplate('eab', "each_byte {|`byte^| `block^ }")

call XPTemplate('eac', "each_char {|`char^| `block^ }")

call XPTemplate('eacon', "each_cons(`window size^) {|`cons^| `block^ }")

call XPTemplate('easli', "each_slice(`slice size^) {|`slice^| `block^ }")

call XPTemplate('win', "with_index {|`record^, `index^| `block^ }")

call XPTemplate('map', "map {|`arg^| `block^ }")

call XPTemplate('inj', "inject {|`accumulator^, `object^| `block^ }")

call XPTemplate('inj0', "inject(0) {|`accumulator^, `object^| `block^ }")

call XPTemplate('inji', "inject(`initial^) {|`accumulator^, `object^| `block^ }")

call XPTemplate('dirg', "Dir.glob('`dir^') {|`d^| `block^ }")

call XPTemplate('file', "File.foreach('`filename^') {|`line^| `block^ }")

call XPTemplate('open', "open('`filename [,mode]^') {|io| `block^ }")

call XPTemplate('sor', "sort {|`el1^, `el2^| `el2^ <=> `el1^ }")

call XPTemplate('sorb', "sort_by {|`arg^| `block^ }")

call XPTemplate('all', "all? {|`element^| `condition^ }")

call XPTemplate('any', "any? {|`element^| `condition^ }")

call XPTemplate('cfy', "classify {|`element^| `condition^ }")

call XPTemplate('col', "collect {|`obj^| `block^ }")

call XPTemplate('det', "detect {|`obj^| `block^ }")

call XPTemplate('fet', "fetch(`name^) {|`key^| `block^ }")

call XPTemplate('fin', "find {|`element^| `block^ }")

call XPTemplate('fina', "find_all {|`element^| `block^ }")

call XPTemplate('grep', "grep(/`pattern^/) {|`match^| `block^ }")

call XPTemplate('max', "max {|`element1^, `element2^| `block^ }")

call XPTemplate('min', "min {|`element1^, `element2^| `block^ }")

call XPTemplate('par', "partition {|`element^| `block^ }")

call XPTemplate('rej', "reject {|`element^| `block^ }")

call XPTemplate('sel', "select {|`element^| `block^ }")

call XPTemplate('sub', "sub(/`pattern^/) {|`match^| `block^ }")

call XPTemplate('gsub', "gsub(/`pattern^/) {|`match^| `block^ }")

call XPTemplate('scan', "scan(/`pattern^/) {|`match^| `block^ }")

call XPTemplate('tc', "
  \require 'test/unit'\n
  \require '`module^'\n
  \\n
  \class Test`NameOfTestCases^ < Test::Unit:TestCase\n
  \def test_`test case name^\n
  \end\n
  \end")

call XPTemplate('deft', "
  \def test_`case name^\n
  \`cursor^
  \end")

call XPTemplate('ass', "assert(`boolean condition^ `message...^, \\`\\^^^)")

call XPTemplate('ani', "assert_nil(`object^ `message...^, \\`\\^^^)")

call XPTemplate('ann', "assert_not_nil(`object [, message]^)")

call XPTemplate('aeq', "assert_equal(`expected^, `actual [, message]^)")

call XPTemplate('ane', "assert_not_equal(`expected^, `actual [, message]^)")

call XPTemplate('aid', "assert_in_delta(`expected float^, `actual float^, `delta [, message]^)")

call XPTemplate('ara', "assert_raise(`exception^) { `block^ }")

call XPTemplate('anr', "assert_nothing_raised(`exception^) { `block^ }")

call XPTemplate('aio', "assert_instance_of(`class^, `object to compare [, message]^)")

call XPTemplate('ako', "assert_kind_of(`class^, `object to compare [, message]^)")

call XPTemplate('art', "assert_respond_to(`object^, `resp. to this message [, message]^)")

call XPTemplate('ama', "assert_match(/`regexp^/`flags^, `string [, message]^)")

call XPTemplate('anm', "assert_no_match(/`regexp^/`flags^, `string [, message]^)")

call XPTemplate('asa', "assert_same(`expected^, `actual [, message]^)")

call XPTemplate('ans', "assert_not_same(`expected^, `actual [, message]^)")

call XPTemplate('aop', "assert_operator(`obj1^, `operator^, `obj2 [, message]^)")

call XPTemplate('ath', "assert_throws(`expected symbol [, message]^) { `block^ }")

call XPTemplate('ase', "assert_send(`send array (send array[1] to [0] with [x] as args; exp true). [, message]^)")

