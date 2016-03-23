#!/bin/bash

#GV_url="http://ffmpeg.org/releases/ffmpeg-3.0.tar.bz2"
#GV_sha1="daa827a8d1b7d5be418087165a55bdad5197f9d5"
GV_url="http://ffmpeg.org/releases/ffmpeg-2.8.1.tar.bz2"
GV_sha1="95046cd9251b69c61b11ebcd1e163ac14d0fc2c6"

GV_depend=()

FU_tools_get_names_from_url
GV_version="54.31.100"
FU_tools_installed "libavutil.pc"

if [ $? == 1 ]; then

	GV_args=(
		"--cross-prefix=${GV_host}-"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--incdir=${UV_sysroot_dir}/include"
		"--bindir=${UV_sysroot_dir}/usr/bin"
		"--target-os=linux"
		"--arch=${GV_host}"
		"--disable-doc"
		"--enable-gpl"
#		"--enable-libx264"
		"--enable-nonfree"
		"--enable-openssl"
		"--disable-decoder=opus"
		"--enable-encoder=vc264"
		"--extra-libs=-ldl"
		"--enable-shared"

		#"--disable-d3d11va"
		#"--disable-dxva2"
		#"--disable-programs"
		#"--disable-static"
		#"--disable-encoders"
		#"--enable-debug=2"
		#"--assert-level=2"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
