#!/bin/bash

GV_url="https://download.samba.org/pub/rsync/src/rsync-3.1.2.tar.gz"
GV_sha1="0d4c7fb7fe3fc80eeff922a7c1d81df11dbb8a1a"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "opt/addon/bin/rsync"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	OPT_prefix="${UV_sysroot_dir}/opt/addon"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${OPT_prefix}" 
		"--datadir=${OPT_prefix}" 
		"--libdir=${OPT_prefix}/lib"
		"--enable-shared"
		"--disable-static"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build_autogen	
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
