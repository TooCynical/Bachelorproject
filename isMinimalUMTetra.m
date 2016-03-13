function b = isMinimalUMTetra(m, n)

lexoNumber = [4 2 1] * m;
b = 0;
permsn = perms(1:n)';
perms3 = perms(1:3)';
lexoWeight = 2.^(0:n-1);

originalm = m;

% First pick an origin.
for k=0:3
    if k > 0
        m = originalm;
        m([1:k-1 k+1:3], :) = bitxor(m(k, :), m([1:k-1 k+1:3], :));
    end
    M = to01(m, n);
    % Then loop over all combinations of permutionmatrices.
    for i=permsn
        for j=perms3
            newM = M(i, j);
            newm = todec(newM, lexoWeight);
            newLexoNumber = [4 2 1] * newm;
            if newLexoNumber < lexoNumber
                return
            end
        end
    end
end
b = 1;