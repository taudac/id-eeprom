DTC=/lib/modules/$(shell uname -r)/build/scripts/dtc/dtc
EEPMAKE=hats/eepromutils/eepmake
EEPFLASH=hats/eepromutils/eepflash.sh

all: taudac.eep

taudac.dtbo: taudac-overlay.dts
	@echo "Building DT overlay..."
	$(DTC) -@ -H epapr -I dts -O dtb -o taudac.dtbo taudac-overlay.dts

taudac.eep: taudac-eeprom.txt taudac.dtbo
	@echo "Building EEPROM image..."
	$(EEPMAKE) taudac-eeprom.txt taudac.eep taudac.dtbo

flash: taudac.eep
	@echo "Writing image to EEPROM..."
	$(EEPFLASH) --write --file=taudac.eep --type=24c32

clean:
	rm -f *.dtbo
	rm -f *.eep

