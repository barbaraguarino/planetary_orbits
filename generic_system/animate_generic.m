function animate_generic(filename)

  if nargin < 2
      meta_file = [filename, '_meta.mat'];

      if exist(meta_file, 'file')
          disp('Carregando massas do arquivo de metadados...');
          loaded_data = load(meta_file);
          m_vet = loaded_data.mass;
      else
          error(['Erro: Massa não fornecida e arquivo de metadados não encontrado: ', meta_file]);
      end
  end

  % número de corpos
  n = length(m_vet);

  % ajuste de segurança para leitura
  full_path = [filename, '.bin'];

  % lê arquivo binário
  fid = fopen(full_path, 'rb');

  if fid == -1
      fid = fopen(filename, 'rb');
  end

  if fid == -1
      error(['Erro Crítico: Arquivo não encontrado: ', filename]);
  end

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
  xlabel('X (UA)');
  ylabel('Y (UA)');
  zlabel('Z (UA)');
  title('Simulação Planetária 3D');

  % Escala de tamanho baseada na massa
  min_size = 5;
  max_size = 20;
  min_mass = min(m_vet);
  max_mass = max(m_vet);

  % evita divisão por zero se todas as massas forem iguais
  if max_mass == min_mass
      marker_sizes = ones(1, n) * ((min_size + max_size) / 2);
  else
      marker_sizes = min_size + (m_vet - min_mass) / (max_mass - min_mass) * (max_size - min_size);
  end

  % cria pontos para cada corpo
  points = zeros(1, n);

  for i = 1:n

      if i == 1
          color = [1 1 0]; % corpo central (estrela)
          m_edge = [0 0 0]; % borda preta
      else
          color = [0 0 1]; % planetas
          m_edge = 'none';
      end

      points(i) = line(pos_data(1,i,1), pos_data(2,i,1), pos_data(3,i,1), ...
                         'Marker', 'o', ...
                         'LineStyle', 'none', ...
                         'MarkerSize', marker_sizes(i), ...
                         'MarkerFaceColor', color, ...
                         'MarkerEdgeColor', m_edge, ...
                         'HitTest', 'off', ...
                         'PickableParts', 'none');
  end

  % configura o ângulo da câmera
  view(45, 30);

  % loop de animação
  for k = 1:n_frames

      if ~ishandle(h_fig)
          break;
      end

      for i = 1:n
          set(points(i), 'XData', pos_data(1,i,k), ...
                         'YData', pos_data(2,i,k), ...
                         'ZData', pos_data(3,i,k));
      end

      drawnow;

  end
end
