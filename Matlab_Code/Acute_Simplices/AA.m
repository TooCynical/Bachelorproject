function L = AA(n,k)

N = MakeN(n);          % Initiate unit n-cube excluding origin
L = [];
T = Acute01Triang(n);  % Produce list of all acute 0/1-triangles

for v = T
   [c,lc,X,Y,bp,bpdata,sre,sredata]  = InitDataStructs(v,N,n);
   
   % for the triangle v from T, set up the initial data structs:
   % 
   % c       = list of vertices j such that [v j] is an acute tet
   % lc      = number/amount of such vertices: lc = length(c);
   % X       = inv(P'*P) for each of the acute tets [v j]
   % Y       = column sums of inv(P'*P) for each of these tets
   % bp      = boolean vector indicating if tet has block prop
   % bpdata  = column j contains [v j]'s rows as binary nrs
   % sre     = boolean vector indicating if tet has block prop
   %           and also the SRE prop
   % sredata = column j contains [v j]'s SRE data
   
   Lp    = RecAcute2(v,2,c,lc,X,Y,bp,bpdata,sre,sredata,N,n,k);
   
   % extend v with each of the acute candidates in c that have
   % both the block property and the SRE property, and for each
   % of the new simplices, update the data structures; continue
   % recursively until acute n-simplices have been found
   
   L     = [L,Lp];
end

