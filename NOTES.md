# Notes

Activate I2C-0 by adding the following line to `/boot/config.txt` and reboot.

```sh
dtparam=i2c_vc=on
```

Run the following commands to build and flash the EEPROM image.

```
make
sudo make flash
```

