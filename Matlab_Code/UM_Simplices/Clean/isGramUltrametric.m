function t = isGramUltrametric(P)
    t = isUltrametric(P' * P);
end

% Returns one if input is strictly ultrametric, zero otherwise.
function t = isUltrametric(G)
% Check if the diagonal entries are maximal in their row.
if G(1, 1) <= G(1, 2) || G(1, 1) <= G(1, 3)
    t = 0;
    return
end
if G(2, 2) <= G(2, 1) || G(2, 2) <= G(2, 3)
    t = 0;
    return
end
if G(3, 3) <= G(3, 1) || G(3, 3) <= G(3, 2)
    t = 0;
    return
end

% Check if there is no unique minimum in the upper and lower
% off-diagonal elements.
upper = sort([G(1, 2) G(1, 3) G(2, 3)]);
if upper(1) ~= upper(2) || upper(1) == 0
    t = 0;
    return
end

% If nothing is wrong return one.
t = 1;
end
