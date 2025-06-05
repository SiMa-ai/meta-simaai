DESCRIPTION = "This recipe lists the firmwares to be installed in SiMa.ai boards"
LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

COMPATIBLE_MACHINE = "davinci|modalix"
PROVIDES += "simaai-firmwares"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://mla_init_davinci.lm \
	file://mla_init_modalix.elf \
	file://x33x0fw.hdr"

do_install:append() {
        install -d ${D}${base_libdir}/firmware
        install -d ${D}${bindir}/
	install -m 0644 ${THISDIR}/files/davinci-mla_driver.elf ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/davinci-mla_driver.bin ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/modalix-mla_driver.elf ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/modalix-mla_driver.bin ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/davinci-evxx-fw ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/modalix-evxx-fw ${D}${base_libdir}/firmware/
	install -m 0755 ${WORKDIR}/mla_init_davinci.lm ${D}${bindir}/
	install -m 0755 ${WORKDIR}/mla_init_modalix.elf ${D}${bindir}/
	install -m 0644 ${WORKDIR}/x33x0fw.hdr ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/davinci-cvu-fw ${D}${base_libdir}/firmware/
	install -m 0644 ${THISDIR}/files/modalix-cvu-fw ${D}${base_libdir}/firmware/
}
}

FILES:${PN} =+ 	"${base_libdir}/firmware/"
INSANE_SKIP:${PN} += "arch"
INSANE_SKIP:${PN} += "already-stripped"
