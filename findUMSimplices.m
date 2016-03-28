function rawUM = findUMSimplices(n)
global totalAmtChecked;

% First get the minimal acute triangles in order.
L = SortedAcute01Triang(n);

rawUM = [];

% Start with a minimal triangle and add n-2 more vertices.
for t=L
	for i = nchoosek(1:2^n - 1, n-2)'
		totalAmtChecked = totalAmtChecked + 1;
		m = [t; i];
		M = to01(m);
		% Add m to rawUT if it is ultrametric.
		if isGramUltrametric(M)==1
			rawUM = [rawUM m]; %#ok<AGROW>
		end
	end
end