#!/bin/bash

GV_url="https://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz"
GV_sha1="3e042e5f2c7223bffdaac9646a533b8c758b65b5"

GV_depend=()

FU_tools_get_names_from_url
GV_version="5.9.20110404"
FU_tools_installed "ncurses.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	OPT_prefix="${UV_sysroot_dir}/opt/addon" 

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${OPT_prefix}" 
		"--libdir=${OPT_prefix}/lib"
		"--bindir=${OPT_prefix}/bin"
		"--sbindir=${OPT_prefix}/bin"
		"--includedir=${OPT_prefix}/include"
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
		
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall

fi
