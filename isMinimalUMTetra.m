function b = isMinimalUMTetra(m, n)

b = 0;
permsn = perms(1:n)';
originalm = m;

% First pick an origin.
for k=0:3
    if k > 0
        m = originalm;
        m([1:k-1 k+1:3], :) = bitxor(m(k, :), m([1:k-1 k+1:3], :));
    end
    M = to01(m, n);
    % Then loop over all row permutations.
    for i=permsn
		newM = M(i, 1:3);
		
		% For each row permuation, the 'best' columnpermutation is the
		% one that sorts the columns.
		newm = sort(todec(newM, n));
		
		% Now check if this representation is smaller.
		if lexoCompare(newm, originalm) == 1
			return
		end
    end
end
b = 1;