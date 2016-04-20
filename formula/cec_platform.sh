#!/bin/bash

GV_url="https://github.com/Pulse-Eight/platform.git"
GV_sha1=""

FU_tools_get_names_from_url

FU_binaries_installed "/lib/libp8-platform.a"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	GV_build_start=`date +%s`
	
	GV_args=(
#		"-DCMAKE_TOOLCHAIN_FILE=../cmake/CrossCompile.cmake"
#	    "-DXCOMPILE_BASE_PATH=/path/to/tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi"
		"-DXCOMPILE_LIB_PATH=$UV_sysroot_dir/opt/vc/lib"
		"-DRPI_INCLUDE_DIR=$UV_sysroot_dir/opt/vc/include"
		"-DRPI_LIB_DIR=$UV_sysroot_dir/opt/vc/lib"
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
	
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	GV_dir_name="${GV_dir_name}/build"

	export CFLAGS="$CFLAGS -fPIC -DCMAKE_INSTALL_PREFIX=$UV_sysroot_dir"
	export LDFLAGS="$LDFLAGS -pthread -lpthread"
	FU_build_configure_cmake "-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
	FU_build_make "-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
	FU_build_install "-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"

	FU_build_finishinstall "-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
	unset CFLAGS
fi
