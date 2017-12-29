#/bin/sh
set -e

cd `dirname $0`
for name in `ls -A dotfiles/`; do
	mkdir -p `dirname "$HOME/$name"`
	if [ ! -e "$HOME/$name" ]; then
		ln -T -s "`pwd`/dotfiles/$name" "$HOME/$name" && echo "created: $HOME/$name"
	else
		echo "skip: $HOME/$name"
	fi
done
