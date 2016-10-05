DTC=/lib/modules/$(shell uname -r)/build/scripts/dtc/dtc
EEPMAKE=hats/eepromutils/eepmake
EEPFLASH=hats/eepromutils/eepflash.sh

all: taudac.eep

blank.eep:
	dd if=/dev/zero ibs=1k count=4 of=blank.eep

erase: blank.eep
	@echo "Erasing EEPROM..."
	$(EEPFLASH) --write --file=blank.eep --type=24c32

taudac.dtbo: taudac-overlay.dts
	@echo "Building DT overlay..."
	$(DTC) -@ -H epapr -I dts -O dtb -o taudac.dtbo taudac-overlay.dts

taudac.eep: taudac-eeprom.txt taudac.dtbo
	@echo "Building EEPROM image..."
	$(EEPMAKE) taudac-eeprom.txt taudac.eep taudac.dtbo

flash: taudac.eep
	@echo "Programming EEPROM..."
	$(EEPFLASH) --write --file=taudac.eep --type=24c32

clean:
	rm -f *.dtbo
	rm -f *.eep

