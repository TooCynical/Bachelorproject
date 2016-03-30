function b = lexoCompare(m , k)
% Returns (m < k) for two decimally represented polytopes.
b=0;
for i=1:size(m, 1)
	if m(i) > k(i)
		return;
	end
	if m(i) < k(i)
		b = 1;
		return;
	end
end