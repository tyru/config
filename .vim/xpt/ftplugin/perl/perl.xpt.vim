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

XPTemplateDef

XPT xif hint=..\ if\ ..;
`expr^ if `cursor^;


XPT xwhile hint=..\ while\ ..;
`expr^ while `cursor^;


XPT xunless hint=..\ unless\ ..;
`expr^ unless `cursor^;


XPT xforeach hint=..\ foreach\ ..;
`expr^ foreach @`cursor^;


XPT sub hint=sub\ ..\ {\ ..\ }
sub `fun_name^ {
    `cursor^
}


XPT while hint=while\ (\ ..\ )\ {\ ..\ }
while (`cond^) {
    `cursor^
}


XPT unless hint=unless\ (\ ..\ )\ {\ ..\ }
unless (`cond^) {
    `cursor^
}


XPT eval hint=eval\ {\ ..\ };if...
eval {
    `risky^
};
if ($@) {
    `cursor^
}


XPT for hint=for\ (my\ ..;..;++)
for (my $`var^ = 0; $`var^ < `count^; $`var^++) {
    `cursor^
}


XPT foreach hint=foreach\ my\ ..\ (..){}
foreach my $`var^ (@`array^) {
    `cursor^
}


XPT package hint=
package `className^;

use base qw(`cursor^);

sub new {
    my $class = shift;
    $class = ref $class if ref $class;
    my $self = bless {}, $class;
    $self;
}

1;


