function UT = UM01Tetra(n)

% First get the minimal acute triangles in order.
L = SortedAcute01Triang(n);
rawUT = []

% Loop through all combinations t = [v1 v2] where [v1 v2] is
% a minimal acute triangle.
for t=L
	% Find the smallest dimension v1 and v2 can be embedded into.
	minDim = floor(log2(t(2))) + 1;
	% Loop through all v3, where v3 = [v31; v32], with v31 any 
    % vector of length min_dim, and v32 a vector of the form 
    % [1 1 1 1 ... 0 0 0 0 ...] of length n - min_dim.
	for v31=1:(2^minDim - 1)
		for v32=0:(n-minDim)
            % Create v3 from v31 and v32
			v3 = v31 + 2^minDim * (2^v32 - 1);
            % Check if v3 > v2 (this could be done in the loop).
			if v3 > t(2)
                % Create a matrix (in dec-form) from t and v3.
                m = [t; v3];
                % Add m to rawUT if it is ultrametric.
                
                
            end
		end
	end
end

