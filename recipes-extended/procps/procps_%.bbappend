FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
		file://99-custom-sysctl.conf \
		"

do_install:append:modalix() {
	install -d ${D}${sysconfdir}/sysctl.d/
	install -m 0644 ${WORKDIR}/99-custom-sysctl.conf ${D}${sysconfdir}/sysctl.d/
}
