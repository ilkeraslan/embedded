\ For each column send an output
\ For each row control the values
\ If event detection bit is read we found the pressed key
  \ in row-column format
\ GPIO-18 -> Row-1
\ GPIO-23 -> Row-2
\ GPIO-24 -> Row-3
\ GPIO-25 -> Row-4
\ GPIO-16 -> Column-1
\ GPIO-22 -> Column-2
\ GPIO-27 -> Column-3
\ GPIO-10 -> Column-4

\ Enables falling edge detection for the pins which control the rows
  \ by writing 1 into corresponding pin positions (GPIO-18, 23, 24, 25)
\ (0x03840000) is (0000 0011 1000 0100 0000 0000 0000 0000) in BINARY
: SETUP_ROWS 
  3840000 GPFEN0 ! ;

\ Row pins are input, column pins are output 
\ GPFSEL1 field is used to define the operation of the pins GPIO-10 - GPIO-19
\ GPFSEL2 field is used to define the operation of the pins GPIO-20 - GPIO-29
\ Each 3-bits of the GPFSEL represents a GPIO pin
\ In order to address GPIO-10, GPIO-16, and GPIO-18 we should operate on the bits position 
  \ 2-1-0(GPIO-10), 20-19-18(GPIO-16) and 26-25-24(GPIO-18) storing the value into GPFSEL1
\ In order to address GPIO-22, GPIO-23, GPIO-24, GPIO-25, and GPIO-27 we should operate on the bits position 
  \ 8-7-6(GPIO-22), 11-10-9(GPIO-23), 14-13-12(GPIO-24), 17-16-15(GPIO-25), and 23-22-21(GPIO-27)
  \ storing the value into GPFSEL2
\ GPIO-18 is input -> 000
\ GPIO-23 is input -> 000
\ GPIO-24 is input -> 000
\ GPIO-25 is input -> 000
\ GPIO-16 is output -> 001
\ GPIO-22 is output -> 001
\ GPIO-27 is output -> 001
\ GPIO-10 is output -> 001
\ As a result we should write 
\   (0000 0000 0000 0100 0000 0000 0000 0001) into GPFSEL1_REGISTER_ADDRESS IN HEX(0x40001)
\   (0000 0000 0010 0000 0000 0000 0100 0000) into GPFSEL2_REGISTER_ADDRESS IN HEX(0x200040)
: SETUP_IO 
  40001 GPFSEL1 @ OR GPFSEL1 ! 
  200040 GPFSEL2 @ OR GPFSEL2 ! ;

\ Clear GPIO-16, GPIO-22, GPIO-27, and GPIO-10 using GPCLR0 register
  \ by writing 1 into the corresponding positions
\ (0x8410400) is (0000 1000 0100 0001 0000 0100 0000 0000) in BINARY
: CLEAR_COLUMNS 
  8410400 GPCLR0 @ OR GPCLR0 ! ;

: SETUP_KEYPAD 
  SETUP_ROWS 
  SETUP_IO 
  CLEAR_COLUMNS ;
