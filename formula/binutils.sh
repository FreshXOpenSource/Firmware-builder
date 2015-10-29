#!/bin/bash

GV_url="http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz"
GV_sha1="f10c64e92d9c72ee428df3feaf349c4ecb2493bd"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "readelf"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}/usr/local" 
		"--sbindir=${UV_sysroot_dir}/usr/local/bin"
		"--bindir=${UV_sysroot_dir}/usr/local/sbin"
		"--libdir=${UV_sysroot_dir}/usr/local/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
