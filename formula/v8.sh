#!/bin/bash

GV_url="https://github.com/v8/v8/archive/4.10.10.zip"
GV_sha1="c077cc6c2f744f251f016de0be9e74d47370157c"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "opt/nodejs/bin/v8"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export LD="${UV_target}-ld"
	export CC="${UV_target}-gcc"
	export CXX="${UV_target}-g++"

	OPT_target="${UV_sysroot_dir}/opt/node"

	if [ "${UV_board}" == "beaglebone" ]; then
		FP="on"
		FPU="neon"
		FPT="hard"
		CPU="arm"
		ISV7="true"

	elif [ "${UV_board}" == "raspi2" ]; then
		FP="on"
		FPU="neon"
		FPT="hard"
		CPU="arm"
		ISV7="true"

	elif [ "${UV_board}" == "raspi" ]; then
		FP="on"
		FPU="vfp"
		FPT="hard"
		CPU="arm"
		ISV7="false"

	elif [ "${UV_board}" == "hardfloat" ]; then
		CPU="arm"
		FP="on"
		FPT="hard"
		FPU="vfp"
		ISV7="false"
	else
		CPU="arm"
		FP="off"
		FPT="soft"
		FPU="vfp"
		ISV7="false"
	fi

	GV_args=(
		"--prefix=${OPT_target}" 
		"--dest-cpu=${CPU}"
		"--dest-os=linux"
		"--with-arm-float-abi=${FP}"
		"--without-dtrace"
		"--with-arm-fpu=${FPU}"
		"--shared-openssl"
		"--shared-libuv"
		"--shared-zlib"
		"--shared-http-parser"
	)

	FU_file_get_download
	FU_file_extract_tar

	GV_dir_name="v8-4.10.10"

	# FU_build_configure
	FU_build_make arm.release armv7=${ISV7} hardfp=${FP} snapshot=off armfpu=${FPU} armfloatabi=${FPT} -j4 i18nsupport=off
	# FU_build_make
	FU_build_finishinstall

	unset CC
fi
