#!/bin/bash

GV_url="https://github.com/OpenVPN/openvpn/archive/v2.3.10.zip"
GV_sha1="1a7ce12e324025726d98be448c62a7f95eb0a674"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "openvpn"

if [ $? == 1 ]; then

	FU_tools_check_depend

	GV_dir_name="openvpn-2.3.10"

#	export CHOST=$UV_target
#	export CBUILD=$UV_target
#	export CC="${UV_target}-gcc"
	export IMAGEROOT="${UV_sysroot_dir}" 

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--sharedstatedir=${UV_sysroot_dir}/tmp" 
		"--disable-server"
		"--disable-plugin-auth-pam"
	)
	export LZO_CFLAGS="-I${UV_sysroot_dir}/include"
	export LZO_LIBS="-L${UV_sysroot_dir}/lib -llzo2"


	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_autoreconf
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall

	unset CFLAGS
	unset LDFLAGS
#	unset CHOST
#	unset CC
fi
