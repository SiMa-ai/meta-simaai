include conf/machine/include/arm/armv8-2a/tune-cortexa65.inc

#TOOLCHAIN specific configs
TUNE_CCARGS += "${@bb.utils.contains("TUNE_FEATURES", "cortexa65", "-mabi=lp64", "", d)}"

#Kernel specific config
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += " kernel-image kernel-devicetree kernel-modules"
CORE_IMAGE_EXTRA_INSTALL += " kernel-image kernel-devicetree kernel-modules"

IMAGE_FSTYPES += "ext4.gz cpio cpio.gz wic.gz wic.bmap"
IMAGE_INSTALL += " kernel-modules kernel-devicetree"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-simaai"
KCONFIG_MODE = "--alldefconfig"

#Use below when we have multiple kernel versions
PREFERRED_VERSION_linux-simaai ?= "6.1%"
KERNEL_IMAGETYPE = "Image"

#U-BOOT specific config
PREFERRED_PROVIDER_virtual/bootloader = "u-boot"
PREFERRED_PROVIDER_u-boot-fw-utils = "libubootenv"

EXTRA_IMAGEDEPENDS += "virtual/bootloader"

IMAGE_BOOT_FILES = "${KERNEL_IMAGETYPE};boot-0/ ${KERNEL_IMAGETYPE};boot-1/ ${DEVICETREE_NAME} uboot.env uboot-redund.env boot.scr.uimg;boot-0/ boot.scr.uimg;boot-1/"
