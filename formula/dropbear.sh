#!/bin/bash

GV_url="https://matt.ucc.asn.au/dropbear/releases/dropbear-2015.68.tar.bz2"
GV_sha1="bb5006059430e3c53f4128dd17b46f46f24db68b"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "scp"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--sbindir=${UV_sysroot_dir}/sbin"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_make PROGRAMS="scp"
	FU_build_install 
	FU_build_finishinstall
	ln -s ${UV_sysroot_dir}/sbin/sshd ${UV_sysroot_dir}/sbin/dropbear
	ln -s ${UV_sysroot_dir}/bin/ssh ${UV_sysroot_dir}/bin/dbclient
fi
