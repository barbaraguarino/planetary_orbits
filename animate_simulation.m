function animate_simulation(filename, m_vet)
  % número de corpos
  n = length(m_vet);

  % lê arquivo binário
  fid = fopen(filename, 'rb');
  data = fread(fid, 'double');
  fclose(fid);

  % reorganiza dados: 2 x n x n_frames
  n_values_per_frame = 2 * n;
  n_frames = floor(length(data) / n_values_per_frame);
  pos_data = reshape(data(1:(n_frames*n_values_per_frame)), [2, n, n_frames]);

  % limites fixos do gráfico
  max_coord = max(abs(pos_data(:))) * 1.1;
  if max_coord == 0, max_coord = 1; end

  figure;
  axis equal;
  xlim([-max_coord, max_coord]);
  ylim([-max_coord, max_coord]);
  hold on;

  % cria círculos para cada corpo
  circles = cell(1, n);  % vetor de handles
  for i = 1:n
      r = sqrt(m_vet(i))/2; % raio proporcional à massa
      x = pos_data(1,i,1) - r;
      y = pos_data(2,i,1) - r;

      if i == 1
          color = 'y'; % corpo central
      else
          color = 'b'; % planetas
      end

      circles{i} = rectangle('Position', [x, y, 2*r, 2*r], ...
                             'Curvature', [1 1], ...
                             'FaceColor', color);
  end

  % loop de animação: atualiza apenas posições dos objetos
  for k = 1:n_frames
      for i = 1:n
          r = sqrt(m_vet(i))/2;
          x = pos_data(1,i,k) - r;
          y = pos_data(2,i,k) - r;
          set(circles{i}, 'Position', [x, y, 2*r, 2*r]);
      end
      drawnow;
      pause(0.02);  % controla velocidade
  end
end

