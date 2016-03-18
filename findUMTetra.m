function rawUT = findUMTetra(n)
global totalAmtChecked;

% First get the minimal acute triangles in order.
L = SortedAcute01Triang(n);

rawUT = [];

for t=L
	T = to01(t);
	% Find the dimensions of the blocks:
	% [1 1] d1
	% [1 0] d2
	% [0 1] d3
	% [0 0] d4
	d12 = sum(T(:, 1));
	d1 = sum(T(1:d12, 2));
	d2 = d12 - d1;
	d3 = sum(T(:, 2)) - d1;
	d4 = n - d3 - d2 - d1;
	for v31=0:d1
		for v32=0:d2
			for v33=0:d3
				for v34=0:d4
					v31dec = 2^v31 - 1;
					v32dec = 2^d1 * (2^v32 - 1);
					v33dec = 2^(d1 + d2) * (2^v33 - 1);
					v34dec = 2^(d1 + d2 + d3) * (2^v34 - 1);
					v3 = v31dec + v32dec + v33dec + v34dec;
					% Check if v3 > v2 (this could be done in the loop).
 				    if v3 > t(2)
					   totalAmtChecked = totalAmtChecked + 1;
					   % Create a matrix (in dec-form and 01-form) from t and v3.
					   m = [t; v3];
					   M = to01(m, n);
					   % Add m to rawUT if it is ultrametric.
					   if isGramUltrametric(M)==1
					       rawUT = [rawUT m]; %#ok<AGROW>
					   end
				   end
				end
			end
		end
	end
end
