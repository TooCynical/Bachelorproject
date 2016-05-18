function S = Ehrlich(n)

a = 1:n; b = a; c = 0*a;
S = zeros(1,prod(2:n)-1);
t = 1;

while true
   k = 1;
   while c(k)==k
       c(k) = 0;
       k    = k+1;
   end
   if k==n
       break
   else
       c(k) = c(k)+1;
   end
   a([1,b(k)+1]) = a([b(k)+1,1]);
   S(t) = b(k)+1;
   t = t+1;
   j = 1;
   k = k-1;
   while j<k
       b([j k]) = b([k j]);
       j = j+1;
       k = k-1;
   end
end
S = [1,S];
