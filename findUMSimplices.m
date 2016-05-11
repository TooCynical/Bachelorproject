function rawUM = findUMSimplices(n)

global totalAmtChecked;
global convTable;
rawUM = [];

% First get the minimal UM tetraeders in order.
[~, ~, L] = UM01Tetra(n, 1);

% Get all combinations of 2 numbers from 1:n in order of maximal element.
nc2 = rot90(n+1 - nchoosek(1:n, 2), 2)';
% Get the amount of combinations of 2 numbers from 1:k for all 3 <= k <= n.
kc2 = zeros(n, 1);
for i = 3:n
    kc2(i) = nchoosek(i, 2);
end

% Recursively add new vertices to a set of (at least three) UM
% vertices.
function b = addVertex(m, w, poss)
    totalAmtChecked = totalAmtChecked + 1;
    new_poss = [];
    if size(m, 1) < n
        % Check each possible next vertex larger than the previous ones.
        for v = poss
            if v > m(end) && checkLastUM([m; v]) == 1
                new_poss = [new_poss v];
            end
        end
        
        % Check if enough possible vertices are left.
        if size(new_poss, 2) < n - size(m, 1)
            return
        end
        
        % Call the recursion for each possible vertex that retains
        % row order.
        for v = new_poss
            % Update row numbers
            new_w = 2 * w + convTable(:, v);
            if isequal(new_w, sort(new_w, 'descend')) == 1
                addVertex([m; v], new_w, new_poss);
            end
        end
    else
        rawUM = [rawUM m];
    end
end

% Check whether all tetraeders containing the last vertex of V (and two
% different vertices) are ultrametric.
function b = checkLastUM(v)
    % Loop through all combinations of three vertices in v containing the
    % last vertex and two earlier ones.
    for j = nc2(:, 1:kc2(size(v, 1) - 1))
        M = to01([v(j); v(end)]);
        if isGramUltrametric(M)==0
            b = 0;
            return
        end
    end
    b = 1;
end

% Call addVertex for each of the minimal UM tetraeders.
for m=L
    M = to01(m);
    w = M * [4; 2; 1];
    addVertex(m, w, m(end)+1:2^n-1);
end
end

