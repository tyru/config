#/bin/sh
set -e

cd `dirname $0`
for name in `ls -A dotfiles/`; do
	if [ -L "$HOME/$name" ]; then
	  rm -f "$HOME/$name"
	  echo "removed: $HOME/$name"
	fi
done
