function simulate_planetary_orbits(pos_vet, vel_vet, m_vet, n_steps, step_size, steps_between_save, G, filename)
  tic;
  starttime = time();
  n = length(m_vet);

  % Pré-calcula a matriz de produtos de massa
  M_matrix = G * (m_vet' * m_vet);

  fid = fopen([filename, '.bin'], 'wb');
  flog = fopen([filename, '.log'], 'w');

  % Implementação do Leapfrog
  a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n);
  vel_vet = vel_vet + a_vet * (step_size / 2.0);

  fprintf('Simulação em progresso:  0.00%% concluído.\r');

  for _t = 1:n_steps
    % Atualiza a posição para (t + step_size)
    % usando a velocidade de meio-passo
    pos_vet = pos_vet + vel_vet * step_size;

    % Calcula a aceleração na nova Posição (t + step_size)
    a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n);

    % Atualiza a velocidade de (t + step_size/2) para (t + 3*step_size/2)
    vel_vet = vel_vet + a_vet * step_size;

    % Salvar os dados
    if mod(_t, steps_between_save) == 0
      fwrite(fid, pos_vet, 'double');
      percent_done = (_t / n_steps) * 100;
      fprintf('Simulação em progresso: %.2f%% concluído.\r', percent_done);
    end
  end

  clc;
  fprintf('Simulação em progresso: 100.00%% concluído.\n');

  endtime = time();
  duration = endtime - starttime;

  % Escreve no arquivo de log
  fprintf(flog, ...
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
  );

  disp('Simulação finalizada. Dados salvos.');
  fclose(fid);
  fclose(flog);
  toc;
end

% Função de aceleração

function a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n)
    % Calcular matrizes de diferença de posição
    dx = pos_vet(1,:) - pos_vet(1,:)';
    dy = pos_vet(2,:) - pos_vet(2,:)';
    dz = pos_vet(3,:) - pos_vet(3,:)';

    d2 = dx.^2 + dy.^2 + dz.^2;

    inv_d3 = d2 .^ (-1.5);

    % Lida com a singularidade
    inv_d3(eye(n) == 1) = 0;

    % Calcular o termo de força comum
    F_term = M_matrix .* inv_d3;

    % Calcular a força total em cada corpo
    fx_total = sum(F_term .* dx, 2);
    fy_total = sum(F_term .* dy, 2);
    fz_total = sum(F_term .* dz, 2);

    f_vet = [fx_total, fy_total, fz_total]';

    % Aceleração
    a_vet = f_vet ./ m_vet;
end
