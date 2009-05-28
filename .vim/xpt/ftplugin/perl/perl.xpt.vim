if exists("b:__PERL_XPT_VIM__")
    finish
endif
let b:__PERL_XPT_VIM__ = 1


XPTvar $BODY    # some code here ...


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
XSET body=$BODY
sub `fun_name^ {
    `cursor^
}


XPT while hint=while\ (\ ..\ )\ {\ ..\ }
XSET body=$BODY
while (`cond^) {
    `cursor^
}


XPT unless hint=unless\ (\ ..\ )\ {\ ..\ }
XSET body=$BODY
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
XSET body=$BODY
for (my $`var^ = 0; $`var^ < `count^; $`var^++) {
    `cursor^
}


XPT foreach hint=foreach\ my\ ..\ (..){}
XSET body=$BODY
foreach my $`var^ (@`array^) {
    `cursor^
}



XPT package hint=
package `className^;

use base qw(`parent^);

sub new {
    my $class = shift;
    $class = ref $class if ref $class;
    my $self = bless {}, $class;
    $self;
}

1;


