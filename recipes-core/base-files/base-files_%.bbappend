FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://blacklist.conf \
            file://hosts"

do_install:append() {
	install -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 blacklist.conf ${D}${sysconfdir}/modprobe.d/
	install -m 0644 hosts ${D}${sysconfdir}/
}
