#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:clisp
#REQ:texlive

cd $SOURCE_DIR

wget -nc http://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xindy-2.5.1-upstream_fixes-1.patch

NAME=xindy
VERSION=2.5.1
URL=http://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz

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

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

sed -i "s/ grep -v '^;'/ awk NF/" make-rules/inputenc/Makefile.in &&

sed -i 's%\(indexentry\)%\1\\%' make-rules/inputenc/make-inp-rules.pl &&

patch -Np1 -i ../xindy-2.5.1-upstream_fixes-1.patch &&

./configure --prefix=/opt/texlive/2018              \
            --bindir=/opt/texlive/2018/bin/$TEXARCH \
            --datarootdir=/opt/texlive/2018         \
            --includedir=/usr/include               \
            --libdir=/opt/texlive/2018/texmf-dist   \
            --mandir=/opt/texlive/2018/texmf-dist/doc/man &&

make LC_ALL=POSIX

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
