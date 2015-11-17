#!/bin/bash

GV_url="http://dmalloc.com/releases/dmalloc-5.5.2.tgz"
GV_sha1="20719de78decbd724bc3ab9d6dce2ea5e5922335"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "dmalloc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/bin"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--includedir=${UV_sysroot_dir}/include"
		"--disable-cxx"
		"--enable-threads"
	#	"--enable-shlib"
	)
	
	FU_file_get_download

	FU_file_extract_tar

	(cd "${GV_source_dir}/${GV_dir_name}"; gsed -i "s/ac_cv_page_size=0/ac_cv_page_size=12/" configure)
 
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
