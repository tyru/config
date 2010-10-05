#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use YAML ();

use base qw/Exporter/;
our @EXPORT = qw(
    install is_mswin say load_config
    get_home_from_user determine_user_and_home
);



sub install {
    # install $src to $dest as $user.
    my ($src, $dest, $user) = @_;

    unless (-e $src) {
        warn "$src:$!\n";
        return;
    }
    # Delete destination
    # TODO: Use rsync?
    rmtree($dest);

    say("$src -> $dest");
    unless (-d (my $dir = dirname($dest))) {
        mkpath $dir or die "$dir: $!";
    }
    system('cp', '-R' . ($^O eq 'MSWin32' ? '' : 'L'), $src, $dest);

    if ($^O eq 'MSWin32' || $^O eq 'msys') {
        # nop
    } elsif ($^O eq 'cygwin') {
        system('chown', '-R', $user, $dest);
    } elsif ($^O eq 'freebsd') {
        system('chown', '-R', $user, $dest);
    } else {
        system('chown', '-R', "$user:$user", $dest);
    }
}

sub is_mswin {
    $^O =~ /\A(MSWin32|cygwin)\Z/;
}

sub say {
    print @_, "\n" # orz
}

sub load_config {
    my ($config_file) = @_;
    die unless -f $config_file;
    YAML::LoadFile($config_file);
}

BEGIN {
    if ($^O eq 'MSWin32') {
        *determine_user_and_home = sub {
            my ($user, $home);

            unless (exists $ENV{HOME}) {
                die "Please set environment variable 'HOME'.";
            }
            unless (-d $ENV{HOME}) {
                die "%HOME% ($ENV{HOME}) is not accessible.";
            }
            $home = $ENV{HOME};
            $user = $ENV{USERNAME};

            unless (-d $home) {
                die "$home:$!"
            }

            ($user, $home);
        };
        *get_home_from_user = sub {
            unless (exists $ENV{HOME}) {
                die "Please set environment variable 'HOME'.";
            }
            return $ENV{HOME};
        };
    }
    else {
        *determine_user_and_home = sub {
            my ($user, $home);

            unless (exists $ENV{USER}) {
                die "Please set environment variable 'USER'.";
            }
            $user = $ENV{USER};

            if ($user eq 'root') {
                $home = "/root";
            }
            else {
                $home = "/home/$user";
            }

            unless (-d $home) {
                die "$home:$!"
            }

            ($user, $home);
        };
        *get_home_from_user = sub {
            my ($username) = @_;

            if ($username eq 'root') {
                return "/root";
            }
            else {
                return "/home/$username";
            }
        };
    }
}


__END__

=head1 NAME

    Util.pm - NO DESCRIPTION YET.


=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

tyru <tyru.exe@gmail.com>
