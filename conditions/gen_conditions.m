function [sys] = gen_conditions()

    % --- Configuração e Constantes ---

    % G = 4 * pi^2 assume massa em M_sol, distância em AU e tempo em Anos.
    sys.G = 4 * pi^2;

    % Nome, Massa (M_sol), Raio Orbital (AU), Cor, Tamanho Visual
    planet_data = {
        'Sol',      1.0,         0.0,       'y',           250;
        'Mercúrio', 1.6601e-7,   0.387098,  [0.5 0.5 0.5], 15;
        'Vênus',    2.4478e-6,   0.723332,  [0.8 0.6 0.2], 25;
        'Terra',    3.0035e-6,   1.000000,  'b',           25;
        'Marte',    3.2272e-7,   1.523679,  'r',           15;
        'Júpiter',  9.5458e-4,   5.204267,  [0.8 0.5 0.2], 100;
        'Saturno',  2.8581e-4,   9.582000,  [0.9 0.8 0.6], 80;
        'Urano',    4.3641e-5,   19.29000,  'c',           40;
        'Netuno',   5.1497e-5,   30.100000, 'b',           40;
        'Plutão',   6.556e-9,    39.480000, [0.6 0.4 0.4], 10;
    };

    % Extração dos dados
    names  = planet_data(:, 1)';
    mass   = [planet_data{:, 2}];
    radii  = [planet_data{:, 3}];
    colors = planet_data(:, 4)';
    sizes  = [planet_data{:, 5}];

    n = length(mass);

    %% --- Inicialização e Cálculos ---

    % Ângulos aleatórios para posição inicial na órbita
    theta = rand(1, n) * 2 * pi;
    theta(1) = 0; % Sol no ângulo 0

    % 1. Posição: Conversão Polar para Cartesiana
    x = radii .* cos(theta);
    y = radii .* sin(theta);

    pos = [x; y];

    % 2. Velocidade Orbital Circular
    % v = sqrt(GM / r)
    v_mag = zeros(1, n);

    % Evita divisão por zero para o Sol (radii(1) é 0)
    v_mag(2:end) = sqrt(sys.G * mass(1) ./ radii(2:end));

    % A velocidade é tangente à posição (rotacionada 90 graus)
    vx = -v_mag .* sin(theta);
    vy =  v_mag .* cos(theta);

    vel = [vx; vy];

    %% --- Ajuste do Baricentro (Drift Correction) ---

    % 1. Correção de Velocidade (Momento Linear)
    % Garante que o Sol tenha um pequeno "recuo" oposto aos planetas
    % para que o sistema todo não saia andando (drift).
    momentum_total = sum(mass .* vel, 2);
    vel(:, 1) = -momentum_total / mass(1);

    % 2. Correção de Posição (Centro de Massa)
    % Garante que o centro de massa do sistema esteja exatamente em (0,0)
    % Isso evita que o Sol oscile muito longe da origem do gráfico.
    center_of_mass = sum(mass .* pos, 2) / sum(mass);
    pos = pos - center_of_mass;

    %% --- Dados de Saída ---
    sys.pos = pos;
    sys.vel = vel;
    sys.mass = mass;
    sys.color = colors;
    sys.name = names;
    sys.size = sizes;
end
