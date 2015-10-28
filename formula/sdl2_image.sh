#!/bin/bash

GV_url="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz"
GV_sha1="20b1b0db9dd540d6d5e40c7da8a39c6a81248865"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

#	export LIBTOOL="./libtool --tag=CC"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-libtool-lock"
		"--disable-sdltest"
		"--enable-pcx=no"
		"--enable-gif=no"
		"--enable-tga=no"
		"--enable-bmp=no"
		"--enable-webp=no"
		"--enable-xv=no"
		"--enable-pnm=no"
	)
	
	FU_file_get_download
	FU_file_extract_tar

#	FU_build_autogen
	export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	export CPPFLAGS="${CPPFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	export CXXFLAGS="${CXXFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	FU_build_configure
	cp ${UV_sysroot_dir}/bin/libtool ${GV_source_dir}/${GV_dir_name}/

	FU_build_make 
	FU_build_install 
	#"install-strip"
	FU_build_finishinstall
fi
