function gen_scenarios()
    clc;

    if exist('common', 'dir'), addpath('common'); end
    if exist('solar_system', 'dir'), addpath('solar_system'); end

    output_dir = 'simulation_examples';
    if ~exist(output_dir, 'dir'), mkdir(output_dir); end

    disp('GERADOR DE CENÁRIOS EXTREMOS');

    % CENÁRIO 1: Solar HD (Referência)

    disp('[1/5] Gerando: solar_hd (Simulando 25 anos)...');
    [sys] = initial_conditions_solar_system();

    step_size = 0.0002;
    n_steps = 12500;
    save_interval = 1;

    filename = fullfile(output_dir, 'solar_hd');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, save_interval, filename);

    % CENÁRIO 2: Super Júpiter (O Destruidor de Mundos)

    disp('[2/5] Gerando: super_jupiter (Simulando 50 anos de caos)...');
    [sys] = initial_conditions_solar_system();

    sys.mass(6) = sys.mass(6) * 1000; % Júpiter vira uma estrela gêmea

    step_size = 0.002;
    n_steps = 25000;   % 50 Anos
    save_interval = 10;

    filename = fullfile(output_dir, 'super_jupiter');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, save_interval, filename);

    % CENÁRIO 3: A Estrela de Nêutrons (Órbitas Espirais)

    disp('[3/5] Gerando: estrela_neutrons (Caos Controlado)...');

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

    disp('[4/5] Gerando: plutao_kamikaze (Mergulho suicida)...');
    [sys] = initial_conditions_solar_system();

    % Zera a velocidade orbital natural
    sys.vel(:, 10) = [0; 0; 0];

    dir = -sys.pos(:, 10)/norm(sys.pos(:, 10));

    sys.vel(:, 10) = 2*dir;

    step_size = 0.002;
    n_steps = 25000; % 50 anos de viagem
    save_interval = 10;

     filename = fullfile(output_dir, 'plutao_kamikaze');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, save_interval, filename);

     % CENÁRIO 5: Deriva Galática
     % Fazer o Sistema Solar se mover

    disp('[5/5] Gerando: solar_moving_sun (Sistema Solar se movendo)...');
    [sys] = initial_conditions_solar_system();

    sys.vel(1,:) = sys.vel(1,:) + 48.6/6;

    step_size = 0.002;
    n_steps = 25000; % 50 anos de viagem
    save_interval = 10;

     filename = fullfile(output_dir, 'solar_moving_sun');
    simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, save_interval, filename);



    disp('Cenários gerados!');
end
