## Embedded
An Embedded Systems project which tries to simulate the [Home Assistant](https://www.home-assistant.io/) using a RaspberryPi.

### How To Use
- Install Minicom and Picocom
```
sudo apt-get install minicom && sudo apt-get install picocom
```
- Make the project
```
make
```
- Start a Serial Port (your baud rate might be different, so please check yours and replace 115200 with that)
```
sudo picocom --b 115200 /dev/ttyUSB0 --send "ascii-xfr -sv -l100 -c10" --imap delbs
```
- Boot the RaspberryPi
- Press `ENTER`
- Prepare the terminal for file input by pressing
```
CTRL + A + S
```
- Drag the file `embedded.f` and drop into the terminal
- Press `ENTER`
- After the terminal finished transfering the file successfully, call `SETUP` and press `ENTER`. 

At this point you should be able to use the system without any serial port.
