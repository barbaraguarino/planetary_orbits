function simulate_planetary_orbits(pos_vet, vel_vet, m_vet, G, n_steps, step_size, steps_between_save, filename)

  % --- Configuração Inicial ---

  tic;
  starttime = time();

  n = length(m_vet);

  % Pré-calcula da Matriz de Massas
  M_matrix = G * (m_vet' * m_vet);

  fid = fopen([filename, '.bin'], 'wb');
  flog = fopen([filename, '.log'], 'w');

  if fid == -1 || fid == -1
        error('Erro: Não foi possível criar os arquivos de saída.');
  end

  % --- Integrador Leapfrog ---

  % O método Leapfro conserva energia melhor que outros.
  % Ele exige que a velociade estaja desfasada da posição por meio passo. (dt/2)

  % Calculo da aceleração inicial baseada na posição t=0
  a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n);

  % Avança a velocidade para t = 0.5 * dt
  vel_vet = vel_vet + a_vet * (step_size / 2.0);

  fprintf('Simulação em progresso:  0.00%% concluído.\r');

  % --- Loop Principal da Simulação ---

  for _t = 1:n_steps

    % Atualiza a posição
    % Move o corpo usando a velocidade que está no "meio" do intervalo.
    pos_vet = pos_vet + vel_vet * step_size;

    % Calcula nova aceleração
    % Depois de mover o corpo, a gravidade muda.
    a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n);

    % Atualiza a velocidade
    % Atualiza a velociade para o próximo meio-passo.
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

  toc;

  % --- Escreve no Arquivo de Log ---

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

  fclose(fid);
  fclose(flog);

  disp('Simulação finalizada. Dados salvos.');
end

% --- Função de Aceleração ---

% Calcula a aceleração gravitacional de todos os corpos.
function a_vet = calculate_acceleration(pos_vet, m_vet, M_matrix, n)

    % Matrizes de Distância
    % Calcula a distância de "todos para todos" simultaneamente.
    dx = pos_vet(1,:) - pos_vet(1,:)';
    dy = pos_vet(2,:) - pos_vet(2,:)';
    dz = pos_vet(3,:) - pos_vet(3,:)';

    % Distância ao Quadrado
    d2 = dx.^2 + dy.^2 + dz.^2;

    % --- Lei da Gravitação Universa ---
    % A força é proporcional a 1/r^2. A aceleração vetorial precisa de 1/r^3.
    inv_d3 = d2 .^ (-1.5);

    % Correção de Singularidade:
    % A distância de um corpo para ele mesmo é 0. Isso daria divisão por zero.
    inv_d3(eye(n) == 1) = 0;

    % --- Cálculo da Força Total ---
    % Combina as massas com a distância inversa.
    F_term = M_matrix .* inv_d3;

    % Somatŕoio das Forças
    % Soma todas as forças que atuam em cada corpo (linhas).
    fx_total = sum(F_term .* dx, 2);
    fy_total = sum(F_term .* dy, 2);
    fz_total = sum(F_term .* dz, 2);

    % Monta o vetor de forças
    f_vet = [fx_total, fy_total, fz_total]';

    % --- Segunda Lei de Newton ---
    % a = F/m
    a_vet = f_vet ./ m_vet;
end
