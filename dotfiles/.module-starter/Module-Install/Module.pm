package <MODULE NAME>;

use 5.10.0;
use strict;
use warnings;
use utf8;

our $VERSION = eval '0.001';

# use Exporter;
# use base qw(Exporter);

# our @EXPORT    = qw();
# our @EXPORT_OK = qw();

use Carp;
# gnu_compat: --opt="..." is allowed.
# no_bundling: single character option is not bundled.
# no_ignore_case: no ignore case on long option.
use Getopt::Long qw(:config gnu_compat no_bundling no_ignore_case);
use Pod::Usage;




sub run {
    GetOptions(
        'h|help' => \&__usage_exit,
    ) or __usage_exit();


    # TODO
}

sub __usage_exit {
    pod2usage(-verbose => 1);
}


# sub new {
#     my ($class) = @_;
#     bless {}, $class;
# }



1;
__END__

=head1 NAME

<MODULE NAME> - [One line description of module's purpose here]


=head1 SYNOPSIS

    use <MODULE NAME>;
  
  
=head1 DESCRIPTION


=head1 METHODS

=over

=item new()

create instance.

=back


=head1 BUGS

    No known bugs.


=head1 AUTHOR

<AUTHOR>  C<< <<EMAIL>> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) <YEAR>, <AUTHOR> C<< <<EMAIL>> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
