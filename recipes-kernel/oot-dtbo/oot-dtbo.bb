SUMMARY = "Device tree overlay files for SiMa.ai boards."
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

COMPATIBLE_MACHINE = "davinci|modalix"

FILESEXTRAPATHS:prepend = "${THISDIR}/files:"

SRC_URI += " \
    file://Makefile \
    file://imx415-0.dtso \
    file://imx415-1.dtso \
    file://imx415-2.dtso \
    file://imx415-3.dtso \
    file://imx477-0.dtso \
    file://imx477-1.dtso \
    file://imx477-2.dtso \
    file://imx477-3.dtso \
    file://isp-imx415-csi0.dtso \
    file://isp-imx415-csi1.dtso \
    file://isp-imx415-csi2.dtso \
    file://isp-imx415-csi3.dtso \
    file://imx477-som-csi1.dtso \
    file://imx477-som-csi2.dtso \
    file://isp-0.dtso \
    file://isp-1.dtso \
    file://isp-2.dtso \
    file://isp-3.dtso \
    file://isp-som-csi1.dtso \
    file://isp-som-csi2.dtso \
    file://connectech-carrier-som.dtso \
    file://waveshare-carrier-som.dtso \
    file://seeed-studio-carrier-som.dtso \
    file://pattern-generator-0.dtso \
    file://pcie-8rc.dtso \
    file://pcie-8ep.dtso \
    file://pcie-4rc-2rc-2rc.dtso \
    file://pcie-2rc-2rc-2rc-2rc.dtso \
    file://pcie-4ep-2rc-2rc.dtso \
    file://econ-imx678-csi-0-isp-0.dtso \
    file://econ-imx678-csi-1-isp-1.dtso \
    file://econ-imx678-csi-2-isp-2.dtso \
    file://econ-imx678-csi-3-isp-3.dtso \
    file://waveshare-econ-imx678-csi-1-isp-0.dtso \
    file://waveshare-econ-imx678-csi-2-isp-1.dtso \
    file://waveshare-imx477-csi-2-isp-1.dtso \
    file://waveshare-imx477-csi-1-isp-0.dtso \
    file://waveshare-econ-imx678.dtso \
"
inherit deploy

S = "${WORKDIR}"

DEPENDS += "dtc-native"

ALLOW_EMPTY:${PN} = "1"
ALLOW_EMPTY:${PN}-dev = "1"
ALLOW_EMPTY:${PN}-staticdev = "1"

do_deploy() {
    install -d ${DEPLOYDIR}/overlays
    install -m 0644 ${B}/*.dtbo ${DEPLOYDIR}/overlays
}

addtask do_deploy after do_compile
