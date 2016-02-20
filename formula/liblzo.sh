#!/bin/bash

GV_url="http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz"
GV_sha1="e2a60aca818836181e7e6f8c4f2c323aca6ac057"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "lib/liblzo2.so"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		
		"--libdir=${UV_sysroot_dir}/lib"
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
