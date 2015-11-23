#!/bin/bash

GV_url="http://www.dest-unreach.org/socat/download/socat-2.0.0-b8.tar.bz2"
GV_sha1="11853869b72612880f2eee42c56a5f3e70b76255"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "socat"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--datadir=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--disable-test"
		"--disable-sctp"
		"--disable-socks4"
		"--disable-socks4a"
		"--disable-proxy"
		"--disable-exec"
		"--disable-ext2"
		"--disable-readline"
		"--disable-tun"
		"--disable-sycls"
		"--disable-filan"
		"--disable-libwrap"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build_autogen	
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
