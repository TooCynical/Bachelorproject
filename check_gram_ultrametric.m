function t = check_gram_ultrametric(P)
    t = check_ultrametric(P.' * P);
end

% Returns one if input is strictly ultrametric, zero otherwise.
function t = check_ultrametric(M)
    % Check if the diagonal entries are maximal in their row.
    if M(1, 1) <= M(1, 2) || M(1, 1) <= M(1, 3)
        t = 0;
        return
    end
    if M(2, 2) <= M(2, 1) || M(2, 2) <= M(2, 3)
        t = 0;
        return
    end
    if M(3, 3) <= M(3, 1) || M(3, 3) <= M(3, 2)
        t = 0;
        return
    end
	
    % Check if there is no unique minimum in the upper and lower
	% off-diagonal elements.
    upper = reshape(M(1:2, 2:3), [1, 4]);
    lower = reshape(M(2:3, 1:2), [1, 4]);
    if sum(upper == min(upper)) < 2 || sum(lower == min(lower)) < 2
        t = 0;
        return
    end
	
	% If nothing is wrong return one.
    t = 1;
end

