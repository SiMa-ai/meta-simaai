include simaai-image-common-upgrade.inc

# images to build before building swupdate image
IMAGE_DEPENDS = "simaai-image-minimal"
SWUPDATE_IMAGES += "simaai-image-minimal-${MACHINE}.rootfs.ext4.gz"
