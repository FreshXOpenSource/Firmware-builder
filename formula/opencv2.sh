#!/bin/bash

GV_url="https://github.com/Itseez/opencv/archive/2.4.12.3.zip"
GV_sha1="fc162721b2b2a0ea764fbefaaa6144b9c1aa58c2"

GV_depend=(
	"cryptodev"
)

FU_tools_get_names_from_url
# pkgconfig created incorrectly (with v=2.4.12.2)
GV_version="2.4.12.2"
FU_tools_installed "opencv.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	FU_file_get_download
	FU_file_extract_tar
	
	GV_dir_name="opencv-2.4.12.3"
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
	GV_extension="zip"
	
	$SED -i 's/4.6/'$($UV_target-gcc -dumpversion)'/g' \
		"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"
	
	$SED -i 's/-${GCC_COMPILER_VERSION}//g' \
		"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"
	
	replace="${UV_toolchain_dir//\//\\/}"
	$SED -i "s/\/usr\/arm-linux-gnueabi\${FLOAT_ABI_SUFFIX}/${replace}/g" \
		"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"

	if [ -d "${GV_source_dir}/${GV_dir_name}/build" ]; then 
		rm -rf "${GV_source_dir}/${GV_dir_name}/build"
	fi
	
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	
	cd "${GV_source_dir}/${GV_dir_name}/build"
	
	if [ "${UV_board}" == "beaglebone" ]; then 
		softfp="OFF"
		hardfp="ON"
		enable_neon="ON"
		
	elif [ "${UV_board}" == "raspi2" ]; then 
		softfp="OFF"
		hardfp="ON"
		enable_neon="OFF"
		$SED -i 's/-mthumb//g' \
			"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"
		
	elif [ "${UV_board}" == "raspi" ]; then 
		softfp="OFF"
		hardfp="ON"
		enable_neon="OFF"
		$SED -i 's/-mthumb//g' \
			"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"
		
	elif [ "${UV_board}" == "hardfloat" ]; then 
		softfp="OFF"
		hardfp="ON"
		enable_neon="OFF"
		
	else
		softfp="ON"
		hardfp="OFF"
		enable_neon="OFF"
	fi

	GV_args=(
		"-DSOFTFP=${softfp}"
		"-DCMAKE_TOOLCHAIN_FILE='${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake'"
		"-DCMAKE_SYSTEM_LIBRARY_PATH:PATH='${UV_sysroot_dir}/lib'"
		"-DCMAKE_SYSTEM_INCLUDE_PATH:PATH='${UV_sysroot_dir}/include'"
		"-DCMAKE_LIBRARY_PATH:PATH='${UV_sysroot_dir}/lib'"
		"-DCMAKE_INCLUDE_PATH:PATH='${UV_sysroot_dir}/include'"
		"-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
		"-DCMAKE_INSTALL_NAME_TOOL=/usr/bin/install_name_tool"
		"-DENABLE_VFPV3=${hardfp}"
		"-DENABLE_NEON=${enable_neon}"
		"${GV_source_dir}/${GV_dir_name}"
#		"-DCMAKE_C_COMPILER_ENV_VAR=${UV_toolchain_dir}/bin/${UV_target}-gcc"
#		"-DCMAKE_CXX_COMPILER_ENV_VAR=${UV_toolchain_dir}/bin/${UV_target}-g++"
#		"-DCMAKE_C_COMPILER=${UV_toolchain_dir}/bin/${UV_target}-gcc"
#		"-DCMAKE_CXX_COMPILER=${UV_toolchain_dir}/bin/${UV_target}-g++"
	)

	echo ${UV_target}-gcc
	FU_build_configure_cmake
	FU_build_make
	FU_build_install
	
fi
