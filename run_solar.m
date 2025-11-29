function [] = run_solar()
  clc; clear; close all;

  % Adiciona pastas ao path
  addpath('conditions');
  addpath('calculation');
  addpath('animation');

  % Cria pasta de dados se não existir
  if ~exist('data', 'dir'), mkdir('data'); end

  filename = fullfile('data', 'simulacao_solar_2d');

  disp('=== Simulação do Sistema Solar 2D ===');

  % 1. Gerar Condições
  sys = gen_conditions();

  % 2. Configurar Simulação
  n_steps = 100000;
  step_size = 0.0005;
  save_interval = 50;

  % 3. Rodar Física
  simulate_planetary_orbits(sys.pos, sys.vel, sys.mass, sys.G, ...
                            n_steps, step_size, save_interval, filename);

  % 4. Animar
  gen_animate(filename, length(sys.mass), sys.name, sys.color, sys.size);
end
