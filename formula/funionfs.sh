#!/bin/bash

GV_url="http://funionfs.apiou.org/file/funionfs-0.4.3.tar.gz"
GV_sha1="c7d497e89a53dfd6f56c4cf0a205f60c01502158"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "funionfs"

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
