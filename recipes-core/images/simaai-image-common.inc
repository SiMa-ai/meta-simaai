LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"

include recipes-core/images/core-image-minimal.bb

COMPATIBLE_MACHINE = "davinci|modalix"

inherit extrausers image-buildinfo

CORE_IMAGE_EXTRA_INSTALL += "sudo nfs-utils-client u-boot-fw-utils swupdate e2fsprogs-resize2fs \
                             simaai-firmwares simaai-drivers parted procps rsyslog openssh man-db \
                             tzdata-core tzdata-misc tzdata-posix tzdata-right tzdata-africa \
                             tzdata-americas tzdata-antarctica tzdata-arctic tzdata-asia \
                             tzdata-atlantic tzdata-australia tzdata-europe tzdata-pacific"

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

do_rootfs_wicenv:prepend() {
    wicvars = d.getVar('WICVARS')
    if not wicvars:
        return

    dtbo_files = ""
    image_boot_files = d.getVar('IMAGE_BOOT_FILES') or ""

    deploydir = d.getVar('D')
    if '/' in deploydir:
        deploydir = deploydir[:deploydir.rfind('/')]
    deploydir = deploydir + "/rootfs/boot/overlays/"

    for root, dirs, files in os.walk(deploydir):
        for file in files:
            if file.endswith(".dtbo"):
                dtbo_files += f" overlays/{file};boot-0"
                dtbo_files += f" overlays/{file};boot-1"

    image_boot_files += f" {dtbo_files}"
    d.setVar('IMAGE_BOOT_FILES', image_boot_files.strip())
    d.setVar('WICVARS', wicvars)
}

IMAGE_BUILDINFO_VARS += "MACHINE DATE TIME SIMA_BUILD_VERSION"

IMAGE_PREPROCESS_COMMAND =+ "get_sima_build_version;"

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers;"
