function gen_animate(filename, n, planet_names, c_vet, sizes, show_zones, show_trails)

  if nargin < 6
      show_zones = true;
  end

  if nargin < 7
      show_trails = true;
  end

  full_path = [filename, '.bin'];
  fid = fopen(full_path, 'rb');

  if fid == -1
      error(['Erro ao abrir arquivo: ', full_path]);
      return;
  end

  data = fread(fid, 'double');
  fclose(fid);

  n_values_per_frame = 2 * n;
  n_frames = floor(length(data) / n_values_per_frame);

  if n_frames == 0
    warning('Sem dados.');
    return;
  end

  pos_data = reshape(data(1:(n_frames * n_values_per_frame)), [2, n, n_frames]);

  h_fig = figure('Name', 'Simulação Sistema Solar (2D)', 'NumberTitle', 'off');

  max_coord = 35;

  hold on;
  grid on;
  axis equal;

  xlim([-max_coord, max_coord]);
  ylim([-max_coord, max_coord]);

  xlabel('X (AU)');
  ylabel('Y (AU)');

  title('Simulação do Sistema Solar');

  zone_handles = [];
  zones_config = [];
  theta = [];

  % --- Configuração das Zonas ---
  if show_zones
      zones_config = struct(...
          'hot',  [0.0, 0.8, 1, 0, 0, 0.4], ...
          'hab',  [0.8, 1.8, 0, 1, 0, 0.4], ...
          'cold', [1.8, 40.0, 0, 1, 1, 0.3] ...
      );

      n_theta = 100;
      theta = linspace(0, 2*pi, n_theta);
      sun_pos_init = pos_data(:, 1, 1);

      zone_handles = draw_zones(zones_config, theta, sun_pos_init);
  end

  points = cell(1, n);
  labels = cell(1, n);
  trails = cell(1, n);
  trail_length = 200;

  text_offset = max_coord * 0.001;

  for i = 1:n

      if iscell(c_vet)
          color_val = c_vet{i};
      else
          color_val = c_vet(i);
      end

      points{i} = scatter(pos_data(1,i,1), pos_data(2,i,1), ...
                           sizes(i), color_val, 'filled', ...
                           'MarkerEdgeColor', 'k', ...
                           'HitTest', 'off', ...
                           'PickableParts', 'none');

      pos_txt = pos_data(:,i,1);
      labels{i} = text(pos_txt(1)+text_offset, pos_txt(2)+text_offset, ...
                 planet_names{i}, 'FontSize', 10, 'Color', 'k', ...
                 'HorizontalAlignment', 'left', ...
                 'VerticalAlignment', 'bottom', ...
                 'HitTest', 'off', ...
                 'PickableParts', 'none');

      if show_trails
          trails{i} = plot(NaN, NaN, '-', 'Color', color_val, 'LineWidth', 1.0, ...
                           'HitTest', 'off', 'PickableParts', 'none');
      end
  end

  disp('Iniciando animação...');

  skip_frame = 1; % Pode aumentar se estiver lento (ex: 5)

  while ishandle(h_fig)
      for k = 1:skip_frame:n_frames
          if ~ishandle(h_fig), break; end

          sun_pos = pos_data(:, 1, k);

          % Atualiza zonas
          if show_zones
              update_zones(zone_handles, zones_config, theta, sun_pos);
          end

          % Atualiza planetas
          for i = 1:n
              pos = pos_data(:, i, k); % Vetor 2x1 (X, Y)

              set(points{i}, 'XData', pos(1), 'YData', pos(2));

              new_txt_pos = [pos(1)+text_offset, pos(2)+text_offset, 0];
              set(labels{i}, 'Position', new_txt_pos);

              if show_trails
                  start_idx = max(1, k - trail_length);
                  idx_range = start_idx:3:k;
                  if isempty(idx_range), idx_range = k; end

                  set(trails{i}, 'XData', squeeze(pos_data(1,i,idx_range)), ...
                                 'YData', squeeze(pos_data(2,i,idx_range)));
              end
          end

          drawnow;
          pause(0.01);
      end
      break;
  end

  if ishandle(h_fig)
    close(h_fig);
  end

  disp('Animação finalizada.');

end
