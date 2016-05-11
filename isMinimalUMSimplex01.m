function b = isMinimalUMSimplex01(m, n)

b = 0;
originalm = m;

% Get the rows of m as binary vectors.
% TODO

global EhrlichTable;

% Loop over each possible choice of origin.
for k=0:n
    % Pick an origin.
    if k > 0
        m = originalm;
        m([1:k-1 k+1:end], :) = bitxor(m(k, :), m([1:k-1 k+1:end], :));
    end
    % Loop over all row permutations using Ehrlich swaps.
    for p = EhrlichTable
        % Swap row 1 and p and sort the columns of the result.
        m = rowSwap(m, 1, p);
        
        % Now check if this representation is smaller.
        if lexoCompare(sort(m), originalm) == 1
            return
        end
    end
end
b = 1;
end

% Swap two given rows in m using bitget and bitset.
function t = rowSwap(m, r1, r2)
    val1 = bitget(m, r1);
    val2 = bitget(m, r2);
    t = bitset(m, r2, val1);
    t = bitset(t, r1, val2);
end
