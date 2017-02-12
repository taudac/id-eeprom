DTC=/lib/modules/$(shell uname -r)/build/scripts/dtc/dtc
CC=gcc
EEPMAKE=hats/eepromutils/eepmake
EEPFLASH=hats/eepromutils/eepflash.sh

all: taudac.eep

blank.eep:
	dd if=/dev/zero ibs=1k count=4 of=blank.eep

taudac.dtbo: taudac-overlay.dts
	@echo "Building DT overlay..."
	$(CC) -E -P -I . -x assembler-with-cpp taudac-overlay.dts -o taudac-overlay.dts.i
	$(DTC) -@ -H epapr -I dts -O dtb -o taudac.dtbo taudac-overlay.dts.i

taudac.eep: taudac-eeprom.txt taudac.dtbo
	@echo "Building EEPROM image..."
	$(EEPMAKE) taudac-eeprom.txt taudac.eep taudac.dtbo

eeprom.unlocked:
	@echo "Unlocking EEPROM..."
	echo '25' > /sys/class/gpio/export
	@sleep 0.1
	echo 'out' > /sys/class/gpio/gpio25/direction
	echo '0' > /sys/class/gpio/gpio25/value
	@date > eeprom.unlocked

erase flash: %: eeprom.unlocked do-%
	@echo "Locking EEPROM..."
	echo '25' > /sys/class/gpio/unexport
	@rm eeprom.unlocked

do-erase: blank.eep
	@echo "Erasing EEPROM..."
	$(EEPFLASH) --write --file=blank.eep --type=24c32

do-flash: taudac.eep
	@echo "Programming EEPROM..."
	$(EEPFLASH) --write --file=taudac.eep --type=24c32

clean:
	rm -f *.dts.i
	rm -f *.dtbo
	rm -f *.eep

