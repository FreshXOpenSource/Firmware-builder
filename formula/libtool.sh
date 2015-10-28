#!/bin/bash

GV_url="http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz"
GV_sha1="25b6931265230a06f0fc2146df64c04e5ae6ec33"

GV_depend=(
)

FU_tools_get_names_from_url
FU_binaries_installed "libtool"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall	
fi
