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
