EEPMAKE=hats/eepromutils/eepmake
EEPFLASH=hats/eepromutils/eepflash.sh

all: taudac.eep

taudac.dtbo: taudac-overlay.dts
	@echo "Building DT overlay..."
	dtc -@ -I dts -O dtb -o taudac.dtbo taudac-overlay.dts

taudac.eep: taudac-eeprom.txt taudac.dtbo
	@echo "building EEPROM file..."
	$(EEPMAKE) taudac-eeprom.txt taudac.eep taudac.dtbo

clean:
	rm -f *.dtbo
	rm -f *.eep
