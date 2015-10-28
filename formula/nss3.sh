#!/bin/bash

GV_url="http://ftp.mozilla.org/pub/security/nss/releases/NSS_3_20_RTM/src/nss-3.20-with-nspr-4.10.8.tar.gz"
GV_sha1="1c608b5dba672249b94d2266e435eb23d761ff78"

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
	)
	
	FU_file_get_download
	FU_file_extract_tar

	mkdir ${GV_source_dir}/${GV_dir_name}/
	mv ${GV_source_dir}/nss-3.20/nss/* ${GV_source_dir}/${GV_dir_name}/
	rmdir ${GV_source_dir}/${GV_dir_name}/nss
	cp patches/arm-linux-gnueabihf-v7l.mk ${GV_source_dir}/${GV_dir_name}/coreconf/arm-linux-gnueabihf-v7l-$(uname -r).mk
	export OS_TARGET=arm-linux-gnueabihf-v7l-

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
