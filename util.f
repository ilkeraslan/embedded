\ GPIO utils
HEX
FE000000 CONSTANT DEVBASE
DEVBASE 200000 + CONSTANT GPFSEL0
DEVBASE 200004 + CONSTANT GPFSEL1
DEVBASE 200008 + CONSTANT GPFSEL2
DEVBASE 200040 + CONSTANT GPEDS0
DEVBASE 20001C + CONSTANT GPSET0
DEVBASE 200028 + CONSTANT GPCLR0
DEVBASE 200034 + CONSTANT GPLEV0
DEVBASE 200058 + CONSTANT GPFEN0

\ Applies Logical Left Shift of 1 bit on the given value
\ Returns the shifted value
\ Usage: 2 MASK
  \ 2(BINARY 0010) -> 4(BINARY 0100)
: MASK 1 SWAP LSHIFT ;

\ Sets the given GPIO pin to HIGH if configured as output
\ Usage: 12 HIGH -> Sets the GPIO-18 to HIGH
: HIGH 
  MASK GPSET0 ! ;

\ Clears the given GPIO pin if configured as output
\ Usage: 12 LOW -> Clears the GPIO-18
: LOW 
  MASK GPCLR0 ! ;

\ Tests the actual value of GPIO pins 0..31
\ 0 -> GPIO pin n is low
\ 1 -> GPIO pin n is high
\ Usage: 12 TPIN (Test GPIO-18)
: TPIN GPLEV0 @ SWAP RSHIFT 1 AND ;

: DELAY 
  BEGIN 1 - DUP 0 = UNTIL DROP ;

\ The constant to define the position of a command validator
\ For this project a valid command contains a special character in the 3rd position of that command
\ Example: 12A# is a valid command as it contains the predefined special character on the 3rd position
\          06B3 is not a valid command as it does not contain the predefined special character
\             on the 3rd position
CONSTANT OK_POS 3

\ The constant to define the position of a command validator
\ For this project a valid command contains a special character in the 3rd position of that command
\ Example: 12A# is a valid command as it contains the special character # (23 in HEX) on the 3rd position
\          06B* is not a valid command as it does not contain the predefined special character # (23 in HEX)
\             on the 3rd position
CONSTANT OK_C 23

\ Contants to define on and off operations
\ Example: 12A# -> Device no 12 is ON (A is 41 in HEX)
\          12B# -> Device no 12 is OFF (B is 42 in HEX)
CONSTANT ON_C 41
CONSTANT OFF_C 42

\ The number of the devices that the system supports (in HEX)
\ Example: DEV_NO A will define the CONSTANT as 10 in DECIMAL
CONSTANT DEV_NO 99

\ Variable to store the (OK_POS + 1) length commands
\ Changing the OK_POS CONSTANT will provide different length arrays
VARIABLE D_CMDS OK_POS CELLS ALLOT

\ Variable to store (DEV_NO + 1) number of devices (in HEX)
VARIABLE DEVS DEV_NO CELLS ALLOT

\ Takes the VARIABLE name and the index of the element to leave its memory address on TOS
\ Example: DEVS 3 C_ADDR @ -> Fetches the value of the element on the 4th position (index 3)
: C_ADDR CELLS + ;

\ Decides if a given command is OK or not checking the OK_C
\   on the position OK_POS of that command
\ Example: 64B# ?CMD
: ?CMD
  OK_POS D_CMD @ OK_C = ;

\ Resets the D_CMDS VARIABLE by writing 0's
: RES_CMD 
  OK_POS 1 + 0 DO 0 I D_CMD ! LOOP ;


: D_ON 
  D_CMDS 0 C_ADDR @  ;
