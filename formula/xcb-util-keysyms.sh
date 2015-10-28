#!/bin/bash

GV_url="http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.3.9.tar.bz2"
GV_sha1="74d9d0eeb13ec0e36b35f4b812e8073d1a09e51c"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xcb-keysyms.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-devel-docs"
		"--without-doxygen"
	)
	
	FU_file_get_download
	FU_file_extract_tar	
	
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi