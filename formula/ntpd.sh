#!/bin/bash

GV_url="https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p6.tar.gz"
GV_sha1="7244b0fb66ceb66283480e8f83a4c4a2099f9cd7"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "opt/addon/bin/ntpdate"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

#	export CC="${UV_target}-gcc"
#	export LD="${UV_target}-ld"

	OPT_prefix="${UV_sysroot_dir}/opt/addon"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${OPT_prefix}" 
		"--bindir=${OPT_prefix}/bin"
		"--sbindir=${OPT_prefix}/bin"
		"--libdir=${OPT_prefix}/lib"
		"--includedir=${OPT_prefix}/include"
		"--disable-nls"
		"--with-yielding-select=yes"
	)

	FU_file_get_download
	FU_file_extract_tar

	export LDFLAGS="${LDFLAGS} -ldl -lrt -lpthread"
	FU_build_autogen
	FU_build_configure

	FU_build_make
	FU_build_install
	FU_build_finishinstall

	unset CC
	unset LD
fi
