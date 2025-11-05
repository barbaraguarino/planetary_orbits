function [] = run_planetary_simulation()
  clc;
  clear all;

  filename = "simulacao_solar";

  disp('Gerando condições iniciais...');
  [pos, vel, mass, radius, color, n, G] = gen_initial_conditions_solar_system();

  % (Passos, Tam. Passo, Salvar a cada, G, Nome)
  % Valores de exemplo: 1000000 passos, step de 0.0001, salvar a cada 100
  disp('Iniciando simulação...');
  simulate_planetary_orbits_vectorized(pos, vel, mass, 5000000, 0.0001, 100, G, filename);

  % 3. Animar os resultados
  disp('Carregando animação...');
  animate_simulation(filename, mass, color);
end
