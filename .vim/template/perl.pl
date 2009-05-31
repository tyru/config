#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Getopt::Long;
use Perl6::Say;
use Pod::Usage;

### sub ###
sub usage () {
    pod2usage(-verbose => 2);
}


### main ###
my ($needhelp);
GetOptions(
    'help' => \$needhelp,
) or usage;
usage   if $needhelp;




__END__

=head1 NAME

    <%filename%> - NO DESCRIPTION YET.


=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

tyru <<%email%>>
