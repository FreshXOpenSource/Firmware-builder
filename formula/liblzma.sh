#!/bin/bash

GV_url="http://tukaani.org/xz/xz-5.1.4beta.tar.gz"

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-nls"
	"--disable-doc"
	"--disable-scripts"
	"--disable-lzma-links"
	"--disable-lzmainfo"
	"--disable-lzmadec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "liblzma.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi