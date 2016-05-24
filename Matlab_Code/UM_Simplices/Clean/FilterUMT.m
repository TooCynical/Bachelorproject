function [MU, NMU] = FilterUMT(U, n)

    % 0/1 Conversion table.
    global convTable;
    convTable = [zeros(n, 1) MakeN(n)];
    
    MU = [];
    NMU = [];
    for m = U
        if isMinimal(m, n)
            MU = [MU m];
        else
            NMU = [NMU m];
        end        
    end
end

function b = isMinimal(m, n)

    global convTable;
    originalm = m;
    % Precalculating this saves quite some time...
    perms3 = perms(1:3)';

        % Loop over each possible choice of origin.
        for k=0:3    
            % Pick an origin.
            if k > 0
                m = originalm;
                m([1:k-1 k+1:3], :) = bitxor(m(k, :), m([1:k-1 k+1:3], :));
            end
            M = convTable(:, m + 1);
            % Loop over each column permutation.
            for i=perms3
                % Perform the column permutation.
                newM = M(1:n, i);

                % Then sort the rows (easiest in 0/1-form).
                newM = flipud(sortrows(newM));

                % Convert to decimal representation.
                newm = (2.^(0:(n-1)) * newM)';
                % Now check if this representation is smaller.
                if lexoCompare(newm, originalm) == 1
                    b = 0;
                    return
                end
            end
        end
    b = 1;
end