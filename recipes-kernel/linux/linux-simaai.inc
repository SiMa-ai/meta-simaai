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
SRCREV = "75cf83206ddf82d4c94f9eaf037c30fbe2e5bcef"

SRC_URI += "${KERNEL_GIT_URI_SSH};protocol=${KERNEL_GIT_PROTOCOL};branch=${KERNEL_GIT_BRANCH}"

LINUX_VERSION_EXTENSION ?= ""

def get_overlay_list(d):
    import os
    s_dir = d.getVar('S')
    dtso_path = os.path.join(s_dir, 'arch/arm64/boot/dts/simaai/overlays')

    if not os.path.exists(dtso_path):
        return ""

    overlay_list = []
    for root, dirs, files in os.walk(dtso_path):
        for f in files:
            if f.endswith('.dtso'):
                full_path = os.path.join(root, f.replace('.dtso', '.dtbo'))
                rel_path = os.path.relpath(full_path, os.path.join(s_dir, 'arch/arm64/boot/dts'))
                overlay_list.append(rel_path)

    return " " + " ".join(sorted(overlay_list))

do_deploy:append() {
	cd ${DEPLOYDIR} || exit 1
	find . -maxdepth 1 -type l -name "*.dtbo" -delete

	mkdir -p overlays
	if ls *.dtbo >/dev/null 2>&1; then
		mv -f *.dtbo overlays/
	fi
	cd -

        bbnote "Compiling secure linux kernel ..."
		mkdir ${DEPLOYDIR}/sec
		cp ${DEPLOYDIR}/Image ${DEPLOYDIR}/sec/Image
		split -b 1048544 ${DEPLOYDIR}/sec/Image ${DEPLOYDIR}/sec/ImageBlock
		rm -rf ${DEPLOYDIR}/sec/Image
		for file in ${DEPLOYDIR}/sec/*; do
			# Check if it is a file
			if [ -f "$file" ]; then
				# Calculate SHA256 and output the result
				#cp "$file" x
				openssl sha256 -binary "$file"  >> "$file"
				openssl aes-128-ctr -e -K 7071b00bc9371e648877abbad0014aa4 -iv fedcba9876543210   -in $file -out ${DEPLOYDIR}/sec/y
				cat ${DEPLOYDIR}/sec/y >> ${DEPLOYDIR}/sImage
				rm -rf $file
				rm -rf ${DEPLOYDIR}/sec/x
				rm -rf ${DEPLOYDIR}/sec/y
			fi
		done
		mv ${DEPLOYDIR}/sImage ${DEPLOYDIR}/Image.enc
		rm -rf ${DEPLOYDIR}/sec
}

KERNEL_DEVICETREE:append = "${@get_overlay_list(d)}"
