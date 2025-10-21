function animate_simulation(filename, m_vet)
  % número de corpos
  n = length(m_vet);

  % lê arquivo binário
  fid = fopen(filename, 'rb');
  data = fread(fid, 'double');
  fclose(fid);

  % reorganiza dados: 3 x n x n_frames
  n_values_per_frame = 3 * n;
  n_frames = floor(length(data) / n_values_per_frame);
  pos_data = reshape(data(1:(n_frames * n_values_per_frame)), [3, n, n_frames]);

  % limites do gráfico
  max_coord = max(abs(pos_data(:))) * 1.1;
  if max_coord == 0, max_coord = 1; end

  figure;
  hold on;
  grid on;
  axis equal;
  xlim([-max_coord, max_coord]);
  ylim([-max_coord, max_coord]);
  zlim([-max_coord, max_coord]);
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
  title('Simulação Planetária 3D');

  % === Escala de tamanho baseada na massa ===
  min_size = 20;
  max_size = 500;
  min_mass = min(m_vet);
  max_mass = max(m_vet);

  % evita divisão por zero se todas as massas forem iguais
  if max_mass == min_mass
      sizes = ones(1, n) * ((min_size + max_size) / 2);
  else
      % mapeia linearmente a massa para o intervalo [min_size, max_size]
      sizes = min_size + (m_vet - min_mass) / (max_mass - min_mass) * (max_size - min_size);
  end

  % cria pontos para cada corpo
  points = cell(1, n);
  for i = 1:n
      if i == 1
          color = 'y'; % corpo central (estrela)
      else
          color = 'b'; % planetas
      end
      points{i} = scatter3(pos_data(1,i,1), pos_data(2,i,1), pos_data(3,i,1), ...
                           sizes(i), color, 'filled');


  end

  % configura o ângulo da câmera
  view(45, 25);

  % loop de animação
  for k = 1:n_frames
      for i = 1:n
          set(points{i}, 'XData', pos_data(1,i,k), ...
                         'YData', pos_data(2,i,k), ...
                         'ZData', pos_data(3,i,k));

      end
      drawnow;
      pause(0.02);
  end
end
