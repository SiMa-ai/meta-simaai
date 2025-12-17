DESCRIPTION = "Utilities for platform bringup for SIMA Davinci boards"
LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

inherit cmake pkgconfig

COMPATIBLE_MACHINE = "davinci|modalix"
PROVIDES += "simaai-platform-tests"
DEPENDS = "simaai-mem devmem2 edac-utils python3 nlohmann-json "
RDEPENDS:${PN} += "simaai-mem devmem2 edac-utils python3 nlohmann-json "
ARCH = "arm64"

SIMAAI_PLAT_TEST_GIT_URI = "git://git@github.com/SiMa-ai/simaai-a65-platform-tests.git"
SIMAAI_PLAT_TEST_GIT_PROTOCOL = "ssh"
SIMAAI_PLAT_TEST_BRANCH = "master"
SRC_URI = "${SIMAAI_PLAT_TEST_GIT_URI};protocol=${SIMAAI_PLAT_TEST_GIT_PROTOCOL};branch=${SIMAAI_PLAT_TEST_BRANCH}"
SRCREV = "cbc8d46077336375f5bc58e4b683da1e25bf5e9f"

S = "${WORKDIR}/git"

# include files for using kernel headers"
CPPFLAGS += " -I${STAGING_KERNEL_DIR}/include/uapi -I${STAGING_KERNEL_DIR}/include"

# building NoC util
EXTRA_OECMAKE = "-DTARGET_MACHINE=${MACHINE}"

FILES:${PN} =+ "${bindir}/simaai_pt"

SOLIBS = ".so"
FILES_SOLIBSDEV = ""
