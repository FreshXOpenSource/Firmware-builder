#!/bin/bash

GV_url="ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.29.tar.bz2"
GV_sha1="8b456e2d8adf538aef3fc2d24aae2377509f9544"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "aplay"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--without-curses"
		"--disable-python"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
