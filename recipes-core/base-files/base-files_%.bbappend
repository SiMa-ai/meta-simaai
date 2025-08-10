FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://blacklist.conf \
            file://hosts \
            file://90-network.rules.davinci \
            file://90-network.rules.modalix \
            file://90-counter.rules \
            file://99-simaai-dev.rules \
            file://99-rpmsg.rules \
            file://phy.conf"

do_install:append() {
	install -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 blacklist.conf ${D}${sysconfdir}/modprobe.d/
	install -m 0644 hosts ${D}${sysconfdir}/
	install -d ${D}${sysconfdir}/udev/rules.d/
	cp 90-network.rules.${MACHINE} 90-network.rules
	install -m 0644 90-network.rules ${D}${sysconfdir}/udev/rules.d/
	install -m 0644 90-counter.rules ${D}${sysconfdir}/udev/rules.d/
	install -m 0644 99-simaai-dev.rules ${D}${sysconfdir}/udev/rules.d/
	install -m 0644 99-rpmsg.rules ${D}${sysconfdir}/udev/rules.d/
}

do_install:append:modalix() {
	install -d ${D}${sysconfdir}/modules-load.d/
	install -m 0644 phy.conf ${D}${sysconfdir}/modules-load.d/
}
