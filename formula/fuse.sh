#!/bin/bash

GV_url="http://downloads.sourceforge.net/project/fuse/fuse-2.X/2.9.4/fuse-2.9.4.tar.gz"
GV_sha1="c8b25419f33624dc5240af6a5d26f2c04367ca71"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--exec-prefix=${UV_sysroot_dir}"
		"--sbindir=${UV_sysroot_dir}/usr/bin"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--disable-example"
		"--disable-lib"
		"--enable-shared"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	export MOUNT_FUSE_PATH=${UV_sysroot_dir}/usr/bin
	export INIT_D_PATH=${UV_sysroot_dir}/etc/init.d
	export UDEV_RULES_PATH=${UV_sysroot_dir}/etc/udev/rules.d

	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
