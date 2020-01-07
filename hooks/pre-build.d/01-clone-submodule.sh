set -ue

cloned() {
  git submodule status | awk "\$2 == \"$1\"" | grep -q '^[^-]'
}

# Clone submodule
if [ "$pkgdir" ] && [ "$repos" ] && ! cloned "$pkgdir/$repos"; then
  git submodule update --init --recursive "$pkgdir/$repos"
  git --git-dir="$pkgdir/$repos/.git" checkout master
fi
