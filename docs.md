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

*PijFORTHOS* is a interpreter used to interact with a Raspberry Pi, as specified in its documentation:
> pijFORTHos is a bare-metal [FORTH](https://www.forth.com/starting-forth/) interpreter for the Raspberry Pi (original, Model B).

> The interpreter uses the RPi serial console (115200 baud, 8 data bits, no parity, 1 stop bit). If you have pijFORTHos on an SD card in the RPi, you can connect it to another machine (even another RPi) using a USB-to-Serial cable. When the RPi is powered on (I provide power through the cable), a terminal program on the host machine allows access to the FORTH console.

This project has been developed using a modified version of *PijFORTHOS* by the [Professor Daniele Peri](https://www.unipa.it/persone/docenti/p/daniele.peri) for research purposes. Although it is possible to build the code on the Raspberry Pi, I preferred the Cross-Compilation for ease of debugging. As specified in the `README.md`, `make` the project on your machine and transfer it to the Raspberry Pi using the USB to UART serial interface. This technique enables the developer to interact with the Raspberry Pi dynamically, meaning that the developer may use the defined WORDs or define new WORDs on his/her machine and execute them while the program is running.
