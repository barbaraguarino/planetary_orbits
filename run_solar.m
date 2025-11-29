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

  n_steps = 500000;         % Número total de passos
  step_size = 0.0001;       % Tamanho de passo de tempo
  steps_between_save = 100;  % A cada quantos passos os dados devem ser salvos

  disp(['Iniciando simulação e salvando em: ' filename]);

  simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, n_steps, step_size, steps_between_save, filename);

  disp('Carregando animação...');
  gen_animate(filename, length(sys.mass), sys.name, sys.color, sys.size);

end
