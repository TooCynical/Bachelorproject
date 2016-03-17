function M = to01(m, n)

% Get binary vectors from the convTable.
global convTable;
M = convTable(:, [m(1), m(2), m(3)]);
