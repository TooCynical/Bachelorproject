function [amts, UM] = UM01Simplices(n)

% ---- COUNTING / STORING VARIABLES ----
rawUM = [];
UM = [];
UMn = [];
global totalAmtChecked;
totalAmtChecked = 0;
totalUltrametric = 0;
totalMinimal = 0;
totalMinimaln = 0;

% ---- GLOBAL TABLES ----
% 01-Conversion table
global convTable;
convTable = [zeros(n, 1) flipud((dec2bin(1:2^n-1, n) - 48)')];
% Column permutations.
global permsn;
permsn = perms(1:n)';

rawUM = findUMSimplices(n);
totalUltrametric = size(rawUM, 2);

% Now filter for minimality.
for m=rawUM
    if isMinimalUMSimplex(m, n)==1
        totalMinimal = totalMinimal + 1;
        UM = [UM m];  %#ok<AGROW>
    end
end

amts = [totalAmtChecked; totalUltrametric; totalMinimal; totalMinimaln];
