function [amts, UTn, UT] = UM01Tetra(n, modus)

% ---- COUNTING / STORING VARIABLES ----
rawUT = [];
UT = [];
UTn = [];
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
global perms3;
perms3 = perms(1:3)';

% Find ultrametric candidates.
if modus == 1
	rawUT = findUMTetra(n);
end
if modus == 2
	rawUT = findUMTetraFull(n);
end
totalUltrametric = size(rawUT, 2);

% Now filter for minimality.
for m=rawUT
    if isMinimalUMTetra(m, n)==1
        totalMinimal = totalMinimal + 1;
        UT = [UT m];  %#ok<AGROW>
    end
end

% Finally filter for dimension.
for m=UT
	M = to01(m);
	if ~isequal(M(n, :), [0 0 0])
        totalMinimaln = totalMinimaln + 1;
		UTn = [UTn m];  %#ok<AGROW>
	end
end

amts = [totalAmtChecked; totalUltrametric; totalMinimal; totalMinimaln];
