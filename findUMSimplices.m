function rawUM = findUMSimplices(n)

global totalAmtChecked;
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
function b = addVertex(v, poss)
    % Check each possible next vertex larger than the previous ones.
    totalAmtChecked = totalAmtChecked + 1;
    if size(v, 1) < n
        for m = v(end)+1:2^n-1
            t = [v; m];
            T = to01(t);
            if sum(T(:, end)) >= sum(T(:, 1))
                if checkLastUM(t) == 1
                    addVertex(t, poss)
                end
            end
        end
    else
        rawUM = [rawUM v];
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
for v=L
    addVertex(v, v(end)+1:2^n);
end
end

