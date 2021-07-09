\ Contains various words to interact with the lcd

\ Prints "welcome" to screen
: WELCOME
  57 >LCDM 
  45 >LCDM
  4C >LCDM
  43 >LCDM  
  4F >LCDM
  4D >LCDM
  45 >LCDM ;

\ Clears the screen
: CLEAR
  0C >I2C 1000 DELAY 
  08 >I2C 1000 DELAY 
  1C >I2C 1000 DELAY 
  18 >I2C 1000 DELAY ;

\ Moves the blinking cursor to second line
: >LINE2
  CC >I2C
  C8 >I2C
  0C >I2C
  08 >I2C ;

\ Shows a blinking cursor at first line
: SETUP_LCD 
  0C >I2C 1000 DELAY 
  08 >I2C 1000 DELAY
  2C >I2C 1000 DELAY 
  28 >I2C 1000 DELAY ;
