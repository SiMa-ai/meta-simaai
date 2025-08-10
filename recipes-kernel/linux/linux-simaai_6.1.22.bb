LINUX_VERSION ?= "6.1.22"

require recipes-kernel/linux/linux-simaai.inc

EXTRA_OEMAKE += "DTC_FLAGS=-@"
