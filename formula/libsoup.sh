#!/bin/bash

GV_url="http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.40/libsoup-2.40.3.tar.xz"
GV_sha1="63ce1d2b022b58831430099b28dee3b47fb63ed1"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libsoup-2.4.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--disable-glibtest"
		"--disable-gtk-doc"
		"--disable-nls"
		"--disable-tls-check"
		"--without-gnome"
	)

	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
