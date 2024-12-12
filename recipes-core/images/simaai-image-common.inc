include recipes-core/images/core-image-minimal.bb

COMPATIBLE_MACHINE = "davinci"

inherit extrausers image-buildinfo

CORE_IMAGE_EXTRA_INSTALL += "sudo nfs-utils-client u-boot-fw-utils swupdate e2fsprogs-resize2fs \
                             simaai-firmwares parted rsyslog openssh man-db"

EXTRA_USERS_PARAMS += "groupadd sima; \
                       useradd -p '$(cat ${THISDIR}/files/sima.pwd)' -g sima -G sudo sima; \
                       usermod -p '$(cat ${THISDIR}/files/root.pwd)' root;"

update_sudoers(){
    sed -i 's/# %sudo/%sudo/' ${IMAGE_ROOTFS}/etc/sudoers
    sed -i 's/# Defaults secure_path=/Defaults secure_path=/' ${IMAGE_ROOTFS}/etc/sudoers
}

remove_simaailog_from_syslog(){
    sed -i 's/auth,authpriv.none/local6,auth,authpriv.none/' ${IMAGE_ROOTFS}/etc/rsyslog.conf
}

include simaai-build-version.inc

python get_sima_build_version () {

    sima_build_number = build_version(d)
    print(sima_build_number)
    d.setVar('SIMA_BUILD_VERSION', sima_build_number)
}

IMAGE_BUILDINFO_VARS += "MACHINE DATE TIME SIMA_BUILD_VERSION"

IMAGE_PREPROCESS_COMMAND =+ "get_sima_build_version;"

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers;"
