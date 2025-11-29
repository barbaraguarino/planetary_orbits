function [] = run_solar()
  clc; clear all;

  addpath('conditions');
  addpath('calculation');
  addpath('animation');

  if ~exist('data', 'dir')
      mkdir('data');
  end

  filename = fullfile('data', 'simulacao_solar');

  disp('Simulação do Sistema Solar');
  disp('Gerando condições iniciais...');

  [sys] = gen_conditions();

  n_steps = 500000;
  step_size = 0.0001;
  steps_between_save = 100;

  disp(['Iniciando simulação e salvando em: ' filename]);

  simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, ...
              step_size, steps_between_save, filename);

  disp('Carregando animação...');
  gen_animate(filename, length(sys.mass), sys.name, sys.color, sys.size);
end
