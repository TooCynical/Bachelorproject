function UT = UM01Tetra(n)

% First get the minimal acute triangles in order.
L = SortedAcute01Triang(n);
UT  =0;

% Loop through all combinations t = [v1 v2] where [v1 v2] is
% a minimal acute triangle.
for t=L
	% Find the smallest dimension v1 and v2 can be embedded into.
	min_dim = ceil(log2(max(t(1), t(2))));
	%min_dim = n;
	% Loop through all v3, where v3 = [v4; v5], with v4 any vector
	% of length min_dim, and v5 a vector of the vorm [1 1 1 1 ... 0 0 0 0 ...]
	% of length n - min_dim.
	for v4=1:(2^min_dim - 1)
		for w5=0:(n-min_dim)
			v3 = v4 + 2^min_dim * (2^w5 - 1);
			v = [t; v3];
			if isUMTetra(v, n)==1 && v3 > t(2)
				UT = UT + 1;
			end
		end
	end
end

