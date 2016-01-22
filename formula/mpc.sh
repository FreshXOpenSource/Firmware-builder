#!/bin/bash

GV_url="ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.2.tar.gz"
GV_sha1="5072d82ab50ec36cc8c0e320b5c377adb48abe70"

FU_tools_get_names_from_url

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"

	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make	
	FU_build_install

	FU_build_finishinstall
fi
