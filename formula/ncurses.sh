#!/bin/bash

GV_url="https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz"
GV_sha1="3e042e5f2c7223bffdaac9646a533b8c758b65b5"

GV_depend=()

FU_tools_get_names_from_url
GV_version="5.9.20110404"
FU_tools_installed "ncurses.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/bin"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--includedir=${UV_sysroot_dir}/include"
		"--with-shared"
		"--without-debug"
		"--without-ada"
		"--enable-overwrite"
		"--disable-big-core"
		"--without-tests"
		"--without-manpages"
		"--enable-pc-files"
		"--with-build-cc=/usr/bin/gcc"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build_autogen
		
	#export BUILD_CC=/usr/bin/gcc
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
	#unset BUILD_CC

fi
