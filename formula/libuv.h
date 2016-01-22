#!/bin/bash

GV_url="http://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz"
GV_sha1="46eaedb875ae6e63677b51ec583656199241d597"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--exec-prefix=${UV_sysroot_dir}"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
