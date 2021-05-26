- Install Minicom and Picocom
```
sudo apt-get install minicom && sudo apt-get install picocom
```
- Make the project
```
make
```
- Start Serial Port
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