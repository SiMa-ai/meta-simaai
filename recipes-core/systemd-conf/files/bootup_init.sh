#!/bin/sh

UBOOT_ENV_DEV=/dev/mmcblk0p3
UBOOT_ENV_MOUNT=/tmp/boot
DATA_PART_MOUNT_PATH=/data/
DATA_PART_NUM="6"
function get_boot_device() {
        for i in `cat /proc/cmdline`; do
                case "$i" in
                        root=*)
                                ROOT="${i#root=}"
                                ;;
                esac
        done
}

#  echo mounting u-boot.env of ${UBOOT_ENV_DEV} at ${UBOOT_ENV_MOUNT}
mkdir -p ${UBOOT_ENV_MOUNT}
mount ${UBOOT_ENV_DEV} ${UBOOT_ENV_MOUNT}
get_boot_device
BOOT_DEVICE=${ROOT::-2}
DATA_PART_DEV=${ROOT%?}${DATA_PART_NUM}
if [[ -e ${DATA_PART_DEV} ]]; then
    mkdir -p ${DATA_PART_MOUNT_PATH}
    mount ${DATA_PART_DEV} ${DATA_PART_MOUNT_PATH}
fi
fallback=`(fw_printenv fallback)`
if [ $fallback = "fallback=true" ]; then
    parted ${BOOT_DEVICE} toggle 4 legacy_boot
    parted ${BOOT_DEVICE} toggle 5 legacy_boot
    parted ${BOOT_DEVICE} toggle 1 legacy_boot
    parted ${BOOT_DEVICE} toggle 2 legacy_boot
    fw_setenv fallback
fi
upgrade_flag=`(fw_printenv upgrade_available)`
if [ ${upgrade_flag} = "upgrade_available=1" ]; then
    fw_setenv upgrade_available 0
    fw_setenv bootcount 0
fi
