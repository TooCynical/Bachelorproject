function b = is_minimal_um_tetra(m, n)
	
	lexo_number = [4 2 1] * m;
	M = to01(m, n);
	b = 0;
	permsn = perms(1:n)';
    perms3 = perms(1:3)';
    kl = 2.^(0:n-1);
    
	orig_M = M;
	orig_m = m;
	
	% First pick an origin.
	for k=1:3
		m = orig_m;
		m([1:k-1 k+1:3], :) = bitxor(m(k, :), m([1:k-1 k+1:3], :));
		% Then loop over all combinations of permutionmatrices.
		for i=permsn
			for j=perms3
				new_M = M(i, j);
				new_m = todec(new_M, kl);
				new_lexo_number = [4 2 1] * new_m;
				if new_lexo_number < lexo_number
				%	m
				%	new_m
					return
				end
			end
		end
	end
	
	b = 1;