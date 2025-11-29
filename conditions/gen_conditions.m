function [sys] = gen_conditions()

    % Distância : Unidade Astronômicas
    % Tempo     : Anos Terrestres
    % Massa     : Massa Solar

    %% --- Configuração e Constantes ---

    % Constante gravitacional ajustada
    sys.G = 4 * pi^2;

    % Nome, Massa, Raio Orbital (AU), Inclinacao , Cor, Tamanho Visual
    planet_data = {
        'Sol',      1.0,         0,         0.00,  'y',           250;
        'Mercúrio', 1.6601e-7,   0.387098,  7.00,  [0.5 0.5 0.5], 15;
        'Vênus',    2.4478e-6,   0.723332,  3.39,  [0.8 0.6 0.2], 25;
        'Terra',    3.0035e-6,   1.000000,  0.00,  'b',           25;
        'Marte',    3.2272e-7,   1.523679,  1.85,  'r',           15;
        'Júpiter',  9.5458e-4,   5.204267,  1.30,  [0.8 0.5 0.2], 100;
        'Saturno',  2.8581e-4,   9.582000, 2.49,  [0.9 0.8 0.6], 80;
        'Urano',    4.3641e-5,   19.29000, 0.77,  'c',           40;
        'Netuno',   5.1497e-5,   30.100000, 1.77,  'b',           40;
        'Plutão',   6.556e-9,    39.480000, 17.16, [0.6 0.4 0.4], 10;
    };

    % Extração dos dados para vetores
    names  = planet_data(:, 1)';
    mass   = [planet_data{:, 2}];
    radii  = [planet_data{:, 3}];
    incl   = [planet_data{:, 4}];
    colors = planet_data(:, 5)';
    sizes  = [planet_data{:, 6}];

    n = length(mass);

    %% --- Inicialização dos Vetores de Estado ---

    pos = zeros(3, n);
    vel = zeros(3, n);

    % Ângulos aleatórios para posição inicial na órbita.
    theta = rand(1, n) * 2 * pi;
    theta(1) = 0; % O Sol começar com ângulo 0.

    %% --- Cálculo de Órbitas ---

    %% Criar planeta no plano 2D
    x_2d = radii .* cos(theta);
    y_2d = radii .* sin(theta);
    z_2d = zeros(1, n);

    pos_temp = [x_2d; y_2d; z_2d];

    % Calcular Velocidade Orbital Circular
    v_mag = zeros(1, n);
    v_mag(2:end) = sqrt(sys.G * mass(1) ./ radii(2:end));

    % A velocidade é tangente à posição.
    vx_2d = -v_mag .* sin(theta);
    vy_2d =  v_mag .* cos(theta);
    vz_2d = zeros(1, n);

    vel_temp = [vx_2d; vy_2d; vz_2d];

    % --- Aplicação da Inclinação Orbital (3D) ---

    % Rotacionar tanto a posição, quanto a velocidade para incluir a inclinação
    for i = 2:n
        angle_rad = deg2rad(incl(i));

        % Matriz de Rotação em torno do eixo X
        Rx = [1, 0, 0;
              0, cos(angle_rad), -sin(angle_rad);
              0, sin(angle_rad),  cos(angle_rad)];

        % Aplica a rotação
        pos(:, i) = Rx * pos_temp(:, i);
        vel(:, i) = Rx * vel_temp(:, i);
    end

    % --- Ajuste do Baricentro (Conservação do Momento) ---
    % Se a soma dos momentos (m*v) não for zero, o sistema todo
    % começa a "andar" pelo espaço. Para evitar isso, o Sol deve se
    % mover na direção oposta à soma dos planetas.

    % Soma o momento linear de todos os planetas.
    momentum_total = sum(mass .* vel, 2);

    % Define a velocidade do Sol para anular esse momento total.
    vel(:, 1) = -momentum_total / mass(1);

    %% --- Dados de Saída ---

    sys.pos = pos;       % Posições iniciais
    sys.vel = vel;       % Velocidades inicias
    sys.mass = mass;     % Massas (Massas Solares)
    sys.color = colors;  % Cores para plotagem
    sys.name = names;    % Nomes dos copros
    sys.size = sizes;    % Tamanho visual relativo para plotagem

end
