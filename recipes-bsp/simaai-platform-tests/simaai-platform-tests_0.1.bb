DESCRIPTION = "Utilities for platform bringup for SIMA Davinci boards"
LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

COMPATIBLE_MACHINE = "davinci|modalix"
PROVIDES += "simaai-platform-tests"
DEPENDS = "simaai-mem devmem2 edac-utils"
RDEPENDS:${PN} += "simaai-mem devmem2 edac-utils"
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
       install -m 0755 ${S}/platform-tests.py ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/gpio/gpio_test ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/power-test/cpuburn ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ddr/ddr_test ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ddr/ecc_test_davinci.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ddr/ecc_test_michelangelo.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/emmc_sd/emmc_sd_test.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/sdma/dma_test.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ethernet/set_sgmii_rxtx_loopback.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ethernet/set_sgmii_txrx_loopback.sh ${D}${bindir}/simaai_pt
       install -m 0755 ${S}/ethernet/start_sgmii_pattern.sh ${D}${bindir}/simaai_pt
}

FILES:${PN} =+ "${bindir}/simaai_pt"
