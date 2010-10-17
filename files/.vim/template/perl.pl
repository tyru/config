#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

# gnu_compat: --opt="..." is allowed.
# no_bundling: single character option is not bundled.
# no_ignore_case: no ignore case on long option.
use Getopt::Long qw(:config gnu_compat no_bundling no_ignore_case);
use Pod::Usage;

### sub ###
sub usage () {
    pod2usage(-verbose => 2);
}


### main ###
my $needhelp;
GetOptions(
    'h|help' => \$needhelp,
) or usage;
usage if $needhelp;




__END__

=head1 NAME

    <%filename%> - NO DESCRIPTION YET.


=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

tyru <<%email%>>
