function [] = run_planetary_simulation()
  filename = "sim.bin"
  [pos, vel, mass, radius, color, n, G] = gen_initial_conditions_solar_system();
  simulate_planetary_orbits_vectorized(pos, vel, mass, 10000, 0.001, 25, G, filename);
  animate_simulation_solar_system(filename, mass, color);
end
