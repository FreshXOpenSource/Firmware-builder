#!/bin/bash

GV_url="http://downloads.sourceforge.net/project/libpng/libpng16/older-releases/1.6.18/libpng-1.6.18.tar.gz"
GV_sha1="c936eaa83fcd65c3c0eb696fd1f0ecc8c04f241f"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libpng16.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/usr/bin"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libpng16"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
