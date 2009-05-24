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
`expr^ if `cond^;


XPT xwhile hint=..\ while\ ..;
`expr^ while `cond^;


XPT xunless hint=..\ unless\ ..;
`expr^ unless `cond^;


XPT xforeach hint=..\ foreach\ ..;
`expr^ foreach @`array^;


XPT sub hint=sub\ ..\ {\ ..\ }
XSET body=$BODY
sub `fun_name^ {
    `body^
}


XPT while hint=while\ (\ ..\ )\ {\ ..\ }
XSET body=$BODY
while (`cond^) {
    `body^
}


XPT unless hint=unless\ (\ ..\ )\ {\ ..\ }
XSET body=$BODY
unless (`cond^) {
    `body^
}


XPT eval hint=eval\ {\ ..\ };if...
eval {
    `risky^
};
if ($@) {
    `handle^
}


XPT for hint=for\ (my\ ..;..;++)
XSET body=$BODY
for (my $`var^ = 0; $`var^ < `count^; $`var^++) {
    `body^
}


XPT foreach hint=foreach\ my\ ..\ (..){}
XSET body=$BODY
foreach my $`var^ (@`array^) {
    `body^
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


