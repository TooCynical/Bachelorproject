function rawUT = findUMTetraFull(n)
global totalAmtChecked;

% First get the minimal acute triangles in order.
L = SortedAcute01Triang(n);

rawUT = [];

for t=L
	for v3=1:2^n - 1
		totalAmtChecked = totalAmtChecked + 1;
		m = [t; v3];
		M = to01(m, n);
		% Add m to rawUT if it is ultrametric.
		if isGramUltrametric(M)==1
			rawUT = [rawUT m]; %#ok<AGROW>
		end
	end
end