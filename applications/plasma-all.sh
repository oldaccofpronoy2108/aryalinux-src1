#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gconf
#REQ:gtk2
#REQ:gtk3
#REQ:frameworks5
#REQ:libpwquality
#REQ:libxkbcommon
#REQ:mesa
#REQ:wayland
#REQ:networkmanager
#REQ:pipewire
#REQ:pulseaudio
#REQ:qca
#REQ:sassc
#REQ:taglib
#REQ:xcb-util-cursor
#REQ:fftw
#REQ:gsettings-desktop-schemas
#REQ:libdbusmenu-qt
#REQ:libcanberra
#REQ:libinput
#REQ:linux-pam
#REQ:lm_sensors
#REQ:oxygen-icons5
#REQ:pciutils
#REQ:smartmontools


cd $SOURCE_DIR



NAME=plasma-all
VERSION=5.21.1

SECTION="KDE Plasma 5"

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


url=https://download.kde.org/stable/plasma/5.21.1/
cat > plasma-5.21.1.md5 << "EOF"
6704f5b7e08ddef06aaae2329c83edd0  kdecoration-5.21.1.tar.xz
6b7cc3ccf7881ea0d0bde07ead95860c  libkscreen-5.21.1.tar.xz
ad1b34a1fa173c92d279941333e15d04  libksysguard-5.21.1.tar.xz
672efd2a00cae728c602aee8dcbe6d34  breeze-5.21.1.tar.xz
cd2968bedf5a2f81df05921fb27d3c4d  breeze-gtk-5.21.1.tar.xz
2607a8599c0923e824a5d9a8661fe11d  kscreenlocker-5.21.1.tar.xz
2b0542f736741808cf08ea08f60b3b70  oxygen-5.21.1.tar.xz
a7254b02d4e52f406840090ad6cd1a04  kinfocenter-5.21.1.tar.xz
efa5758ce2ee0f8fd70f188198187f6a  ksysguard-5.21.1.tar.xz
bee63f7adde88fda32313b479050cc91  kwayland-server-5.21.1.tar.xz
56647c9a9a14c447013d734321dfeb28  kwin-5.21.1.tar.xz
a6d561c5183168449de63840888ec120  plasma-workspace-5.21.1.tar.xz
f94222d6d0237978e4a00d68abcf45b7  plasma-disks-5.21.1.tar.xz
582c0bc22874a5dd28f82c765b2562e8  bluedevil-5.21.1.tar.xz
1140e976e5cc8e157c0fb7d15058a07b  kde-gtk-config-5.21.1.tar.xz
85c2366ba57798df2cd2c4a006fa6430  khotkeys-5.21.1.tar.xz
b6ea73b30e16f05923840c79146d0280  kmenuedit-5.21.1.tar.xz
1dfd0ddec58bd28d93a09dea672dcb70  kscreen-5.21.1.tar.xz
cefd31bcc087e54faa00a619c762ba63  kwallet-pam-5.21.1.tar.xz
4faee9fba32bb4c4f69b98b23e3d5950  kwayland-integration-5.21.1.tar.xz
25867c8239bea61976bd3f5ab8af9e9f  kwrited-5.21.1.tar.xz
45bf96a93445d1ab3c9a63d8b40d8974  milou-5.21.1.tar.xz
09f1f2668113c01d327b9873ed4f80a6  plasma-nm-5.21.1.tar.xz
a8d0daf6e671c125e7f09e4b67f9f158  plasma-pa-5.21.1.tar.xz
0bc819955f9c5bc483d2b443b765d544  plasma-workspace-wallpapers-5.21.1.tar.xz
b9d5703a6e291e3ba4d8f967b83beb94  polkit-kde-agent-1-5.21.1.tar.xz
77758cb82a129155c4db2a0a4d14d993  powerdevil-5.21.1.tar.xz
31070b325b1673aec305b1d13fe7fc08  plasma-desktop-5.21.1.tar.xz
749d00234c2bc6991af0c0cd5bc36e96  kdeplasma-addons-5.21.1.tar.xz
94e3eb05ee7c06e25587dd6c198fcc7c  kgamma5-5.21.1.tar.xz
61cac749eec698ffaa4d54eaaf251565  ksshaskpass-5.21.1.tar.xz
#3f54255d7515f08615f7905329771ea6  plasma-sdk-5.21.1.tar.xz
c675d299cc468021ce31267a69589373  sddm-kcm-5.21.1.tar.xz
3311f6e733d26aa0a7803351cba7c0c5  discover-5.21.1.tar.xz
#9d4627fe5e15c972d1bd5902653eb15c  breeze-grub-5.21.1.tar.xz
#006bd972f30dbf79f5d8cc6702816361  breeze-plymouth-5.21.1.tar.xz
c30bbee8eed6943cb40144bcd70e9a55  kactivitymanagerd-5.21.1.tar.xz
8db9a652a9c40be8f092efda2d6a8463  plasma-integration-5.21.1.tar.xz
95d1ff516afb540c2a94297e6f816bb7  plasma-tests-5.21.1.tar.xz
#b536cd7d2274c552b740fbfce9920a9f  plymouth-kcm-5.21.1.tar.xz
dfe793c51a0654a38a80404fbda4de57  xdg-desktop-portal-kde-5.21.1.tar.xz
3a3de5e9e4caa35e95c009d2aa21cf04  drkonqi-5.21.1.tar.xz
b4295f7d395e547f7936b76717e2d4cd  plasma-vault-5.21.1.tar.xz
caf1b7d83ec0c75c315fce35f4fcc1b4  plasma-browser-integration-5.21.1.tar.xz
a19f5e8158322e91d08e93ccedc11feb  kde-cli-tools-5.21.1.tar.xz
3a626e27e0cf792142ad5269efe95ed9  systemsettings-5.21.1.tar.xz
5d7d94423d252301cf236db930d21357  plasma-thunderbolt-5.21.1.tar.xz
#b31c66f7c84c0d3177d116b3db06cd9e  plasma-nano-5.21.1.tar.xz
#e2a71cf0145b1f546bd4e1a483cd3017  plasma-phone-components-5.21.1.tar.xz
eee25dec70bffac0dc0858d6a53f829e  plasma-firewall-5.21.1.tar.xz
de0b75f307c6674971079abd1c3e0d6e  plasma-systemmonitor-5.21.1.tar.xz
ee1d2b217efbc83d16218d4370bd6098  qqc2-breeze-style-5.21.1.tar.xz
EOF
as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root
while read -r line; do

    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)
    touch /tmp/plasma-done
    if grep $file /tmp/plasma-done; then continue; fi
    wget -nc $url/$file
    if echo $file | grep /; then file=$(echo $file | cut -d/ -f2); fi

    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

    tar -xf $file
    pushd $packagedir

       mkdir build
       cd    build

       cmake -DCMAKE_INSTALL_PREFIX=/usr \
             -DCMAKE_BUILD_TYPE=Release         \
             -DBUILD_TESTING=OFF                \
             -Wno-dev ..  &&

        make
        as_root make install
    popd


    as_root rm -rf $packagedir
    as_root /sbin/ldconfig
echo $file >> /tmp/plasma-done

done < plasma-5.21.1.md5

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/pam.d/kde << "EOF" 
# Begin /etc/pam.d/kde

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     include        system-auth

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde
EOF

cat > /etc/pam.d/kde-np << "EOF" 
# Begin /etc/pam.d/kde-np

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     required       pam_permit.so

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde-np
EOF

cat > /etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth    include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

