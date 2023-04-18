DESCRIPTION = "simaai-mem lib for SiMa.ai boards"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "davinci"
DEPENDS += "virtual/kernel"
PROVIDES += "simaai-mem"
ARCH = "arm64"

SIMAAI_MEM_GIT_URI = "git://github.com/SiMa-ai/simaai-memory-lib.git"
SIMAAI_MEM_GIT_PROTOCOL = "http"
SIMAAI_MEM_BRANCH = "master"
SRC_URI = "${SIMAAI_MEM_GIT_URI};protocol=${SIMAAI_MEM_GIT_PROTOCOL};branch=${SIMAAI_MEM_BRANCH}"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

# Way to use installed kernel headers to compile simaai-mem-lib 
# Below doesnt work so hardcoding
#do_configure[depends] += "virtual/kernel:do_shared_workdir"
CPPFLAGS += " -I${STAGING_KERNEL_DIR}/include/uapi -I${STAGING_KERNEL_DIR}/include"

EXTRA_OEMAKE += "CC='${CC}'"
EXTRA_OEMAKE += "CXX='${CXX}'"

do_install:append() {
	install -d ${D}${libdir}
	install -m 0755 ${S}/libsimaaimem.so ${D}${libdir}

	install -d ${D}${bindir}
	install -m 0755 ${S}/simaai_mem_test ${D}${bindir}

	install -d ${D}${includedir}/simaai
	install -m 0444 ${S}/simaai_memory.h ${D}${includedir}/simaai/simaai_memory.h
}

# This is needed since by default unversioned .so file goes to the -dev package
# which result in a QA warning. This is done to force installing unversioned .so
# files to main package
SOLIBS = ".so"
FILES_SOLIBSDEV = ""
