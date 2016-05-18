function [c,lc,X,Y,bp,bpdata,sre,sredata] = InitDataStructs(v,N,n)

P  = N(:,v);
lc = 0;
Pt = P';
Z  = inv(Pt*P);

for j = v(2)+1:2^n-1  % these are all candidate acute neighbours
   p = N(:,j);
   b = Pt*p;
   h = Z*b;
   
   % the inverse of [P,p]'*[P,p] is now [ Z + h s h*    - h s ]
   %                                    [     - s h*        s ]
   %
   % where s = 1/d >= 0 with d = p'*p - b*h = sum(p)-b'*h
   %
   % hence we compute this d and verify its positivity

   d = sum(p)-b'*h;
   if abs(d)>1e-12
       s = 1/d;     % and now we can compute the entry s
       f = -s*h;    % and the rest of the last row/column
       if max(f)<-1e-12        % verify its off-diag negativity ...
          if sum(f)+s>1e-12    % and if last column sums to positive
              A = Z-f*h';         % and only *then* compute the rest!
              if min(sum(A)+f')>1e-12  % verify positive column sums ...
                  if sum(sum(A<-1e-12))==2 % and off-diag negativity
                     c(lc+1) = j;            % if acute, add j to list
                     B       = [A,f;f',s];   % and also the other data
                     X{lc+1} = B;
                     Y{lc+1} = B*[1;1;1];
                     lc      = lc+1;
                  end
              end
          end
       end
   end
end

bp     = zeros(1,lc);
bpdata = zeros(n,lc);
y      = P*[4;2];       % get binary values of rows of P

for i=1:lc
    z = y + N(:,c(i));  % and for each acute additional vertex, update
    if all(diff(z)<=0)
        bp(i)       = 1;
        bpdata(:,i) = z;
    end
end

sre     = zeros(1,lc);
sredata = zeros(7,lc);

x1 = sum(P(:,1));
x2 = sum(P(x1+1:end,2));
z  = [1;1+x1;1+x1+x2;n+1];

for i=1:lc
   if bp(i)
       p      = N(:,c(i));
       s1     = sum(p(1+x1:n));
       if s1 >= x2
           s2 = s1 + sum(p(1:x1));
           if s2 >= x1
               sre(i)       = 1;
               x            = [x1;x2;sum(p(z(3):n))];
               sredata(:,i) = [x;z];
           end
       end
   end
end

                     


    
        
        