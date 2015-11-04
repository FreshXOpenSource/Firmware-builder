#!/bin/bash

#
#   This script copies all needed components from sysroot to the firmware folder
#

GV_base_dir=$(cd "`dirname ${0}`" && pwd -P)

. config.cfg

if [ -z "${UV_firmware_dir}" ]; then
    echo UV_firmware_dir not set in config.cfg
    exit 1
fi

SRC=${UV_sysroot_dir}
DEST=${UV_firmware_dir}
DESTBIN=${UV_firmware_dir}/usr/bin

test -e ${DESTBIN} || mkdir -p ${DESTBIN}
test -e ${DEST}/tmp || mkdir -p ${DEST}/tmp
test -e ${DEST}/opt/vc || mkdir -p ${DEST}/opt/vc
chmod 1777 ${DEST}/tmp

rsync -avp ${SRC}/lib/ ${DEST}/lib  --exclude "*.a" --exclude "*.la"
#--exclude "libnss*"
rsync -avp ${SRC}/bin/ ${DESTBIN}/
rsync -avp ${SRC}/sbin/ ${DESTBIN}/
rsync -avp ${SRC}/usr/sbin/ ${DESTBIN}/
rsync -avp ${SRC}/usr/bin/ ${DESTBIN}/
rsync -avp ${SRC}/opt/vc/{bin,lib} ${DEST}/opt/vc
rsync -avp ${SRC}/etc/ ${DEST}/etc

# Clean out
LIST="/usr/bin/c_rehash /usr/bin/libtool /usr/bin/libtoolize /usr/bin/openssl /usr/bin/pngfix  /usr/bin/ffprobe /usr/bin/ffserver /usr/bin/ffmpeg  /usr/bin/curl    /usr/bin/rdjpgcom /usr/bin/wrjpgcom /usr/bin/uniondbg /usr/bin/unionimap /usr/bin/unionctl /usr/bin/djpeg    /usr/bin/cjpeg    /usr/bin/jpegtran /usr/bin/strace-log-merge /usr/bin/png-fix-itxt    /usr/bin/strace-graph /usr/bin/dropbearkey /usr/bin/dropbearconvert /etc/init.d /lib/pkg-config /lib/cmake /usr/bin/freetype-config /usr/bin/sdl2-config /usr/bin/curl-config /usr/bin/libpng16-config"
for i in `echo $LIST`; do
    rm -rf ${DEST}$i
done

test -e $DEST/bin || ln -s usr/bin $DEST/bin
test -e $DEST/sbin || ln -s usr/bin $DEST/sbin
test -e $DEST/usr/sbin || ln -s bin $DEST/usr/sbin
test -e $DEST/init || ln -s usr/bin/busybox $DEST/init

echo Firmware created in $DEST

