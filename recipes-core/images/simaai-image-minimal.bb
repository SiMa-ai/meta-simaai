include recipes-core/images/core-image-minimal.bb

COMPATIBLE_MACHINE = "davinci"

inherit extrausers image-buildinfo

CORE_IMAGE_EXTRA_INSTALL += "sudo openssh u-boot-fw-utils swupdate nfs-utils-client \
                             simaai-firmwares simaai-drivers simaai-platform-tests \
                             rsyslog e2fsprogs-resize2fs parted man-db"


INHERIT += "extrausers"

EXTRA_USER_PARAMS = "usermod -p 'root' root;"

update_sudoers(){
    encrypted=$(openssl passwd -6 -salt 12345  root)
    sed -i "s/^root::/root:$encrypted:/" ${IMAGE_ROOTFS}/etc/shadow
}

remove_simaailog_from_syslog(){
    sed -i 's/auth,authpriv.none/local6,auth,authpriv.none/' ${IMAGE_ROOTFS}/etc/rsyslog.conf
}

include simaai-build-version.inc

python get_sima_build_version () {
    sima_build_number = "1.3.0"
    print(sima_build_number)
    d.setVar('SIMA_BUILD_VERSION', sima_build_number)
}

IMAGE_BUILDINFO_VARS += "MACHINE DATE TIME SIMA_BUILD_VERSION"

IMAGE_PREPROCESS_COMMAND =+ "get_sima_build_version;"

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers;"
