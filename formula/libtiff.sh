#!/bin/bash

GV_url="http://download.osgeo.org/libtiff/tiff-4.0.2.tar.gz"

DEPEND=(
	"zlib"
	"libjpeg"
	"liblzma"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-largefile"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "libtiff-4.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build

	cd $GV_base_dir
	rm -rf "${UV_sysroot_dir}/share"
fi
