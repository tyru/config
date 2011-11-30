#/bin/sh

cwd=`pwd`
for i in `cat dotfiles.lst`; do
	ln "$@" -T -s $cwd/dotfiles/$i ~/$i && echo "created ~/$i"
done
