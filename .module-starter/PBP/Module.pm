package <MODULE NAME>;

use strict;
use warnings;
use Carp;

our $VERSION = eval '0.001';

use Exporter;
use base qw(Exporter);

our @EXPORT    = qw();
our @EXPORT_OK = qw();




sub new {
    my $self = shift;
    bless {}, $self;
}




1;
__END__

=head1 NAME

<MODULE NAME> - [One line description of module's purpose here]


=head1 VERSION

This document describes <MODULE NAME> version 0.0.1


=head1 SYNOPSIS

    use <MODULE NAME>;
  
  
=head1 DESCRIPTION


=head1 METHODS

=over

=item new()

create instance.

=back


=head1 DEPENDENCIES

None.


=head1 BUGS

    No known bugs.


=head1 AUTHOR

<AUTHOR>  C<< <<EMAIL>> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) <YEAR>, <AUTHOR> C<< <<EMAIL>> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
