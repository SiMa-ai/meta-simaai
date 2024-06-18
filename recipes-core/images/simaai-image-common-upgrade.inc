DESCRIPTION = "Example image demonstrating how to build SWUpdate compound image"

LICENSE = "SiMaai-EULA-1.0"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://${SIMAAI_LICENSE_DIR}/SiMaai-EULA-1.0;md5=b3adbdb7cc0f9b68072871b7c5914bf4"

COMPATIBLE_MACHINE = "davinci"
ARCH = "arm64"

inherit swupdate

SRC_URI = "\
    file://update.sh \
    file://sw-description \
"

include simaai-build-version.inc

python do_insert_version_sw_description () {

    #Prepare sw-description file
    os.system("sed -i \"/version =/d\" " + d.getVar('WORKDIR') + "/sw-description")
    os.system("sed -i '3i    version =\"" + "1.3.0" + "\";' " + d.getVar('WORKDIR') + "/sw-description")
}
addtask  insert_version_sw_description  before do_swuimage after do_prepare_recipe_sysroot

# images and files that will be included in the .swu image
SWUPDATE_IMAGES = "Image davinci-combo-board.dtb \
                    davinci-dual-m2.dtb davinci-hhhl.dtb u-boot.bin boot.scr.uimg"
