function [] = run_generic()
  clc; clear all;

  addpath('common');
  addpath('generic_system');

  if ~exist('data', 'dir'), mkdir('data'); end

  filename = fullfile('data', 'simulacao_generica');

  disp('Simulação Genérica');
  disp('Gerando condições iniciais aleatórias...');

  n_bodies = 50;
  radius_sys = 10;
  mass_sys = 100;
  G = 1.0;

  [pos, vel, mass] = initial_conditions_generic_system(n_bodies, radius_sys, mass_sys, G);

  save([filename, '_meta.mat'], 'mass');

  n_steps = 5000000;         % Número total de passos
  step_size = 0.00001;       % Tamanho de passo de tempo
  steps_between_save = 100;  % A cada quantos passos os dados devem ser salvos

  disp(['Iniciando simulação e salvando em: ' filename]);

  simulate_planetary_orbits(pos, vel, mass, G, n_steps, step_size, steps_between_save, filename);

  disp('Carregando animação...');
  animate_generic(filename);

end
