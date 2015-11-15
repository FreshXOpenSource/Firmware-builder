#!/bin/bash

GV_url="ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.1.0.tar.bz2"
GV_sha1="1ad980aa5a1f3118d686f74d3973d64909e3efc3"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "aplay"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--datadir=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--sysconfdir=${UV_sysroot_dir}/etc"
		"--includedir=${UV_sysroot_dir}/include"
		"--datarootdir=${UV_sysroot_dir}/usr/share"
		"--bindir=${UV_sysroot_dir}/bin"
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--with-alsa-prefix=${UV_sysroot_dir}/lib"
		"--with-udev-rules-dir=${UV_sysroot_dir}/etc/udev"
		"--enable-shared"
		"--disable-xmlto"
		"--disable-bat"
		"--disable-static"
		"--disable-python"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build_autogen	
	FU_build_configure
	export ALSA_CONFIG_DIR=/etc
	export ALSA_PLUGINS_DIR=/usr/lib/alsa-lib
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
