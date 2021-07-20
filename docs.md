# Embedded Docs

As it has already been defined in `README`, this project tries to simulate the [Home Assistant](https://www.home-assistant.io/) using a RaspberryPi. At the moment the devices are supposed to be already connected to the system, and the system is only responsible for their management. In a future version, *hopefully* device detection and device connection will be addressed as well.

## Circuit

![Embedded Circuit](https://user-images.githubusercontent.com/33685811/125765767-04f28f21-9fd9-4ff4-a965-d02d5c1fc5fd.png)

## Development Ambient

The project has been realized using the following hardware and environment:
- [PijFORTHOS](https://github.com/organix/pijFORTHos)
- [Raspberry Pi 4B](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/specifications/)
- A machine with `Ubuntu 20.04.2 LTS` distribution
- [FT232RL](https://ftdichip.com/wp-content/uploads/2020/08/DS_FT232R.pdf) USB to UART serial interface
- [Tinsharp TC1602B-01 VER:00](http://www.tinsharp.com/product/327.html) 16x2 LCD
- [Philips PCF8574AT](https://dtsheet.com/doc/204293/philips-pcf8574) Remote 8-bit I/O expander for I2C-bus
- 4x4 Keypad Matrix
- Breadboard and Jumper Wires

Although this project has been developed with a Raspberry Pi 4B, theoretically it should be able to run on a [Raspberry Pi 3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) as well. However it has not been tested effectively so you should always keep that in mind. To do that you may change the definition `FE000000 CONSTANT DEVBASE` to `3F000000 CONSTANT DEVBASE` and you should be good to go.

The machine that we use for development would be another Linux distribution, a MacOS, or a Windows. On Windows you may use [Putty](https://www.putty.org/) in order to interact with the Raspberry Pi, whereas on a MacOS you should be able to use [Minicom](https://formulae.brew.sh/formula/minicom) and [Picocom](https://formulae.brew.sh/formula/picocom).

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

![LCD](https://user-images.githubusercontent.com/33685811/125774432-3a0370f0-314d-4d3c-b2d8-cf1e72fccb3c.png)

This project uses an LCD 16x2 (16 rows x 2 columns) with an integrated I2C module. The LCD is capable of displaying ASCII characters, letters, numbers, and symbols. In fact, we comunicate with the LCD sending the ASCII code of the character that we want to show, in HEX.

![I2C_LCD](https://user-images.githubusercontent.com/33685811/125774556-1398fa26-20d7-46d0-b778-b694edf0eac4.png)

Using an I2C interface that connects the serial input and parallel output mode to LCD allows us to use only 4 lines in order to comunicate with the LCD. The IC chip used is `PCF8574AT` and we should detect its address in order to establish a comunication. 

The I2C bus is a:
- synchronous
- multi-master
- multi-slave
- packet switched
- single-ended
- serial computer
bus used for attaching lower-speed peripheral integrated circuits to processors/microcontrollers in short distance.

Serial Data (SDA) and Serial Clock (SCL) wires carry the data in an I2C bus. Using the Open-Drain for Bidirectional Communication we may transfer a low by pulling the line to low or a high by leaving the line floating, which makes the pull-up resistor pull the voltage up.

The I2C bus works as following:
- Master sends:
  - START condition
  - Slave address (7-bit)
  - 0 for writing (1-bit)
- Slave sends ACK bit to acknowledge
- Master sends the register address to write into
- Slave sends ACK bit to acknowledge
- Master starts sending the actual data
- Master sends STOP condition

In this case the master is the Raspberry Pi, and the slave is I2C LCD module.

While the SCL is high, a high-to-low transition on the SDA line defines a `Start` condition, and a low-to-high transition on the SDA line defines a `Stop` condition. During each clock pulse of the SCL, one data bit is transmitted via SDA. Any number of data bytes may be transferred between `Start` and `Stop` conditions. Data is transferred sending the most significant bit first.

Each byte of data gets an ACK (acknowledge) response from the receiver. In order to receive the ACK, the sender must release the SDA line, so that the receiver may pull down the SDA line to become stable low during the high phase of the ACK clock period.


The WORD `>I2C` writes a byte to the I2C bus to the Broadcom Serial Controller (BSC) master address. In this project we use the second master address, which we obtain adding the `804008` offset to the base device address. The word `>LCD` controls if we want to send a command or a piece of data, and sends the expander a byte of which the bits are positioned in a significant way. For instance, the command `2C >LCD` produces (0x2C = 0010 1100) on the I2C bus:
```
D7=0, D6=0, D5=1, D4=0, Backlight=1, Enable=1, R/W’=0, RS=0
```
The command `28 >LCD` produces (0x2C = 0010 1000) on the I2C bus:
```
D7=0, D6=0, D5=1, D4=0, Backlight=1, Enable=0, R/W’=0, RS=0
```

This sequence of commands are interpreted as the *Function Set* command (0x20 = 0010 0000) with the parameter `DL=0`. As a result, we get to switch the bus to the 4-bit mode. Using the 4-bit mode, in order to send 1 byte to LCD we need to write 4 times on the I2C bus:
- 4 most significant bits with `Enable = 1`
- 4 most significant bits with `Enable = 0`
- 4 least significant bits with `Enable = 1`
- 4 least significant bits with `Enable = 0`

![Function Set](https://user-images.githubusercontent.com/33685811/125796047-7c024fdb-3333-44a1-b8ce-67d84374d436.png)
> ![Function Set Instructions](https://user-images.githubusercontent.com/33685811/125796234-cc9f899c-035d-4a70-87cd-5848cb6b4f32.png) ![Function Set Instructions-2](https://user-images.githubusercontent.com/33685811/125796435-ea23d4fa-6e44-44d9-b65b-2a2e8b13f876.png)

After this setup you can send any ASCII character by typing its HEX code and calling `>LCD` word, like `57 >LCD` (which sends `W` to LCD).

### Keypad

The Keypad Matrix contains a number of keys in one place. The 4x4 Keypad matrix used in this project contains 4 rows and 4 columns of buttons, which makes it a 16 push button switch device. 

![Keypad](https://user-images.githubusercontent.com/33685811/125770253-40faff6c-66c0-4488-8493-4cb7915290e0.png)

If we take a closer look to this scheme it may be noticed that the rightmost cable controls the rightmost column(the one with the characters A-B-C-D),  and viceversa the leftmost cable controls the uppermost row(the one with the characters 1-2-3-A). Thus connecting 8 keys with 8 GPIO-pins enables us to control 16 buttons which makes it quite efficient reducing the number of ports required.

![Keypad Internal Circuit](https://user-images.githubusercontent.com/33685811/125771118-0eb7bda8-6ed8-4613-82a2-4f17edac94e6.png)

The image above represents the internal circuit of the Keypad. Using either a row scanning method or a column scanning method we can detect the pressed key. In order to do this:
- Configure GPIO pins controlling the rows as output (GPIO pins 18, 23, 24, 25)
- Configure GPIO pins controlling the columns as input (GPIO pins 16, 22, 27, 10)
- Enable falling edge detection for the pins controlling rows in order to check the current value of the signal is lower than the value it had one time step before
- Clear each row using the corresponding GPCLR register
- Set HIGH the row that we want to control using the corresponding GPSET register
- Press any key on the row set to HIGH
- Test the GPIO pin value which controls the column of the pressed key, via the corresponding GPLEV register
- If the value is HIGH the press event has been detected correctly

Please note that the pins which control the rows and columns may be changed as you wish. While doing this, please make sure to check the Pull Up/Pull Down resistance of the selected pins.

In this project the Keypad setup has been done defining the WORD `SETUP_KEYPAD` which includes each step explained above.

## Software

As emphasized before, this software *only* manages the *supposedly connected devices* in a house. For instance, you have already connected your garage door controller to the system, and the system **simulates** some operations for you. For the time being those operations are:
- Open (A key)
- Close (B key)
- Get State (C key).

Foe each operation you can also use the defined WORDS from your terminal: `>OPEN`, `>CLOSE`, `<STATE`.

As one may imagine each operation is controlled by pressing the corresponding key. `A` opens the door, `B` closes the door, and `C` returns its state by telling you if ifs open or closed. But of course it's not enough to press the operation key only, we need the device id too, as we want to manage more than a garage door.

Thus the command to interact with the given device has the format: `12A#`. The first two characters represent the device id that we want to control (in HEX), the third character is the operation that we want to execute, and the last character is the **GO** command that we give to the software. So this command means *Open the device with the id 18(12 in HEX)*.

As you may have noticed the system is quite extensible. One may assign other meanings to other patterns in order to do different operations. A command which ends with `*` may reset the given device, a command which starts with the operation code followed by the device id may remove the device from the system, or a command like `45#*` may add the new device with the id 45 to the system.

During these commands the system is always interactive, and gives feedback to the user about the pressed key. At the end of each command, the validity of the command is controlled. If the command is not valid, user gets a `NOT VALID` feedback on the LCD, and the command is not taken into account. If it is a valid command, the operation on the given command gets realized with an eventual feedback to user.

## Project Structure

Each file contains the WORDS correlated to its name. More specifically:
- `se-ans.f` contains WORDS for standard ANSI Forth compatibility (courtesy of Professor Daniele Peri)
- `util.f` contains WORDS for utility instructions
- `i2c.f` contains WORDS to use the I2C bus
- `lcd.f` contains WORDS to comunicate with the LCD
- `commands.f` contains WORDS to control and execute the user commands
- `keypad.f` contains WORDS to check keypad events
- `main.f` contains a WORD to do the main setup
