#/bin/sh

cwd=`pwd`
for i in `cat dotfiles.lst`; do
	[ -L "$HOME/$i" ] && rm -f "$HOME/$i"
done
