#!/bin/bash

GV_url="https://github.com/nodejs/node/archive/v4.2.4.zip"
GV_sha1="571d121cb9c539932f58f73de26066dd38774d6c"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "opt/nodejs/bin/node"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export LD="${UV_target}-ld"
	export CC="${UV_target}-gcc"
	export CXX="${UV_target}-g++"

	OPT_target="${UV_sysroot_dir}/opt/node"

	if [ "${UV_board}" == "beaglebone" ]; then
		FP="hard"
		FPU="neon"
		CPU="arm"

	elif [ "${UV_board}" == "raspi2" ]; then
		FP="hard"
		FPU="neon"
		CPU="arm"

	elif [ "${UV_board}" == "raspi" ]; then
		FP="hard"
		FPU="vfp"
		CPU="arm"

	elif [ "${UV_board}" == "hardfloat" ]; then
		CPU="arm"
		FP="hard"
		FPU="vfp"
	else
		CPU="arm"
		FP="soft"
		FPU="vfp"
	fi

	GV_args=(
		"--prefix=${OPT_target}" 
		"--dest-cpu=${CPU}"
		"--dest-os=linux"
		"--with-arm-float-abi=${FP}"
		"--without-dtrace"
		"--with-arm-fpu=${FPU}"
	)

	FU_file_get_download
	FU_file_extract_tar

	GV_dir_name="node-4.2.4"

	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall

	unset CC
fi
