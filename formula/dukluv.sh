#!/bin/bash

GV_url="https://github.com/FreshXOpenSource/dukluv.git"
GV_sha1=""

FU_tools_get_names_from_url
GV_version="0.8.1"

FU_tools_installed "dukluv.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	GV_build_start=`date +%s`
	
	GV_args=(
		"-DCMAKE_SYSTEM_NAME='Linux'"
		"-DCMAKE_SYSTEM_VERSION=1"
		"-DCMAKE_SYSTEM_PROCESSOR='arm'"
		"-DCMAKE_C_COMPILER='$UV_target-gcc'"
		"-DCMAKE_CXX_COMPILER='$UV_target-g++'"
		"-DCMAKE_FIND_ROOT_PATH='${CMAKE_FIND_ROOT_PATH} $UV_toolchain_dir'"
		"-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
		"${GV_source_dir}/${GV_dir_name}"
	)
	
	FU_file_git_clone
	(cd ${GV_source_dir}/${GV_dir_name}; git submodule init; git submodule update)
	
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	GV_dir_name="${GV_dir_name}/build"
	
	FU_build_configure_cmake
	FU_build_make
	FU_build_install

	FU_build_finishinstall
fi
