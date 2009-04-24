#!/bin/sh
# Last Change: 20-Apr-2002.

# Seach vim install directory
if [ -d "/usr/local/share/vim" ] ; then
  instdir="/usr/local/share/vim/vimfiles"
elif [ -d "/usr/share/vim" ] ; then
  instdir="/usr/share/vim/vimfiles"
else instdir="/usr/local/share/chalice"
fi

echo "Install directory: $instdir"

# Make install directory for chalice
mkdir -p $instdir

# Copy files of chalice to install directory
cp -R doc ftplugin plugin syntax $instdir
