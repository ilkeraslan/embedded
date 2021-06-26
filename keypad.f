\ For each row send an output
\ For each column control the values
\ If event detection bit is read we found the pressed key
  \ in row-column format
\ GPIO-18 -> Row-1 (1-2-3-A)
\ GPIO-23 -> Row-2 (4-5-6-B)
\ GPIO-24 -> Row-3 (7-8-9-C)
\ GPIO-25 -> Row-4 (*-0-#-D)
\ GPIO-16 -> Column-1 (A-B-C-D)
\ GPIO-22 -> Column-2 (3-6-9-#)
\ GPIO-27 -> Column-3 (2-5-8-0)
\ GPIO-10 -> Column-4 (1-4-7-*)

\ Enables falling edge detection for the pins which control the rows
  \ by writing 1 into corresponding pin positions (GPIO-18, 23, 24, 25)
\ (0x03840000) is (0000 0011 1000 0100 0000 0000 0000 0000) in BINARY
: SETUP_ROWS 
  3840000 GPFEN0 ! ;

\ Row pins are output, column pins are input 
\ GPFSEL1 field is used to define the operation of the pins GPIO-10 - GPIO-19
\ GPFSEL2 field is used to define the operation of the pins GPIO-20 - GPIO-29
\ Each 3-bits of the GPFSEL represents a GPIO pin
\ In order to address GPIO-10, GPIO-16, and GPIO-18 we should operate on the bits position 
  \ 2-1-0(GPIO-10), 20-19-18(GPIO-16) and 26-25-24(GPIO-18) storing the value into GPFSEL1
\ In order to address GPIO-22, GPIO-23, GPIO-24, GPIO-25, and GPIO-27 we should operate on the bits position 
  \ 8-7-6(GPIO-22), 11-10-9(GPIO-23), 14-13-12(GPIO-24), 17-16-15(GPIO-25), and 23-22-21(GPIO-27)
  \ storing the value into GPFSEL2
\ GPIO-18 is output -> 001
\ GPIO-23 is output -> 001
\ GPIO-24 is output -> 001
\ GPIO-25 is output -> 001
\ GPIO-16 is input -> 000
\ GPIO-22 is input -> 000
\ GPIO-27 is input -> 000
\ GPIO-10 is input -> 000
\ As a result we should write 
\   (0001 0000 0000 0000 0000 0000 0000) into GPFSEL1_REGISTER_ADDRESS IN HEX(0x1000000)
\   (0000 1001 0010 0000 0000) into GPFSEL2_REGISTER_ADDRESS IN HEX(0x9200)
: SETUP_IO 
  1000000 GPFSEL1 @ OR GPFSEL1 ! 
  9200 GPFSEL2 @ OR GPFSEL2 ! ;

\ Clear GPIO-18, GPIO-23, GPIO-24, and GPIO-25 using GPCLR0 register
  \ by writing 1 into the corresponding positions
\ (0x3840000) is (0011 1000 0100 0000 0000 0000 0000) in BINARY
: CLEAR_ROWS 
  3840000 GPCLR0 ! ;

: SETUP_KEYPAD 
  SETUP_ROWS 
  SETUP_IO 
  CLEAR_ROWS ;

: PRESSED 
  TPIN 1 = IF 1 ELSE 0 THEN ;
