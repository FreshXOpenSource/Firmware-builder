#!/bin/sh

. $LBBASEPATH/config/system.conf

DISTRO=$1
KERNELVER=$2
ARCH=$3

if [ "X-f" == "X$DISTRO" ]; then
	DISTRO=$KERNELVER
	KERNELVER=$ARCH
	ARCH=$4
	FORCE=TRUE
fi

LBROOT=/linboot
ROOTFS=$LBROOT/rootfs
REPOSITORY=$LBROOT/sys/kernel
KRNREP=$REPOSITORY/kernel
CFGREP=$REPOSITORY/config

TFTP=$LBROOT/tftpboot/boot/ng
TFTPCONF=$LBROOT/tftpboot/config/config

SRCIMAGE=initrd-image/$ARCH
IMAGE=$KRNREP/$ARCH/initrd-$KERNELVER-$ARCH.cpio.gz.img
KERN=$KRNREP/$ARCH/vmlinuz-$KERNELVER-$ARCH
CONFIG=$CFGREP/pxeconfig-$KERNELVER-$ARCH
MODREP=$REPOSITORY/modules/$ARCH

SYSROOT=$ROOTFS/$DISTRO
MODULESDIR=${SYSROOT}/lib/modules/${KERNELVER}
SYSTEMMAP=$SYSROOT/boot/System.map-${KERNELVER}

if [ -z "$KERNELVER" ] || [ ! -d "$SYSROOT" ] || [ ! -d "$MODULESDIR" ] || [ ! -f "${MODULESDIR}/modules.dep" ] || [ -z "$ARCH" ]; then
    echo
    echo "Usage : $0 [-f] DISTRO KERNELVER ARCHITECTURE"
    echo "	DISTRO: 	Linux distribution under $ROOTFS"
    echo "	KERNELVER: 	the full kernel version (e.g. \"2.6.18-8.1.8.el5\")"
    echo "	ARCHITECTURE: 	i386 or x86_64"
    echo "	[KERNEL]: 	Path to the kernel file (if not found in $SYSROOT/boot/vmlinuz-KERNELVER"
#    echo "Params : $KERNELVER $SYSROOT $MODULESDIR ${MODULESDIR}/modules.dep $ARCH $IMAGE"
    echo ""
    if [ ! -d "$SYSROOT" ]; then echo Directory not found : $SYSROOT; fi
    if [ ! -d "$MODULESDIR" ]; then echo Directory not found : $MODULESDIR; fi
    if [ ! -f "${MODULESDIR}/modules.dep" ]; then echo File not found : ${MODULESDIR}/modules.dep; fi
    exit 1
fi

if [ ! -f "$SYSTEMMAP" ]; then
	echo "Expecting System.map to be at $SYSTEMMAP"
	exit 1
fi
if [ ! -f "$SYSROOT/boot/vmlinuz-${KERNELVER}" ]; then
	echo "Expecting vmlinuz to be at $SYSROOT/boot/vmlinuz-${KERNELVER}"
	echo "Please give additional parameter KERNEL"
	exit 1
fi


# copy a kernel module and its dependencies
newcopydep()
{
    local FILELIST DEPFILE MODULE TARGET
    
    DEPFILE="$1"
    MODULE="$2"
    TARGET="$3"

    modules=$(grep $MODULE $DEPFILE); 
    modules=${modules/:/}; 
    for m in $modules ; do 
    #    echo [ -f ${SYSROOT}/${m} ] \&\& cp -rp --remove-destination ${SYSROOT}/${m} $TARGET/${m}
        if [ -f ${SYSROOT}/${m} ]; then
	   mkdir -p `dirname "$TARGET/${m}"`
	   cp -rp --remove-destination "${SYSROOT}/${m}" "$TARGET/${m}"
	fi
    done
    
}

# mk temp folder
if [ -d __pxeboot-tmp__ ]; then
	echo "Clearing up old __pxeboot-tmp__ folder..."
	rm -rf __pxeboot-tmp__
fi


