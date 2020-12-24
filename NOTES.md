# Notes

Activate I2C-0 by adding the following line to `/boot/config.txt` and reboot.

```sh
dtparam=i2c_vc=on
```

Program the ID EEPROM:

```
make flash
```

