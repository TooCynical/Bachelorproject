function U = UMT(n)
    %UMT    Ultrametric tetraeders.
    % U = UMT(n) is a 3xm matrix containing decimal representations of at 
    % least one representative of each equivalence class of ultrametric 
    % tetraeders in the n-cube.

    % 0/1 Conversion table.
    convTable = [zeros(n, 1) MakeN(n)];
    % Minimal acute triangles in order.
    L = SortedAcute01Triang(n);
    % Ultrametric tetraeders.
    U = [];

    % Start with an acute triangle.
    for t=L
        % Convert to 0/1 representation.
        T = convTable(:, t + 1);
        [b1, b2, b3, b4] = findBlockSizes(T, n);
        % Loop over possible configurations given by the blocksizes.
        for v31=0:b1
            for v32=0:b2
                for v33=0:b3
                    for v34=0:b4
                        % Find a decimal and 0/1 representation for v3.
                        v3 = b2dec(b1, b2, b3, [v31, v32, v33, v34]);
                        V3 = convTable(:, v3 + 1);
                        % Check if v3 > v2.
                        % Check if #1's in v3 > #1's in v1
                        if v3 > t(2) && sum(V3) >= sum(T(:, 1))
                            % Create a matrix (in dec-form and 01-form) 
                            % from t and v3.
                            m = [t; v3];
                            M = [T convTable(:, v3 + 1)];
                            % Add m to rawUT if it is ultrametric.
                            if isGramUltrametric(M)==1
                                U = [U m]; %#ok<AGROW>
                            end
                        end
                    end
                end
            end
        end
    end
end

% Find the blocksizes of a nx2 0/1 matrix.
function [b1, b2, b3, b4] = findBlockSizes(T, n)
    d12 = sum(T(:, 1));
    b1 = sum(T(1:d12, 2));
    b2 = d12 - b1;
    b3 = sum(T(:, 2)) - b1;
    b4 = n - b3 - b2 - b1;
end

% Converts block lengths together with block indices to
% a decimal representation.
function v3 = b2dec(b1, b2, b3, blockIndices)
    block1Dec = 2^blockIndices(1) - 1;
    block2Dec = 2^b1 * (2^blockIndices(2) - 1);
    block3Dec = 2^(b1 + b2) * (2^blockIndices(3) - 1);
    block4Dec = 2^(b1 + b2 + b3) * (2^blockIndices(4) - 1);
    v3 = block1Dec + block2Dec + block3Dec + block4Dec;
end

