DESCRIPTION = "Linux Kernel recipe for SiMa.ai board"
SECTION = "kernel"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

require recipes-kernel/linux/linux-yocto.inc

KMACHINE = "${MACHINE}"
COMPATIBLE_MACHINE = "davinci|modalix"

S = "${WORKDIR}/git"

KERNEL_GIT_BRANCH = "master"
KERNEL_GIT_URI_SSH = "git://git@github.com/SiMa-ai/simaai-linux.git"
KERNEL_GIT_PROTOCOL = "ssh"
SRCREV = "e92918061c54726431a00c60d3d9fff2ddce27f2"

SRC_URI += "${KERNEL_GIT_URI_SSH};protocol=${KERNEL_GIT_PROTOCOL};branch=${KERNEL_GIT_BRANCH}"

LINUX_VERSION_EXTENSION ?= ""
