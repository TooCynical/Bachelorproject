function FU = FilterUMT(U)

b = 0;
originalm = m;
originalM = to01(m);
% Precalculating this saves quite some time...
perms3 = perms(1:3)';

    % Loop over each possible choice of origin.
    for k=0:3    
        % Pick an origin.
        if k > 0
            m = originalm;
            m([1:k-1 k+1:3], :) = bitxor(m(k, :), m([1:k-1 k+1:3], :));
        end
        M = to01(m);
        % Loop over each column permutation.
        for i=perms3
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
