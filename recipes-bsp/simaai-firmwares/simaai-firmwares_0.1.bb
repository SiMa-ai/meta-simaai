DESCRIPTION = "This recipe lists the firmwares to be installed in SiMa.ai boards"
LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

COMPATIBLE_MACHINE = "davinci"
PROVIDES += "simaai-firmwares"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://mla_driver.bin \
        file://mla_driver.elf \
        file://davinci-evxx-fw \
	file://init_mla_mem.lm"

do_install:append() {
        install -d ${D}${base_libdir}/firmware
        install -d ${D}${bindir}/
	install -m 0644 ${THISDIR}/files/mla_driver.elf ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/mla_driver.bin ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/davinci-evxx-fw ${D}${base_libdir}/firmware/
	install -m 0755 ${THISDIR}/files/init_mla_mem.lm ${D}${bindir}/
}

FILES:${PN} =+ 	"${base_libdir}/firmware/"
INSANE_SKIP:${PN} = "arch"
