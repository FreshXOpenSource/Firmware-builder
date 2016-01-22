#!/bin/bash

GV_url="http://www.artfiles.org/gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2"
GV_sha1="0612270b103941da08376df4d0ef4e5662a2e9eb"

FU_tools_get_names_from_url

false

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export CC="${UV_target}-gcc" \
	export CXX="${UV_target}-g++" \
	export AR="${UV_target}-ar" \
	export RANLIB="${UV_target}-ranlib"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-languages=c,c++"

	)
	
#	FU_file_get_download
#	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make	
	FU_build_install

	FU_build_finishinstall

	unset CC
	unset CXX
	unset AR
	unset RANLIB
fi
