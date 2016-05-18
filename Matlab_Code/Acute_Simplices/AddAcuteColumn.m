function [z,X,Y] = AddAcuteColumn(P,lw,X,Y,p)

% Given P acute and lw its number of columns
% and X = inv(P'*P) and Y = inv(P'*P)*e, see
% if [P,p] is acute and if so, set z=1 and
% update X and Y for the new acute [P,p]

z  = 0;
b  = P'*p;
h  = X*b;

% X equals inv(P*P) and we want to update it
% into the inverse of [P p]*[P p]
%
% the new inverse is [ X + h s h*    - h s ]
%                    [       s h*        s ]
%
% where s = 1/d >0 with d = p*p - b*h

% check if h > 0 and if sh := 1 - sum(h) > 0

qq = 1;
sh = 1;

for j=1:lw 
    sh = sh-h(j);
    if h(j)<=1e-12 || sh<=1e-12
        qq = 0;
        break
    end
end

% if h positive and sums to less than one ... 

if qq == 1
    d  = sum(p)-b'*h;           % if d==0 then [P,p] singular
    if abs(d)>1e-12
         s  = 1/d; 
         Y  = Y - sh*s*h;
         if all(Y>1e-12)
             X  = X+h*s*h';
             % now check if upper triangle X is negative
             qq = 1;
             for i=1:lw
                 for j=i+1:lw
                     if X(i,j)>-1e-12
                         qq = 0;
                         break
                     end
                 end
                 if qq==0
                     break
                 end
             end
             % if upper triangle X is negative ...
             if qq==1
                 z = 1;
                 c = -h*s;
                 X = [X c ; c' s];
                 Y = [Y ; sh*s];
              end
         end
     end
end