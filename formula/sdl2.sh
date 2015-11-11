#!/bin/bash

GV_url="https://www.libsdl.org/tmp/release/SDL2-2.0.4.tar.gz"
GV_sha1="c1f94a2c476edabd87d3179dab266fb040e09eb1"

if [ ${UV_board} == "raspi" ] || [ ${UV_board} == "raspi2" ]; then
	GV_depend=("raspberry-firmware")
else
	GV_depend=("")
fi

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

	if [ ${UV_board} == "raspi" ] || [ ${UV_board} == "raspi2" ]; then
		echo "Building for raspberry 1 or 2"
		OLDCFLAGS=${CFLAGS}
		OLDLDFLAGS=${LDFLAGS}
		export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/opt/vc/include -I${UV_sysroot_dir}/opt/vc/include/interface/vcos/pthreads -I${UV_sysroot_dir}/opt/vc/include/interface/vmcs_host/linux"
		export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/opt/vc/lib -lbcm_host -ldl -lvcos -lrt -lvchiq_arm -lpthread"
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
			"--disable-video-dummy"
			"--disable-video-wayland"
			"--disable-video-x11"
			"--disable-video-opengl"
			"--disable-libudev"
			"--disable-pulseaudio"
			"--enable-alsa"
			"--disable-ibus"
			"--disable-video-directfb"
		)
	else
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
		)
	fi

	FU_file_get_download
	FU_file_extract_tar

	FU_build_autogen
	if [ ${UV_board} == "raspi" ] || [ ${UV_board} == "raspi2" ]; then
		gsed -i "s/.raspberry-linux/linux/" ${GV_source_dir}/${GV_dir_name}/configure.in
		gsed -i "s/.raspberry-linux/linux/" ${GV_source_dir}/${GV_dir_name}/configure
	fi
	FU_build_configure
	cp ${UV_sysroot_dir}/bin/libtool ${GV_source_dir}/${GV_dir_name}/

	FU_build_make
	FU_build_install 
	FU_build_finishinstall
	export CFLAGS=${OLDCFLAGS}
	export LDFLAGS=${OLDLDFLAGS}
fi
