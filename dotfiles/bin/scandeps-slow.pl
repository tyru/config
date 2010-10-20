#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Getopt::Long;
use Pod::Usage;
use Scalar::Util qw(blessed);
use IO::Handle;
use Data::Dumper;
use List::Util qw(first);
use File::Spec;
use Memoize;
use Module::CoreList;

use List::MoreUtils qw(uniq after);
use PPI;


### sub ###
sub usage () {
    pod2usage(-verbose => 2);
}

my $verbose;
sub p {
    local $\ = "\n";
    print @_    if $verbose;
}

sub is_module {
    my ($mod) = @_;
    no strict;
    no warnings;
    eval "require $mod";
    $@ ? 0 : 1;
}

{
    local @INC = uniq @INC;
    sub get_module_path {
        my $mod = shift;
        $mod =~ s{::}{/}g;
        $mod .= ".pm";
        my $inc = first { -f File::Spec->catfile($_, $mod) } @INC;
        return undef    unless defined $inc;
        File::Spec->catfile($inc, $mod);
    }
}

{
    # for cache, and forbid to require recursively between modules.
    my %required_module_cache;

    sub required_module {
        my ($script_file) = @_;

        if (exists $required_module_cache{$script_file}) {
            return keys %{ $required_module_cache{$script_file} };
            # to re-run PPI, uncomment the following and delete the line above.
            # delete $required_module_cache{$script_file};
        }

        p "creating document for $script_file...";
        my $doc = PPI::Document->new($script_file) || return ();
        p "done.";
        my $include_nodes = $doc->find('PPI::Statement::Include');
        unless ($include_nodes) {
            return ();
        }

        my @required;
        for my $node (@$include_nodes) {
            my ($required) = after {
                $_ eq 'require'
                || $_ eq 'use'
                # needless?
                # || $_ eq 'no'
            } map {
                $_->{content}
            } grep {
                blessed($_) eq 'PPI::Token::Word'
            } @{ $node->{children} };

            next    unless defined $required;

            if ($required eq 'base') {    # base.pm
                # after 'base' of 'use base ...'
                my ($maybe_whitespace, @args) = after {
                    blessed($_) && $_->isa('PPI::Token::Word')
                    && $_->{content} eq 'base'
                } @{ $node->{children} };
                if ($maybe_whitespace->{content} !~ /\s+/ || @args == 0) {
                    die "assertion failed:" . Dumper($node);
                }

                push @required, map {
                    if ($_->isa('PPI::Token::Quote')) {
                        my $sep = $_->{separator};
                        my ($body) = $_->{content} =~ /$sep(.*)$sep/;
                        warn "body is empty"    if $body eq '';
                        $body;
                    } elsif ($_->isa('PPI::Token::Quote')) {
                        my $op = $_->{operator};    # qw, etc.
                        my ($a, $b) = split //, $_->{sections}[0]{type};
                        my ($body) = $_->{content} =~ /$op\s*$a(.*)$b/;
                        warn "body is empty"    if $body eq '';
                        split /\s+/, $body;    # inside of qw(Foo Bar)
                    } else {
                        ();
                    }
                } @args;
            } else {
                push @required, $required;
            }
        }
        return @required;
    }
}

sub dump_corelist {
    my @dep_modules = @_;
    my @not_core_modules;
    my $max_require_ver = -1;

    for my $module (@dep_modules) {
        my $require_ver = Module::CoreList->first_release($module);
        # if (defined $require_ver) {
        #     print "$module was first released with perl $require_ver\n";
        # } else {
        #     print "$module was not in CORE (or so I think)\n";
        # }
        if (defined $require_ver) {
            if ($max_require_ver < $require_ver) {
                $max_require_ver = $require_ver;
            }
        } else {
            push @not_core_modules, $module;
        }
    }

    return ($max_require_ver, \@not_core_modules);
}

sub print_dep_modules {
    my ($script_file, $argv) = @_;
    my %opt = map { $_ => ${ $argv->{$_} } } keys %$argv;

    return      unless -f $script_file;

    my @dep_modules = required_module($script_file);

    if ($opt{'recursive'}) {
        # for cache, and forbid to require recursively between modules.
        my %processed;
        for (my $i = 0; $i < @dep_modules; $i++) {
            my $path;
            if (exists $processed{$dep_modules[$i]}
                || ! defined($path = get_module_path($dep_modules[$i])))
            {
                next;
            }
            p "processing $dep_modules[$i]...$path";
            my @mod = required_module($path);
            if (@mod) {
                p "! $dep_modules[$i] requiring: ".join(' ', @mod);
                push @dep_modules, @mod;
            }
            $processed{$dep_modules[$i]} = 1;    # processed
        }
    }

    @dep_modules = grep { is_module($_) } uniq sort @dep_modules;
    my ($max_require_ver, $not_core_modules) = dump_corelist(@dep_modules);

    if ($opt{'1'}) {
        print "$_\n"    for @$not_core_modules;
    } else {
        if (@$not_core_modules) {
            print "$script_file depends on:\n";
            print "  $_\n"  for @$not_core_modules;
        } else {
            if ($max_require_ver == -1) {
                warn "can't dump corelist for $script_file\n";
            } else {
                print "$script_file works with perl $max_require_ver\n";
            }
        }
    }
}

### main ###
my $needhelp;
my $recursive;
my $one_col;
%ARGV = (
    help => \$needhelp,
    recursive => \$recursive,
    verbose => \$verbose,
    1 => \$one_col,
);
GetOptions(%ARGV) or usage;
usage   if $needhelp;

if ($verbose) {
    STDOUT->autoflush(1);
    STDERR->autoflush(1);
}

print_dep_modules($_, \%ARGV) for @ARGV;


__END__

=head1 NAME

    get-max-ver-requiring.pl - get max version to require


=head1 SYNOPSIS

    $ perl get-max-ver-requiring.pl <script or module file>

    $ perl get-max-ver-requiring.pl get-max-ver-requiring.pl
    foo.pl depends on:
      List::MoreUtils
      Module::Info
      PPI

    $ perl get-max-ver-requiring.pl foo.pl
    foo.pl works with perl 5.0006

    # prints entire required modules.
    $ perl get-max-ver-requiring.pl foo.pl -r

    # output for other command.
    # like a 'ls -1'.
    $ perl get-max-ver-requiring.pl foo.pl -1


=head1 OPTIONS

=over

=item -h, --help

show this help

=item -r, --recursive

search modules recursively

=item -1

list one module per line

=back


=head1 AUTHOR

tyru <tyru.exe@gmail.com>
