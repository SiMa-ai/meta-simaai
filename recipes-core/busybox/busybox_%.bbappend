SUMMARY = "Busybox recipe for board from SiMa.ai"

#For switching between busybox init default is sysvinit
#require conf/distro/include/init-manager-mdev-busybox.inc
#BUSYBOX_SPLIT_SUID = "0"
##VIRTUAL-RUNTIME_init_manager = "busybox-mdev"

COMPATIBLE_MACHINE = "davinci|modalix"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://enable_blacklist.cfg"
