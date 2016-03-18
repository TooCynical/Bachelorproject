function M = to01(m)

% Get binary vectors from the convTable.
global convTable;
M = convTable(:, m);
