#!/bin/bash

GV_url="https://github.com/Pulse-Eight/libcec.git"
GV_sha1=""

FU_tools_get_names_from_url

FU_binaries_installed "/bin/cec-client"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	GV_build_start=`date +%s`
	
	GV_args=(

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

	export CFLAGS="$CFLAGS -I$UV_sysroot_dir/opt/vc/include -pthread"
	export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/opt/vc/lib -lbcm_host -ldl -lvcos -lrt -lvchiq_arm -lpthread -lm -lstdc++"
	FU_build_configure_cmake
	export CFLAGS="$CFLAGS -I$UV_sysroot_dir/opt/vc/include -pthread"
	export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/opt/vc/lib -lbcm_host -ldl -lvcos -lrt -lvchiq_arm -lpthread -lm -lstdc++"

	FU_build_make
	FU_build_install

	FU_build_finishinstall
	unset CFLAGS
	unset LDFLAGS
fi
