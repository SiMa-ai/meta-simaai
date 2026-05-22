DESCRIPTION = "U-Boot for Sima.ai DaVinci Platform"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"

COMPATIBLE_MACHINE = "davinci|modalix"
DEPENDS += "dtc-native gnutls-native"
PROVIDES += "u-boot"
ARCH = "arm64"

UBOOT_GIT_URI = "git://git@github.com/SiMa-ai/sima-ai-uboot.git"
UBOOT_GIT_PROTOCOL = "ssh"

UBOOT_BRANCH = "master"
SRC_URI = "${UBOOT_GIT_URI};protocol=${UBOOT_GIT_PROTOCOL};branch=${UBOOT_BRANCH}"
SRCREV = "ae825aa3b679389672e7b5b6f5e7a75f55330e1d"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
EXTRA_OEMAKE += "DTC_FLAGS=-@"

# Uncomment this line to enable DDR CLI in u-boot
# DDR CLI is very specific mode of u-boot to find the best DDR 
# configuration on SiMa.ai SoCs, and ususally should not be enabled.
# Please enable DDR CLI if you really sure you need it.
# SRC_URI += "file://ddr_cli.cfg"

# Uncomment this line to enable debug UART in u-boot
# Debug UART is needed only during board bringup when u-boot crashes 
# before main cosole initialization.
# Please enable debug UART if you really sure you need it.
# SRC_URI += "file://debug_uart_davini.cfg"

python __anonymous() {
    machine = d.getVar('MACHINE')
    if machine == "davinci":
        bb.note("Building uboot.bin for davinci")
        return

    zebu = d.getVar('ZEBU') or "0"
    if zebu == "1":
        bb.note("Building uboot.bin for Zebu")
        d.appendVar("SRC_URI", " file://debug_uart_modalix_zebu.cfg")
    else:
        bb.note("Building uboot.bin for SoC")
        d.appendVar("SRC_URI", " file://debug_uart_modalix.cfg")
}

UBOOT_INITIAL_ENV = "uboot.txt"
S = "${WORKDIR}/git"

do_deploy:append() {
    if [ ! -z "${SERIAL_CONSOLES}" ]; then
        baudrate=`echo "${SERIAL_CONSOLES}" | sed 's/\;.*//'`
        ttydev=`echo "${SERIAL_CONSOLES}" | sed -e 's/^[0-9]*\;//' -e 's/\;.*//'`
        cur_baudrate=`grep baudrate ${UBOOT_INITIAL_ENV} | awk -F= '{print $2}'`
        if [ "${cur_baudrate}" != "${baudrate}" ]; then
            echo "changing baudrate from ${cur_baudrate} to ${baudrate}"
            sed -i -e "s/^baudrate\=[0-9]*/baudrate\=$baudrate/g" ${UBOOT_INITIAL_ENV}
            sed -i -e "s/console=.*/console\=$ttydev,${baudrate}n8/g" ${UBOOT_INITIAL_ENV}
        fi
    fi

   ${B}/tools/mkimage -C none -A arm -T script -d ${S}/board/sima/${MACHINE}/bootscripts/mmcboot.cmd ${B}/boot.scr.uimg
   ${B}/tools/mkimage -C none -A arm -T script -d ${S}/board/sima/${MACHINE}/bootscripts/netboot.cmd ${B}/netboot.scr.uimg
   ${B}/tools/mkenvimage -s 0x80000 -o uboot.env ${UBOOT_INITIAL_ENV}
   ${B}/tools/mkenvimage -r -s 0x80000 -o uboot-redund.env ${UBOOT_INITIAL_ENV}
   install -D -m 644 ${B}/boot.scr.uimg ${DEPLOYDIR}/
   install -D -m 644 ${B}/netboot.scr.uimg ${DEPLOYDIR}/
   if [ "${ENABLE_SECURE}" = "1" ]; then
		bbnote "Compiling secure U-Boot..."
		ln -s -f ${DEPLOY_DIR_IMAGE}/${UBOOT_BINARY} ${DEPLOY_DIR}/${UBOOT_BINARY}
		cp ${DEPLOYDIR}/u-boot.bin ${DEPLOYDIR}/t-boot-sec.bin
		# final size=1440000, each 1MB block appends 32 bytes hash, so reduce those bytes
		desired_size=1439936
		current_size=$(stat -c%s t-boot-sec.bin)
		# reserve 1-byte to append '0' as a marker which is used while decryption
		zeros_to_append=$(expr $desired_size - $current_size - 1)
		echo "Padding: " $zeros_to_append
		mkdir ${DEPLOYDIR}/sec
                cp ${DEPLOYDIR}/t-boot-sec.bin ${DEPLOYDIR}/sec/t-boot-sec.bin
                split -b 1048544 ${DEPLOYDIR}/sec/t-boot-sec.bin ${DEPLOYDIR}/sec/ubootBlock
                rm -rf ${DEPLOYDIR}/sec/t-boot-sec.bin
                for file in ${DEPLOYDIR}/sec/*; do
                        # Check if it is a file
                        if [ -f "$file" ]; then
                                # Calculate SHA256 and output the result
                                openssl sha256 -binary "$file"  >> "$file"
				current_file_size=$(stat -c%s "$file")
				if [ "$current_file_size" -lt 1048576 ]; then
					echo -n '0' >> $file
					dd if=/dev/zero of=$file bs=1 count=$zeros_to_append conv=notrunc oflag=append
				fi
                                openssl aes-128-ctr -e -K 7071b00bc9371e648877abbad0014aa4 -iv fedcba9876543210   -in $file -out ${DEPLOYDIR}/sec/y
                                cat ${DEPLOYDIR}/sec/y >> ${DEPLOYDIR}/suboot
                                rm -rf $file
                                rm -rf ${DEPLOYDIR}/sec/y
                        fi
                done
                mv ${DEPLOYDIR}/suboot ${DEPLOYDIR}/u-boot.bin
                rm -rf ${DEPLOYDIR}/sec

	fi
}

python () {
    if d.getVar("ENABLE_SECURE") == "1":
        d.appendVar("SRC_URI", " file://secure_boot.cfg")
}
