function M = to01(m, n)
	M = flipud((dec2bin(m, n) - 48)');