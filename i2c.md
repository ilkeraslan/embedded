- Master sends:
  - START condition
  - Slave address (7-bit)
  - 0 for writing (1-bit)
- Slave sends ACK bit to acknowledge
- Master sends the register address to write into
- Slave sends ACK bit to acknowledge
- Master starts sending the actual data
- Master sends STOP condition


La parola >i2c esegue una scrittura di un byte sul bus i2c dopo che la parola i2c-addr ne ha indicato l’indirizzo.
Quindi la parola >LCD mette insieme tutto inviando all’expander un byte i cui bit sono posti in uscita sulle linee del bus corrispondenti.

2C >LCD produce (0x2C = 0010 1100) sul bus
  D7=0, D6=0, D5=1, D4=0, Backlight=1, Enable=1, R/W’=0, RS=0. 
28 >LCD produce (0x28 = 0010 1000) sul bus
  D7=0, D6=0, D5=1, D4=0, Backlight=1, Enable=0, R/W’=0, RS=0.

Questa sequenza viene interpretata dal display come il comando Function Set (0x20 = 0010 0000) con parametro DL=0 che commuta il display nella modalità bus a 4 bit.

Quindi, secondo protocollo, per inviare un byte al display sono necessarie 4 scritture sul bus i2c:
- 4 bit più significativi con Enable=1
- 4 bit più significativi con Enable=0
- 4 bit meno significativi con Enable=1
- 4 bit meno significativi con Enable=0

0101 0111 -> W
0101 1100 -> 5C
0101 1000 -> 58
0111 1100 -> 7C
0111 1000 -> 78

SETUP_I2C

0C WRITE_TO_I2C
08 WRITE_TO_I2C

2C WRITE_TO_I2C
28 WRITE_TO_I2C

5D WRITE_TO_I2C
58 WRITE_TO_I2C
0D WRITE_TO_I2C
08 WRITE_TO_I2C

5D WRITE_TO_I2C
58 WRITE_TO_I2C
0D WRITE_TO_I2C
08 WRITE_TO_I2C

5D WRITE_TO_I2C
58 WRITE_TO_I2C
0D WRITE_TO_I2C
08 WRITE_TO_I2C

