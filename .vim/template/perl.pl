#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Getopt::Long qw(:config auto_help gnu_compat);
use Perl6::Say;
use Pod::Usage;





GetOptions(
    # some options here ...
) or pod2usage(-verbose => 2);


### FUNCTIONS ###


__END__

=head1 NAME

    <%filename%> - NO DESCRIPTION YET.


=head1 SYNOPSIS

    perl <%filename%> [args ...]
    ./<%filename%> [args ...]


=head1 OPTIONS

