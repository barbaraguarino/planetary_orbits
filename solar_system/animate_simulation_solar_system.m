function animate_simulation(filename, m_vet, c_vet)
  % número de corpos
  n = length(m_vet);

  planet_names = {'Sol','Mercúrio','Vênus','Terra','Marte','Júpiter','Saturno','Urano','Netuno','Plutão'};

  % lê arquivo binário
  fid = fopen([filename, '.bin'], 'rb');
  data = fread(fid, 'double');
  fclose(fid);

  % reorganiza dados: 3 x n x n_frames
  n_values_per_frame = 3 * n;
  n_frames = floor(length(data) / n_values_per_frame);
  pos_data = reshape(data(1:(n_frames * n_values_per_frame)), [3, n, n_frames]);

  % limites do gráfico
  max_coord = max(abs(pos_data(:))) * 1.1;
  if max_coord == 0, max_coord = 1; end

  h_fig = figure;

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
  max_size = 100;
  min_mass = min(m_vet);
  max_mass = max(m_vet);

  % evita divisão por zero se todas as massas forem iguais
  if max_mass == min_mass
      sizes = ones(1, n) * ((min_size + max_size) / 2);
  else
      % mapeia linearmente a massa para o intervalo [min_size, max_size]
      sizes = min_size + (m_vet - min_mass) / (max_mass - min_mass) * (max_size - min_size);
  end

  r_inner = 0.95;
  r_outer = 1.37;

  theta = linspace(0, 2*pi, 100);
  [R, T] = meshgrid([r_inner r_outer], theta);
  X = R .* cos(T);
  Y = R .* sin(T);
  Z = zeros(size(X));

  surf(X, Y, Z, 'FaceColor', [0 1 0], 'FaceAlpha', 0.1, 'EdgeColor', 'none');

  % cria pontos para cada corpo
  points = cell(1, n);
  labels = cell(1, n);
  trails = cell(1, n);
  trail_length = 10;

  for i = 1:n
      color = c_vet(i);
      points{i} = scatter3(pos_data(1,i,1), pos_data(2,i,1), pos_data(3,i,1), ...
                           sizes(i), color, 'filled');

      offset = 0.5 * sizes(i) / max_coord;
      labels{i} = text(pos_data(1,i,1)+offset, pos_data(2,i,1)+offset, pos_data(3,i,1)+offset, ...
                 planet_names{i}, 'FontSize', 10, 'Color', 'k', 'HorizontalAlignment', 'center');

      trails{i} = plot3(NaN, NaN, NaN, '-', 'Color', c_vet(i));
  end

  % configura o ângulo da câmera
  view(45, 25);

  while ishandle(h_fig)
      for k = 1:n_frames
          if ~ishandle(h_fig)
              break;
          end

            clc;
            fprintf('Frame: %d / %d\n', k, n_frames);

          for i = 1:n
              set(points{i}, 'XData', pos_data(1,i,k), ...
                             'YData', pos_data(2,i,k), ...
                             'ZData', pos_data(3,i,k));

              set(labels{i}, 'Position', [pos_data(1,i,k)+offset, pos_data(2,i,k)+offset, pos_data(3,i,k)+offset]);

              start_idx = max(1, k - trail_length + 1);
              set(trails{i}, 'XData', squeeze(pos_data(1,i,start_idx:k)), ...
                             'YData', squeeze(pos_data(2,i,start_idx:k)), ...
                             'ZData', squeeze(pos_data(3,i,start_idx:k)));
          end

          drawnow expose;
          pause(0.02);

      end

  end

  disp('Animação interrompida (janela fechada).');
  close all;
  clear all;
end
