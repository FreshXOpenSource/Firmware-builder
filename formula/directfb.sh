#!/bin/bash

GV_url="http://sources.buildroot.net/DirectFB-1.7.7.tar.gz"
GV_sha1="205d824906906303db9b096cc2d3bea0662e8860"

GV_depend=(
	"zlib"
	"tslib"
	"freetype"
	"libpng"
	"jpeg"
	"inputproto"
	"videoproto"
	"kbproto"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export LIBS="-lm"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--enable-zlib"
		"--enable-debug"
		"--disable-voodoo"
		"--disable-mmx"
		"--disable-sse"
		"--without-tools"
		"--with-gfxdrivers=none"
		"--with-sysroot=${UV_sysroot_dir}"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	echo -n "Patch ${GV_name}... "
	patch "${GV_source_dir}/${GV_dir_name}/gfxdrivers/davinci/davinci_c64x.c" \
		< "${GV_base_dir}/patches/directfb_davinci.patch" >$GV_log_file 2>&1
	FU_tools_is_error "patch"
	
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi

export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/lib/directfb-1.7-7"
