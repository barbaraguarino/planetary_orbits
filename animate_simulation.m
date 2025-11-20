function animate_simulation(filename, m_vet, c_vet)
  n = length(m_vet);
  planet_names = {'Sol','Mercúrio','Vênus','Terra','Marte','Júpiter','Saturno','Urano','Netuno','Plutão'};

  % Leitura dos dados
  fid = fopen([filename, '.bin'], 'rb');
  if fid == -1, error("Arquivo..."), return; end
  data = fread(fid, 'double');
  fclose(fid);

  n_values_per_frame = 3 * n;
  n_frames = floor(length(data) / n_values_per_frame);

  if n_frames == 0, error("Arquivo..."), return; end

  pos_data = reshape(data(1:(n_frames * n_values_per_frame)), [3, n, n_frames]);

  % Configuração inicial da figura
  max_coord = 30;
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

  % Escala de tamanho baseada na massa
  min_size = 40; max_size = 200;
  min_mass = min(m_vet); max_mass = max(m_vet);

  if max_mass == min_mass
      sizes = ones(1, n) * ((min_size + max_size) / 2);
  else
      sizes = min_size + (m_vet - min_mass) / (max_mass - min_mass) * (max_size - min_size);
  end

  % Zonas (Quente, Fria e Habitável)

  % Definição dos raios (em AU)
  r_hot_inner = 0.0;
  r_hot_outer = 0.8;

  r_hab_inner = 0.8;
  r_hab_outer = 1.8;

  r_cold_inner = 1.8;
  r_cold_outer = 40.0;

  % Criação da malha para os anéis
  n_theta_steps = 50;
  theta = linspace(0, 2*pi, n_theta_steps);

  % Malha da Zona Quente
  [R_hot, T_hot] = meshgrid([r_hot_inner, r_hot_outer], theta);
  X_hot_mesh = R_hot .* cos(T_hot);
  Y_hot_mesh = R_hot .* sin(T_hot);
  Z_hot_mesh = zeros(size(X_hot_mesh));

  % Malha da Zona Habitável
  [R_hab, T_hab] = meshgrid([r_hab_inner, r_hab_outer], theta);
  X_hab_mesh = R_hab .* cos(T_hab);
  Y_hab_mesh = R_hab .* sin(T_hab);
  Z_hab_mesh = zeros(size(X_hab_mesh));

  % Malha da Zona Fria
  [R_cold, T_cold] = meshgrid([r_cold_inner, r_cold_outer], theta);
  X_cold_mesh = R_cold .* cos(T_cold);
  Y_cold_mesh = R_cold .* sin(T_cold);
  Z_cold_mesh = zeros(size(X_cold_mesh));

  % Desenha os anéis na Posição Inicial do Sol
  sun_pos_initial = pos_data(:, 1, 1);

  h_zone_hot = surf(X_hot_mesh + sun_pos_initial(1), Y_hot_mesh + sun_pos_initial(2), Z_hot_mesh + sun_pos_initial(3), ...
      'FaceColor', 'r', 'FaceAlpha', 0.4, 'EdgeColor', 'none');

  h_zone_hab = surf(X_hab_mesh + sun_pos_initial(1), Y_hab_mesh + sun_pos_initial(2), Z_hab_mesh + sun_pos_initial(3), ...
      'FaceColor', 'g', 'FaceAlpha', 0.4, 'EdgeColor', 'none');

  h_zone_cold = surf(X_cold_mesh + sun_pos_initial(1), Y_cold_mesh + sun_pos_initial(2), Z_cold_mesh + sun_pos_initial(3), ...
      'FaceColor', 'c', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

  % Criação dos Planetas e Rastros

  points = cell(1, n);
  labels = cell(1, n);
  trails = cell(1, n);
  trail_length = 200;

  for i = 1:n
      color = c_vet(i);
      points{i} = scatter3(pos_data(1,i,1), pos_data(2,i,1), pos_data(3,i,1), ...
                           sizes(i), color, 'filled');

      offset = 1.0 * sizes(i) / max_coord;

      labels{i} = text(pos_data(1,i,1)+offset, pos_data(2,i,1)+offset, pos_data(3,i,1)+offset, ...
                 planet_names{i}, 'FontSize', 10, 'Color', 'k', 'HorizontalAlignment', 'center');

      trails{i} = plot3(NaN, NaN, NaN, '-', 'Color', c_vet(i));
  end

  view(45, 25); % Posição de visualização

  % Loop da animação

  while ishandle(h_fig)
      for k = 1:n_frames
          if ~ishandle(h_fig), break; end

          % Atualização das posições das Zonas de acordo com o sol
          sun_pos_current = pos_data(:, 1, k);

          set(h_zone_hot, 'XData', X_hot_mesh + sun_pos_current(1), ...
                           'YData', Y_hot_mesh + sun_pos_current(2), ...
                           'ZData', Z_hot_mesh + sun_pos_current(3));

          set(h_zone_hab, 'XData', X_hab_mesh + sun_pos_current(1), ...
                           'YData', Y_hab_mesh + sun_pos_current(2), ...
                           'ZData', Z_hab_mesh + sun_pos_current(3));

          set(h_zone_cold, 'XData', X_cold_mesh + sun_pos_current(1), ...
                           'YData', Y_cold_mesh + sun_pos_current(2), ...
                           'ZData', Z_cold_mesh + sun_pos_current(3));

          % Atualização dos planetas e rastros

          for i = 1:n
              current_pos = pos_data(:, i, k);

              set(points{i}, 'XData', current_pos(1), ...
                             'YData', current_pos(2), ...
                             'ZData', current_pos(3));

              set(labels{i}, 'Position', [current_pos(1)+offset, current_pos(2)+offset, current_pos(3)+offset]);

              start_idx = max(1, k - trail_length + 1);

              set(trails{i}, 'XData', squeeze(pos_data(1,i,start_idx:k)), ...
                             'YData', squeeze(pos_data(2,i,start_idx:k)), ...
                             'ZData', squeeze(pos_data(3,i,start_idx:k)));
          end

          drawnow expose;
          pause(0.01);
      end
  end

  disp('Animação interrompida.');
end
