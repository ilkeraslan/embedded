## Embedded
An Embedded Systems project which tries to simulate the [Home Assistant](https://www.home-assistant.io/) using a RaspberryPi. The documentation is provided in the `docs.md` file.

![Embedded](https://user-images.githubusercontent.com/33685811/125822178-60ea7d1a-ebd4-46f7-934c-2a73eef1cd01.jpg)

### How To Use
- Install Minicom and Picocom
```
sudo apt-get install minicom && sudo apt-get install picocom
```
- Make the project (if it is not the first time you are compiling the project, **you should delete the file `embedded.f` first** as it will append new data there, which will only create problems)
```
make
```
- Start a Serial Port (your baud rate might be different, so please check yours and replace 115200 with that)
```
sudo picocom --b 115200 /dev/ttyUSB0 --send "ascii-xfr -sv -l100 -c10" --imap delbs
```
- Boot the RaspberryPi
- Press `ENTER`
- Prepare the terminal for file input by pressing `CTRL + A + S`
- Drag the file `embedded.f` and drop into the terminal
- Press `ENTER`
- After the terminal finished transfering the file successfully, call `SETUP` and press `ENTER`. 

At this point you should be able to use the system without any serial port.
