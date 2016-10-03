dtbo: taudac-overlay.dts
	@echo "Building DT overlay..."
	dtc -@ -I dts -O dtb -o taudac.dtbo taudac-overlay.dts

clean:
	rm -f *.dtbo
