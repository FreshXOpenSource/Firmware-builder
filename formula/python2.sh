#!/bin/bash

GV_url="https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tar.xz"
GV_sha1="ee5a50c5562e7448f037d35fdedc18d95c748b9e"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "opt/python2/bin/python2"
if [ $? == 1 ]; then
	FU_tools_check_depend

	OPT_prefix="${UV_sysroot_dir}/opt/python2" 
	GV_args=(
		"--host=${GV_host}"
		"--prefix=${OPT_prefix}"
		"--libdir=${OPT_prefix}/lib"
		"--bindir=${OPT_prefix}/bin"
		"--includedir=${OPT_prefix}/include"
		"--enable-shared"
		"--disable-ipv6"
		#	TODO : generalise build system flag
		"--build=x86_64-apple-darwin15"
	)

	FU_file_get_download
	FU_file_extract_tar

	cd ${GV_source_dir}/${GV_dir_name}
	make distclean
	./configure
	make Parser/pgen
	mkdir ../../bin/Parser
	mv Parser/pgen ../../bin/Parser/hostpgen
	ln -s `which python` ../../bin/hostpython
	make distclean

	cd ../..

	export "CC=${UV_target}-gcc"
	export "AR=${UV_target}-ar"
	export "RANLIB=${UV_target}-ranlib"

	echo ac_cv_file__dev_ptmx=no > /tmp/config.site
	echo ac_cv_file__dev_ptc=no >> /tmp/config.site
	export CONFIG_SITE=/tmp/config.site

	FU_build_autogen
	FU_build_configure
	# Patch the makefile to create a hostsystem pgen file
	# Furthermore the hostsystem needs to provide a python 2.7.x (brew install python2 ...)
	gsed -i 's/\$.PGEN.*.\$.GRAMMAR_INPUT/\$\(HOSTPGEN\) \$\(GRAMMAR_INPUT/' ${GV_source_dir}/${GV_dir_name}/Makefile
	#gsed -i 's/^PGEN=.*/PGEN=\$\(HOSTPGEN\)/' ${GV_source_dir}/${GV_dir_name}/Makefile
	#FU_build_make HOSTPYTHON=${GV_base_dir}/bin/hostpython HOSTPGEN=${GV_base_dir}/bin/Parser/hostpgen -j 4
	FU_build_make -i -j4 install HOSTPYTHON=${GV_base_dir}/bin/hostpython HOSTPGEN=${GV_base_dir}/bin/Parser/hostpgen CROSS_COMPILE_TARGET=yes prefix=${OPT_prefix}

	rm /tmp/config.site

	FU_build_finishinstall
fi
