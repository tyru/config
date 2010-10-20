#!/bin/sh


true=":"
false="/bin/false"
success=0
failure=1


usage() {
    progname=`basename $0`

    cat <<EOM
    Usage: $progname [-h] [--] ...
EOM

    # More informative
    cat <<EOM
    Usage
        $progname [{options}] [--]

    Options
        -h
            Show help.
EOM

    exit 1
}

die() {
    [ $# != 0 ] && echo "$@"
    exit 1
}

warn() {
    echo "$@" >&2
}

main() {
    # TODO
}


while getopts h opt; do
    case $opt in
        h) usage ;;
    esac
done
shift `expr $OPTIND - 1`


main "$@"
