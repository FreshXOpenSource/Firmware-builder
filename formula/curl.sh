#!/bin/bash

GV_url="https://curl.haxx.se/download/curl-7.47.1.tar.bz2"
GV_sha1="db57162affecaa320b462e35d2adbb37bf30bbe7"

GV_depend=(
	"zlib"
	"openssl"
	"libssh"
)

FU_tools_get_names_from_url
FU_tools_installed "libcurl.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lcrypto -lz -ldl "

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/usr/bin"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		#"--without-libssh2"
		"--enable-ipv6"
		"--disable-ldap"
		"--disable-ldaps"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall	
fi
