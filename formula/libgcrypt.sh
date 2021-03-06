#!/bin/bash

GV_url="ftp://ftp.gnupg.org/gcrypt//libgcrypt/libgcrypt-1.5.0.tar.bz2"
GV_sha1="3e776d44375dc1a710560b98ae8437d5da6e32cf"

GV_depend=()

FU_tools_get_names_from_url
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
	
	PKG_libs="-lgcrypt"
	
	FU_build_pkg_file 
	FU_build_finishinstall
fi
