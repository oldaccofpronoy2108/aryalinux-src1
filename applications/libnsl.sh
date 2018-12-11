#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:rpcsvc-proto
#REQ:libtirpc

cd $SOURCE_DIR

wget -nc https://github.com/thkukuk/libnsl/archive/v1.2.0/libnsl-1.2.0.tar.gz

NAME=libnsl
VERSION=1.2.0
URL=https://github.com/thkukuk/libnsl/archive/v1.2.0/libnsl-1.2.0.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

autoreconf -fi                &&
./configure --sysconfdir=/etc &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install                  &&
mv /usr/lib/libnsl.so.2* /lib &&
ln -sfv ../../lib/libnsl.so.2.0.0 /usr/lib/libnsl.so
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
