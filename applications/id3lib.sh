#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/id3lib/id3lib-3.8.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/id3lib-3.8.3-consolidated_patches-1.patch

NAME=id3lib
VERSION=3.8.3
URL=https://downloads.sourceforge.net/id3lib/id3lib-3.8.3.tar.gz

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

patch -Np1 -i ../id3lib-3.8.3-consolidated_patches-1.patch &&

libtoolize -fc                &&
aclocal                       &&
autoconf                      &&
automake --add-missing --copy &&

./configure --prefix=/usr --disable-static &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install  &&
cp doc/man/* /usr/share/man/man1 &&

install -v -m755 -d /usr/share/doc/id3lib-3.8.3 &&
install -v -m644 doc/*.{gif,jpg,png,ico,css,txt,php,html} \
                    /usr/share/doc/id3lib-3.8.3
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
