#!/bin/bash

GV_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.5.2.tar.gz"
GV_sha1="a0649cab12662370894599a3f3e7fbe4a6598e1c"
#GV_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.6.1.tar.bz2"
#GV_sha1="393447fbf64c107b20a1ccc9e9a9a52f39786ae0"

GV_depend=(
	"zlib"
)

FU_tools_get_names_from_url
GV_version="17.1.11"
FU_tools_installed "freetype2.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	export LIBPNG_CFLAGS=-I${UV_sysroot_dir}/include/libpng16
	export LIBPNG_LDFLAGS=-lpng16
	export CC_BUILD=/usr/bin/gcc
	#FU_build_autogen
	(cd ${GV_source_dir}/${GV_dir_name}; sh autogen.sh || exit 1)
	FU_build_configure
	rm -f "${GV_source_dir}/${GV_dir_name}config.mk"

	FU_build_make
	FU_build_install
	FU_build_finishinstall
	unset CC_BUILD
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/freetype2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
