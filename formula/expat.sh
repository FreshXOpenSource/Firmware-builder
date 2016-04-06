#!/bin/bash

GV_url="https://sourceforge.net/projects/expat/files/expat/2.1.1/expat-2.1.1.tar.bz2"
GV_sha1="ff91419882ac52151050dad0ee8190645fbeee08"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "${UV_sysroot_dir}/opt/addon/lib/pkgconfig/expat.pc"


if [ $? == 1 ]; then
	
	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}/opt/addon" 
		"--libdir=${UV_sysroot_dir}/opt/addon/lib"
		"--includedir=${UV_sysroot_dir}/opt/addon/include"
		"--enable-shared"
		"--disable-static"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install "installlib"
	FU_build_finishinstall	
fi
