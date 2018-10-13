set -ue

cloned() {
  git submodule status | awk "\$2 == \"$1\"" | grep -q '^[^-]'
}

# Clone submodule
if ! cloned "$pkgdir/$repos"; then
  git submodule update --init --recursive "$pkgdir/$repos"
fi
