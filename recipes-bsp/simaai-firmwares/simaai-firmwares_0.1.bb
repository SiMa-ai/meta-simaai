DESCRIPTION = "This recipe lists the firmwares to be installed in SiMa.ai boards"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "davinci"
PROVIDES += "simaai-firmwares"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://mla_driver.bin \
	file://davinci-evxx-fw \
	file://init_mla_mem.lm"

do_install:append() {
        install -d ${D}${base_libdir}/firmware
        install -d ${D}${bindir}/
	install -m 0644 ${THISDIR}/files/mla_driver.bin ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/davinci-evxx-fw ${D}${base_libdir}/firmware/
	install -m 0755 ${THISDIR}/files/init_mla_mem.lm ${D}${bindir}/
}

FILES:${PN} =+ 	"${base_libdir}/firmware/"
INSANE_SKIP:${PN} = "arch"
