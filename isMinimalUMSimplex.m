function b = isMinimalUMSimplex(m, n)

b = 0;
originalm = m;
% Precalculating this saves quite some time...
global permsn;

% Loop over each possible choice of origin.
for k=0:n
    % Pick an origin.
    if k > 0
        m = originalm;
        m([1:k-1 k+1:end], :) = bitxor(m(k, :), m([1:k-1 k+1:end], :));
    end
    M = to01(m);
    % Loop over each column permutation.
    for i=permsn
        % Perform the column permutation.
        newM = M(1:n, i);
        
        % Then sort the rows (easiest in 0/1-form).
        newM = flipud(sortrows(newM));

        newm = todec(newM, n);

        % Now check if this representation is smaller.
        if lexoCompare(newm, originalm) == 1
            return
        end
    end
end
b = 1;

