#!/bin/bash

GV_url="http://w1.fi/releases/wpa_supplicant-2.5.tar.gz"
GV_sha1="f82281c719d2536ec4783d9442c42ff956aa39ed"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--shared"
	)

	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_autogen
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
