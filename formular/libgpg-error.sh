#!/bin/bash

URL="ftp://ftp.gnupg.org/GnuPG/libgpg-error//libgpg-error-1.10.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--disable-nls"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build

cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${NAME}
Description: libgpg-errors library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir}
Cflags: -I\${includedir}
EOF
fi
