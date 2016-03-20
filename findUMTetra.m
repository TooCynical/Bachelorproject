function rawUT = findUMTetra(n)
global totalAmtChecked;

% First get the minimal acute triangles in order.
L = SortedAcute01Triang(n);

rawUT = [];

for t=L
	% Loop over possible configurations given by the blocksizes.
	T = to01(t);
	blockLengths = findBlockSizes(T, n);
	for v31=0:blockLengths(1)
		for v32=0:blockLengths(2)
			for v33=0:blockLengths(3)
				for v34=0:blockLengths(4)
					% Find a decimal and 0/1 representation for v3.
					v3 = blockNumtoDec(blockLengths, [v31, v32, v33, v34]);
					V3 = to01(v3);
					% Check if v3 > v2.
					% Check if #1's in v3 > #1's in v1
 				    if v3 > t(2) && sum(V3) >= sum(T(:, 1))
					   totalAmtChecked = totalAmtChecked + 1;
					   % Create a matrix (in dec-form and 01-form) from t and v3.
					   m = [t; v3];
					   M = to01(m);
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

end

% Finds the length of the blocks:
% [1 1]
%  ...  d1
%  ...
% [1 0] 
%  ...  d2
%  ...
% [0 1] 
%  ...  d3
%  ...
% [0 0] 
%  ...  d4
%  ...
function blockLengths = findBlockSizes(T, n)
	d12 = sum(T(:, 1));
	d1 = sum(T(1:d12, 2));
	d2 = d12 - d1;
	d3 = sum(T(:, 2)) - d1;
	d4 = n - d3 - d2 - d1;
	blockLengths = [d1, d2, d3, d4];
end

% Converts block lengths together with block indices to
% a decimal representation.
function v3 = blockNumtoDec(blockLengths, blockIndices)
	block1Dec = 2^blockIndices(1) - 1;
	block2Dec = 2^blockLengths(1) * (2^blockIndices(2) - 1);
	block3Dec = 2^(blockLengths(1) + blockLengths(2)) * (2^blockIndices(3) - 1);
	block4Dec = 2^(blockLengths(1) + blockLengths(2) + blockLengths(3)) * (2^blockIndices(4) - 1);
	v3 = block1Dec + block2Dec + block3Dec + block4Dec;
end
