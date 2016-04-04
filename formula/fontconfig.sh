#!/bin/bash

GV_url="http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.94.tar.bz2"
GV_sha1="5eb9b1fe8c3f9e0447b1238ade3c7af15b671a4d"

GV_depend=(
	"zlib"
	"expat"
	"freetype"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}/opt/addon" 
		"--libdir=${UV_sysroot_dir}/opt/addon/lib"
		"--includedir=${UV_sysroot_dir}/opt/addon/include"
		"--enable-shared"
		"--disable-static"
		"--disable-docs"
		"--with-arch=ARM"
		#--enable-libxml2
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
