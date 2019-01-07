#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:opensp

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openjade-1.3.2-upstream-1.patch

NAME=openjade
VERSION=1.3.2
URL=https://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz

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

patch -Np1 -i ../openjade-1.3.2-upstream-1.patch
sed -i -e '/getopts/{N;s#&G#g#;s#do .getopts.pl.;##;}' \
-e '/use POSIX/ause Getopt::Std;' msggen.pl
export CXXFLAGS="$CXXFLAGS -fno-lifetime-dse" &&
./configure --prefix=/usr \
--mandir=/usr/share/man \
--enable-http \
--disable-static \
--enable-default-catalog=/etc/sgml/catalog \
--enable-default-search-path=/usr/share/sgml \
--datadir=/usr/share/sgml/openjade-1.3.2 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
make install-man &&
ln -v -sf openjade /usr/bin/jade &&
ln -v -sf libogrove.so /usr/lib/libgrove.so &&
ln -v -sf libospgrove.so /usr/lib/libspgrove.so &&
ln -v -sf libostyle.so /usr/lib/libstyle.so &&

install -v -m644 dsssl/catalog /usr/share/sgml/openjade-1.3.2/ &&

install -v -m644 dsssl/*.{dtd,dsl,sgm} \
/usr/share/sgml/openjade-1.3.2 &&

install-catalog --add /etc/sgml/openjade-1.3.2.cat \
/usr/share/sgml/openjade-1.3.2/catalog &&

install-catalog --add /etc/sgml/sgml-docbook.cat \
/etc/sgml/openjade-1.3.2.cat
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
echo "SYSTEM \"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd\" \
\"/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd\"" >> \
/usr/share/sgml/openjade-1.3.2/catalog
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
