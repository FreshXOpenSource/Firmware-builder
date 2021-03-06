#!/bin/bash

GV_url="https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz"
GV_sha1="28c109190345ce5469add8cf3f45c5dd57fe2a85"

GV_depend=()

FU_tools_get_names_from_url
GV_version="2.0.19-stable"
FU_tools_installed "${LV_formula%;*}.pc"

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
