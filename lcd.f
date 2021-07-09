\ Contains various words to interact with the lcd

\ Prints "welcome" to screen
: WELCOME
  57 >LCD 
  45 >LCD
  4C >LCD
  43 >LCD  
  4F >LCD
  4D >LCD
  45 >LCD ;

\ Clears the screen
: CLEAR
  101 >LCD ;

\ Moves the blinking cursor to second line
: >LINE2
  1C0 >LCD ;

\ Shows a blinking cursor at first line
: SETUP_LCD 
  102 >LCD ;
