#!/bin/bash

GV_url="ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.0.tar.bz2"
GV_sha1="94b9af685488221561a73ae285c4fddaa93663e4"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "alsa.pc"

# TODO : fix /etc/alsa issue

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--enable-shared"
		"--disable-static"
		"--disable-python"
		"--with-configdir=/etc/alsa"
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/bin"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--includedir=${UV_sysroot_dir}/include"
                "--datarootdir=${UV_sysroot_dir}/usr/share"
                "--bindir=${UV_sysroot_dir}/bin"
                "--sbindir=${UV_sysroot_dir}/sbin"
      		"--with-alsa-prefix=/"
                "--with-udev-rules-dir=${UV_sysroot_dir}/etc/udev"
		"--with-configdir=/etc/alsa"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	export ALSA_CONFIG_DIR=/etc
	export ALSA_PLUGINS_DIR=/usr/lib/alsa-lib 
	FU_build_make
	FU_build_install "install-strip"
	cp -rp /etc/alsa ${UV_sysroot_dir}/etc
	FU_build_finishinstall
fi
