#!/bin/bash

GV_url="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.1.13.tar.xz"
GV_sha1="683398e7ae5b72f3fb71910f58728938cc2b6dc5"

FU_tools_get_names_from_url

if [ $? == 1 ]; then
	
	if [ ! -e ${UV_sysroot_dir}/include/Kbuild ]; then
		FU_file_get_download
		FU_file_extract_tar
		cp -rp ${GV_source_dir}/${GV_dir_name}/include/* ${UV_sysroot_dir}/opt/kernel/include
	fi

fi
