#!/bin/bash

#GV_sha1="e1330ef53e81894b7a42910ef3de5da18fc03206"
#GV_url="http://wallaby.freshx.de/wallyd-1.0.0.tar.gz"
GV_url="git@git.freshx.de:Wally/Firmware-wallyd"


GV_depend=(
	"sdl2"
	"curl"
)

FU_tools_get_names_from_url
FU_binaries_installed "wallyd"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_args=(
		"--host=${GV_host}"
		"--prefix=${UV_sysroot_dir}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--bindir=${UV_sysroot_dir}/usr/bin"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-raspberry"
	)
	
	#FU_file_get_download
	#FU_file_extract_tar
	FU_file_git_clone
	
	OCFLAGS=${CFLAGS}
	OLDFLAGS=${LDFLAGS}
	export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/opt/vc/include -I${UV_sysroot_dir}/opt/vc/include/interface/vcos/"
	export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/opt/vc/include/interface/vcos/pthreads -I${UV_sysroot_dir}/opt/vc/include/interface/vmcs_host/linux/"
	export LDFLAGS="-L${UV_sysroot_dir}/opt/vc/lib -Wl,-rpath -Wl,LIBDIR ${LDFLAGS}"
	FU_build_autogen
	FU_build_configure
	cp ${UV_sysroot_dir}/bin/libtool ${GV_source_dir}/${GV_dir_name}
	export PLUGINSDIR=${UV_sysroot_dir}/lib/wallyd/plugins
	export CC=${GV_host}-gcc
	export LD=${GV_host}-ld
	export CFLAGS="${CFLAGS} -fPIC -std=gnu99 -DRASPBERRY"
	export PLUGIN_CFLAGS="-fPIC -std=gnu99 -DRASPBERRY -I${UV_sysroot_dir}/opt/vc/include -I${UV_sysroot_dir}/opt/vc/include"
	FU_build_make
	export PATH=${UV_toolchain_dir}/${UV_target}/bin:$PATH
	FU_build_install
	FU_build_finishinstall	
	export CFLAGS=${OCFLAGS}
	export LDFLAGS=${OLDFLAGS}
fi
