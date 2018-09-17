# Check if $PATH contains $prefix/bin
set -u

# skip if the bin directory doesn't exist
bindir=$prefix/bin
[ -d "$bindir" ] || exit 0

in_the_path() {
  echo "$PATH" | tr ':' '\n' | fgrep -q "$1"
}

if ! in_the_path $bindir; then
  cat <<EOM >&2

+=================================================+
| '$bindir' is not in your \$PATH !           |
| Please set your own .bash_profile, and so on.   |
+=================================================+
EOM
fi
