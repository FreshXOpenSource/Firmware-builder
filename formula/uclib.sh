#!/bin/bash

GV_url="http://downloads.uclibc-ng.org/releases/1.0.11/uClibc-ng-1.0.11.tar.xz"
GV_sha1="56767a4a97b3af53a1c65785020f446b44cfc389"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "uclib.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	FU_file_get_download
	FU_file_extract_tar
		
	echo Copying config file patches/uclib.config ${GV_source_dir}/${GV_dir_name}/.config
	cp patches/uclib.config ${GV_source_dir}/${GV_dir_name}/.config
	# See : http://lists.uclibc.org/pipermail/uclibc/2009-April/042355.html
	sed -i "s/\-Wl,\-z,defs//" ${GV_source_dir}/${GV_dir_name}/Rules.mak
	export CC=${UV_target}-gcc
	export HOSTCC=${CC}
	FU_build_make ARCH=arm CROSS_COMPILE=${UV_target}-
	FU_build_install
	FU_build_finishinstall
fi
