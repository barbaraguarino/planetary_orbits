function a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n)

    dx = pos_vet(1,:) - pos_vet(1,:)';
    dy = pos_vet(2,:) - pos_vet(2,:)';

    d2 = dx.^2 + dy.^2;

    inv_d3 = d2 .^ (-1.5);

    inv_d3(eye(n)==1) = 0;

    F_term = M_matrix .* inv_d3;

    fx = sum(F_term .* dx, 2);
    fy = sum(F_term .* dy, 2);

    f_vet = [fx, fy]';
    a_vet = f_vet ./ m_vet;
end
