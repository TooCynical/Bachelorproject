 function L = Acute01Triang(n)

K = [];

for a=0:n-3
    for b=a:n-3
        for c=b:n-3
            if a+b+c <= n-3
               K = [K; a b c];
            end
        end
    end
end

K = K+ones(size(K));
L = [];

for v=K'
    x = 2^(v(1)+v(2))-1;
    y = 2^v(1)-1;
    z = (2^v(3)-1)*2^(v(1)+v(2));
    L = [L,[x;y+z]];
end
