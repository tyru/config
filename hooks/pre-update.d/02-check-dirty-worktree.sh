# Skip if no repository exists
[ "$repos" ] && [ -e "$pkgdir/$repos/.git" ] || exit 0

# Check if working tree is dirty or has untracked files
status=$(git --git-dir=$pkgdir/$repos/.git status --porcelain)
if [ "$status" != "" ]; then
  echo
  echo "!!!!! Working is dirty or has untracked files !!!!!" >&2
  echo "$status" >&2
  exit 1
fi
