package <%filename_noext%>;

use strict;
use warnings;
use Carp;

use version;
our $VERSION = qv('0.0.0');

use base qw(Exporter);

our @EXPORT    = qw();
our @EXPORT_OK = qw();
our %EXPORT_TAGS = ();

# use base 'Class::Accessor::Fast';
# __PACKAGE__->mk_accessors(qw());
# use Perl6::Say;



sub new {
    my $self = shift;
    bless {}, $self;
}




1;
__END__
