function t = isGramUltrametric(P)
t = 1;
G = P.' * P;
for i = nchoosek(1:size(P,2), 3)'
    GT = G(i, i);
    t = t && isUltrametric(GT);
end
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
upper = reshape(G(1:2, 2:3), [1, 4]);
lower = reshape(G(2:3, 1:2), [1, 4]);
if sum(upper == min(upper)) < 2 || sum(lower == min(lower)) < 2
    t = 0;
    return
end

% If nothing is wrong return one.
t = 1;
end
