function rawUM = findUMSimplices(n)

global totalAmtChecked;
rawUM = [];

% First get the minimal UM tetraeders in order.
[~, ~, L] = UM01Tetra(n, 1);

% Recursively add new vertices to a set of (at least three) UM
% vertices.
function b = addVertex(v, poss)
    % Check each possible next vertex larger than the previous ones.
    totalAmtChecked = totalAmtChecked + 1;
    if size(v, 1) < n
        for m = v(end):2^n-1
            if checkLastUM([v; m]) == 1
                addVertex([v; m], poss)
            end
        end
    else
        M = to01(v);
        if isGramUltrametric(M)==1
            rawUM = [rawUM v];
        end
    end
end

%Check whether all tetraeders containing the last vertex of V (and two
%different vertices) are ultrametric.
function b = checkLastUM(v)
    nc2 = nchoosek(1:size(v, 1)-1, 2)';
    for i = nc2
        M = to01([v(i); v(end)]);
        if isGramUltrametric(M)==0
            b = 0;
            return;
        end
    end
    b = 1;
end

% Call addVertex for each of the minimal UM tetraeders.
for v=L
    addVertex(v, 1:2^n);
end
end

