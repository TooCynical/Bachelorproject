function N = MakeN(n)

N = zeros(n,2^n-1);
for i=1:2^n-1
  p = bitand(i,2.^(0:n-1))&1:n;
  N(:,i) = p';
end
