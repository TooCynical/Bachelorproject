function M = to01(m)

% Get binary vectors from the convTable (shift one to also get the zero case).
global convTable;
M = convTable(:, m + 1);
