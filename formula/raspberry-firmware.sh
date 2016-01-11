#!/bin/bash

#
#	Adapt this to https://github.com/raspberrypi/firmware/archive/master.zip and fix the shasum
#   if you want the latest master version, but be aware of potential failures
#
GV_url="https://github.com/FreshXOpenSource/raspberrypi-firmware/archive/Firmware-4.13.zip"
GV_sha1="c82015fb5ca78dbbea27b279ed9b8dd00dc418f7"

GV_depend=()

# 	This needs to be adapted for newer firmware's (see git repo folder ./modules)
if [ ${UV_board} == "raspi" ]; then
	PI_KERNEL_VERSION="4.1.13+"
fi
if [ ${UV_board} == "raspi2" ]; then
	PI_KERNEL_VERSION="4.1.13-v7+"
fi

FU_tools_get_names_from_url
FU_binaries_installed "opt/vc/bin/tvservice"

if [ $? == 1 ]; then
	
	export PI_KERNEL_DEST="${UV_sysroot_dir}/lib/modules/${PI_KERNEL_VERSION}"
	export PI_KERNEL_SRC="${GV_source_dir}/${GV_dir_name}/modules/${PI_KERNEL_VERSION}"

	FU_file_get_download
	FU_file_extract_tar

	mv ${GV_source_dir}/raspberrypi-firmware-Firmware-4.13 ${GV_source_dir}/${GV_dir_name}

	#	Binaries and libs
	mkdir -p ${UV_sysroot_dir}/opt/vc
	rsync -avp ${GV_source_dir}/${GV_dir_name}/hardfp/opt/vc/bin/tvservice ${UV_sysroot_dir}/opt/vc/bin/
	rsync -avp ${GV_source_dir}/${GV_dir_name}/hardfp/opt/vc/bin/raspistill ${UV_sysroot_dir}/opt/vc/bin/
	rsync -avp ${GV_source_dir}/${GV_dir_name}/hardfp/opt/vc/bin/raspivid ${UV_sysroot_dir}/opt/vc/bin/
	rsync -avp ${GV_source_dir}/${GV_dir_name}/hardfp/opt/vc/lib ${UV_sysroot_dir}/opt/vc/
	rsync -avp ${GV_source_dir}/${GV_dir_name}/opt/vc/include ${UV_sysroot_dir}/opt/vc/

	#	Kernel modules for USB HID and Serial, Fuse, Squash, IPv6 and libs
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/usb
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/net/wireless/rtl8192cu
	mkdir -p ${PI_KERNEL_DEST}/kernel/sound/{arm,core}
	mkdir -p ${PI_KERNEL_DEST}/kernel/{fs,net,lib}
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/media/platform/bcm2835
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/media/v4l2-core

	rsync -avp ${PI_KERNEL_SRC}/modules.* ${PI_KERNEL_DEST}
	# WLAN
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/net/wireless/rtl8192cu/8192cu.ko ${PI_KERNEL_DEST}/kernel/drivers/net/wireless/rtl8192cu/
	# Video Support
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/media/platform/bcm2835/bcm2835-v4l2.ko ${PI_KERNEL_DEST}/kernel/drivers/media/platform/bcm2835
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/media/v4l2-core/*.ko ${PI_KERNEL_DEST}/kernel/drivers/media/v4l2-core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/media/media.ko ${PI_KERNEL_DEST}/kernel/drivers/media/
	# Audio
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/arm/snd-bcm2835.ko ${PI_KERNEL_DEST}/kernel/sound/arm/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd-pcm.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd-timer.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	# USB basic / ttl adapter
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/usb/serial/{pl2303*,usbserial*} ${PI_KERNEL_DEST}/kernel/drivers/usb/
	# FS
	rsync -avp ${PI_KERNEL_SRC}/kernel/fs/{fuse,squashfs,overlayfs} ${PI_KERNEL_DEST}/kernel/fs/
	# Net
	rsync -avp ${PI_KERNEL_SRC}/kernel/net/ipv6 ${PI_KERNEL_DEST}/kernel/net/

	#	Boot folder 
	if [ ${UV_board} == "raspi2" ]; then
		rsync -avp ${GV_source_dir}/${GV_dir_name}/boot ${UV_sysroot_dir} --exclude kernel.img
	fi
	if [ ${UV_board} == "raspi" ]; then
		rsync -avp ${GV_source_dir}/${GV_dir_name}/boot ${UV_sysroot_dir} --exclude kernel7.img
	fi

fi
