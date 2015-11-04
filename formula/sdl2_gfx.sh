#!/bin/bash

GV_url="http://downloads.sourceforge.net/project/sdl2gfx/SDL2_gfx-1.0.1.tar.gz"
GV_sha1="a136873b71a8c00c0233db26e0c1dad9629b4209"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

	OLDCFLAGS=${CFLAGS}
	OLDLDFLAGS=${LDFLAGS}

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-libtool-lock"
		"--disable-sdltest"
		"--disable-mmx"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	cp ${UV_sysroot_dir}/bin/libtool ${GV_source_dir}/${GV_dir_name}
	#FU_build_autogen
	export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	export CPPFLAGS="${CPPFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	export CXXFLAGS="${CXXFLAGS} -I${UV_sysroot_dir}/include/SDL2"
	FU_build_configure

	FU_build_make
	FU_build_install 
	#"install-strip"
	FU_build_finishinstall
	export CFLAGS=${OLDCFLAGS}
	export LDFLAGS=${OLDLDFLAGS}
fi
