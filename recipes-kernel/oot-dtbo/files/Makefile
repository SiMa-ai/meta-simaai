DTSO := $(shell ls *.dtso)
NAMES := $(basename $(DTSO))

DTC = dtc
DTC_FLAGS = -@ -I dts -O dtb

all:
	for name in $(NAMES); do \
		$(DTC) $(DTC_FLAGS) -o $$name.dtbo $$name.dtso; \
	done

clean:
	rm -rf /boot/overlays/*.dtbo
