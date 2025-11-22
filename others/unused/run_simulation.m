function run_simulation(n_bodies, radius_sys, mass_sys, G, n_steps, step_size, steps_between_save, name)

  clc; clear all;
  
  addpath('common');
  addpath('generic_system');

  if ~exist('data', 'dir'), mkdir('data'); end

  filename = fullfile('data', name);

  disp('Simulação Genérica');
  disp('Gerando condições iniciais aleatórias...');

  [pos, vel, mass] = initial_conditions_generic_system(n_bodies, radius_sys, mass_sys, G);

  save([filename, '_meta.mat'], 'mass');
  
  disp(['Iniciando simulação e salvando em: ' filename]);

  simulate_planetary_orbits(pos, vel, mass, G, n_steps, step_size, steps_between_save, filename);

  disp('Carregando animação...');
  animate_generic(filename);
  
end
