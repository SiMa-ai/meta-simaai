DESCRIPTION = "This recipe lists the firmwares to be installed in SiMa.ai boards"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "davinci"
PROVIDES += "simaai-drivers"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://sima_pep_drv.ko"

FILES:${PN} =+ "${base_prefix}/opt/*"

do_install:append() {
        install -d ${D}${base_prefix}/opt/sima/bin
        install -d ${D}${base_prefix}/opt/sima/drivers
        install -m 0644 ${THISDIR}/files/sima_pep_drv.ko ${D}${base_prefix}/opt/sima/drivers
}
