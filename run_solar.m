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

  [pos, vel, mass, radius, color, n, G] = initial_conditions_solar_system();

  step_size = 0.00001;
  n_steps = 5000000;

  steps_between_save = 1000;

  disp(['Iniciando simulação e salvando em: ' filename]);

  simulate_planetary_orbits(pos, vel, mass, n_steps, step_size, steps_between_save, G, filename);

  disp('Carregando animação...');
  animate_solar(filename, mass, color);

end
