#!/bin/sh
# Original script is from oreilly book "Linuxサーバ Hacks" (Linux Server Hacks)

# TODO
# - install as given user


movein_dir="send_config"

die () {
    echo "$*" >&2
    exit 1
}

if [ -z "$1" ]; then
    echo "Usage: `basename $0` hostname"
    exit 1
fi

cd "`dirname $0`/$movein_dir" || die "failed to chdir: $!"
tar zhcf - . | ssh $1 "tar zpvxf -"
