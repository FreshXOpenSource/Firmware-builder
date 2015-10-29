#!/bin/bash

GV_url="http://downloads.sourceforge.net/project/strace/strace/4.10/strace-4.10.tar.xz"
GV_sha1="5c3ec4c5a9eeb440d7ec70514923c2e7e7f9ab6c"

GV_depend=()

FU_tools_get_names_from_url

if [ $? == 0 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}"
		"--bindir=${UV_sysroot_dir}/usr/bin"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	export CFLAGS="${CFLAGS} -I${UV_toolchain_dir}/${UV_target}/libc/usr/include/${UV_target} -I${UV_toolchain_dir}/${UV_target}/libc/usr/include"
	export CFLAGS_FOR_BUILD="${CFLAGS}"
	FU_build_autogen
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
