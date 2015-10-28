#!/bin/bash

GV_url="https://www.libsdl.org/tmp/release/SDL2-2.0.4.tar.gz"
GV_sha1="c1f94a2c476edabd87d3179dab266fb040e09eb1"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-libtool-lock"
		"--disable-dbus"
		"--disable-esd"
		"--disable-video-mir"
		"--disable-video-wayland"
		"--disable-video-x11"
		"--disable-video-opengl"
		"--disable-video-opengles"
		"--disable-video-opengles1"
		"--disable-video-opengles2"
		"--disable-libudev"
		"--disable-ibus"
		"--disable-alsa"
		"--enable-video-directfb"
#		"--enable-static=no"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_autogen
	FU_build_configure
	cp ${UV_sysroot_dir}/bin/libtool ${GV_source_dir}/${GV_dir_name}/

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
fi
