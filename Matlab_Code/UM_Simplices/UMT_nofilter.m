function rawUT = UMT_nofilter(n)
% First get the minimal acute triangles in order.
L = SortedAcute01Triang(n);

rawUT = [];
convTable = [zeros(n, 1) MakeN(n)];

%Loop through all combinations t = [v1 v2] where [v1 v2] is
%a minimal acute triangle.
for t=L
   % Create a matrix (in dec-form and 01-form) from t and v3.
   for v3 = 1:2^n-1
       m = [t; v3];
       M = convTable(:, m+1);
       % Add m to rawUT if it is ultrametric.
       if isGramUltrametric(M)==1
           rawUT = [rawUT m]; %#ok<AGROW>
       end
   end
end