#!/bin/bash

#
#	This formula copies the glibc parts into the sysroot
#

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "ldconfig"

if [ $? == 1 ]; then

	rsync -avp ${UV_toolchain_dir}/${UV_target}/libc/lib/${UV_target}/ ${UV_sysroot_dir}/lib/
	rsync -avp ${UV_toolchain_dir}/${UV_target}/libc/sbin/ldconfig ${UV_sysroot_dir}/sbin/

fi
