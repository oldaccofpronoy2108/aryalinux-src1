#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libgee
#REQ:libbamf3


cd $SOURCE_DIR

wget -nc https://launchpad.net/plank/1.0/0.11.89/+download/plank-0.11.89.tar.xz


NAME=plank
VERSION=0.11.89
URL=https://launchpad.net/plank/1.0/0.11.89/+download/plank-0.11.89.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr &&
make
sudo make install
mkdir -pv /usr/share/plank/themes
git clone https://github.com/kennyh0727/plank-themes
cd plank-themes
cp -r {anti-shade,paperterial,shade} /usr/share/plank/themes/
cd ..


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

