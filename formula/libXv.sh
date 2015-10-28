#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/lib/libXv-1.0.7.tar.bz2"
GV_sha1="49c87e0ccb999966b7b1b4e72cb927f05e0835bd"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xv.pc"

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
	FU_build_install
	FU_build_finishinstall
fi
