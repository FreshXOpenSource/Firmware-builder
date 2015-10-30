#!/bin/bash

#GV_url="http://jpegclub.org/support/files/jpegsrc.v8d1.tar.gz"
GV_sha1="d65ed6f88d318f7380a3a5f75d578744e732daca"
GV_url="http://www.ijg.org/files/jpegsrc.v9a.tar.gz"

GV_depend=()

FU_tools_get_names_from_url
GV_version="9a"
FU_tools_installed "${LV_formula%;*}.pc"

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

	GV_dir_name="jpeg-9a"
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
	PKG_libs="-ljpeg"
	
	FU_build_pkg_file 
	FU_build_finishinstall
fi
