#!/bin/bash

#
#	Adapt this to https://github.com/raspberrypi/firmware/archive/master.zip and fix the shasum
#   if you want the latest master version, but be aware of potential failures
#
GV_url="http://heikki.virekunnas.fi/wp-content/uploads/sites/2/2015/08/kernel-screen.tar.gz"
GV_sha1="30562ab7d73b93da3a91757cde257fb1d2e6b175"

GV_depend=()

# 	This needs to be adapted for newer firmware's (see git repo folder ./modules)
if [ ${UV_board} == "raspi" ]; then
	PI_KERNEL_VERSION="4.1.6+"
fi
if [ ${UV_board} == "raspi2" ]; then
	PI_KERNEL_VERSION="4.1.6-v7+"
fi

FU_tools_get_names_from_url

false

if [ $? == 1 ]; then
	
	export PI_KERNEL_DEST="${UV_sysroot_dir}/lib/modules/${PI_KERNEL_VERSION}"
	export PI_KERNEL_SRC="${GV_source_dir}/${GV_dir_name}/ext4/lib/modules/${PI_KERNEL_VERSION}"

	FU_file_get_download
	FU_file_extract_tar

	mkdir ${GV_source_dir}/${GV_dir_name}
	mv ${GV_source_dir}/fat32 ${GV_source_dir}/${GV_dir_name}
	mv ${GV_source_dir}/ext4 ${GV_source_dir}/${GV_dir_name}

	#	Kernel modules for USB HID and Serial, Fuse, Squash, IPv6 and libs
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/usb
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/net/wireless/rtl8192cu
	mkdir -p ${PI_KERNEL_DEST}/kernel/sound/{arm,core}
	mkdir -p ${PI_KERNEL_DEST}/kernel/{fs,net,lib}
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/staging/fbtft
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/video/fbdev

	rsync -avp ${PI_KERNEL_SRC}/modules.* ${PI_KERNEL_DEST}
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/net/wireless/rtl8192cu/8192cu.ko ${PI_KERNEL_DEST}/kernel/drivers/net/wireless/rtl8192cu/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/arm/snd-bcm2835.ko ${PI_KERNEL_DEST}/kernel/sound/arm/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd-pcm.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd-timer.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/usb/serial/{pl2303*,usbserial*} ${PI_KERNEL_DEST}/kernel/drivers/usb/
	rsync -avp ${PI_KERNEL_SRC}/kernel/fs/{fuse,squashfs,overlayfs} ${PI_KERNEL_DEST}/kernel/fs/
	rsync -avp ${PI_KERNEL_SRC}/kernel/net/ipv6 ${PI_KERNEL_DEST}/kernel/net/
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/staging/fbtft/{fb_ili9340.ko,fb_ili9341.ko} ${PI_KERNEL_DEST}/kernel/drivers/staging/fbtft
        rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/video/fbdev/* ${PI_KERNEL_DEST}/kernel/drivers/video/fbdev

	#	Boot folder 
	if [ ${UV_board} == "raspi2" ]; then
		mkdir ${UV_sysroot_dir}/boot
		rsync -avp ${GV_source_dir}/${GV_dir_name}/fat32/* ${UV_sysroot_dir}/boot --exclude kernel.img
		mv ${UV_sysroot_dir}/boot/kernel-screen.img ${UV_sysroot_dir}/boot/kernel7.img 
	fi
	if [ ${UV_board} == "raspi" ]; then
		echo Pi A/B not supported
		exit 1
	fi

fi
