DTC=dtc
CC=gcc
EEPMAKE=utils/eeptools/eepmake
EEPFLASH=utils/eeptools/eepflash.sh
EEPDEVID=10

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

.PHONY: clean taudac-info.txt

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
	$(EEPMAKE) -v1 taudac-eeprom.txt taudac.eep taudac.dtbo -c taudac-info.txt

/dev/i2c-${EEPDEVID}:
	dtoverlay i2c-gpio i2c_gpio_sda=0 i2c_gpio_scl=1 bus=${EEPDEVID}

eeprom.unlocked:
	@$(call ok,"Unlocking EEPROM...")
	pinctrl set 25 op pn dl
	@date > eeprom.unlocked

erase flash: %: eeprom.unlocked /dev/i2c-${EEPDEVID} do-%
	@$(call ok,"Locking EEPROM...")
	pinctrl set 25 ip pn
	@rm eeprom.unlocked

do-erase: blank.eep
	@$(call warn,"Erasing EEPROM...")
	$(EEPFLASH) --write --file=blank.eep --type=24c64 --device=${EEPDEVID}

do-flash: taudac.eep
	@$(call warn,"Programming EEPROM...")
	$(EEPFLASH) --write --file=taudac.eep --type=24c64 --device=${EEPDEVID}

release: taudac.dtbo
	@git describe --exact-match HEAD > /dev/null || \
		$(call warn,"HEAD is not tagged!")
	@install -m 644 -vD -t $(RELEASEDIR)/boot/overlays taudac.dtbo
	@echo $(GITHASH) > $(RELEASEDIR)/taudac.dtbo.hash

clean:
	@git clean -fX
