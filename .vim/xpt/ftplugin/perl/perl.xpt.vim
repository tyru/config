if exists("b:__PERL_XPT_VIM__")
    finish
endif
let b:__PERL_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _condition/perl.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
" Based on snipmate's perl templates

call XPTemplate('sub', [
            \ 'sub `fun_name^ {',
            \ '    `cursor^',
            \ '}'
            \])

call XPTemplate( 'xif', '`expr^ if `cond^;' )
call XPTemplate( 'xwhile', '`expr^ while `cond^;' )
call XPTemplate( 'xunless', '`expr^ unless `cond^;' )
call XPTemplate( 'xforeach', '`expr^ foreach @`array^;' )

call XPTemplate('while', [
            \ 'while (`cond^) {',
            \ '    `cursor^',
            \ '}'
            \])
call XPTemplate('unless', [
            \ 'unless (`cond^) {',
            \ '    `cursor^',
            \ '}'
            \])

call XPTemplate('eval', [
            \ 'eval {',
            \ '    `risky^',
            \ '};',
            \ 'if ($@) {',
            \ '    `handle^',
            \ '}'
            \])

call XPTemplate('for', [
            \ 'for (my $`var^ = 0; $`var^ < `count^; $`var^++) {',
            \ '    `cursor^',
            \ '}'
            \])

call XPTemplate('foreach', [
            \ 'foreach my $`var^ (@`array^) {',
            \ '    `cursor^',
            \ '}'
            \])

call XPTemplate( 'package', [
            \ 'package `className^;',
            \ '',
            \ 'use base qw(`parent^);',
            \ '',
            \ 'sub new {',
            \ '    my $class = shift;',
            \ '    $class = ref $class if ref $class;',
            \ '    my $self = bless {}, $class;',
            \ '    $self;',
            \ '}',
            \ '',
            \ '1;',
            \ '' ])

