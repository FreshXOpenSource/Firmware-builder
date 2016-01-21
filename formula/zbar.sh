#!/bin/bash

GV_url="http://sourceforge.net/projects/zbar/files/zbar/0.10/zbar-0.10.tar.gz/download"
GV_sha1="a389e21eb6b796689c6a2379e603b13bbf6d58c7"

FU_tools_get_names_from_url
GV_tar_name="zbar-0.10.tar.gz"
GV_dir_name="zbar-0.10"
GV_version="0.10"
FU_tools_installed "zbar.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}/opt"
		"--libdir=${UV_sysroot_dir}/opt/lib"
		"--bindir=${UV_sysroot_dir}/opt/bin"
		"--sbindir=${UV_sysroot_dir}/opt/bin"
		"--includedir=${UV_sysroot_dir}/opt/include"
		"--enable-shared"
		"--disable-static"
		"--without-imagemagick"
		"--without-python"
		"--without-gtk"
		"--without-qt"
		"--without-x"
#		"--disable-video"
	)

	FU_file_get_download
	FU_file_extract_tar

	gsed -i "s/linux\/videodev.h/libv4l1-videodev.h/" ${GV_source_dir}/${GV_dir_name}/configure.ac
	gsed -i "s/linux\/videodev.h/libv4l1-videodev.h/" ${GV_source_dir}/${GV_dir_name}/configure
	gsed -i "s/linux\/videodev.h/libv4l1-videodev.h/" ${GV_source_dir}/${GV_dir_name}/zbar/video/v4l1.c
	#rm ${GV_source_dir}/${GV_dir_name}/configure
	#(cd ${GV_source_dir}/${GV_dir_name}; autoreconf -f)

	FU_build_configure
	FU_build_make
	FU_build_install
	
fi
