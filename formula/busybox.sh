#!/bin/bash

GV_url="http://busybox.net/downloads/busybox-1.24.0.tar.bz2"
GV_sha1="238a9b8a66c31fdcdd00790a840ef03cc77482c7"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "busybox"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	alias sed="gsed"
	
	OLDPATH=$PATH
	export PATH=${GV_base_dir}/bin:/usr/bin:$PATH
	FU_build_make ARCH=arm CROSS_COMPILE=${UV_target}- defconfig

	#	Comment out SYNC since it fails on some libc's
	sed -i "s/CONFIG_SYNC=y/CONFIG_SYNC=n/" ${GV_source_dir}/${GV_dir_name}/.config

	FU_build_make ARCH=arm CROSS_COMPILE=${UV_target}- BINDIR=${UV_sysroot_dir}/usr/bin
	PATH=$OLDPATH
	FU_build_make ARCH=arm CROSS_COMPILE=${UV_target}- install CONFIG_PREFIX=${UV_sysroot_dir} BINDIR=${UV_sysroot_dir}/usr/bin
	FU_build_finishinstall
fi
