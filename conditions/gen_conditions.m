function [sys] = gen_conditions()

    % --- Configuração e Constantes ---

    % Constante gravitacional ajustada (para Unidades Astronômicas e Anos)
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

    %% --- Inicialização dos Vetores de Estado (2D) ---
    % Matrizes 2xN (Linha 1: X, Linha 2: Y)
    pos = zeros(2, n);
    vel = zeros(2, n);

    % Ângulos aleatórios para posição inicial na órbita
    theta = rand(1, n) * 2 * pi;
    theta(1) = 0; % Sol no ângulo 0

    %% --- Cálculo de Órbitas ---

    % Posição: Conversão Polar para Cartesiana
    pos(1, :) = radii .* cos(theta); % X
    pos(2, :) = radii .* sin(theta); % Y

    % Velocidade Orbital Circular
    % v = sqrt(GM / r)
    v_mag = zeros(1, n);

    % Evita divisão por zero para o Sol (raio 0)
    if radii(1) == 0
       v_mag(2:end) = sqrt(sys.G * mass(1) ./ radii(2:end));
    else
       v_mag = sqrt(sys.G * mass(1) ./ radii);
    end

    % Velocidade tangente à trajetória (perpendicular ao raio)
    vel(1, :) = -v_mag .* sin(theta); % Vx
    vel(2, :) =  v_mag .* cos(theta); % Vy

    %% --- Ajuste do Baricentro ---
    % Garante que o momento linear total do sistema seja zero para que o sistema
    % não "vagueie" pelo espaço.

    momentum_total = sum(mass .* vel, 2); % Soma vetorial das linhas
    vel(:, 1) = -momentum_total / mass(1);

    %% --- Dados de Saída ---
    sys.pos = pos;
    sys.vel = vel;
    sys.mass = mass;
    sys.color = colors;
    sys.name = names;
    sys.size = sizes;
end
