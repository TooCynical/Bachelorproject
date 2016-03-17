function M = to01(m, n)
%Todo: efficienter
M = flipud((dec2bin(m, n) - 48)');