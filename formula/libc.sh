#!/bin/bash

#
#	This formula copies the cross-compilers core libc parts into the sysroot
#

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "ldconfig"

if [ $? == 1 ]; then

	#rsync -avp ${UV_toolchain_dir}/${UV_toolchain_libc}/lib/ ${UV_sysroot_dir}/lib/
	rsync -avp ${UV_toolchain_dir}/${UV_toolchain_libc}/${UV_target}/libc/lib/ ${UV_sysroot_dir}/lib/

	if [ $? == 1 ]; then
		exit 1
	fi
	rsync -avp ${UV_toolchain_dir}/${UV_target}/lib/libgcc_s.so* ${UV_sysroot_dir}/lib/
	if [ $? == 1 ]; then
		exit 1
	fi
	rsync -avp ${UV_toolchain_dir}/${UV_toolchain_libc}/${UV_target}/libc/sbin/ldconfig ${UV_sysroot_dir}/usr/bin/
	if [ $? == 1 ]; then
		exit 1
	fi

fi
