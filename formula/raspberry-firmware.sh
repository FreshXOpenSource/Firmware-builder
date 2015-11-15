#!/bin/bash

#
#	Adapt this to https://github.com/raspberrypi/firmware/archive/master.zip
#   if you want the latest master version, but be aware of potential failures
#
GV_url="https://github.com/raspberrypi/firmware/archive/1.20150820.zip"
GV_sha1="fdb869cc13b074e0e000a930c601052cb86495d7"

GV_depend=()

# 	This needs to be adapted for newer firmware's (see git repo folder ./modules)
if [ ${UV_board} == "raspi" ]; then
	PI_KERNEL_VERSION="4.1.6+"
fi
if [ ${UV_board} == "raspi2" ]; then
	PI_KERNEL_VERSION="4.1.6-v7+"
fi

FU_tools_get_names_from_url
FU_binaries_installed "opt/vc/bin/tvservice"

if [ $? == 1 ]; then
	
	export PI_KERNEL_DEST="${UV_sysroot_dir}/lib/modules/${PI_KERNEL_VERSION}"
	export PI_KERNEL_SRC="${GV_source_dir}/${GV_dir_name}/modules/${PI_KERNEL_VERSION}"

	FU_file_get_download
	FU_file_extract_tar

	mv ${GV_source_dir}/firmware-1.20150820 ${GV_source_dir}/${GV_dir_name}

	#	Binaries and libs
	mkdir -p ${UV_sysroot_dir}/opt/vc
	rsync -avp ${GV_source_dir}/${GV_dir_name}/hardfp/opt/vc/bin/tvservice ${UV_sysroot_dir}/opt/vc/bin/
	rsync -avp ${GV_source_dir}/${GV_dir_name}/hardfp/opt/vc/lib ${UV_sysroot_dir}/opt/vc/
	rsync -avp ${GV_source_dir}/${GV_dir_name}/opt/vc/include ${UV_sysroot_dir}/opt/vc/

	#	Kernel modules for USB HID and Serial, Fuse, Squash, IPv6 and libs
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/usb
	mkdir -p ${PI_KERNEL_DEST}/kernel/drivers/net/wireless/rtl8192cu
	mkdir -p ${PI_KERNEL_DEST}/kernel/sound/{arm,core}
	mkdir -p ${PI_KERNEL_DEST}/kernel/{fs,net,lib}

	rsync -avp ${PI_KERNEL_SRC}/modules.* ${PI_KERNEL_DEST}
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/net/wireless/rtl8192cu/8192cu.ko ${PI_KERNEL_DEST}/kernel/drivers/net/wireless/rtl8192cu/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/arm/snd-bcm2835.ko ${PI_KERNEL_DEST}/kernel/sound/arm/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd-pcm.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/sound/core/snd-timer.ko ${PI_KERNEL_DEST}/kernel/sound/core/
	rsync -avp ${PI_KERNEL_SRC}/kernel/drivers/usb/serial/{pl2303*,usbserial*} ${PI_KERNEL_DEST}/kernel/drivers/usb/
	rsync -avp ${PI_KERNEL_SRC}/kernel/fs/{fuse,squashfs,overlayfs} ${PI_KERNEL_DEST}/kernel/fs/
	rsync -avp ${PI_KERNEL_SRC}/kernel/net/ipv6 ${PI_KERNEL_DEST}/kernel/net/

	#	Boot folder 
	if [ ${UV_board} == "raspi2" ]; then
		rsync -avp ${GV_source_dir}/${GV_dir_name}/boot ${UV_sysroot_dir} --exclude kernel.img
	fi
	if [ ${UV_board} == "raspi" ]; then
		rsync -avp ${GV_source_dir}/${GV_dir_name}/boot ${UV_sysroot_dir} --exclude kernel7.img
	fi

fi
