include recipes-core/images/core-image-minimal.bb

COMPATIBLE_MACHINE = "davinci"

inherit extrausers image-buildinfo
EXTRA_USERS_PARAMS += "usermod -p $(openssl passwd root) root;"

update_sudoers(){
    sed -i 's/# %sudo/%sudo/' ${IMAGE_ROOTFS}/etc/sudoers
    sed -i 's/# Defaults secure_path=/Defaults secure_path=/' ${IMAGE_ROOTFS}/etc/sudoers
}

remove_simaailog_from_syslog(){
    sed -i 's/auth,authpriv.none/local6,auth,authpriv.none/' ${IMAGE_ROOTFS}/etc/rsyslog.conf
}

TOOLCHAIN_TARGET_TASK:remove = "simaai-soc-pipeline"

BUILD_NUMBER = "PRIVATE"

python get_sima_build_version () {

    print("getting sima build version")
    meta_simaai_path = ""
    major = ""
    minor = ""
    patch = ""

    # get build number
    build_number = d.getVar('BUILD_NUMBER')
    print(build_number)

    d.setVar('SIMA_BUILD_VERSION', "unkown_unknown_" + build_number)
    print(d.getVar('SIMA_BUILD_VERSION'))

    # get the meta-simaai layer path
    layers = (d.getVar("BBLAYERS") or "").split()
    for layer in layers:
        if "meta-simaai" in layer:
            meta_simaai_path = layer
            break

    print(meta_simaai_path)

    # get version number
    try:
        with open(meta_simaai_path + "/VERSION.in", 'r') as f:
            for line in f:
                if "major" in line :
                    major = line.split()[-1]
                elif "minor" in line :
                    minor = line.split()[-1]
                elif "patch" in line :
                    patch = line.split()[-1]
                else :
                    print("ERROR in version")
                    return
    except IOError:
       return

    version = major + "." + minor + "." + patch
    print(version)

    # get branch information
    branch_name = base_get_metadata_git_branch(meta_simaai_path, None).strip()
    print(branch_name)

    if "PRIVATE" not in build_number:
        build_number = "B" + build_number

    # prepare simaai version number
    sima_build_number = version + "_" + branch_name + "_" + build_number
    print(sima_build_number)
    d.setVar('SIMA_BUILD_VERSION', sima_build_number)
}

IMAGE_BUILDINFO_VARS += "MACHINE DATE TIME SIMA_BUILD_VERSION"

IMAGE_PREPROCESS_COMMAND =+ "get_sima_build_version;"
