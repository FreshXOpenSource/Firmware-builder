#!/bin/bash

GV_url="http://www.infradead.org/~tgr/libnl/files/libnl-3.2.25.tar.gz"
GV_sha1="b7a4981f7edf7398256d35fd3c0b87bc84ae27d1"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/bin"
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
