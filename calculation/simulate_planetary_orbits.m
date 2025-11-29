function simulate_planetary_orbits(pos_vet, vel_vet, m_vet, G, n_steps, step_size, steps_between_save, filename)

  tic;
  n = length(m_vet);

  % Matriz de Massas para Força: G * mi * mj
  M_matrix = G * (m_vet' * m_vet);

  fid = fopen([filename, '.bin'], 'wb');
  if fid == -1, error('Erro ao criar arquivo.'); end

  % Aceleração Inicial
  a_vet = calculate_acceleration_2d(pos_vet, m_vet, M_matrix, n);

  % Leapfrog: Avança V para t = 0.5*dt
  vel_vet = vel_vet + a_vet * (step_size / 2.0);

  fprintf('Simulação 2D em progresso...\n');

  for t = 1:n_steps
    % 1. Posição (Drift)
    pos_vet = pos_vet + vel_vet * step_size;

    % 2. Aceleração (Kick)
    a_vet = calculate_acceleration_2d(pos_vet, m_vet, M_matrix, n);

    % 3. Velocidade (Drift)
    vel_vet = vel_vet + a_vet * step_size;

    % Salvar
    if mod(t, steps_between_save) == 0
      fwrite(fid, pos_vet, 'double');
    end
  end

  toc;
  fclose(fid);
  disp('Dados salvos.');
end
