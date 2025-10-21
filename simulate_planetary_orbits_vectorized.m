function simulate_planetary_orbits_vectorized(pos_vet, vel_vet, m_vet, n_steps, step_size, steps_between_save, G, filename)
  tic

  n = length(m_vet);
  f_vet = zeros(3, n);
  a_vet = zeros(3, n);

  fid = fopen(filename, 'wb');

  n_iter = 0;

  for _t = 1:n_steps
    n_iter++;
    f_vet(:,:) = 0; %reseta a força

    %distancias em cada eixo
    dx = pos_vet(1,:) - pos_vet(1,:)';
    dy = pos_vet(2,:) - pos_vet(2,:)';
    dz = pos_vet(3,:) - pos_vet(3,:)';

    %matriz distancia ao quadrado
    d2 = dx.^2 + dy.^2 + dz.^2;

    %matriz distância
    d = sqrt(d2);
    d(d < 1e-12) = Inf;

    F = G * (m_vet' * m_vet) ./ d2; % matriz de magnitudes
    F(eye(n) == 1) = 0; % zerar a diagonal principal (i não exerce força sobre i)

    %forças em cada eixo
    fx = F .* dx ./ d;
    fy = F .* dy ./ d;
    fz = F .* dz ./ d;

    f_vet = [sum(fx, 2)'; sum(fy, 2)'; sum(fz, 2)'];

    a_vet = f_vet ./ m_vet; %aceleração dos corpos

    %parte do euler
    vel_vet = vel_vet + a_vet * step_size;
    pos_vet = pos_vet + vel_vet * step_size;

    if mod(_t, steps_between_save) == 0
      fwrite(fid, pos_vet, 'double');
    end
  end

  fclose(fid);

  toc
end
