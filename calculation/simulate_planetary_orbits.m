function simulate_planetary_orbits(pos_vet, vel_vet, m_vet, G, n_steps, step_size, steps_between_save, filename)

  tic;
  starttime = time();

  n = length(m_vet);

  M_matrix = G * (m_vet' * m_vet);

  fid = fopen([filename, '.bin'], 'wb');

  if fid == -1
        error('Erro: Não foi possível criar o arquivo de saída.');
  end

  a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n);
  vel_vet = vel_vet + a_vet * (step_size / 2.0);

  fprintf('Simulação em progresso:  0.00%% concluído.\r');

  for _t = 1:n_steps
    pos_vet = pos_vet + vel_vet * step_size;
    a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n);
    vel_vet = vel_vet + a_vet * step_size;

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

  toc;

  fclose(fid);

  disp('Simulação finalizada. Dados salvos.');
end
