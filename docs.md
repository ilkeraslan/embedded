# Embedded Docs

As it has already been defined in `README`, this project tries to simulate the [Home Assistant](https://www.home-assistant.io/) using a RaspberryPi. At the moment the devices are supposed to be already connected to the system, and the system is only responsible for their management. In a future version, *hopefully* device detection and device connection will be addressed as well.

## Circuit

[Embedded Circuit](https://user-images.githubusercontent.com/33685811/125765767-04f28f21-9fd9-4ff4-a965-d02d5c1fc5fd.png)

## Development Ambient

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

Although the project has been developed using FORTH language, *PijFORTHOS* does not interpret each WORD defined in FORTH. Here you can find the subset of [FORTH WORDS available in *PijFORTHOS*](https://github.com/organix/pijFORTHos/blob/master/doc/forth.md).

> The interpreter uses the RPi serial console (115200 baud, 8 data bits, no parity, 1 stop bit). If you have pijFORTHos on an SD card in the RPi, you can connect it to another machine (even another RPi) using a USB-to-Serial cable. When the RPi is powered on (I provide power through the cable), a terminal program on the host machine allows access to the FORTH console.

This project has been developed using a modified version of *PijFORTHOS* by the [Professor Daniele Peri](https://www.unipa.it/persone/docenti/p/daniele.peri) for research purposes. Although it is possible to build the code on the Raspberry Pi, I preferred the Cross-Compilation for ease of debugging. As specified in the `README.md`, `make` the project on your machine and transfer it to the Raspberry Pi using the USB to UART serial interface. This technique enables the developer to interact with the Raspberry Pi dynamically, meaning that the developer may use the defined WORDs or define new WORDs on his/her machine and execute them while the program is running.


### USB to UART Serial Interface

From the [Wikipedia Page](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter):
> A universal asynchronous receiver-transmitter (UART /ˈjuːɑːrt/) is a computer hardware device for asynchronous serial communication in which the data format and transmission speeds are configurable. It sends data bits one by one, from the least significant to the most significant, framed by start and stop bits so that precise timing is handled by the communication channel.

UART is used to build a serial comunication channel between a peripheral device serial port and another device. The n bytes of data is decomposed into bits and each bit is transmitted sequentially. When the destination device receives the transmitted bits, they are composed into complete bytes. Although using the shift register of the UART it is possible to select between the serial and parallel transmition. Mostly the least significant bit is transmitted first, but there may be some exceptions.

Each character to send is mapped into:
- logic low start bit
- data bits
- parity bit
- stop bit/s

In this manner the receiver is able to read the start bit to decide if a new character is being transmitted, read the data bits, check the parity and finally read the stop bit/s to understand the transmission has ended.

During the development the UART interface has been used to send/receive data to/from Raspberry Pi and to define new WORDs in order to interact with the kernel.

### LCD



### I/O expander for I2C-bus
// TODO

### Keypad
// TODO

## Software
// TODO
