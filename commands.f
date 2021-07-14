\ Manages the given commands

\ The constant to define the position of a command validator
\ For this project a valid command contains a special character in the 3rd position of that command
\ Example: 12A# is a valid command as it contains the predefined special character on the 3rd position
\          06B3 is not a valid command as it does not contain the predefined special character
\             on the 3rd position
CONSTANT OK_POS 3

\ The constant to define the position of an operation type
\ A -> Device on
\ B -> Device off
\ Example: 12A# turns the device 12 on
\          12B# turns the device 12 off
CONSTANT OP_POS 2

\ The constant to define the position of a command validator
\ For this project a valid command contains a special character in the 3rd position of that command
\ Example: 12A# is a valid command as it contains the special character # (23 in HEX) on the 3rd position
\          06B* is not a valid command as it does not contain the predefined special character # (23 in HEX)
\             on the 3rd position
CONSTANT OK_C 23

\ Contants to define on and off operations
\ Example: 12A# -> Device no 12 is ON
\          12B# -> Device no 12 is OFF
CONSTANT ON_C A
CONSTANT OFF_C B

\ The number of the devices that the system supports (in HEX)
\ Example: DEV_NO A will define the CONSTANT as 10 in DECIMAL
CONSTANT DEV_NO 99

\ Variable to store the (OK_POS + 1) length commands
\ Changing the OK_POS CONSTANT will provide different length arrays
VARIABLE D_CMDS OK_POS CELLS ALLOT

\ Variable to store (DEV_NO + 1) number of devices (in HEX)
VARIABLE DEVS DEV_NO CELLS ALLOT

\ Decides if a given command is OK or not by checking the OK_C
\   on the position OK_POS of that command
\ Example: 64B# ?CMD
: ?CMD
  D_CMDS OK_POS CELLS + @ OK_C = ;

: OP_TYPE 
  D_CMDS OP_POS CELLS + @ DUP 
  ON_C = IF 
    DROP ON_C
  ELSE OFF_C = IF 
    OFF_C
  THEN THEN ;

\ Resets the D_CMDS VARIABLE by writing 0's
\ Note: OK_POS 1 + 0 DO 0 D_CMDS I CELLS + ! LOOP instruction for this definition does not work
\       otherwise it would have been more Forth style
VARIABLE AUX_I
: RES_CMD 
  0 AUX_I !
  BEGIN 
  D_CMDS AUX_I @ CELLS + ! 
  AUX_I @ 1 + AUX_I !
  AUX_I @ OK_POS 1 + = UNTIL ;

\ Fetches the first 2 values stored in D_CMDS and converts it to a device number
\ Example: D_CMDS-0 contains 3
\          D_CMDS-1 contains E
\          Leaves 3E on TOS
: 2DEV 
  D_CMDS 0 CELLS + @ 4 LSHIFT
  D_CMDS 1 CELLS + @ 
  OR ;

\ Sets a device on/off
\ Example: ON_C D_SET -> Sets the device on
\          OFF_C D_SET -> Sets the device off
: D_SET 
  R> DEVS 2DEV CELLS + >R ! ;

\ Executes the given command if it is valid, else prints NOT_VALID on the screen
: XCMD 
  ?CMD IF 
    OP_TYPE D_SET 
    1000 DELAY 4F >LCD
    1000 DELAY 4B >LCD
  ELSE 
    CLEAR 
    1000 DELAY NOT_VALID 
    3000 DELAY CLEAR
  THEN ;
