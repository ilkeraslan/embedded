EMBEDDED: util.f i2c.f lcd.f keypad.f main.f
	cat util.f >> embedded.f
	cat i2c.f >> embedded.f
	cat lcd.f >> embedded.f
	cat keypad.f >> embedded.f
	cat commands.f >> embedded.f
	cat main.f >> embedded.f
	