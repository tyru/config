#/bin/sh

set -e

cd `dirname $0`

if [ "$MSYSTEM" = "MINGW32" ]; then
	os_convert() {
		re="^$1[ \t]+"
		entry=`egrep "$re" dotfiles.lst.mingw || true`
		if [ "$entry" ]; then
			echo "$entry" | sed -re "s/$re//"
		else
			echo "$1"
		fi
	}
else
	os_convert() {
		echo "$1"	# No conversion
	}
fi

for from in `cat dotfiles.lst`; do
	to=`os_convert "$from"`
	mkdir -p `dirname "$HOME/$to"`
	if ln -T -s "`pwd`/dotfiles/$from" "$HOME/$to"; then
		echo "created $HOME/$to"
	else
		echo "error: Could not create $HOME/$to"
	fi
done
