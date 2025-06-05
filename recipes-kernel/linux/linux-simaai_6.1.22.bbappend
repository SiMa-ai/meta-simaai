SUMMARY = "Device tree overlay files for sensors supported on SiMa.ai boards."
FILESEXTRAPATHS:prepend = "${THISDIR}/files:"
SRC_URI += " \
    file://imx477-0.dtso \
    file://imx477-1.dtso \
    file://imx477-2.dtso \
    file://imx477-3.dtso \
    file://isp-0.dtso \
    file://isp-1.dtso \
    file://isp-2.dtso \
    file://isp-3.dtso \
    file://pattern-generator-0.dtso \
"

DEPENDS += "dtc-native"
EXTRA_OEMAKE += "DTC_FLAGS=-@"

do_compile:append() {
    for dtso in ${WORKDIR}/*.dtso; do
        base_name=$(basename $dtso .dtso)
        ${STAGING_BINDIR_NATIVE}/dtc -@ -I dts -O dtb -o ${B}/${base_name}.dtbo ${dtso}
    done
}

do_install:append() {
    install -d ${D}/boot/overlays
    install -m 0644 ${B}/*.dtbo ${D}/boot/overlays
}

do_deploy:append() {
    install -d ${DEPLOYDIR}/overlays
    install -m 0644 ${B}/*.dtbo ${DEPLOYDIR}/overlays
}
