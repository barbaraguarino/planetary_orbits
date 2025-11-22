function [] = run_solar()
  clc; clear all;

  addpath('common');
  addpath('solar_system');

  if ~exist('data', 'dir')
      mkdir('data');
  end

  filename = fullfile('data', 'simulacao_solar');

  disp('Simulação do Sistema Solar');
  disp('Gerando condições iniciais...');

  [sys] = initial_conditions_solar_system();

  n_steps = 5000000;         % Número total de passos
  step_size = 0.00001;       % Tamanho de passo de tempo
  steps_between_save = 100;  % A cada quantos passos os dados devem ser salvos

  disp(['Iniciando simulação e salvando em: ' filename]);

  simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, steps_between_save, filename);

  disp('Carregando animação...');
  animate_solar(filename, length(sys.mass), sys.name, sys.color, sys.size);

end
