#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libpng
#REQ:mesa
#REQ:xbitmaps
#REQ:xcb-util


cd $SOURCE_DIR

NAME=x7app
VERSION=

SECTION="X Window System Environment"
DESCRIPTION="The Xorg applications provide the expected applications available in previous X Window implementations."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")



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

echo $USER > /tmp/currentuser

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > app-7.md5 << "EOF"
3b9b79fa0f9928161f4bad94273de7ae  iceauth-1.0.8.tar.bz2
c4a3664e08e5a47c120ff9263ee2f20c  luit-1.1.1.tar.bz2
215940de158b1a3d8b3f8b442c606e2f  mkfontscale-1.2.1.tar.bz2
92be564d4be7d8aa7b5024057b715210  sessreg-1.1.2.tar.bz2
93e736c98fb75856ee8227a0c49a128d  setxkbmap-1.3.2.tar.bz2
3a93d9f0859de5d8b65a68a125d48f6a  smproxy-1.0.6.tar.bz2
e96b56756990c56c24d2d02c2964456b  x11perf-1.6.1.tar.bz2
e50587c1bb832aafd1a19d91a0890a0b  xauth-1.1.tar.bz2
5b6405973db69c0443be2fba8e1a8ab7  xbacklight-1.2.3.tar.bz2
9956d751ea3ae4538c3ebd07f70736a0  xcmsdb-1.0.5.tar.bz2
25cc7ca1ce5dcbb61c2b471c55e686b5  xcursorgen-1.0.7.tar.bz2
8809037bd48599af55dad81c508b6b39  xdpyinfo-1.3.2.tar.bz2
480e63cd365f03eb2515a6527d5f4ca6  xdriinfo-1.0.6.tar.bz2
e1d7dc1afd3ddb8fab16d6a76f21a258  xev-1.2.4.tar.bz2
90b4305157c2b966d5180e2ee61262be  xgamma-1.0.6.tar.bz2
a48c72954ae6665e0616f6653636da8c  xhost-1.0.8.tar.bz2
ac6b7432726008b2f50eba82b0e2dbe4  xinput-1.6.3.tar.bz2
c45e9f7971a58b8f0faf10f6d8f298c0  xkbcomp-1.4.5.tar.bz2
c747faf1f78f5a5962419f8bdd066501  xkbevd-1.1.4.tar.bz2
502b14843f610af977dffc6cbf2102d5  xkbutils-1.0.4.tar.bz2
938177e4472c346cf031c1aefd8934fc  xkill-1.0.5.tar.bz2
61671fee12535347db24ec3a715032a7  xlsatoms-1.1.3.tar.bz2
4fa92377e0ddc137cd226a7a87b6b29a  xlsclients-1.1.4.tar.bz2
e50ffae17eeb3943079620cb78f5ce0b  xmessage-1.0.5.tar.bz2
51f1d30a525e9903280ffeea2744b1f6  xmodmap-1.0.10.tar.bz2
eaac255076ea351fd08d76025788d9f9  xpr-1.0.5.tar.bz2
2358e29133d183ff67d4ef8afd70b9d2  xprop-1.2.5.tar.bz2
fe40f7a4fd39dd3a02248d3e0b1972e4  xrandr-1.5.1.tar.xz
34ae801ef994d192c70fcce2bdb2a1b2  xrdb-1.2.0.tar.bz2
c56fa4adbeed1ee5173f464a4c4a61a6  xrefresh-1.0.6.tar.bz2
70ea7bc7bacf1a124b1692605883f620  xset-1.2.4.tar.bz2
5fe769c8777a6e873ed1305e4ce2c353  xsetroot-1.1.2.tar.bz2
b13afec137b9b331814a9824ab03ec80  xvinfo-1.1.4.tar.bz2
11794a8eba6d295a192a8975287fd947  xwd-1.0.7.tar.bz2
26d46f7ef0588d3392da3ad5802be420  xwininfo-1.1.5.tar.bz2
79972093bb0766fcd0223b2bd6d11932  xwud-1.0.5.tar.bz2
EOF
mkdir -pv app &&
cd app &&
grep -v '^#' ../app-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/app/ &&
md5sum -c ../app-7.md5
as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root
for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
     case $packagedir in
       luit-[0-9]* )
         sed -i -e "/D_XOPEN/s/5/6/" configure
       ;;
     esac

     ./configure $XORG_CONFIG
     make
     as_root make install
  popd
  rm -rf $packagedir
done
as_root rm -f $XORG_PREFIX/bin/xkeystone


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd