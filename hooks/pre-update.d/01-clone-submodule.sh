set -ue

# Skip if no repository exists
[ "$repos" ] && [ -e "$pkgdir/$repos/.git" ] || exit 0

# Clone submodule
git submodule init $pkgdir/$repos
git submodule update $pkgdir/$repos
