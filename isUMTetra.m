function b = isUMTetra(m, n)
	M = to01(m, n);
	if check_gram_ultrametric(M)==1
		b = is_minimal_um_tetra(m ,n);
        return
	end
	b = 0;

	