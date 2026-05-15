DESCRIPTION = "Utilities for platform bringup for SIMA Davinci boards"
LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

COMPATIBLE_MACHINE = "davinci|modalix"
PROVIDES += "simaai-platform-tests-svc"
DEPENDS = "simaai-mem devmem2 edac-utils python3"
RDEPENDS:${PN} += "simaai-mem devmem2 edac-utils python3"
ARCH = "arm64"

SIMAAI_PLAT_TEST_GIT_URI = "git://git@github.com/SiMa-ai/simaai-a65-platform-tests.git"
SIMAAI_PLAT_TEST_GIT_PROTOCOL = "ssh"
SIMAAI_PLAT_TEST_BRANCH = "master"
SRC_URI = "${SIMAAI_PLAT_TEST_GIT_URI};protocol=${SIMAAI_PLAT_TEST_GIT_PROTOCOL};branch=${SIMAAI_PLAT_TEST_BRANCH}"
SRCREV = "b402e898a8ebf3f3083d8d4d4ce1b8107c8af5c3"

S = "${WORKDIR}/git"

inherit systemd
SYSTEMD_SERVICE:${PN} = "${PN}.service"

# include files for using kernel headers"
CPPFLAGS += " -I${STAGING_KERNEL_DIR}/include/uapi -I${STAGING_KERNEL_DIR}/include"

do_install() {
       install -d ${D}${bindir}/simaai_pt
       install -d ${D}${systemd_system_unitdir}
       install -m 0755 ${S}/platform-tests.py ${D}${bindir}/simaai_pt
       install -m 0644 ${S}/service/simaai-platform-tests-svc.service ${D}${systemd_system_unitdir}
}

FILES:${PN} =+ "${bindir}/simaai_pt ${systemd_system_unitdir}" 


