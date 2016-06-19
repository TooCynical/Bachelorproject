function U = UMS(n, k)
    %UMS    Ultrametric simplices.
    % U = UMS(n) is a kxm matrix containing decimal representations of at 
    % least one representative of each equivalence class of ultrametric 
    % k-simplices in the n-cube.

    % 0/1 Conversion table.
    convTable = [zeros(n, 1) MakeN(n)];
    % Minimal UM tetraeders in order.
    UMTs = FilterUMT(UMT(n), n);
    % Ultrametric simplices.
    U = [];
    % All combinations of 2 numbers from 1:n in order of maximal element.
    nc2 = rot90(n+1 - nchoosek(1:n, 2), 2)';
    % Get the amount of combinations of 2 numbers from 1:k for all
    % 3 <= k <= n.
    kc2 = zeros(n, 1);
    for i = 3:n
        kc2(i) = nchoosek(i, 2);
    end
    
    totalAmtChecked = 0;
    
    % Call addVertex for each of the minimal UM tetraeders with
    % possibilities satisfying the SRE property.
    for m=UMTs
        M = to01(m);
        w = M * [4; 2; 1];
        addVertex(m, M, w, m(end)+1:2^n-1);
    end
    
    % Recursively add new vertices to a set of (at least three) UM
    % vertices.
    function b = addVertex(m, M, w, poss)
        totalAmtChecked = totalAmtChecked + 1;
        new_poss = [];
        
%         % Check SRE on first time.
%         if size(m,1) == 4 
%             if ~checkSRE(m, M, w)
%                 return
%             end
%         end
        
        if size(m, 1) < k
            % Check each possible next vertex larger than the previous ones.
            for v = poss
                if v > m(end) && checkLastUM([m; v]) == 1 && ...
                        sum(convTable(:, v+1)) >= sum(M(:, 1))
                    new_poss = [new_poss v];
                end
            end

            % Check if enough possible vertices are left.
            if size(new_poss, 2) < k - size(m, 1)
                return
            end

            % Call the recursion for each possible vertex that retains
            % row order.
            for v = new_poss
                % Update row numbers
                new_w = 2 * w + convTable(:, v + 1);
                if isequal(new_w, sort(new_w, 'descend')) == 1
                    addVertex([m; v], [M convTable(:, v+1)], new_w, new_poss);
                end
            end
        else
            U = [U m];
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
    U = sortrows(U')';
%     totalAmtChecked
end

function b = checkSRE(m, M, w)
    n = size(M, 1);
    a = sum(M(:, 1));
    M;
    N = M(a+1:n, 2:end);
    if size(N, 1) == 0
        b = 1;
        return
    end
   rs = sum(N);
   b = (min(rs) == rs(1));
end


