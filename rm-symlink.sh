#/bin/sh

cwd=`pwd`
for i in `cat dotfiles.lst`; do
	rm -f ~/$i
done
