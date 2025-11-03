function simulate_planetary_orbits_vectorized(pos_vet, vel_vet, m_vet, n_steps, step_size, steps_between_save, G, filename)
  tic

  starttime = mktime (localtime (time ()));

  n = length(m_vet);
  f_vet = zeros(3, n);
  a_vet = zeros(3, n);

  fid = fopen([filename, '.bin'], 'wb');
  flog = fopen([filename, '.log'], 'w');

  n_iter = 0;

  clc;
  fprintf('Iniciando simulação...\n');

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
      clc;
      percent_done = (_t / n_steps) * 100;
      fprintf('Simulação em progresso: %.2f%% concluído.\n', percent_done);
    end
  end

  clc;

  fprintf('Simulação em progresso: 100.00%% concluído.\n');

  endtime = mktime(localtime(time()));
  duration = endtime - starttime;

  fwrite(flog, sprintf( ...
    'Dados da Execução\nFilename: (%s.bin) \nExecução (s): %f\nSteps: %d\nStep Size: %f\nSteps Between Save: %d\nG: %e\nMassas: %s\nPosições (X;Y;Z): %s\nVelocidades (VX;VY;VZ): %s\n', ...
    filename, ...
    duration, ...
    n_steps, ...
    step_size, ...
    steps_between_save, ...
    G, ...
    mat2str(m_vet), ...
    mat2str(pos_vet), ...
    mat2str(vel_vet) ...
  ));


  disp('Simulação finalizada. Dados salvos.');

  fclose(fid);
  fclose(flog);

  toc
end
