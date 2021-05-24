EMBEDDED: util.f i2c.f keypad.f
	cat util.f >> embedded.f
	cat i2c.f >> embedded.f
	cat keypad.f >> embedded.f