if [ -d ${SRCIMAGE} ]; then
	mkdir __pxeboot-tmp__
	cp -rp ${SRCIMAGE}/* __pxeboot-tmp__
	cp -p modules.conf __pxeboot-tmp__/etc/
else
	echo Extracting from ${SRCIMAGE}.tbz
	tar xfj ${SRCIMAGE}.tbz
	mv $ARCH __pxeboot-tmp__
fi

# copy network card drivers
echo -n "Copying module from netmodules.conf and its dependencies to initrd"
for i in `cat netmodules.conf`; do
	echo -n "."
	newcopydep "${MODULESDIR}/modules.dep" $i.ko "__pxeboot-tmp__"
done
echo .

# copy nfs and dependencies
echo -n "Copying module from modules.conf and its dependencies to initrd"
for i in `cat modules.conf`; do
	echo -n "$i "
	newcopydep "${MODULESDIR}/modules.dep" $i.ko "__pxeboot-tmp__"
done
echo .

cp modules.conf __pxeboot-tmp__/etc
cp netmodules.conf __pxeboot-tmp__/etc

# recalculate dependencies
depmod -a -F $SYSTEMMAP -b __pxeboot-tmp__ -C /dev/null $KERNELVER

if [ "x$FORCE" != "xTRUE" ]; then
	echo -n "Drop to a shell for hands-on [y/N]? "
	read S
else
	S=N
fi

if [ "Xy" == "X$S" -o "XY" == "X$S" ];then
	echo "Droping you into an shell, loop still mounted on ./__pxeboot-tmp__"
	echo "Exit to continue process!"
	(cd __pxeboot-tmp__;bash;cd /)
fi

echo "Creating image "
sleep 1

# GENERATE CPIO IMAGE
#(cd __pxeboot-tmp__; find . | cpio -o -c | gzip -9 >$IMAGE )

if [ -f "$IMAGE" ];then
	echo Initrd file $IMAGE already exists.
	if [ "x$FORCE" != "xTRUE" ]; then
		echo -n "Overwrite [Y/n]? "
		read X
	else
		X=Y
	fi
	if [ "Xn" == "X$X" -o "XN" == "X$X" ];then
		rm -rf __pxeboot-tmp__
		echo "Process stopped."
		exit
	else 
		echo Replacing old initrd
		rm -f $IMAGE
		# GENERATE CPIO IMAGE
		(cd __pxeboot-tmp__; find . | cpio -o -c | gzip -9 >$IMAGE )
	fi
else
#		echo -n Creating initrd :
		(cd __pxeboot-tmp__; find . | cpio -o -c | gzip -9 >$IMAGE )
fi

rm -rf __pxeboot-tmp__

DFLTLBSRV=`grep server._default ../menu/menu.txt|cut -d_ -f1`
DEFAULT_LB_SRV=`grep ${DFLTLBSRV}= ../menu/menu.txt | cut -d= -f2`

echo Found default linboot server $DEFAULT_LB_SRV in ../menu/menu.txt! Using for lb_setpxe config...

cat >$CONFIG <<EOF
implicit 0
allowoptions 0
default x_${DISTRO}_$ARCH
label x_${DISTRO}_$ARCH
        kernel /boot/ng/vmlinuz-$KERNELVER-$ARCH
        append distro=$DISTRO SELINUX=0 lbsrv=$DEFAULT_LB_SRV lbversion=14 initrd=/boot/ng/initrd-$KERNELVER-$ARCH.cpio.gz.img root=/dev/ram0 ramdisk_size=65535
EOF

echo Copying kernel and modules to the repository ...
cp $SYSROOT/boot/vmlinuz-$KERNELVER $KERN
cp -rp $MODULESDIR $MODREP/$KERNELVER

echo These files and folder were created:
echo FILE $KERN
echo FILE $IMAGE
echo FILE $CONFIG
echo DIR $MODREP/$KERNELVER
echo These entries are required for the menu generation:
echo osname_distroX_shortcut=$DISTRO
echo osname_distroX_kernel=vmlinuz-$KERNELVER-$ARCH
echo osname_distroX_initrd=initrd-$KERNELVER-$ARCH.cpio.gz.img


if [ "x$FORCE" != "xTRUE" ]; then
	echo -n "Populate the tftpserver [Y/n]? "
	read Y
else
	Y=Y
fi

if [ "XN" == "X$Y" -o "Xn" == "X$Y" ];then
	echo "Population skipped."
else
	cp -f $KERN $TFTP/
	cp -f $IMAGE $TFTP/
	cp $CONFIG $TFTPCONF/${DISTRO}-$KERNELVER-$ARCH
	echo To activate the config now run \"lb_setpxe \<HOST_MAC_OR_IP\> ${DISTRO}-$KERNELVER-$ARCH\"
fi

