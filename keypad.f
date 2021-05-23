\ Row pins are input, column pins are output
\ For each column send and output
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


HEX

FE000000 CONSTANT BASE
BASE 200058 + CONSTANT GPFEN0

\ Enable falling edge detection
MASK GPFEN0 @ OR GPFEN0 ! ;