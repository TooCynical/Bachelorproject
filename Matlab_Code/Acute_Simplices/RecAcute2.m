function L = RecAcute2(v,lv,c,lc,X,Y,bp,bpdata,sre,sredata,N,n,k)

L = [];

if lv==k-1 && lc>0          % end the recursion if v is a (k-1) simplex;
    L = [v*ones(1,lc);c];   % add all acute neighbors from c, and return
else                        % in case v is not yet a (k-1)-simplex
    for i = 1:lc            % we will extend it with all vertices in c
        if bp(i) && sre(i)  % that have the block- and SRE-property ...
            w  = [v;c(i)];  % this is a new acute simplex as vertex vector
            P  = N(:,w);    % and this is its 0/1-matrix P
            t  = 0;         % t counts the amount of acute neighbors of P
            cn = [];
            for j = i+1:lc  % now we check which vertices in c are acute
                p = N(:,c(j));  % neigbors of the new 0/1 simplex P
                [z,nX,nY] = AddAcuteColumn(P,lv+1,X{i},Y{i},p);
                
                % this function adds a vertex p to P and verifies acuteness
                % using X = inv(P'*P) and its column sums Y; 
                % if z=1 then [P,p] is acute and nX and nY are the new data
                % for the extended simplex
                
                if z==1 
                   % if [P p] is acute we will assemble all its data in
                   % new variables cn,Xn,Yn,bpn,bpndata,sren,srendata
                   % that belong to [P p]
                   t             = t+1;
                   cn(t)         = c(j); % acute neighbors ...
                   Xn{t}         = nX;   % inv([P p]'*[P p]) ...
                   Yn{t}         = nY;   % and its column sums
                   zx            = 2*bpdata(:,i)+p; % new row binaries
                   bpn(t)        = all(diff(zx)<=0); % check block prop
                   bpndata(:,t)  = zx;   % new row binaries
                   sren(t)       = 0;    % initiate new SRE variables
                   srendata(:,t) = zeros(size(sredata,1)+2,1);
                   
                   if bpn(t) % only if [P p] has block property ...
                       [val,data]  = TestSRE(p,sredata(:,i));
                       sren(t)   = val; % val is boolean for SRE
                       if val  % only if SRE, then store the data
                           srendata(:,t) = data;
                       end
                   end
                   % done with [P p] / w and with all its data
                end
            end
            if t > 0  % if v has indeed acute neighbors w with all data
                      % available, we continue recursively with w = [v,j]
              K  = RecAcute2(w,lv+1,cn,t,Xn,Yn,bpn,bpndata,sren,srendata,N,n,k);
              L  = [L,K]; 
            end
        end
    end
end
