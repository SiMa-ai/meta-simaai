FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://systemd-networkd-wait-online-override.conf \
    file://systemd-timesyncd-override.conf \
    file://rsyslog.service \
    file://10-ethx-dhcp.network \
    file://20-eth0-static.network \
    file://30-eth1-static.network \
    file://40-eth2-static.network \
    file://50-eth3-static.network \
    file://bootup_init.service \
    file://bootup_init.sh \
"

inherit systemd
SYSTEMD_SERVICE:${PN} = "bootup_init.service"

FILES:${PN} += " \
    ${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d/override.conf \
    ${sysconfdir}/systemd/system/systemd-timesyncd.service.d/override.conf \
    ${sysconfdir}/systemd/system/rsyslog.service \
    ${sysconfdir}/systemd/network/10-ethx-dhcp.network \
    ${sysconfdir}/systemd/network/20-eth0-static.network \
    ${sysconfdir}/systemd/network/30-eth1-static.network \
    ${sysconfdir}/systemd/network/40-eth2-static.network \
    ${sysconfdir}/systemd/network/50-eth3-static.network \
    ${bindir}/bootup_init.sh \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -d ${D}${sysconfdir}/systemd/system
    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d
    install -d ${D}${sysconfdir}/systemd/system/systemd-timesyncd.service.d
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/10-ethx-dhcp.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/20-eth0-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/30-eth1-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/40-eth2-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/50-eth3-static.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/systemd-networkd-wait-online-override.conf \
        ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d/override.conf
    install -m 0644 ${WORKDIR}/systemd-timesyncd-override.conf \
        ${D}${sysconfdir}/systemd/system/systemd-timesyncd.service.d/override.conf
    install -m 0644 ${WORKDIR}/rsyslog.service ${D}${sysconfdir}/systemd/system/
    install -m 0644 ${WORKDIR}/bootup_init.service ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/bootup_init.sh ${D}${bindir}
}
