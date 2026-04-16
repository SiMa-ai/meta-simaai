LINUX_VERSION ?= "6.18.3"

require recipes-kernel/linux/linux-simaai.inc

EXTRA_OEMAKE += "DTC_FLAGS=-@"
