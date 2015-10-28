#!/bin/bash

GV_url="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz"
GV_sha1="542865c604fe92d2f26000428ef733381caa0e8e"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-libtool-lock"
		"--disable-sdltest"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	export CPPFLAGS="${CPPFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	export CXXFLAGS="${CXXFLAGS} -I${UV_sysroot_dir}/include/SDL2"

	# Disable SDL2 OpenGL for the configure process
	mv ${UV_sysroot_dir}/include/SDL2/SDL_opengl.h ${UV_sysroot_dir}/include/SDL2/SDL_opengl.x
	FU_build_configure
	cp ${UV_sysroot_dir}/bin/libtool ${GV_source_dir}/${GV_dir_name}/
	mv ${UV_sysroot_dir}/include/SDL2/SDL_opengl.x ${UV_sysroot_dir}/include/SDL2/SDL_opengl.h


	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
