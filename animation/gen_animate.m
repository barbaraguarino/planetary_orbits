function gen_animate(filename, n, planet_names, c_vet, sizes, show_zones, show_trails)

  if nargin < 6, show_zones = true; end
  if nargin < 7, show_trails = true; end

  % --- Leitura dos Dados 2D ---
  full_path = [filename, '.bin'];
  fid = fopen(full_path, 'rb');
  if fid == -1, error('Erro ao abrir arquivo binário.'); end

  data = fread(fid, 'double');
  fclose(fid);

  % Importante: Agora são 2 coordenadas (x,y) por corpo
  n_values_per_frame = 2 * n;
  n_frames = floor(length(data) / n_values_per_frame);

  if n_frames == 0, warning('Sem dados.'); return; end

  % Reshape para [2, N, Frames]
  pos_data = reshape(data(1:(n_frames * n_values_per_frame)), [2, n, n_frames]);

  % --- Configuração da Figura ---
  h_fig = figure('Name', 'Simulação Solar 2D', 'Color', 'w');

  max_coord = 35; % Ajuste conforme necessário (Plutão ~39 AU)

  hold on; grid on; axis equal;
  xlim([-max_coord, max_coord]);
  ylim([-max_coord, max_coord]);
  xlabel('X (AU)'); ylabel('Y (AU)');
  title('Sistema Solar 2D');
  set(gca, 'Color', [0.05 0.05 0.1]); % Fundo escuro para contraste

  % --- Zonas (Círculos) ---
  zone_handles = [];
  if show_zones
     % Desenha círculos preenchidos
     theta = linspace(0, 2*pi, 100);
     % Zonas: raio_min, raio_max, r, g, b, alpha
     zones = [0.0, 0.8,  1, 0, 0, 0.2;   % Hot
              0.8, 1.8,  0, 1, 0, 0.2;   % Habitable
              1.8, 40.0, 0, 1, 1, 0.1];  % Cold

     for z = 1:size(zones, 1)
         r_inner = zones(z, 1);
         r_outer = zones(z, 2);
         color = zones(z, 3:5);
         alpha = zones(z, 6);

         % Cria anel usando fill
         x_ring = [r_inner*cos(theta), fliplr(r_outer*cos(theta))];
         y_ring = [r_inner*sin(theta), fliplr(r_outer*sin(theta))];

         zone_handles(z) = fill(x_ring, y_ring, color, ...
             'FaceAlpha', alpha, 'EdgeColor', 'none');
     end
  end

  % --- Objetos Gráficos ---
  points = cell(1, n);
  labels = cell(1, n);
  trails = cell(1, n);
  trail_len = 150;

  for i = 1:n
      color_val = c_vet{i};
      if ~ischar(color_val) && length(color_val) > 3
          color_val = color_val(1:3); % Proteção
      end

      % Rastro
      if show_trails
          trails{i} = plot(NaN, NaN, '-', 'Color', color_val, 'LineWidth', 1);
      end

      % Planeta (Scatter 2D)
      points{i} = scatter(pos_data(1,i,1), pos_data(2,i,1), ...
          sizes(i), color_val, 'filled', 'MarkerEdgeColor', 'w');

      % Nome
      labels{i} = text(pos_data(1,i,1), pos_data(2,i,1), ['  ' planet_names{i}], ...
          'Color', 'w', 'FontSize', 9);
  end

  % --- Loop de Animação ---
  disp('Animando...');
  skip = 2; % Pula frames para acelerar visualização

  for k = 1:skip:n_frames
      if ~ishandle(h_fig), break; end

      % O Sol é o índice 1. Se quisermos centralizar no Sol:
      % sun_pos = pos_data(:, 1, k);
      % Mas as zonas são fixas na origem (0,0) neste código simplificado.

      for i = 1:n
          pos = pos_data(:, i, k);

          % Atualiza Planeta
          set(points{i}, 'XData', pos(1), 'YData', pos(2));

          % Atualiza Texto
          set(labels{i}, 'Position', [pos(1), pos(2), 0]);

          % Atualiza Rastro
          if show_trails
              idx_start = max(1, k - trail_len);
              % Acessa histórico [2, 1, Frames] -> squeeze -> [2, Frames] -> transposta -> [Frames, 2]
              hist = pos_data(:, i, idx_start:skip:k);
              set(trails{i}, 'XData', hist(1,:), 'YData', hist(2,:));
          end
      end

      drawnow limitrate;
      pause(0.01);
  end
  disp('Fim.');
end
