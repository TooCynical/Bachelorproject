function [sre,newsredata] = TestSRE(p,sredata)

k   = length(sredata)-1;
k   = k/2;
x   = sredata(1:k);
z   = sredata(k+1:end);
sre = 1;
s   = 0;

for j = k:-1:1
   s = s + sum(p(z(j):z(j+1)-1));
   if s < x(j)
       sre = 0;
       break
   end
end 

newsredata = [];

if sre==1
    xn = sum(p(z(k)+x(k):z(k+1)-1));
    newsredata = [x;xn;z(1:k);z(k)+x(k);z(k+1)];
end
