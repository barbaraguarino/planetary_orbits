function gerar_cenarios_apresentacao()
    clc;

    if exist('common', 'dir'), addpath('common'); end
    if exist('solar_system', 'dir'), addpath('solar_system'); end

    output_dir = 'simulation_examples';
    if ~exist(output_dir, 'dir'), mkdir(output_dir); end

    disp('GERADOR DE CENÁRIOS EXTREMOS');

    % CENÁRIO 1: Solar HD (Referência)

    disp('[1/4] Gerando: solar_hd (Simulando 25 anos)...');
    [sys] = initial_conditions_solar_system();

    step_size = 0.0002;
    n_steps = 12500;
    save_interval = 1;

    filename = fullfile(output_dir, 'solar_hd');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, save_interval, filename);

    % CENÁRIO 2: Super Júpiter (O Destruidor de Mundos)

    disp('[2/4] Gerando: super_jupiter (Simulando 50 anos de caos)...');
    [sys] = initial_conditions_solar_system();

    sys.mass(6) = sys.mass(6) * 1000; % Júpiter vira uma estrela gêmea

    step_size = 0.002;
    n_steps = 25000;   % 50 Anos
    save_interval = 10;

    filename = fullfile(output_dir, 'super_jupiter');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, save_interval, filename);

    % CENÁRIO 3: A Estrela de Nêutrons (Órbitas Espirais)

    disp('[3/4] Gerando: estrela_neutrons (Caos Controlado)...');

    [sys] = initial_conditions_solar_system();

    % Aumenta massa em 3x (suficiente para puxar, mas não para ejetar todos)
    sys.mass(1) = sys.mass(1) * 3.0;

    % Passo de tempo SUPER pequeno para evitar o erro numérico do "chute"
    step_size = 0.0005;
    n_steps = 50000;
    save_interval = 20;

    filename = fullfile(output_dir, 'estrela_neutrons');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, ...
                              n_steps, step_size, save_interval, filename);

    % CENÁRIO 4: Plutão Kamikaze (O Tiro ao Alvo)
    % Fazer Plutão atravessar o sistema solar "cortando" as órbitas

    disp('[4/4] Gerando: plutao_kamikaze (Mergulho suicida)...');
    [sys] = initial_conditions_solar_system();

    % Zera a velocidade orbital natural
    sys.vel(:, 10) = [0; 0; 0];

    % Defini uma velocidade BALÍSTICA direta para o Sol (origem 0,0,0)
    % Plutão começa em X ~ 49. Da uma velocidade negativa forte em X.
    % Vel = -2.0 AU/ano (muito rápido para um planeta)
    sys.vel(:, 10) = [-2.5; 0.5; 2.0];

    step_size = 0.002;
    n_steps = 25000; % 50 anos de viagem
    save_interval = 10;

    filename = fullfile(output_dir, 'plutao_kamikaze');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, save_interval, filename);

    disp('Cenários gerados!');
end
