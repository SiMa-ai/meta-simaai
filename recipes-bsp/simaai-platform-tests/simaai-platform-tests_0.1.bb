DESCRIPTION = "Utilities for platform bringup for SIMA Davinci boards"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "davinci"
PROVIDES += "simaai-platform-tests"
DEPENDS = "simaai-mem"
RDEPENDS:${PN} += "simaai-mem"
ARCH = "arm64"

SIMAAI_PLAT_TEST_GIT_URI = "git://github.com/SiMa-ai/simaai-a65-platform-tests.git"
SIMAAI_PLAT_TEST_GIT_PROTOCOL = "http"
SIMAAI_PLAT_TEST_BRANCH = "master"
SRC_URI = "${SIMAAI_PLAT_TEST_GIT_URI};protocol=${SIMAAI_PLAT_TEST_GIT_PROTOCOL};branch=${SIMAAI_PLAT_TEST_BRANCH}"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

# include files for using kernel headers"
CPPFLAGS += " -I${STAGING_KERNEL_DIR}/include/uapi -I${STAGING_KERNEL_DIR}/include"

do_install() {
       install -d ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/gpio/gpio_test ${D}${bindir}/simaai_pt
	   install -m 0755 ${S}/power-test/cpuburn ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ddr/ddr_test ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ethernet/set_sgmii_rxtx_loopback.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ethernet/set_sgmii_txrx_loopback.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ethernet/start_sgmii_pattern.sh ${D}${bindir}/simaai_pt
}

FILES:${PN} =+ "${bindir}/simaai_pt"
