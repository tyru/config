#!/bin/sh

project="chalice"
repouri="http://cvs.kaoriya.net/svn/kaoriya/vimscript/chalice/trunk"

if [ -r "VERSION" ] ; then
  version=`cat VERSION`
else
  version=`date +%Y%m%d_%H%M%S`
fi
dirname="${project}-${version}"
pkgname="${project}-${version}.tar.bz2"

if [ -d "$dirname" ] ; then
  echo "Already exist a directory: $dirname"
  exit 1
fi
if [ -e "$pkgname" ] ; then
  echo "Already exist a file: $pkgname"
  exit 1
fi

if ! svn export -q "$repouri" "$dirname" ; then
  exit 1
fi
tar cjf "$pkgname" "$dirname"
rm -rf "$dirname"
