function simulate_planetary_orbits(pos_vet, vel_vet, m_vet, n_steps, step_size, steps_between_save, G, filename)
  n = length(m_vet);
  f_vet = zeros(2, n);
  a_vet = zeros(2, n);

  fid = fopen(filename, 'wb');

  n_iter = 0;

  for _t = 1:n_steps
    n_iter++;
    f_vet(:,:) = 0; %reseta a força

    for _i = 1:n
      for _j = _i+1:n
        r_vet = pos_vet(:,_j) - pos_vet(:,_i); %vetor distância
        d = norm(r_vet); %distância
        if d > 1e-12
          magnitude = (G * m_vet(_i)*m_vet(_j))/(d^2); %magnetude da força
          direction = r_vet / d; %direção da força
          f_vet(:,_i) += magnitude * direction;
          f_vet(:,_j) -= magnitude * direction;
        end
      end
    end

    a_vet = f_vet ./ m_vet; %aceleração dos corpos

    vel_vet = vel_vet + a_vet * step_size;
    pos_vet = pos_vet + vel_vet * step_size;

    if mod(_t, steps_between_save) == 0
      fwrite(fid, pos_vet, 'double');
    end
  end

  fclose(fid);

end
