DTC=dtc
CC=gcc
EEPMAKE=hats/eepromutils/eepmake
EEPFLASH=hats/eepromutils/eepflash.sh

export RELEASEDIR ?= ../modules

GITHASH := $(shell git rev-parse HEAD)
GITTAG  := $(shell git describe --tags)

cred = '\033[1;31m'
cgrn = '\033[1;32m'
cylw = '\033[1;33m'
cend = '\033[0m'

define ok
	echo $(cgrn)$(1)$(cend)
endef

define warn
	echo $(cylw)$(1)$(cend)
endef

define die
	(echo $(cred)$(1)$(cend); exit 1)
endef

all: taudac.eep

taudac-info.txt:
	git describe --dirty > $@
	date >> $@

blank.eep:
	dd if=/dev/zero ibs=1k count=8 of=blank.eep

taudac.dtbo: taudac-overlay.dts
	@$(call ok,"Building DT overlay...")
	$(CC) -E -P -I . -x assembler-with-cpp taudac-overlay.dts -o taudac-overlay.dts.i
	$(DTC) -@ -H epapr -I dts -O dtb -o taudac.dtbo taudac-overlay.dts.i

taudac.eep: taudac-eeprom.txt taudac.dtbo taudac-info.txt
	@$(call ok,"Building EEPROM image...")
	$(EEPMAKE) taudac-eeprom.txt taudac.eep taudac.dtbo -c taudac-info.txt

eeprom.unlocked:
	@$(call ok,"Unlocking EEPROM...")
	echo '25' > /sys/class/gpio/export
	@sleep 0.1
	echo 'out' > /sys/class/gpio/gpio25/direction
	echo '0' > /sys/class/gpio/gpio25/value
	@date > eeprom.unlocked

erase flash: %: eeprom.unlocked do-%
	@$(call ok,"Locking EEPROM...")
	echo '25' > /sys/class/gpio/unexport
	@rm eeprom.unlocked

do-erase: blank.eep
	@$(call warn,"Erasing EEPROM...")
	$(EEPFLASH) --write --file=blank.eep --type=24c64

do-flash: taudac.eep
	@$(call warn,"Programming EEPROM...")
	$(EEPFLASH) --write --file=taudac.eep --type=24c64

release: taudac.dtbo
	@git describe --exact-match HEAD > /dev/null || \
		$(call warn,"HEAD is not tagged!")
	@install -m 644 -vD -t $(RELEASEDIR)/boot/overlays taudac.dtbo
	@echo $(GITHASH) > $(RELEASEDIR)/taudac.dtbo.hash

clean:
	@git clean -fX

