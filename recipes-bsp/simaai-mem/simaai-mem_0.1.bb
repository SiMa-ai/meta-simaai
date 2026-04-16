DESCRIPTION = "simaai-mem lib for SiMa.ai boards"
LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

COMPATIBLE_MACHINE = "davinci|modalix"
DEPENDS += "virtual/kernel"
PROVIDES += "simaai-mem"
ARCH = "arm64"

SIMAAI_MEM_GIT_URI = "git://github.com/SiMa-ai/sima-ai-uboot.git"
SIMAAI_MEM_GIT_PROTOCOL = "ssh"
SIMAAI_MEM_BRANCH = "master"
SRC_URI = "${SIMAAI_MEM_GIT_URI};protocol=${SIMAAI_MEM_GIT_PROTOCOL};branch=${SIMAAI_MEM_BRANCH}"
SRCREV = "d7c74cbb59581f1e3d5c65943cc48891715d4341"

S = "${WORKDIR}/git"

# Way to use installed kernel headers to compile simaai-mem-lib 
# Below doesnt work so hardcoding
#do_configure[depends] += "virtual/kernel:do_shared_workdir"
CPPFLAGS += " -I${STAGING_KERNEL_DIR}/include/uapi -I${STAGING_KERNEL_DIR}/include"

EXTRA_OEMAKE += "CC='${CC}'"
EXTRA_OEMAKE += "CXX='${CXX}'"

do_install() {
	oe_runmake install DESTDIR=${D}
}

FILES_SOLIBSDEV = ""
SOLIBS = ".so*"
INSANE_SKIP:${PN} += "dev-so"
