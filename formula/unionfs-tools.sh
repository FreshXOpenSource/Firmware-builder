#!/bin/bash

GV_url="http://download.filesystems.org/unionfs/unionfs-utils-0.x/unionfs_utils-0.2.tar.gz"
GV_sha1="a4e77fee93646df439b8cca0a9a6d547edf121fa"

GV_depend=("libuuid")

FU_tools_get_names_from_url
FU_binaries_installed "unionfs"

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
