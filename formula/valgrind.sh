#!/bin/bash

GV_url="http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2"
GV_sha1="340757e91d9e83591158fe8bb985c6b11bc53de5"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "valgrind"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/bin"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--includedir=${UV_sysroot_dir}/include"
		"--disable-cxx"
		"--enable-threads"
	)
	
	FU_file_get_download

	FU_file_extract_tar

	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
