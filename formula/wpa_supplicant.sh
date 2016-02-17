#!/bin/bash

GV_url="http://w1.fi/releases/wpa_supplicant-2.5.tar.gz"
GV_sha1="f82281c719d2536ec4783d9442c42ff956aa39ed"

GV_depend=()

FU_tools_get_names_from_url
FU_binaries_installed "wpa_supplicant"

if [ $? == 1 ]; then
	
    FU_tools_check_depend
    FU_file_get_download
    FU_file_extract_tar

    export    CC=${UV_target}-gcc
    export    AR=${UV_target}-ar
    export    RANLIB=${UV_target}-ranlib
    export    PREFIX=${GV_prefix}
    export    LDFLAGS="-L$UV_sysroot_dir/lib -lpthread -ldl"
    export    CFLAGS="-I${GV_source_dir}/${GV_dir_name}/src $CFLAGS -I$UV_sysroot_dir/include/libnl3 $LDFLAGS"

    do_cd "${GV_source_dir}/${GV_dir_name}/src"
    make V=1 

    do_cd "${GV_source_dir}/${GV_dir_name}/wpa_supplicant"
    cp defconfig .config
    echo CONFIG_LIBNL32=y >>.config
    echo LIBS+=-L$UV_sysroot_dir/lib -lpthread -lm -ldl >>.config
    make V=1 BINDIR=$UV_sysroot_dir/bin

    do_cd "${GV_source_dir}/${GV_dir_name}"
    install -m 0755 wpa_supplicant/wpa_cli ${UV_sysroot_dir}/bin
    install -m 0755 wpa_supplicant/wpa_passphrase ${UV_sysroot_dir}/bin
    install -m 0755 wpa_supplicant/wpa_supplicant ${UV_sysroot_dir}/bin

    unset CFLAGS
    unset LDFLAGS
    do_cd $GV_base_dir
fi
