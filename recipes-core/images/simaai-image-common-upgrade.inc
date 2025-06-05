DESCRIPTION = "Example image demonstrating how to build SWUpdate compound image"

LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

COMPATIBLE_MACHINE = "davinci|modalix"
ARCH = "arm64"

inherit swupdate

SW_FILE = "sw-description_${MACHINE}"
UPDATE_FILE = "update_${MACHINE}.sh"
SRC_URI = "\
    file://${UPDATE_FILE} \
    file://${SW_FILE} \
"

include simaai-build-version.inc

do_unpack:append() {
    os.system("cp " + d.getVar('WORKDIR') + "/" + d.getVar('SW_FILE') + " " + d.getVar('WORKDIR') + "/sw-description")
}

def populate_dtbo(d):
    dtbo_files = ""

    deploydir = d.getVar('DEPLOY_DIR_IMAGE')
    deploydir = deploydir + "/overlays/"

    for root, dirs, files in os.walk(deploydir):
        for file in files:
            if file.endswith(".dtbo"):
                dtbo_files += f"overlays/{file}"
                dtbo_files += f" "
    return dtbo_files

def populate_dtb(d):
    dtbs = []
    devicetree_files = d.getVar('KERNEL_DEVICETREE').split()
    for f in devicetree_files:
        dtbs.append(f.split('/')[-1])
    DEVICE_TREE = ' '.join(dtbs)
    return DEVICE_TREE

python do_insert_version_sw_description () {
    #Prepare sw-description file
    os.system("sed -i \"/version =/d\" " + d.getVar('WORKDIR') + "/sw-description")
    os.system("sed -i '3i    version =\"" + build_version(d) + "\";' " + d.getVar('WORKDIR') + "/sw-description")
}
addtask  insert_version_sw_description before do_swuimage after do_prepare_recipe_sysroot

# images and files that will be included in the .swu image
SWUPDATE_IMAGES = "Image u-boot.bin boot.scr.uimg ${@populate_dtb(d)} ${@populate_dtbo(d)}"
