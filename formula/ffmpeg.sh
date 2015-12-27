#!/bin/bash

GV_url="http://ffmpeg.org/releases/ffmpeg-2.8.1.tar.bz2"
GV_sha1="95046cd9251b69c61b11ebcd1e163ac14d0fc2c6"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "ffmpeg"

if [ $? == 1 ]; then

	GV_args=(
		"--cross-prefix=${GV_host}-"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--incdir=${UV_sysroot_dir}/include"
		"--bindir=${UV_sysroot_dir}/usr/bin"
		"--target-os=linux"
		"--arch=${GV_host}"
		"--enable-shared"

		#"--disable-d3d11va"
		#"--disable-dxva2"
		#"--disable-programs"
		#"--disable-static"
		#"--disable-encoders"
		#"--enable-debug=2"
		#"--assert-level=2"
		#"--disable-doc"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
