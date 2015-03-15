#!/bin/bash

GV_url="ftp://xmlsoft.org/libxml2/libxslt-1.1.27.tar.gz"

DEPEND=(
	"libxml2"
	"libgcrypt"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--with-libxml-src=${GV_source_dir}/${LIBSML2SCR}"
	"--without-python"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "${GV_name}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
