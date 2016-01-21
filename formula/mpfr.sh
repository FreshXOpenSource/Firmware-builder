#!/bin/bash

GV_url="http://www.mpfr.org/mpfr-current/mpfr-3.1.3.tar.xz"
GV_sha1="383303f9de5ebe055b03b94642b03465baf9e6c7"

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
