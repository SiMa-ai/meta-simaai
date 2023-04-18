include simaai-image-common.inc

inherit extrausers

CORE_IMAGE_EXTRA_INSTALL += "sudo openssh u-boot-fw-utils swupdate nfs-utils-client \
                             simaai-firmwares simaai-drivers simaai-platform-tests \
			     rsyslog"

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers;"
