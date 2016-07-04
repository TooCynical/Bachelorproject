function L = SortedAcute01Triang(n)
    % Return the minimal representatives of the n-dimensional acute 
    % triangles in lexicographical order.
    L = Acute01Triang(n);
    L = sortrows(L')';
end

