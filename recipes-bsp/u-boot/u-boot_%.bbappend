DESCRIPTION = "U-Boot for Sima.ai DaVinci Platform"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"

COMPATIBLE_MACHINE = "davinci|modalix"
DEPENDS += "dtc-native gnutls-native"
PROVIDES += "u-boot"
ARCH = "arm64"

UBOOT_GIT_URI = "git://github.com/SiMa-ai/sima-ai-uboot.git"
UBOOT_GIT_PROTOCOL = "http"

UBOOT_BRANCH = "master"
SRC_URI = "${UBOOT_GIT_URI};protocol=${UBOOT_GIT_PROTOCOL};branch=${UBOOT_BRANCH}"
SRCREV = "${AUTOREV}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
EXTRA_OEMAKE += "DTC_FLAGS=-@"

# Uncomment this line to enable DDR CLI in u-boot
# DDR CLI is very specific mode of u-boot to find the best DDR 
# configuration on SiMa.ai SoCs, and ususally should not be enabled.
# Please enable DDR CLI if you really sure you need it.
# SRC_URI += "file://ddr_cli.cfg"

# Uncomment this line to enable debug UART in u-boot
# Debug UART is needed only during board bringup when u-boot crashes 
# before main cosole initialization.
# Please enable debug UART if you really sure you need it.
# SRC_URI += "file://debug_uart_davini.cfg"
SRC_URI:append:modalix = " file://debug_uart_modalix.cfg"
UBOOT_INITIAL_ENV = "uboot.txt"
S = "${WORKDIR}/git"

do_deploy:append() {
   ${B}/tools/mkimage -C none -A arm -T script -d ${S}/board/sima/${MACHINE}/bootscripts/mmcboot.cmd ${B}/boot.scr.uimg
   ${B}/tools/mkimage -C none -A arm -T script -d ${S}/board/sima/${MACHINE}/bootscripts/netboot.cmd ${B}/netboot.scr.uimg
   ${B}/tools/mkenvimage -s 0x80000 -o uboot.env ${UBOOT_INITIAL_ENV}
   ${B}/tools/mkenvimage -r -s 0x80000 -o uboot-redund.env ${UBOOT_INITIAL_ENV}
   install -D -m 644 ${B}/boot.scr.uimg ${DEPLOYDIR}/
   install -D -m 644 ${B}/netboot.scr.uimg ${DEPLOYDIR}/
}
