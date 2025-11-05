function [] = run_planetary_simulation()
  clc;
  clear all;

  filename = "simulacao_solar";

  disp('Gerando condições iniciais...');
  [pos, vel, mass, radius, color, n, G] = gen_initial_conditions_solar_system();

  % (Passos, Tam. Passo, Salvar a cada, G, Nome)
  step_size = 0.00001;
  n_steps = 5000000;
  steps_between_save = 1000;

  disp('Iniciando simulação...');

  simulate_planetary_orbits_vectorized(pos, vel, mass, n_steps, step_size, steps_between_save, G, filename);

  % Animar os resultados
  disp('Carregando animação...');
  animate_simulation(filename, mass, color);
end
