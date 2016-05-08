function rawUM = findUMSimplicesBrute(n)
global totalAmtChecked;

% First get the minimal acute Tetraeders in order.
[~, ~, L] = UM01Tetra(n, 1);

rawUM = [];

% Start with a minimal triangle and add n-2 more vertices.
for t=L
	for i = nchoosek(t(3):2^n - 1, n-3)'
        totalAmtChecked = totalAmtChecked + 1;
        m = [t; i];
        M = to01(m);
        % Add m to rawUT if it is ultrametric.
        if isGramUltrametric(M)==1
            rawUM = [rawUM m]; %#ok<AGROW>
        end
	end
end