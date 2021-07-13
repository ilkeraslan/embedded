## Embedded Docs

### Development Ambient

The project has been realized using the following hardware and environment:
- [PijFORTHOS](https://github.com/organix/pijFORTHos)
- [Raspberry Pi 4B](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/specifications/)
- A machine with `Ubuntu 20.04.2 LTS` distribution
- [FT232RL](https://ftdichip.com/wp-content/uploads/2020/08/DS_FT232R.pdf) USB to UART serial interface
- [Tinsharp TC1602B-01 VER:00](http://www.tinsharp.com/product/327.html) 16x2 LCD
- [Philips PCF8574](https://dtsheet.com/doc/204293/philips-pcf8574) Remote 8-bit I/O expander for I2C-bus
- 4x4 Keypad Matrix
- Breadboard and Jumper Wires

Although this project has been developed with a Raspberry Pi 4B, theoretically it should be able to run on a [Raspberry Pi 3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) as well. However it has not been tested effectively so you should always keep that in mind. To do that you may change the definition `FE000000 CONSTANT DEVBASE` to `3F000000 CONSTANT DEVBASE`.

The other machine would be another Linux distribution, a MacOS, or a Windows. On Windows you may use [Putty](https://www.putty.org/) in order to interact with the Raspberry Pi, whereas on a MacOS you should be able to use [Minicom](https://formulae.brew.sh/formula/minicom) and [Picocom](https://formulae.brew.sh/formula/picocom).