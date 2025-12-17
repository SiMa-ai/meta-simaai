FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
  
SRC_URI:append = " \
                file://0001-simaai-handler-for-troot-flash.patch \
                file://0002-use-fixed-datadst-dir.patch"
