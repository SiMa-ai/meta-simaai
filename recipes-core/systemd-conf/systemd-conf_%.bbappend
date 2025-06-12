FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://systemd-networkd-wait-online-override.conf \
    file://systemd-timesyncd-override.conf \
    file://10-endx-dhcp.network \
    file://20-end0-static.network \
    file://30-end1-static.network \
    file://40-end2-static.network \
    file://50-end3-static.network \
    file://mnt.mount \
    file://simaai-pick-nfs.service \
    file://bootup_init.service \
    file://bootup_init.sh \
    file://file-limit.conf \
"

inherit systemd
SYSTEMD_SERVICE:${PN} = "mnt.mount simaai-pick-nfs.service bootup_init.service"

FILES:${PN} += " \
    ${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d/override.conf \
    ${sysconfdir}/systemd/system/systemd-timesyncd.service.d/override.conf \
    ${systemd_unitdir}/system.conf.d/ \
    ${sysconfdir}/systemd/network/10-endx-dhcp.network \
    ${sysconfdir}/systemd/network/20-end0-static.network \
    ${sysconfdir}/systemd/network/30-end1-static.network \
    ${sysconfdir}/systemd/network/40-end2-static.network \
    ${sysconfdir}/systemd/network/50-end3-static.network \
    ${bindir}/bootup_init.sh \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -d ${D}${sysconfdir}/systemd/system
    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d
    install -d ${D}${sysconfdir}/systemd/system/systemd-timesyncd.service.d
    install -d ${D}${systemd_system_unitdir}
	install -d ${D}${systemd_unitdir}/system.conf.d
    install -m 0644 ${WORKDIR}/10-endx-dhcp.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/20-end0-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/30-end1-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/40-end2-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/50-end3-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/systemd-networkd-wait-online-override.conf \
        ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d/override.conf
    install -m 0644 ${WORKDIR}/systemd-timesyncd-override.conf \
        ${D}${sysconfdir}/systemd/system/systemd-timesyncd.service.d/override.conf
    install -m 0644 ${WORKDIR}/file-limit.conf ${D}${systemd_unitdir}/system.conf.d/
    install -m 0644 ${WORKDIR}/mnt.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/simaai-pick-nfs.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/bootup_init.service ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/bootup_init.sh ${D}${bindir}
}
