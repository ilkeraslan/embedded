\ GPIO utils
HEX
FE000000 CONSTANT BASE
BASE 200000 + CONSTANT GPFSEL0
BASE 200004 + CONSTANT GPFSEL1
BASE 200008 + CONSTANT GPFSEL2
BASE 200040 + CONSTANT GPEDS0
BASE 20001C + CONSTANT GPSET0
BASE 200028 + CONSTANT GPCLR0
BASE 200034 + CONSTANT GPLEV0
BASE 200058 + CONSTANT GPFEN0

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
\ 3 Broadcom Serial Controller (BSC) masters exist, we use the 2nd one
\ BSC1 register address: 0xFE804000 (Because our model is Rpi 4B)
\ To use the I2C interface add the following offsets to BCS1 register address
\ Each register is 32-bits long
\ 0x0  -> Control Register (used to enable interrupts, clear the FIFO, define a read or write operation and start a transfer)
\ 0x4  -> Status Register (used to record activity status, errors and interrupt requests)
\ 0x8  -> Data Length Register (defines the number of bytes of data to transmit or receive in the I2C transfer)
\ 0xc  -> Slave Address Register (specifies the slave address and cycle type)
\ 0x10 -> Data FIFO Register (used to access the FIFO)
\ 0x14 -> Clock Divider Register (used to define the clock speed of the BSC peripheral)
\ 0x18 -> Data Delay Register (provides fine control over the sampling/launch point of the data)
\ 0x1c -> Clock Stretch Timeout Register (provides a timeout on how long the master waits for the slave
\                                         to stretch the clock before deciding that the slave has hung)

\ I2C REGISTER ADDRESSES
\ BASE 804000 + -> I2C_CONTROL_REGISTER_ADDRESS
\ BASE 804004 + -> I2C_STATUS_REGISTER_ADDRESS
\ BASE 804008 + -> I2C_DATA_LENGTH_REGISTER_ADDRESS
\ BASE 80400C + -> I2C_SLAVE_ADDRESS_REGISTER_ADDRESS
\ BASE 804010 + -> I2C_DATA_FIFO_REGISTER_ADDRESS
\ BASE 804014 + -> I2C_CLOCK_DIVIDER_REGISTER_ADDRESS
\ BASE 804018 + -> I2C_DATA_DELAY_REGISTER_ADDRESS
\ BASE 80401C + -> I2C_CLOCK_STRETCH_TIMEOUT_REGISTER_ADDRESS

\ GPIO-2(SDA) AND GPIO-3(SCL) PINS SHOULD TAKE ALTERNATE FUNCTION 0
\ SO WE SHOULD CONFIGURE GPFSEL0 FIELD AS IT IS USED TO DEFINE THE OPERATION OF THE FIRST 10 GPIO PINS
\ EACH 3-BITS OF THE GPFSEL REPRESENTS A GPIO PIN, SO IN ORDER TO ADDRESS THE GPIO-2 AND GPIO-3
\   IN THE GPFSEL0 FIELD (32-BITS), WE SHOULD OPERATE ON THE BITS POSITION 8-7-6(GPIO-2) AND 11-10-9(GPIO-3)
\ AS A RESULT WE SHOULD WRITE (0000 0000 0000 0000 0000 1001 0000 0000) 
\   TO GPFSEL0_REGISTER_ADDRESS IN HEX(0x00000900)
: SETUP_I2C 
  900 GPFSEL0 @ OR GPFSEL0 ! ;

\ Resets Status Register using I2C_STATUS_REGISTER (BASE 804004 +)
\ (0x00000302) is (0000 0000 0000 0000 0000 0011 0000 0010) in BINARY
\ Bit 1 is 1 -> Clear Done field
\ Bit 8 is 1 -> Clear ERR field
\ Bit 9 is 1 -> Clear CLKT field
: RESET_S 
  302 BASE 804004 + ! ;

\ Resets FIFO using I2C_CONTROL_REGISTER (BASE 804000 +)
\ (0x00000010) is (0000 0000 0000 0000 0000 0000 0001 0000) in BINARY
\ Bit 4 is 1 -> Clear FIFO
: RESET_FIFO
  10 BASE 804000 + ! ;

\ Sets slave address 0x0000003F (Because our expander model is PCF8574T)
\ into I2C_SLAVE_ADDRESS_REGISTER (BASE 80400C +)
: SET_SLAVE 
  3F BASE 80400C + ! ;

\ Stores data into I2C_DATA_FIFO_REGISTER_ADDRESS (BASE 804010 +)
: STORE_DATA
  BASE 804010 + ! ;

\ Starts a new transfer using I2C_CONTROL_REGISTER (BASE 804000 +)
\ (0x00008080) is (0000 0000 0000 0000 1000 0000 1000 0000) in BINARY
\ Bit 0 is 0 -> Write Packet Transfer
\ Bit 7 is 1 -> Start a new transfer
\ Bit 15 is 1 -> BSC controller is enabled
: SEND 
  8080 BASE 804000 + ! ;

\ Write 1 byte at a time
: >I2C
  RESET_S
  RESET_FIFO
  1 BASE 804008 + !
  SET_SLAVE
  STORE_DATA
  SEND ;
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
\ TODO: Test this
: WELCOME 
  5D >I2C 
  58 >I2C 
  7D >I2C 
  78 >I2C 
   ;

\ TODO: Test this
: SETUP_LCD 
  0C >I2C 
  08 >I2C 
  2C >I2C 
  28 >I2C 
   ;

: SETUP 
  SETUP_I2C 
  SETUP_KEYPAD ;
