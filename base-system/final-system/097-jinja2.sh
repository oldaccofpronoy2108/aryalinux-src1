#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=097-jinja2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=Jinja2-3.0.3.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


python3 setup.py install --optimize=1

fi

cleanup $DIRECTORY
log $NAME