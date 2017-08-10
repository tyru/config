#/bin/sh
set -e

DOTFILES_LIST=dotfiles.lst.mingw


cd `dirname $0`

if [ "$MSYSTEM" = "MINGW32" -a -f "$DOTFILES_LIST" ]; then
	os_convert() {
		re="^$1[ \t]+"
		entry=`egrep "$re" $DOTFILES_LIST || true`
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

get_from() {
	echo "$1" | awk -F'\t' '{ print $1 }'
}

get_to() {
	echo "$1" | awk -F'\t' '{ print $2 }'
}

# Split by newlines.
oldifs=$IFS
IFS="
"
for line in `cat dotfiles.lst`; do
	from=`get_from "$line"`
	to=`get_to "$line"`
	mkdir -p `dirname "$HOME/$to"`
	if [ ! -e "$HOME/$to" ]; then
		ln -T -s "`pwd`/dotfiles/$from" "$HOME/$to" && echo "created: $HOME/$to"
	else
		echo "skip: $HOME/$to"
	fi
done
