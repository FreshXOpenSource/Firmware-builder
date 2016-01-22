#!/bin/bash

GV_url="https://github.com/Mayalinux/db/archive/v6.1.19.zip"
GV_sha1="e89a4d7208577486461f7a0d1e40addc4467a6a6"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "opt/addon/bin/db_load"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export CC="${UV_target}-gcc"
	export STRIP="${UV_target}-strip"

	OPT_prefix="${UV_sysroot_dir}/opt/addon"

	GV_dir_name="db-6.1.19"

	FU_file_get_download
	FU_file_extract_tar

	cd ${GV_source_dir}/${GV_dir_name}/build_unix

	../dist/configure \
		--host=arm-linux-gnueabi \
		--disable-java \
		--disable-sql \
		--disable-jdbc \
		--enable-compat185 \
		--enable-smallbuild \
		--enable-shared \
		--enable-stripped_messages \
		--prefix=${OPT_prefix}

	make
	make install
	make clean

	rm -rf ${OPT_prefix}/docs

	unset CC
	unset STRIP
fi
