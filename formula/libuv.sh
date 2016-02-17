#!/bin/bash

GV_url="http://dist.libuv.org/dist/v1.7.5/libuv-v1.7.5.tar.gz"
GV_sha1="b367c1e9e3333804d2aa91767cf2a54efdf3708d"


FU_tools_get_names_from_url
GV_version="1.7.5"
FU_tools_installed "libuv.pc"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--exec-prefix=${UV_sysroot_dir}"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	cp ./patches/* ${GV_source_dir}/${GV_dir_name}/
	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
