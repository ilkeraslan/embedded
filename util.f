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
