#/bin/sh

cwd=`pwd`
for i in `cat dotfiles.lst`; do
	mkdir -p `dirname ~/$i`
	ln "$@" -T -s $cwd/dotfiles/$i ~/$i && echo "created ~/$i"
done
