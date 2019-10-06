#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=057-bison

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bison-3.4.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '9327 s/mv/cp/' Makefile.in
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.4.2
make -j1
make install

fi

cleanup $DIRECTORY
log $NAME