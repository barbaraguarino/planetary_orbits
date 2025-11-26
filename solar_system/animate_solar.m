function animate_solar(filename, n, planet_names, c_vet, sizes, show_zones, show_trails)

  if nargin < 6
      show_zones = true;
  end

  if nargin < 7
      show_trails = true;
  end

  % Leitura do arquivo binário
  full_path = [filename, '.bin'];
  fid = fopen(full_path, 'rb');
  if fid == -1
      error(['Erro ao abrir arquivo: ', full_path]);
      return;
  end
  data = fread(fid, 'double');
  fclose(fid);

  n_values_per_frame = 3 * n;
  n_frames = floor(length(data) / n_values_per_frame);

  if n_frames == 0
      warning('Arquivo de dados vazio ou corrompido.');
      return;
  end

  pos_data = reshape(data(1:(n_frames * n_values_per_frame)), [3, n, n_frames]);

  % --- Configuração da Figura ---

  h_fig = figure('Name', 'Simulação Sistema Solar', 'NumberTitle', 'off');

  % Definição dos limites do gráfico
  max_coord = 35;

  hold on;
  grid on;
  axis equal;
  xlim([-max_coord, max_coord]);
  ylim([-max_coord, max_coord]);
  zlim([-max_coord, max_coord]);
  xlabel('X (AU)');
  ylabel('Y (AU)');
  zlabel('Z (AU)');
  title('Simulação do Sistema Solar');

  % --- Configuração das Zonas ---

  zone_handles = [];
  zones_config = [];
  theta = [];

  if show_zones
      % As zonas são desenhadas relativas à posição inicial do Sol
      zones_config = struct(...
          'hot',  [0.0, 0.8, 1, 0, 0, 0.4], ...
          'hab',  [0.8, 1.8, 0, 1, 0, 0.4], ...
          'cold', [1.8, 40.0, 0, 1, 1, 0.3] ...
      );

      n_theta = 50;
      theta = linspace(0, 2*pi, n_theta);
      sun_pos_init = pos_data(:, 1, 1);

      zone_handles = draw_zones(zones_config, theta, sun_pos_init);
  end

  % --- Inicialização dos Objetos Gráficos ---

  points = cell(1, n);
  labels = cell(1, n);
  trails = cell(1, n);
  trail_length = 200;

  % Distância do nome ao planetas
  text_offset = max_coord * 0.001;

  for i = 1:n

      if iscell(c_vet)
          color_val = c_vet{i};
      else
          color_val = c_vet(i);
      end

      % Cria os pontos
      points{i} = scatter3(pos_data(1,i,1), pos_data(2,i,1), pos_data(3,i,1), ...
                           sizes(i), color_val, 'filled', ...
                           'MarkerEdgeColor', 'k', ...
                           'HitTest', 'off', ...
                           'PickableParts', 'none');

      % Cria os nomes
      pos_txt = pos_data(:,i,1);
      labels{i} = text(pos_txt(1)+text_offset, pos_txt(2)+text_offset, pos_txt(3)+text_offset, ...
                 planet_names{i}, 'FontSize', 10, 'Color', 'k', ...
                 'HorizontalAlignment', 'left', ...
                 'VerticalAlignment', 'bottom', ...
                 'HitTest', 'off', ...
                 'PickableParts', 'none');

      % Cria o rastro
      if show_trails
          trails{i} = plot3(NaN, NaN, NaN, '-', 'Color', color_val, 'LineWidth', 1.0, ...
                            'HitTest', 'off', 'PickableParts', 'none');
      end
  end

  % Ângulo inicial
  view(45, 30);

  % --- Loop de Animação ---

  disp('Iniciando animação...');

  skip_frame = 1;

  while ishandle(h_fig)
      for k = 1:skip_frame:n_frames
          if ~ishandle(h_fig), break; end

          sun_pos = pos_data(:, 1, k);

          % Atualiza posição das zonas
          if show_zones
              update_zones(zone_handles, zones_config, theta, sun_pos);
          end

          % Atualiza planetas
          for i = 1:n
              pos = pos_data(:, i, k);

              % Atualiza ponto
              set(points{i}, 'XData', pos(1), 'YData', pos(2), 'ZData', pos(3));

              % Atualiza texto
              new_txt_pos = [pos(1)+text_offset, pos(2)+text_offset, pos(3)+text_offset];
              set(labels{i}, 'Position', new_txt_pos);

              % Atualiza rastro
              if show_trails
                  start_idx = max(1, k - trail_length);
                  idx_range = start_idx:3:k;
                  if isempty(idx_range), idx_range = k; end

                  set(trails{i}, 'XData', squeeze(pos_data(1,i,idx_range)), ...
                                 'YData', squeeze(pos_data(2,i,idx_range)), ...
                                 'ZData', squeeze(pos_data(3,i,idx_range)));
              end
          end

          drawnow;

          pause(0.02);
      end

      break

  end

  if ishandle(h_fig), close(h_fig); end
  disp('Animação finalizada.');
end

% --- Funções Auxiliares ---

% Função para desenhar as zonas
function handles = draw_zones(zones, theta, center)
    handles = struct();
    fn = fieldnames(zones);
    for i = 1:numel(fn)
        z = zones.(fn{i});
        [R, T] = meshgrid([z(1), z(2)], theta);
        X = R .* cos(T) + center(1);
        Y = R .* sin(T) + center(2);
        Z = zeros(size(X)) + center(3);

        handles.(fn{i}) = surf(X, Y, Z, ...
            'FaceColor', [z(3) z(4) z(5)], ...
            'FaceAlpha', z(6), ...
            'EdgeColor', 'none', ...
            'HitTest', 'off', ...
            'PickableParts', 'none');
    end
end

% Funação para atualizar as zonas
function update_zones(handles, zones, theta, center)
    fn = fieldnames(zones);
    for i = 1:numel(fn)
        z = zones.(fn{i});
        [R, T] = meshgrid([z(1), z(2)], theta);
        set(handles.(fn{i}), ...
            'XData', R .* cos(T) + center(1), ...
            'YData', R .* sin(T) + center(2), ...
            'ZData', zeros(size(R)) + center(3));
    end
end
