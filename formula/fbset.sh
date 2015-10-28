#!/bin/bash

GV_url="http://users.telenet.be/geertu/Linux/fbdev/fbset-2.1.tar.gz"
GV_sha1="141c42769818a08f1370a60dc3a809d87530db78"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "fbset"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
