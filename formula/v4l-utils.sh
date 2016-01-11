#!/bin/bash

GV_url="http://linuxtv.org/downloads/v4l-utils/v4l-utils-1.8.1.tar.bz2"
GV_sha1="8a378134fd28e0fc0c8c84cd9da0dc4a48338113"

FU_tools_get_names_from_url
GV_version=${GV_version%.zip}
FU_tools_installed "libv4l2.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}"
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/bin"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--includedir=${UV_sysroot_dir}/include"
 	    "--datarootdir=${UV_sysroot_dir}/usr/share"
		"--with-udevdir=${UV_sysroot_dir}/lib/udev"
		"--enable-shared"
		"--disable-static"
		"--disable-libdvbv5"
		"--disable-rpath"
		"--disable-qv4l2"
		"--disable-doxygen-doc"
	)

	FU_file_get_download
	FU_file_extract_tar
	
	(cd ${GV_source_dir}/${GV_dir_name}/; ./bootstrap.sh)


	export LDFLAGS="${LDFLAGS} -lpthread"
	FU_build_configure
	FU_build_make
	FU_build_install
	
fi
