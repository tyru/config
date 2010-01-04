#!/bin/sh
# Original script is from oreilly book "Linuxサーバ Hacks" (Linux Server Hacks)


die () {
    echo "$*" >&2
    exit 1
}

if [ -z "$1" ]; then
    echo "Usage: `basename $0` hostname"
    exit 1
fi

cd `dirname $0` || die "failed to chdir: $!"
tar zcf - . | ssh $1 "tar zpvxf -"
