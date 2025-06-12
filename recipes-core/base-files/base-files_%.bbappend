FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://blacklist.conf \
            file://hosts \
            file://90-network.rules.davinci \
            file://90-network.rules.modalix \
            file://phy.conf"

do_install:append() {
	install -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 blacklist.conf ${D}${sysconfdir}/modprobe.d/
	install -m 0644 hosts ${D}${sysconfdir}/
	install -d ${D}${sysconfdir}/udev/rules.d/
	cp 90-network.rules.${MACHINE} 90-network.rules
	install -m 0644 90-network.rules ${D}${sysconfdir}/udev/rules.d/
}

do_install:append:modalix() {
	install -d ${D}${sysconfdir}/modules-load.d/
	install -m 0644 phy.conf ${D}${sysconfdir}/modules-load.d/
}
