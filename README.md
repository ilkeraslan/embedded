- Install Minicom and Picocom
```
sudo apt-get install minicom && sudo apt-get install picocom
```
- Start Serial Port
```
sudo picocom --b 115200 /dev/ttyUSB0 --send "ascii-xfr -sv -l100 -c10" --imap delbs
```
