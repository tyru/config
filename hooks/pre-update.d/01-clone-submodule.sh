set -ue

# Skip if no repository exists
[ "$repos" ] && [ -e "$pkgdir/$repos/.git" ] || exit 0

cloned() {
  git submodule status | awk "\$2 == \"$1\"" | grep -q '^[^-]'
}

# Clone submodule
if ! cloned "$pkgdir/$repos"; then
  git submodule update --init "$pkgdir/$repos"
fi
