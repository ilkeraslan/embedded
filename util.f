\ Contains utility WORDS

\ Applies Logical Left Shift of 1 bit on the given value
\ Returns the shifted value
\ Usage: 2 MASK
  \ 2(BINARY 0010) -> 4(BINARY 0100)
: MASK 1 SWAP LSHIFT ;
