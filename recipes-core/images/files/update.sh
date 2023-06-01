#!/bin/sh

#irrepspective of boot device, uboot.env is always at mmc[0:3]
#change uboot config parameter CONFIG_ENV_FAT_DEVICE_AND_PART="0:3" for diffferent node
UBOOT_ENV_DEV=/dev/mmcblk0p3
UBOOT_ENV_MOUNT=/tmp/boot

if [ $# -lt 1 ]; then
        exit 0;
fi

function get_boot_device() {
        for i in `cat /proc/cmdline`; do
                case "$i" in
                        root=*)
                                ROOT="${i#root=}"
                                ;;
                esac
        done
}

function get_update_part() {
	OFFSET=$((${#ROOT}-1))
	CURRENT_PART=${ROOT:$OFFSET:1}
	if [ $CURRENT_PART -eq "5" ]; then
		UPDATE_PART="4";
		UPDATE_UBOOT_PART="1";
		CURRENT_UBOOT_PART="2";
	else
		UPDATE_PART="5";
		UPDATE_UBOOT_PART="2";
		CURRENT_UBOOT_PART="1";
	fi
}

function get_update_block_device() {
        UPDATE_ROOT=${ROOT%?}${UPDATE_PART}
        UPDATE_KERNEL=${ROOT%?}3
        UPDATE_UBOOT=${ROOT%?}${UPDATE_UBOOT_PART}
	if [ $UPDATE_KERNEL == $UBOOT_ENV_DEV ]; then
		UPDATE_MOUNT_PATH=$UBOOT_ENV_MOUNT
	else
		UPDATE_MOUNT_PATH=/tmp/boot_update
	fi
}

if [ $1 == "preinst" ]; then
        # get current root device
        get_boot_device
        echo Booting from $ROOT...
        # now get the block device to be updated
        get_update_part
        get_update_block_device
        echo Updating $UPDATE_ROOT...
        echo Updating $UPDATE_KERNEL...
        echo Updating $UPDATE_UBOOT...
	if [ $UPDATE_KERNEL == $UBOOT_ENV_DEV ]; then
        	mkdir -p ${UBOOT_ENV_MOUNT}/boot-0
        	mkdir -p ${UBOOT_ENV_MOUNT}/boot-1
        	mkdir -p ${UBOOT_ENV_MOUNT}/update
	else
		mkdir -p ${UPDATE_MOUNT_PATH}
		mount $UPDATE_KERNEL ${UPDATE_MOUNT_PATH}
        	mkdir -p ${UPDATE_MOUNT_PATH}/boot-0
        	mkdir -p ${UPDATE_MOUNT_PATH}/boot-1
        	mkdir -p ${UPDATE_MOUNT_PATH}/update
		umount $UPDATE_KERNEL && sync
	fi
        # create symlink for update convenience
        ln -sf $UPDATE_ROOT /dev/update_root
        ln -sf $UPDATE_KERNEL /dev/update_kernel
        ln -sf $UPDATE_UBOOT /dev/update_uboot
fi

if [ $1 == "postinst" ]; then
        get_boot_device
        get_update_part
        get_update_block_device
	if [ $UPDATE_KERNEL != $UBOOT_ENV_DEV ]; then
		mount $UPDATE_KERNEL ${UPDATE_MOUNT_PATH}
	fi
	cur_boot_dir=`(fw_printenv boot_path)`
	if [ ${cur_boot_dir} == "boot_path=/boot-1/" ]; then
		cp ${UPDATE_MOUNT_PATH}/update/* ${UPDATE_MOUNT_PATH}/boot-0/
		fw_setenv boot_prefixes /boot-0/
		fw_setenv boot_path /boot-0/
	else
		cp ${UPDATE_MOUNT_PATH}/update/* ${UPDATE_MOUNT_PATH}/boot-1/
		fw_setenv boot_prefixes /boot-1/
		fw_setenv boot_path /boot-1/
	fi
	if [ $UPDATE_KERNEL == $UBOOT_ENV_DEV ]; then
		rm -rf ${UBOOT_ENV_MOUNT}/update
	else
		rm -rf /tmp/boot_update/update
		umount $UPDATE_KERNEL && sync
	fi

        if [[ -h "/dev/update_root" ]]; then
                rm /dev/update_root
        fi
        if [[ -h "/dev/update_kernel" ]]; then
                rm /dev/update_kernel
        fi
        if [[ -h "/dev/update_uboot" ]]; then
                rm /dev/update_uboot
        fi

	BOOT_DEVICE=${ROOT::-2}
	echo boot device:${BOOT_DEVICE}
	parted ${BOOT_DEVICE} toggle ${CURRENT_PART} legacy_boot
	parted ${BOOT_DEVICE} toggle ${CURRENT_UBOOT_PART} legacy_boot
	parted ${BOOT_DEVICE} toggle ${UPDATE_PART} legacy_boot
	parted ${BOOT_DEVICE} toggle ${UPDATE_UBOOT_PART} legacy_boot
	fw_setenv upgrade_available 1
	fw_setenv bootcount 0
	sync && reboot
fi
