#!/bin/sh
# Original script is from oreilly book "Linuxサーバ Hacks" (Linux Server Hacks)

# TODO
# - install as given user


server=''
movein_dir="send_config"

die () {
    echo "$*" >&2
    exit 1
}

usage () {
    echo "Usage: `basename $0` hostname"
    exit 1
}


case $# in
    1)
        server="$1"
        ;;
    2)
        server="$1"
        movein_dir="$2"
        ;;
    *) usage
        ;;
esac

cd "`dirname $0`" || die "failed to chdir: $!"
cd "$movein_dir" || die "failed to chdir: $!"
tar zhcf - . | ssh "$server" "tar zpvxf -"
